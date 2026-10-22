#!/usr/bin/env python3
"""B02 phần 2 — audit HNX-Index (chỉ đọc dữ liệu đầu vào).
Chạy từ gốc `02. Drafts/`: python3 -I results/B02_<ts>_HNX/b02_hnx_audit.py
Đầu ra ghi cạnh script."""
import hashlib, json, os, platform
import numpy as np, pandas as pd
HERE = os.path.dirname(os.path.abspath(__file__))
HNX = "_project/data_incoming/Dữ liệu Lịch sử HNX.csv"
VNI = "results/B02_20261022-1424/vnindex_canonical_20100104_20260520.csv"
EXP = {HNX: "de05a6118e12a8a70cf623782e60a77d5a2da62853015cd4bcd584ff1b38143c",
       VNI: "13a5fa44f6cbfbb36d94b4a0dc04dd4918c8addf4fe46b18dfff43f015329a40"}
START, END = "2010-01-04", "2026-05-20"
sha = lambda p: hashlib.sha256(open(p, "rb").read()).hexdigest()
for p, h in EXP.items():
    assert sha(p) == h, f"SHA lệch: {p}"
out = {"python": platform.python_version(), "pandas": pd.__version__, "inputs": EXP}

raw = pd.read_csv(HNX, encoding="utf-8-sig", dtype=str)
out["raw_columns"] = list(raw.columns)
h = pd.DataFrame({
    "date": pd.to_datetime(raw["Ngày"], format="%d/%m/%Y"),
    "close": pd.to_numeric(raw["Lần cuối"].str.replace(",", ""), errors="coerce"),
    "open": pd.to_numeric(raw["Mở"].str.replace(",", ""), errors="coerce"),
    "high": pd.to_numeric(raw["Cao"].str.replace(",", ""), errors="coerce"),
    "low": pd.to_numeric(raw["Thấp"].str.replace(",", ""), errors="coerce"),
    "vol_raw": raw["KL"].str.strip(),
    "chg_pct": pd.to_numeric(raw["% Thay đổi"].str.rstrip("%").str.replace(",", ""), errors="coerce"),
}).sort_values("date").reset_index(drop=True)
mult = h.vol_raw.str[-1].map({"K": 1e3, "M": 1e6, "B": 1e9})
h["volume"] = pd.to_numeric(h.vol_raw.str.rstrip("KMB"), errors="coerce") * mult
out["full_file"] = dict(n=len(h), start=str(h.date.min().date()), end=str(h.date.max().date()),
    duplicates=int(h.date.duplicated().sum()), weekend=int((h.date.dt.weekday >= 5).sum()),
    missing={c: int(h[c].isna().sum()) for c in ["open", "high", "low", "close", "volume"]},
    covers_end=bool((h.date == END).any()))
s = h[(h.date >= START) & (h.date <= END)].reset_index(drop=True)
out["sample"] = dict(n=len(s), start=str(s.date.min().date()), end=str(s.date.max().date()))

# 1. Lịch giao dịch so với VN-Index chuẩn
v = pd.read_csv(VNI, parse_dates=["date"])
m = v[["date", "close"]].merge(s[["date", "close"]], on="date", how="outer", suffixes=("_vni", "_hnx"), indicator=True)
only_v = m[m._merge == "left_only"].date; only_h = m[m._merge == "right_only"].date
out["calendar"] = dict(n_vni=len(v), n_hnx=len(s), common=int((m._merge == "both").sum()),
    only_vni=[str(x.date()) for x in only_v], only_hnx=[str(x.date()) for x in only_h])

# 2. OHLC
s["prev_close"] = s.close.shift()
f = pd.DataFrame({"year": s.date.dt.year,
    "h_lt_maxoc": s.high < s[["open", "close"]].max(axis=1) - 1e-9,
    "l_gt_minoc": s.low > s[["open", "close"]].min(axis=1) + 1e-9,
    "h_lt_l": s.high < s.low,
    "zero_range": (s.high - s.low).abs() < 1e-9,
    "open_eq_high": (s.open - s.high).abs() < 1e-9,
    "open_eq_low": (s.open - s.low).abs() < 1e-9,
    "open_eq_prevclose": (s.open - s.prev_close).abs() < 1e-9,
    "zero_return": (s.close - s.prev_close).abs() < 1e-9})
g = f.groupby("year").sum(); g["n"] = f.groupby("year").size()
g.reset_index().to_csv(os.path.join(HERE, "hnx_ohlc_checks.csv"), index=False)
out["ohlc_totals"] = g.sum().astype(int).to_dict()
bad = s[f.h_lt_maxoc | f.l_gt_minoc | f.h_lt_l][["date", "open", "high", "low", "close"]]
bad.to_csv(os.path.join(HERE, "hnx_ohlc_violations.csv"), index=False)

# 3. Tỷ suất sinh lời, AR(1), giá đứng yên — HNX so với VN-Index
def rets(d): return 100 * np.log(d.close / d.close.shift())
s["r"] = rets(s); v["r"] = rets(v)
def ac1(x): x = x.dropna(); return float(np.corrcoef(x[1:], x[:-1])[0, 1])
def ac_ci(n): return 1.96 / np.sqrt(n)
per = []
for lab, a, b in [("2010-2012", "2010-01-01", "2012-12-31"), ("2013-2015", "2013-01-01", "2015-12-31"),
                  ("2016-2020", "2016-01-01", "2020-12-31"), ("2021-2026", "2021-01-01", "2026-12-31"),
                  ("Toàn mẫu", "2010-01-01", "2026-12-31")]:
    sh = s[(s.date >= a) & (s.date <= b)]; sv = v[(v.date >= a) & (v.date <= b)]
    per.append(dict(period=lab, n_hnx=int(sh.r.notna().sum()), ac1_hnx=round(ac1(sh.r), 4),
        ac1_vni=round(ac1(sv.r), 4), ci95=round(ac_ci(sh.r.notna().sum()), 4),
        zero_ret_hnx=int((sh.r.abs() < 1e-12).sum()), zero_ret_vni=int((sv.r.abs() < 1e-12).sum()),
        sd_hnx=round(float(sh.r.std()), 3), sd_vni=round(float(sv.r.std()), 3)))
pd.DataFrame(per).to_csv(os.path.join(HERE, "hnx_vs_vni_ac1.csv"), index=False)
out["ac1_table"] = per
both = s[["date", "r"]].merge(v[["date", "r"]], on="date", suffixes=("_hnx", "_vni")).dropna()
out["corr_same_day"] = round(float(both.r_hnx.corr(both.r_vni)), 4)
out["corr_hnx_t_vni_t-1"] = round(float(both.r_hnx.iloc[1:].reset_index(drop=True).corr(both.r_vni.iloc[:-1].reset_index(drop=True))), 4)
out["return_summary"] = dict(min=round(float(s.r.min()), 3), date_min=str(s.loc[s.r.idxmin(), "date"].date()),
    max=round(float(s.r.max()), 3), date_max=str(s.loc[s.r.idxmax(), "date"].date()))
pre = s[s.date < "2013-01-15"].r.abs().max(); post = s[s.date >= "2013-01-15"].r.abs().max()
out["max_abs_r_pre_post_20130115"] = [round(float(pre), 3), round(float(post), 3)]
s[s.r.abs() > 5][["date", "close", "r"]].to_csv(os.path.join(HERE, "hnx_large_returns.csv"), index=False)
gaps = s.date.diff().dt.days
s.assign(gap=gaps, prev=s.date.shift())[gaps > 5][["prev", "date", "gap"]].to_csv(os.path.join(HERE, "hnx_gaps.csv"), index=False)
out["sessions_per_year"] = {int(k): int(x) for k, x in s.groupby(s.date.dt.year).size().items()}

# 4. Nhất quán nội bộ, khối lượng
chk = 100 * (s.close / s.prev_close - 1)
out["changepct_mismatch_gt_0.011"] = int(((chk - s.chg_pct).abs() > 0.011).sum())
suf = s.vol_raw.str[-1]
out["volume_suffix_by_year"] = {int(y): grp.value_counts().to_dict() for y, grp in suf.groupby(s.date.dt.year)}
k2m = s[(suf == "M") & (suf.shift() == "K")][["date", "vol_raw"]]
out["volume_K_to_M_switches"] = [(str(d.date()), x) for d, x in zip(k2m.date, k2m.vol_raw)][:15]
out["volume_median_by_year"] = {int(y): float(x) for y, x in s.groupby(s.date.dt.year).volume.median().items()}

# 5. Tệp chuẩn HNX (cắt 2010-01-04 → 2026-05-20, cùng định dạng tệp VN-Index chuẩn)
c = s[["date", "open", "high", "low", "close"]].copy(); c["date"] = c.date.dt.strftime("%Y-%m-%d")
cp = os.path.join(HERE, "hnxindex_canonical_20100104_20260520.csv")
c.to_csv(cp, index=False, float_format="%.2f")
rd = pd.read_csv(cp); assert len(rd) == len(s) and np.allclose(rd[["open","high","low","close"]].values, s[["open","high","low","close"]].values)
man = pd.DataFrame([
    dict(series="HNX-Index", role="RAW (incoming, Investing.com)", path=HNX, sha256=EXP[HNX], bytes=os.path.getsize(HNX),
         start=out["full_file"]["start"], end=out["full_file"]["end"], n_sessions=len(h), ohlc="yes", volume="yes"),
    dict(series="HNX-Index", role="CANONICAL (derived, đề xuất)", path=os.path.relpath(cp), sha256=sha(cp), bytes=os.path.getsize(cp),
         start=START, end=END, n_sessions=len(c), ohlc="yes", volume="no"),
    dict(series="VN-Index", role="CANONICAL (derived, B02 phần 1)", path=VNI, sha256=EXP[VNI], bytes=os.path.getsize(VNI),
         start=START, end=END, n_sessions=len(v), ohlc="yes", volume="no")])
man.to_csv(os.path.join(HERE, "data_manifest.csv"), index=False)
out["canonical_sha256"] = sha(cp)
json.dump(out, open(os.path.join(HERE, "audit_output.json"), "w"), indent=1, ensure_ascii=False, default=str)
print(json.dumps(out, indent=1, ensure_ascii=False, default=str))
