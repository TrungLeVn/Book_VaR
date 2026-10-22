# B02 phần 2 — audit HNX-Index (run 22/10/2026 16:16, giờ Việt Nam)

- **Ticket:** `tickets/B02.md` phần 2. **Làn:** L0. **Thực hiện:** Lead theo card `team/agents/var-reproduction-analyst.md` v2 (Cowork, Python).
- **Trạng thái:** **executed** (exit 0) + **checked** (SHA đầu vào khớp bằng assert; đọc lại tệp chuẩn khớp; đối chiếu lịch với VN-Index chuẩn). **Dừng NEEDS DECISION** do lỗi VN-Index V9.

## Đầu vào
| Tệp | SHA-256 |
|---|---|
| _project/data_incoming/Dữ liệu Lịch sử HNX.csv | de05a6118e12a8a70cf623782e60a77d5a2da62853015cd4bcd584ff1b38143c |
| results/B02_20261022-1424/vnindex_canonical_20100104_20260520.csv | 13a5fa44f6cbfbb36d94b4a0dc04dd4918c8addf4fe46b18dfff43f015329a40 |

## Đã chạy
`python3 -I results/B02_20261022-1616_HNX/b02_hnx_audit.py` từ gốc (Python 3.10.12, pandas 2.3.3; log `run_log.txt`). Bước quét phiên trùng giá trị (R9) chạy riêng sau đó, kết quả `duplicate_value_rows.csv` — đưa vào script ở lần chạy lại.

## Kết quả
| Kiểm tra | HNX-Index |
|---|---|
| Tệp gốc | 4.191 phiên, 04/01/2010 → 22/10/2026; 0 trùng ngày, 0 thiếu, 0 cuối tuần |
| Mẫu (cắt 20/05/2026) | 4.083 phiên |
| Lịch so với VN-Index | 4.082 phiên chung; chỉ HNX có 24/01/2018 → phát hiện lỗi VN-Index V9 |
| OHLC | 0 vi phạm; giá mở cửa = đóng cửa hôm trước 44% phiên |
| AR(1) toàn mẫu | 0,041 (VN-Index 0,088) |
| Biên độ | max \|r\| 6,76% trước 15/01/2013, 8,38% sau |
| Khối lượng | gãy đơn vị từ 06/03/2025 — không dùng |

**Tệp chuẩn HNX:** `hnxindex_canonical_20100104_20260520.csv` (SHA `79c130bed33c9e2123c8a664cc87442502e067ceb580703b5a59360581bc322c`).

## Tệp
`data_contract.md` (v2) · `data_manifest.csv` · `hnx_ohlc_checks.csv` · `hnx_ohlc_violations.csv` (rỗng) · `hnx_vs_vni_ac1.csv` · `hnx_large_returns.csv` · `hnx_gaps.csv` · `duplicate_value_rows.csv` · `audit_output.json` · `hnxindex_canonical_20100104_20260520.csv` · `b02_hnx_audit.py` · `run_log.txt`

## Trả về Lead
- **NEEDS DECISION (V9):** VN-Index 23/01/2018 trùng 22/01/2018, thiếu 24/01/2018. Phương án: (a) tác giả tải lại VN-Index tháng 01/2018 từ Investing.com (hoặc nguồn khác) để thay 2 phiên — khuyến nghị; (b) xoá phiên 23/01/2018 giả, chấp nhận thiếu 2 phiên và ghi giới hạn.
- **Suggested next task:** sau V9 — L0 chuyển hai tệp chuẩn vào `_project/data/`, mở khoá đợt A (C03-D1, C05-D1, C02-M3, C04-M3).
