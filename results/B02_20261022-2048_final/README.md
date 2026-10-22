# B02 chốt — tệp dữ liệu chuẩn của sách (run 22/10/2026 20:48)

- **Ticket:** `tickets/B02.md` (chốt). **Làn:** L0 (Cowork, Python). **Căn cứ:** tác giả chọn phương án (b) cho V9 — bỏ phiên giả 23/01/2018, ghi giới hạn (chat Cowork 20:47).
- **Trạng thái:** executed + checked (assert SHA đầu vào; kiểm R1–R2, R9; đọc lại khớp).

## Đã chạy
`python3 -I results/B02_20261022-2048_final/b02_finalize.py` — đầu vào: tệp chuẩn VN-Index (B02 phần 1, SHA 13a5fa44…) và HNX-Index (B02 phần 2, SHA 79c130be…).

## Kết quả
| Tệp | Phiên | Khoảng | SHA-256 |
|---|---|---|---|
| vnindex_daily_20100104_20260520.csv | 4.081 | 04/01/2010 → 20/05/2026 | 7c7563691623fe9a85e0ceffe356aa179224e2f07758d6efecd4e663172ff05b |
| hnxindex_daily_20100104_20260520.csv | 4.083 | 04/01/2010 → 20/05/2026 | 79c130bed33c9e2123c8a664cc87442502e067ceb580703b5a59360581bc322c |
- Cả hai: 0 trùng ngày, 0 thiếu giá trị, 0 ngày cuối tuần, 0 vi phạm OHLC, 0 phiên trùng nguyên O/H/L/C với phiên trước.
- Lịch chung: 4.081 phiên; chỉ HNX có 23/01/2018 và 24/01/2018.

## Giới hạn V9 (ghi vào Phụ lục B và mục 3.2.2)
VN-Index trong nguồn Investing.com có phiên 23/01/2018 trùng nguyên 22/01/2018 và không có phiên 24/01/2018. Phiên 23/01/2018 bị loại; hai phiên 23–24/01/2018 không được điền. Hệ quả: tỷ suất sinh lời VN-Index ngày 25/01/2018 (1,565%) tính từ 22/01/2018, gộp ba phiên. Phân tích so sánh VN-Index–HNX-Index dùng 4.081 phiên chung (R10).

## Tệp
`vnindex_daily_20100104_20260520.csv`, `hnxindex_daily_20100104_20260520.csv`, `DATA_MANIFEST.csv`, `finalize_output.json`, `b02_finalize.py`, `run_log.txt`. Bản chép sang `_project/data/` trùng SHA.
