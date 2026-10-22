# Hợp đồng dữ liệu — VN-Index (B02 phần 1)

- **Phiên bản:** v1, 22/10/2026 (run `results/B02_20261022-1424/`). **Phạm vi:** VN-Index. HNX-Index và chỉ số ngành: phần 2 (sau B05; tệp HNX đã đến `_project/data_incoming/` 22/10/2026, SHA ghi ở `data_manifest.csv`, **chưa audit**).
- **Trạng thái:** đề xuất — Lead duyệt rồi mới chuyển tệp chuẩn vào thư mục chương. Áp dụng cho Ch1, Ch3, Ch5 (Ch2, Ch4 nếu dùng ví dụ thực).

## 1. Tệp chuẩn
| Mục | Quy định |
|---|---|
| Nguồn gốc (raw, chỉ đọc) | `04. Chuong_04/data/raw/vni_data.xlsx`, SHA-256 `79f69303…22447cb4`, 1 sheet "VN Index Historical Data (2)" |
| Bản dẫn xuất dùng cho code | `vnindex_canonical_20100104_20260520.csv`, SHA-256 `13a5fa44…f015329a40`; cột `date,open,high,low,close`; ngày ISO `YYYY-MM-DD`; tăng dần; 2 chữ số thập phân |
| Khoảng mẫu | 04/01/2010 → 20/05/2026 (A2); **4.082 phiên giá, 4.081 tỷ suất sinh lời** (đầu tiên: 05/01/2010) |
| Lịch giao dịch | Ngày có trong tệp = phiên giao dịch. Không thêm ngày, không nội suy, không điền giá trước |
| Nhà cung cấp | **CHƯA XÁC NHẬN.** Tên sheet và định dạng tệp Ch1 ("Vol.", "Change %", ngày MM/DD/YYYY) giống dạng xuất của Investing.com — chỉ là suy đoán từ định dạng; tác giả xác nhận để ghi Phụ lục B |

**Căn cứ chọn `vni_data.xlsx`:** (i) đủ khoảng mẫu chính 2010 → 20/05/2026 với OHLC; (ii) khớp tuyệt đối (0 phiên lệch ở O, H, L, C) với `vnindex_daily.csv` của Ch3 trên 4.081 phiên chung và với `vnindex.csv` của Ch1 trên 4.041 phiên chung; (iii) không trùng ngày, không thiếu giá trị, không ngày cuối tuần, 0 vi phạm OHLC; (iv) tác giả đã xác nhận trước đây là nguồn có thẩm quyền (ghi trong PROJECT.md; run này kiểm lại bằng số liệu).

## 2. Quy tắc xử lý
| # | Quy tắc |
|---|---|
| R1 | Đổi tên `Price` → `close`; sắp xếp tăng dần theo ngày; kiểm không trùng ngày (dừng nếu có) |
| R2 | Kiểm OHLC mỗi lần nạp: $P^H \ge \max(P^O,P^C)$, $P^L \le \min(P^O,P^C)$, $P^H \ge P^L$. Vi phạm → dừng, báo Lead (hiện: 0) |
| R3 | Tỷ suất sinh lời: $r_t = 100\ln(P_t/P_{t-1})$ trên giá đóng cửa; không winsorize, không loại quan sát cực trị, không điều chỉnh ngày lễ |
| R4 | Tổn thất $L_t = -r_t$ (notation.md) |
| R5 | Mọi script đọc bản dẫn xuất qua đường dẫn tương đối và kiểm SHA trước khi chạy; không ghi vào `data/raw/` |
| R6 | Thước đo dùng giá mở cửa (Garman–Klass, Rogers–Satchell, Yang–Zhang) phải nêu hạn chế ở mục 3.2 — xem cảnh báo D1 |
| R7 | Khối lượng: không dùng từ nguồn hiện có (cảnh báo D3) |
| R8 | Đoạn 2007–2009 chỉ có trong `vnindex.csv` (Ch1); chỉ dùng nếu C05-D1 chọn làm kiểm định độ bền, và chỉ dùng giá đóng cửa (cảnh báo D2) |

## 3. Cảnh báo chất lượng dữ liệu (đã kiểm ở run này)
| # | Phát hiện | Bằng chứng | Hệ quả |
|---|---|---|---|
| D1 | Từ 2021, giá mở cửa trùng giá đóng cửa phiên trước ở phần lớn phiên | `ohlc_checks.csv`: 2–20 phiên/năm (2010–2020) → 134 (2021), 213–233 (2022–2025), 89/90 (2026) | Giá mở cửa có thể không phải giá khớp đầu phiên thực; ảnh hưởng ước lượng biên độ giá dùng $P^O$ (2.1.3, 3.2.2). Parkinson (chỉ $P^H,P^L$) ít bị ảnh hưởng. **Cần quyết định ở C03-D1** |
| D2 | Đoạn 2007 có OHLC kém | Ch1: $P^O = P^H$ ở 127/248 phiên (2007), 1 phiên biên độ bằng 0 (02/02/2007) | Khớp nhận định trong PROJECT.md; không dùng H/L/O 2007 |
| D3 | Khối lượng (chỉ Ch1) gãy đơn vị ngày 10/01/2025 | hậu tố đổi K → M với cùng độ lớn phần số (09/01/2025: 336,33K; 10/01/2025: 499,27M) | Chuỗi khối lượng không dùng được nếu không chuẩn hóa lại; nguồn kết thúc 19/03/2026 |
| D4 | `vnindex_daily.csv` (Ch3) thiếu phiên 04/01/2010 | 4.081 phiên, bắt đầu 05/01/2010; các phiên còn lại khớp tuyệt đối | Kết quả Ch3 hiện có mất 1 tỷ suất sinh lời đầu mẫu so với hợp đồng này — đối chiếu ở C03-M3 |
| D5 | Script Ch3 đọc từ `../99. Archive/…/vnindex_daily.csv` rồi **ghi đè** `03. Chuong_03/data/raw/vnindex_daily.csv` | `run_chapter03_volatility.R` dòng 18–19, 70 | Trái quy tắc raw chỉ đọc; sửa ở C03-M3 (đọc tệp chuẩn) |
| D6 | `04. Chuong_04/data/raw/VNI.csv` trùng byte với `01. Chuong_01/data/raw/vnindex.csv` | cùng SHA `289e0a51…` | Bản sao; không dùng làm nguồn riêng |
| D7 | Tỷ suất sinh lời lớn nhất | $\min r_t = -6{,}91\%$ (03/04/2025), $\max r_t = 6{,}55\%$ (10/04/2025); 2008: $|r_t| \le 4{,}80\%$ | Phù hợp với giới hạn biên độ giá của từng thời kỳ — đối chiếu với `context/vn_market_facts.md` (B11) |
| D8 | Khoảng trống lịch > 5 ngày | `gaps.csv`: chỉ rơi vào Tết Nguyên đán và 30/4–1/5 | Không có thiếu phiên bất thường; chưa đối chiếu lịch nghỉ chính thức |

## 4. Quy định cho chuỗi bổ sung (phần 2 — áp dụng khi audit HNX, ngành)
Cùng nguồn với VN-Index, ngày cuối 20/05/2026, có OHLC; kiểm R1–R2; báo cáo tự tương quan bậc 1 của $r_t$ và tỷ lệ phiên giá đứng yên (dấu hiệu giao dịch không đồng bộ); ghi SHA vào `data_manifest.csv`.
