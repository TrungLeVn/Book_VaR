# Hợp đồng dữ liệu — v2 (VN-Index + HNX-Index)

- **Phiên bản:** v2, 22/10/2026 — thay v1 (`results/B02_20261022-1424/data_contract.md`, chỉ VN-Index). Run: `results/B02_20261022-1616_HNX/`.
- **Phạm vi:** VN-Index (chuỗi chính), HNX-Index (chuỗi đối chứng duy nhất). Chỉ số ngành, VN30, cổ phiếu riêng lẻ: không dùng (tác giả, 22/10/2026).
- **Nhà cung cấp:** Investing.com — tác giả xác nhận cho VN-Index (22/10/2026). Tệp HNX có định dạng xuất tiếng Việt của Investing.com ("Lần cuối", "KL", "% Thay đổi") — cùng nguồn, suy từ định dạng.
- **Áp dụng:** mọi chương, **kể cả Ch1** (tác giả, 22/10/2026: chuyển hết sang tệp chuẩn).
- **Trạng thái:** đề xuất; **còn 1 lỗi VN-Index chưa xử lý (V9)** — xem mục 3.

## 1. Tệp chuẩn
| Chuỗi | Raw (chỉ đọc) | Bản dẫn xuất dùng cho code | Phiên | Khoảng |
|---|---|---|---|---|
| VN-Index | `04. Chuong_04/data/raw/vni_data.xlsx` (SHA `79f69303…22447cb4`) | `results/B02_20261022-1424/vnindex_canonical_20100104_20260520.csv` (SHA `13a5fa44…f015329a40`) | 4.082 | 04/01/2010 → 20/05/2026 |
| HNX-Index | `_project/data_incoming/Dữ liệu Lịch sử HNX.csv` (SHA `de05a611…1b38143c`; 4.191 phiên, đến 22/10/2026) | `results/B02_20261022-1616_HNX/hnxindex_canonical_20100104_20260520.csv` (SHA `79c130bed33c9e2123c8a664cc87442502e067ceb580703b5a59360581bc322c`) | 4.083 | 04/01/2010 → 20/05/2026 |
Định dạng chung: cột `date,open,high,low,close`; ngày ISO; tăng dần; 2 chữ số thập phân. Lead (L0) chuyển hai tệp vào `_project/data/` sau khi xử lý V9.

## 2. Quy tắc xử lý (giữ R1–R8 của v1, thêm R9–R11)
| # | Quy tắc |
|---|---|
| R1–R5 | Như v1: đổi tên cột, sắp tăng dần, kiểm trùng ngày; kiểm OHLC; $r_t = 100\ln(P_t/P_{t-1})$, không winsorize; $L_t=-r_t$; script đọc bản dẫn xuất, kiểm SHA, không ghi vào `data/raw/` |
| R6 | Ước lượng biên độ giá dùng giá mở cửa (Garman–Klass, Rogers–Satchell, Yang–Zhang): nêu hạn chế; với HNX-Index hạn chế áp dụng **toàn mẫu** (H3). Parkinson (chỉ $P^H,P^L$) là lựa chọn ít bị ảnh hưởng — chốt ở C03-D1 |
| R7 | Không dùng khối lượng của cả hai chuỗi (gãy đơn vị: VN-Index 10/01/2025; HNX-Index từ 06/03/2025) |
| R8 | Đoạn 2007–2009 chỉ có cho VN-Index (`01. Chuong_01/data/raw/vnindex.csv`) và chỉ dùng nếu C05-D1 chọn; Ch1 dùng mẫu chuẩn 2010 → 20/05/2026 |
| R9 | **Kiểm phiên trùng giá trị:** mỗi lần nạp, đánh dấu phiên có O, H, L, C trùng hệt phiên trước; có → dừng, báo L0 |
| R10 | **Lịch giao dịch chung:** phân tích so sánh hai chuỗi (3.7, 5.8) dùng phần giao của hai lịch; phân tích từng chuỗi dùng lịch riêng |
| R11 | Cắt mẫu tại 20/05/2026 (A2) dù tệp HNX có dữ liệu đến 22/10/2026 |

## 3. Cảnh báo chất lượng dữ liệu
### VN-Index (v1: D1–D8 giữ nguyên; thêm)
| # | Phát hiện | Bằng chứng | Hệ quả |
|---|---|---|---|
| **V9** | **Phiên 23/01/2018 là bản sao nguyên của 22/01/2018 và thiếu phiên 24/01/2018** | O/H/L/C 23/01 = 22/01 = (1066,86; 1088,05; 1066,61; 1087,42); HNX có phiên 24/01/2018 (thứ Tư); `vnindex.csv` Ch1 cũng thiếu 24/01/2018 (chung nguồn) — `duplicate_value_rows.csv` | Tỷ suất sinh lời 23/01 = 0 (giả) và 25/01 gộp 2 phiên; ảnh hưởng nhỏ đến ước lượng nhưng là lỗi dữ liệu. **NEEDS DECISION** — không tự điền giá |
### HNX-Index
| # | Phát hiện | Bằng chứng | Hệ quả |
|---|---|---|---|
| H1 | Lịch giao dịch khớp VN-Index trừ 24/01/2018 | 4.082 phiên chung; chỉ HNX có 24/01/2018; không trùng ngày, không ngày cuối tuần, không thiếu giá trị | Sau khi sửa V9: hai lịch trùng nhau hoàn toàn |
| H2 | OHLC hợp lệ | 0 vi phạm, 0 phiên biên độ bằng 0 (`hnx_ohlc_checks.csv`) | — |
| H3 | Giá mở cửa = giá đóng cửa phiên trước ở 1.814/4.083 phiên (44%), mọi năm từ 2011 (66–185 phiên/năm) | `hnx_ohlc_checks.csv` | Giá mở cửa HNX không phản ánh giá khớp đầu phiên trong phần lớn mẫu — xem R6 |
| H4 | Không thấy dấu hiệu mạnh của giao dịch không đồng bộ ở cấp chỉ số | AR(1) của $r_t$: HNX 0,041 so với VN-Index 0,088 (toàn mẫu, ±0,031 ở 95%); 2021–2026: 0,091 so với 0,071; phiên $r_t=0$: 14 (0,34%) — `hnx_vs_vni_ac1.csv` | Vẫn báo cáo AR(1) ở 3.3; phương trình trung bình AR(1) xem xét ở C03-D1 |
| H5 | Tỷ suất sinh lời cực trị phù hợp biên độ HNX | max $|r_t|$ = 6,76% trước 15/01/2013 (biên độ ±7%), 8,38% sau đó (±10%); min −8,38% (28/01/2021), max 7,86% (10/04/2025) | Khớp `context/vn_market_facts.md` L10 |
| H6 | Khối lượng gãy đơn vị | hậu tố K → M từ 06/03/2025, 2025 lẫn K/M; trung vị 2024: 58.845 so với 2025: 70,77 triệu | R7 |
| H7 | "% Thay đổi" khớp giá đóng cửa | 0 phiên lệch > 0,011 điểm % | Nhất quán nội bộ |
| H8 | Đổi phương pháp chỉ số 01/05/2015 (sang vốn hóa free-float) | `context/vn_market_facts.md` I9 (nguồn thứ cấp); không thấy bước nhảy mức chỉ số | Mốc ứng viên điểm gãy cấu trúc cho kiểm định độ bền (3.8, 5.9) |
| H9 | Tương quan HNX–VN-Index | cùng phiên 0,81; $r^{HNX}_t$ với $r^{VNI}_{t-1}$: 0,013 | Mô tả ở 3.7 |

## 4. Giới hạn
- Hai chuỗi cùng một nhà cung cấp; chưa đối chiếu với nguồn độc lập (HOSE, HNX). Khớp nội bộ không chứng minh đúng với giá chính thức — V9 là ví dụ lỗi nguồn.
- Khoảng trống lịch (Tết, 30/4) chưa đối chiếu lịch nghỉ chính thức.
