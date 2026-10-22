#!/usr/bin/env python3
"""B02 chốt — bỏ phiên giả VN-Index 23/01/2018 (V9), kiểm lại hai tệp chuẩn, ghi bản cuối.
Chạy từ gốc `02. Drafts/`: python3 -I results/B02_<ts>_final/b02_finalize.py
Ghi vào thư mục run; Lead (L0) chép sang _project/data/ sau khi kiểm."""
import hashlib, json, os
import numpy as np, pandas as pd
HERE = os.path.dirname(os.path.abspath(__file__))
sha = lambda p: hashlib.sha256(open(p, "rb").read()).hexdigest()
IN = {"VNI": ("results/B02_20261022-1424/vnindex_canonical_20100104_20260520.csv", "13a5fa44f6cbfbb36d94b4a0dc04dd4918c8addf4fe46b18dfff43f015329a40"),
      "HNX": ("results/B02_20261022-1616_HNX/hnxindex_canonical_20100104_20260520.csv", "79c130bed33c9e2123c8a664cc87442502e067ceb580703b5a59360581bc322c")}
for k, (p, h) in IN.items(): assert sha(p) == h, f"SHA lệch {p}"
v = pd.read_csv(IN["VNI"][0], parse_dates=["date"]); h = pd.read_csv(IN["HNX"][0], parse_dates=["date"])
# V9: phiên 23/01/2018 trùng nguyên 22/01/2018 -> bỏ; 24/01/2018 không có trong nguồn -> không điền
a = v[v.date == "2018-01-22"].iloc[0]; b = v[v.date == "2018-01-23"].iloc[0]
assert all(a[c] == b[c] for c in ["open", "high", "low", "close"]), "23/01/2018 không còn trùng 22/01 — dừng"
v2 = v[v.date != "2018-01-23"].reset_index(drop=True)
out = {"inputs": {k: {"path": p, "sha256": s} for k, (p, s) in IN.items()}, "dropped_vni": ["2018-01-23"],
       "missing_vni_not_filled": ["2018-01-23", "2018-01-24"]}
def checks(d, name):
    x = d[["open", "high", "low", "close"]]
    r = 100 * np.log(d.close / d.close.shift())
    dup4 = (x.diff().abs().max(axis=1) == 0); dup4.iloc[0] = False
    return dict(n=len(d), start=str(d.date.min().date()), end=str(d.date.max().date()),
        dup_dates=int(d.date.duplicated().sum()), na=int(x.isna().sum().sum()),
        weekend=int((d.date.dt.weekday >= 5).sum()), sorted=bool(d.date.is_monotonic_increasing),
        ohlc_viol=int(((d.high < x[["open", "close"]].max(axis=1) - 1e-9) | (d.low > x[["open", "close"]].min(axis=1) + 1e-9) | (d.high < d.low)).sum()),
        dup_ohlc_rows=int(dup4.sum()), n_returns=int(r.notna().sum()),
        r_min=round(float(r.min()), 3), r_max=round(float(r.max()), 3))
out["VNI"] = checks(v2, "VNI"); out["HNX"] = checks(h, "HNX")
for k in ["VNI", "HNX"]:
    c = out[k]; assert c["dup_dates"] == 0 and c["na"] == 0 and c["weekend"] == 0 and c["sorted"] and c["ohlc_viol"] == 0 and c["dup_ohlc_rows"] == 0, (k, c)
cal = set(v2.date) ^ set(h.date)
out["calendar_symmetric_diff"] = sorted(str(x.date()) for x in cal)
out["common_sessions"] = len(set(v2.date) & set(h.date))
# Tỷ suất sinh lời 25/01/2018 của VN-Index gộp 22/01 → 25/01
i = v2.index[v2.date == "2018-01-25"][0]
out["vni_r_20180125_spans"] = [str(v2.date[i-1].date()), "2018-01-25", round(float(100*np.log(v2.close[i]/v2.close[i-1])), 3)]
fv = os.path.join(HERE, "vnindex_daily_20100104_20260520.csv"); fh = os.path.join(HERE, "hnxindex_daily_20100104_20260520.csv")
w = lambda d, f: d.assign(date=d.date.dt.strftime("%Y-%m-%d"))[["date", "open", "high", "low", "close"]].to_csv(f, index=False, float_format="%.2f")
w(v2, fv); w(h, fh)
for f, d in [(fv, v2), (fh, h)]:
    rd = pd.read_csv(f); assert len(rd) == len(d) and np.allclose(rd[["open","high","low","close"]].values, d[["open","high","low","close"]].values)
man = pd.DataFrame([
 dict(file="vnindex_daily_20100104_20260520.csv", series="VN-Index", role="chuỗi chính", source="Investing.com (raw: 04. Chuong_04/data/raw/vni_data.xlsx, SHA 79f69303…)", derived_from=IN["VNI"][0], sha256=sha(fv), start=out["VNI"]["start"], end=out["VNI"]["end"], n_sessions=out["VNI"]["n"], note="bỏ 23/01/2018 (trùng 22/01); thiếu 24/01/2018 — giới hạn V9"),
 dict(file="hnxindex_daily_20100104_20260520.csv", series="HNX-Index", role="chuỗi đối chứng", source="Investing.com (raw: _project/data_incoming/Dữ liệu Lịch sử HNX.csv, SHA de05a611…)", derived_from=IN["HNX"][0], sha256=sha(fh), start=out["HNX"]["start"], end=out["HNX"]["end"], n_sessions=out["HNX"]["n"], note="cắt tại 20/05/2026")])
man.to_csv(os.path.join(HERE, "DATA_MANIFEST.csv"), index=False)
json.dump(out, open(os.path.join(HERE, "finalize_output.json"), "w"), indent=1, ensure_ascii=False)
print(json.dumps(out, indent=1, ensure_ascii=False)); print(man[["file", "sha256", "n_sessions"]].to_string(index=False))
