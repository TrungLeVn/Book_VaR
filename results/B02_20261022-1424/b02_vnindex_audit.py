#!/usr/bin/env python3
"""B02 phần 1 — audit ba nguồn VN-Index (chỉ đọc dữ liệu raw).
Chạy từ gốc dự án `02. Drafts/`:  python3 results/B02_<ts>/b02_vnindex_audit.py
Đầu ra ghi cạnh script: audit_output.json, source_comparison.csv, ohlc_checks.csv,
large_returns.csv, gaps.csv, data_manifest.csv."""
import hashlib, json, os, sys, platform
import numpy as np, pandas as pd
HERE = os.path.dirname(os.path.abspath(__file__))
SRC = {
 "XLSX": "04. Chuong_04/data/raw/vni_data.xlsx",
 "CH1":  "01. Chuong_01/data/raw/vnindex.csv",
 "CH3":  "03. Chuong_03/data/raw/vnindex_daily.csv",
 "CH4CSV": "04. Chuong_04/data/raw/VNI.csv",
}
sha = lambda p: hashlib.sha256(open(p, "rb").read()).hexdigest()
def num(s):
    return pd.to_numeric(s.astype(str).str.replace(",", "", regex=False), errors="coerce")
def vol(s):
    m = {"K": 1e3, "M": 1e6, "B": 1e9}
    s = s.astype(str).str.strip()
    mult = s.str[-1].map(m).fillna(1.0)
    base = pd.to_numeric(s.str.rstrip("KMB").str.replace(",", ""), errors="coerce")
    return base * mult
def load(key):
    p = SRC[key]
    if key == "XLSX":
        d = pd.read_excel(p).rename(columns=str.lower).rename(columns={"price": "close"})
        d["date"] = pd.to_datetime(d["date"])
    elif key in ("CH1", "CH4CSV"):
        d = pd.read_csv(p, encoding="utf-8-sig")
        d.columns = [c.strip().lower() for c in d.columns]
        d = d.rename(columns={"price": "close", "vol.": "volume", "change %": "chg_pct"})
        d["date"] = pd.to_datetime(d["date"], format="%m/%d/%Y")
        for c in ["close", "open", "high", "low"]: d[c] = num(d[c])
        d["volume"] = vol(d["volume"])
        d["chg_pct"] = num(d["chg_pct"].astype(str).str.rstrip("%"))
    else:
        d = pd.read_csv(p); d["date"] = pd.to_datetime(d["date"])
    return d.sort_values("date").reset_index(drop=True)

out = {"python": platform.python_version(), "pandas": pd.__version__}
data = {k: load(k) for k in SRC}
man, prof = [], {}
for k, d in data.items():
    dup = int(d["date"].duplicated().sum())
    na = {c: int(d[c].isna().sum()) for c in ["open", "high", "low", "close"]}
    wk = int((d["date"].dt.weekday >= 5).sum())
    prof[k] = dict(path=SRC[k], sha256=sha(SRC[k]), n=len(d), start=str(d.date.min().date()),
                   end=str(d.date.max().date()), duplicates=dup, missing=na, weekend_dates=wk,
                   has_volume="volume" in d, cols=list(d.columns))
    man.append(dict(series="VN-Index", role=k, path=SRC[k], sha256=prof[k]["sha256"],
                    bytes=os.path.getsize(SRC[k]), start=prof[k]["start"], end=prof[k]["end"],
                    n_sessions=len(d), ohlc="yes", volume="yes" if "volume" in d else "no"))
out["profile"] = prof
out["ch1_vs_ch4csv_identical_bytes"] = prof["CH1"]["sha256"] == prof["CH4CSV"]["sha256"]

# 1. So sánh nguồn trên phần chồng lấn
rows = []
def compare(a, b):
    A, B = data[a], data[b]
    m = A.merge(B, on="date", suffixes=("_a", "_b"), how="outer", indicator=True)
    lo, hi = max(A.date.min(), B.date.min()), min(A.date.max(), B.date.max())
    w = m[(m.date >= lo) & (m.date <= hi)]
    both = w[w._merge == "both"]
    r = dict(pair=f"{a}-{b}", overlap_start=str(lo.date()), overlap_end=str(hi.date()),
             n_both=len(both), only_a=int((w._merge == "left_only").sum()),
             only_b=int((w._merge == "right_only").sum()),
             only_a_dates=";".join(str(x.date()) for x in w[w._merge == "left_only"].date[:20]),
             only_b_dates=";".join(str(x.date()) for x in w[w._merge == "right_only"].date[:20]))
    for c in ["close", "open", "high", "low"]:
        diff = (both[c + "_a"] - both[c + "_b"]).abs()
        r[f"{c}_maxabs"] = round(float(diff.max()), 4)
        r[f"{c}_n_gt_0.005"] = int((diff > 0.005).sum())
        r[f"{c}_n_gt_0.5"] = int((diff > 0.5).sum())
        if c == "close" and (diff > 0.005).any():
            top = both.assign(d=diff).nlargest(10, "d")
            r["close_top_diffs"] = ";".join(f"{x.date.date()}:{x.close_a}/{x.close_b}" for x in top.itertuples())
    rows.append(r)
for a, b in [("XLSX", "CH3"), ("XLSX", "CH1"), ("CH1", "CH3")]: compare(a, b)
pd.DataFrame(rows).to_csv(os.path.join(HERE, "source_comparison.csv"), index=False)
out["comparison"] = rows

# 2. Kiểm OHLC theo năm
oh = []
for k in ["XLSX", "CH1", "CH3"]:
    d = data[k].copy(); d["year"] = d.date.dt.year
    d["prev_close"] = d.close.shift()
    f = pd.DataFrame({
        "year": d.year,
        "h_lt_maxoc": d.high < d[["open", "close"]].max(axis=1) - 1e-9,
        "l_gt_minoc": d.low > d[["open", "close"]].min(axis=1) + 1e-9,
        "h_lt_l": d.high < d.low,
        "zero_range": (d.high - d.low).abs() < 1e-9,
        "open_eq_high": (d.open - d.high).abs() < 1e-9,
        "open_eq_low": (d.open - d.low).abs() < 1e-9,
        "close_eq_high_or_low": ((d.close - d.high).abs() < 1e-9) | ((d.close - d.low).abs() < 1e-9),
        "open_eq_prevclose": (d.open - d.prev_close).abs() < 1e-9,
    })
    g = f.groupby("year").agg(["sum"]); g.columns = [c[0] for c in g.columns]
    g["n"] = f.groupby("year").size(); g.insert(0, "source", k)
    oh.append(g.reset_index())
oh = pd.concat(oh); oh.to_csv(os.path.join(HERE, "ohlc_checks.csv"), index=False)
out["ohlc_totals"] = {k: oh[oh.source == k].drop(columns=["source", "year"]).sum().astype(int).to_dict() for k in ["XLSX", "CH1", "CH3"]}

# 3. Tỷ suất sinh lời lớn và khoảng trống lịch
lr, gp = [], []
for k in ["XLSX", "CH1", "CH3"]:
    d = data[k].copy(); d["r"] = 100 * np.log(d.close / d.close.shift())
    big = d[d.r.abs() > 4.5][["date", "close", "r"]].assign(source=k)
    lr.append(big)
    gaps = d.date.diff().dt.days
    g = d.assign(gap=gaps)[gaps > 5][["date", "gap"]].assign(prev=d.date.shift()[gaps > 5], source=k)
    gp.append(g)
    yrs = d.groupby(d.date.dt.year).size()
    out.setdefault("sessions_per_year", {})[k] = {int(y): int(n) for y, n in yrs.items()}
    out.setdefault("return_summary", {})[k] = dict(n=int(d.r.notna().sum()), min=round(float(d.r.min()), 3),
        max=round(float(d.r.max()), 3), date_min=str(d.loc[d.r.idxmin(), "date"].date()),
        date_max=str(d.loc[d.r.idxmax(), "date"].date()))
pd.concat(lr).to_csv(os.path.join(HERE, "large_returns.csv"), index=False)
pd.concat(gp).to_csv(os.path.join(HERE, "gaps.csv"), index=False)

# 4. Khối lượng (chỉ CH1)
d = data["CH1"]
out["ch1_volume"] = dict(n_missing=int(d.volume.isna().sum()),
    by_year_median={int(y): float(v) for y, v in d.groupby(d.date.dt.year).volume.median().items()})
# Change % của nhà cung cấp so với tính lại
d2 = d.assign(chk=100 * (d.close / d.close.shift() - 1))
dd = (d2.chk - d2.chg_pct).abs()
out["ch1_changepct_mismatch_gt_0.011"] = int((dd > 0.011).sum())

# 5. Manifest
pd.DataFrame(man).to_csv(os.path.join(HERE, "data_manifest.csv"), index=False)
json.dump(out, open(os.path.join(HERE, "audit_output.json"), "w"), indent=1, ensure_ascii=False, default=str)
print(json.dumps(out, indent=1, ensure_ascii=False, default=str)[:12000])

# 6. Tệp chuẩn hóa đề xuất (từ XLSX) — chỉ là bản dẫn xuất; Lead chuyển vào thư mục chương sau khi duyệt
c = data["XLSX"][["date", "open", "high", "low", "close"]].copy()
c["date"] = c["date"].dt.strftime("%Y-%m-%d")
cp = os.path.join(HERE, "vnindex_canonical_20100104_20260520.csv")
c.to_csv(cp, index=False, float_format="%.2f")
# kiểm: đọc lại khớp XLSX
chk = pd.read_csv(cp)
assert len(chk) == 4082 and np.allclose(chk[["open","high","low","close"]].values,
        data["XLSX"][["open","high","low","close"]].values, atol=1e-9)
man_df = pd.read_csv(os.path.join(HERE, "data_manifest.csv"))
man_df = pd.concat([man_df, pd.DataFrame([dict(series="VN-Index", role="CANONICAL (derived, đề xuất)",
    path=os.path.relpath(cp, os.getcwd()), sha256=sha(cp), bytes=os.path.getsize(cp), start="2010-01-04",
    end="2026-05-20", n_sessions=len(chk), ohlc="yes", volume="no")])])
# 7. Tệp HNX đến ngày 22/10/2026 — chỉ ghi SHA, chưa audit (B02 phần 2)
hp = "_project/data_incoming/Dữ liệu Lịch sử HNX.csv"
if os.path.exists(hp):
    man_df = pd.concat([man_df, pd.DataFrame([dict(series="HNX-Index", role="INCOMING (chưa audit — B02 phần 2)",
        path=hp, sha256=sha(hp), bytes=os.path.getsize(hp), start="", end="", n_sessions="", ohlc="", volume="")])])
man_df.to_csv(os.path.join(HERE, "data_manifest.csv"), index=False)
print("canonical:", sha(cp))
