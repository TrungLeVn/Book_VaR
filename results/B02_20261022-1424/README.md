# B02 phần 1 — audit nguồn VN-Index (run 22/10/2026 14:24, giờ Việt Nam)

- **Ticket:** `tickets/B02.md` (phần 1). **Thực hiện:** Lead theo card `team/agents/var-reproduction-analyst.md` (Cowork; dùng Python vì card cho phép; không cần R).
- **Trạng thái:** **executed** (script chạy hết, exit 0) và **checked** (đối chiếu chéo ba nguồn; đọc lại tệp chuẩn khớp XLSX bằng assert). Chưa có review độc lập.

## Đầu vào (SHA-256 khớp `_project/input_manifest_20261022.csv`)
| Tệp | SHA-256 | Phiên | Khoảng |
|---|---|---|---|
| 04. Chuong_04/data/raw/vni_data.xlsx | 79f69303fa73be87e77fb15b4c4dc4e07c3f486e5d99ed27e92bdef022447cb4 | 4.082 | 2010-01-04 → 2026-05-20 |
| 01. Chuong_01/data/raw/vnindex.csv | 289e0a51aa5714eb567e31dc9699182be9fb236dec2a7617a3daf6662c75d484 | 4.785 | 2007-01-02 → 2026-03-19 (có khối lượng) |
| 03. Chuong_03/data/raw/vnindex_daily.csv | b23d33a7c506a007ba49ca6f6f2c6d75dab4db33ffaed64805df1c8a4cc6c08e | 4.081 | 2010-01-05 → 2026-05-20 |
| 04. Chuong_04/data/raw/VNI.csv (phát hiện thêm) | 289e0a51… (trùng Ch1) | 4.785 | như Ch1 |

## Đã chạy
`python3 -I results/B02_20261022-1424/b02_vnindex_audit.py` từ gốc `02. Drafts/` (Python 3.10.12, pandas 2.3.3; log: `run_log.txt`). Chỉ đọc dữ liệu raw.

## Kết quả chính
| Kiểm tra | Kết quả |
|---|---|
| Trùng ngày, thiếu giá trị, ngày cuối tuần | 0 ở cả ba nguồn |
| Đối chiếu XLSX–Ch3 (4.081 phiên chung) | lệch tối đa 0,00 ở O, H, L, C; Ch3 thiếu đúng phiên 04/01/2010 |
| Đối chiếu XLSX–Ch1 (4.041 phiên chung, đến 19/03/2026) | lệch tối đa 0,00 ở O, H, L, C; không ngày nào chỉ có ở một nguồn |
| Vi phạm OHLC ($H<\max(O,C)$, $L>\min(O,C)$, $H<L$) | 0 ở cả ba nguồn |
| Số phiên/năm (2010–2025) | 247–252 |
| Tỷ suất sinh lời logarit (%) | min −6,91 (03/04/2025), max 6,55 (10/04/2025) |
| "Change %" của nhà cung cấp (Ch1) so với tính lại | 0 phiên lệch > 0,011 điểm % |
| Cảnh báo | D1 giá mở cửa từ 2021; D2 OHLC 2007; D3 gãy đơn vị khối lượng 10/01/2025; D5 script Ch3 ghi đè raw — chi tiết `data_contract.md` mục 3 |

**Khuyến nghị tệp chuẩn:** `vni_data.xlsx` → bản dẫn xuất `vnindex_canonical_20100104_20260520.csv` (SHA `13a5fa44f6cbfbb36d94b4a0dc04dd4918c8addf4fe46b18dfff43f015329a40`). Căn cứ: `data_contract.md` mục 1.

## Tệp
`data_contract.md` · `data_manifest.csv` (SHA mọi tệp, gồm tệp HNX mới đến — chưa audit) · `source_comparison.csv` · `ohlc_checks.csv` (theo năm) · `large_returns.csv` (|r| > 4,5%) · `gaps.csv` (khoảng trống > 5 ngày lịch) · `audit_output.json` · `vnindex_canonical_20100104_20260520.csv` · `b02_vnindex_audit.py` · `run_log.txt`.

## Giới hạn
- Không xác định được nhà cung cấp dữ liệu (cần tác giả).
- Chưa đối chiếu với nguồn độc lập thứ hai (HOSE/VNDIRECT) — ba tệp có thể cùng một nguồn gốc nên "khớp tuyệt đối" chứng minh tính nhất quán nội bộ, không chứng minh đúng với giá chính thức.
- Khoảng trống lịch chưa đối chiếu lịch nghỉ chính thức.

## Trả về Lead
- **NEEDS DECISION:** (1) xác nhận nhà cung cấp dữ liệu; (2) cách xử lý giá mở cửa sau 2021 cho ước lượng biên độ giá (đưa vào C03-D1); (3) Ch1 chuyển sang tệp chuẩn (mẫu 2010 → 20/05/2026) hay giữ 2007–2026-03 cho phần minh họa.
- **Suggested next task:** B02 phần 2 — audit tệp HNX đã đến (`_project/data_incoming/Dữ liệu Lịch sử HNX.csv`) theo mục 4 của hợp đồng.
