# Dữ liệu chuẩn của sách — đọc trước khi dùng

- **Tệp:** `vnindex_daily_20100104_20260520.csv` (VN-Index, chuỗi chính, 4.081 phiên) · `hnxindex_daily_20100104_20260520.csv` (HNX-Index, chuỗi đối chứng, 4.083 phiên). Cột `date,open,high,low,close`; ngày ISO; tăng dần.
- **SHA-256:** xem `DATA_MANIFEST.csv`. Mọi script kiểm SHA trước khi chạy; lệch → dừng, báo L0.
- **Nguồn:** Investing.com (tác giả xác nhận 22/10/2026). Mẫu 04/01/2010 → 20/05/2026 cho **mọi chương** (kể cả Ch1).
- **Tạo bởi:** `results/B02_20261022-2048_final/` (từ `results/B02_20261022-1424/`, `results/B02_20261022-1616_HNX/`).
- **Hợp đồng dữ liệu:** `results/B02_20261022-1616_HNX/data_contract.md` (v2) + bổ sung v2.1 dưới đây.
- **Chỉ L0 ghi thư mục này.** Làn chương đọc bằng đường dẫn tương đối (vd. từ `0X. Chuong_0X/code/R/`: `../../../_project/data/…`), chép bản dùng vào `0X. Chuong_0X/data/raw/` khi đóng gói chương (M6), ghi SHA vào `DATA_MANIFEST.csv` của chương.

## Quy tắc dùng (tóm tắt hợp đồng v2)
- $r_t = 100\ln(P_t/P_{t-1})$ trên giá đóng cửa; không winsorize, không nội suy, không điền ngày; $L_t = -r_t$.
- Không dùng khối lượng (không có trong tệp chuẩn; nguồn gãy đơn vị năm 2025).
- Ước lượng biên độ giá dùng giá mở cửa (Garman–Klass, Rogers–Satchell, Yang–Zhang) có hạn chế: giá mở cửa = giá đóng cửa hôm trước ở phần lớn phiên (VN-Index từ 2021; HNX-Index 44% toàn mẫu). Lựa chọn chốt ở C03-D1.
- So sánh hai chuỗi (3.7, 5.8): dùng 4.081 phiên chung; phân tích từng chuỗi dùng lịch riêng.
- Đoạn 2007–2009 không thuộc tệp chuẩn; chỉ dùng nếu C05-D1 chọn (nguồn `01. Chuong_01/data/raw/vnindex.csv`).

## Bổ sung v2.1 (22/10/2026 20:48) — giới hạn V9
VN-Index: phiên 23/01/2018 trong nguồn trùng nguyên 22/01/2018 → **đã loại**; phiên 24/01/2018 không có trong nguồn → **không điền**. Tỷ suất sinh lời 25/01/2018 (1,565%) gộp 22/01 → 25/01. Ghi giới hạn này ở mục 3.2.2 và Phụ lục B (tác giả chọn, 22/10/2026).
