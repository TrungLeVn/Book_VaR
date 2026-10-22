# C03-D1 — Thiết kế thực nghiệm Chương 3 (bản trình duyệt)

- **Làn:** L3 (Lead Chương 3) · **Ticket:** `tickets/C03-D1.md` · **Điểm duyệt:** Design (gói chung với C05-D1) · **Phiên bản:** v1, 22/10/2026 · **Trạng thái:** chờ tác giả duyệt.
- **Phạm vi:** chỉ thiết kế. **Không chạy mô hình** để soạn bản này. Đã đọc code/output hiện có của Ch3 và làm thống kê mô tả dữ liệu (đếm phiên, giá mở cửa, khoảng trống lịch) — mục 1.3.
- **Khai báo trước khi xem kết quả:** kết quả cũ của Ch3 (50 điểm dự báo, dữ liệu "archive fallback") đã có và đã được tác giả/agent nhìn thấy. Các lựa chọn dưới đây **không** dựa vào thứ hạng mô hình trong kết quả cũ; lý do của từng lựa chọn là lý do phương pháp hoặc dữ liệu. Sau khi duyệt, mọi thay đổi đặc tả cần ticket mới; kết quả bất lợi được giữ.
- **Căn cứ:** đề cương 3.2 (`00. Book/architecture.md`, SHA docx `93fcabb8…`); thuật ngữ/ký hiệu `00. Book/glossary.md`, `notation.md` (chốt 22/10/2026); hợp đồng dữ liệu v2 (`results/B02_20261022-1616_HNX/data_contract.md`) + v2.1 (`_project/data/README.md`); dữ kiện thể chế `context/vn_market_facts.md`.
- **Trích dẫn phương pháp** (mục 9) là tài liệu kinh điển, **chưa kiểm ở dự án này** → var-source-auditor kiểm ở C03-M4 trước khi đưa vào thân bài.

---

## 0. Tóm tắt quyết định (đề xuất)
| # | Thành phần | Hiện trạng (code `run_chapter03_volatility.R`) | Đề xuất | Lý do chính |
|---|---|---|---|---|
| 1 | Dữ liệu | Tệp archive cũ, ghi đè `data/raw/` | Tệp chuẩn `_project/data/` (SHA kiểm trước khi chạy); không ghi `data/raw/` | Hợp đồng dữ liệu v2.1 |
| 2 | Phương trình trung bình | ARMA(p,q) chọn theo BIC **trên toàn mẫu** (lọt thông tin ngoài mẫu vào dự báo) | **AR(1) + hằng số cố định trước** cho mọi mô hình GARCH; lưới ARMA chỉ báo cáo ở 3.4 | Tránh nhìn trước; AR(1) có căn cứ từ B02 (H4) |
| 3 | Tập mô hình GARCH | 8 đặc tả, không đầy đủ (chuẩn chỉ có GARCH) | **Lưới 4 × 3 = 12**: {GARCH, GJR-GARCH, EGARCH, APARCH} × {chuẩn, Student-t, Student-t lệch} | 5.6.2 cần tách vai trò phương trình phương sai và phân phối |
| 4 | Mô hình đối chứng | Cửa sổ trượt 60, 120; EWMA 0,94 | Lịch sử ($W$ phiên); cửa sổ trượt 20, 60, 120, 252; EWMA $\lambda$ = 0,94 và 0,97 | Khớp 2.1, thước đo đã báo cáo trong mẫu |
| 5 | Thiết kế ngoài mẫu | 50 điểm, mỗi 20 phiên | **Dự báo mọi phiên ngoài mẫu**; cửa sổ trượt $W$ = 1.250; tái ước lượng mỗi 20 phiên, lọc với tham số cố định giữa hai lần ước lượng → $n$ ≈ 2.830 (VN-Index, $h$ = 1) | Đủ lực kiểm định; dùng chung cho kiểm định ngược 99% ở Ch5 |
| 6 | Kỳ dự báo | 1, 5, 10, 20 | Giữ 1, 5, 10, 20 | Đã báo cáo; 10 khớp kỳ hạn VaR 10 ngày ở Ch5 |
| 7 | Thước đo đối chứng | Tổng bình phương tỷ suất sinh lời | **Chính:** tổng bình phương tỷ suất sinh lời. **Phụ:** Parkinson (chỉ $P^H, P^L$). Garman–Klass chỉ ở độ bền, VN-Index 2015–2020 | Giá mở cửa không tin cậy (B02 D1, H3) |
| 8 | Hàm tổn thất | RMSE, MAE, QLIKE | **Xếp hạng chính: QLIKE và MSE** (bền với thước đo có nhiễu); MAE báo cáo phụ, không dùng xếp hạng | Patton (2011) |
| 9 | So sánh | DM so với mô hình RMSE tốt nhất (chuẩn so sánh chọn theo kết quả); MCS chỉ trên sai số bình phương | DM (HAC, hiệu chỉnh mẫu nhỏ) so với **EWMA 0,94 cố định**; MCS trên QLIKE và MSE; MZ với sai số chuẩn HAC | Chuẩn so sánh định trước; khớp H2 |
| 10 | Giai đoạn thị trường | Chưa có | **Hai quy tắc định trước:** (a) khối theo lịch–sự kiện; (b) trạng thái biến động ex-ante (tam phân vị) | Dùng chung Ch5 (5.7) |
| 11 | Bộ dự báo dùng chung | Không | `analysis/common/` (L3b): một lần ước lượng trượt → $\hat\sigma^2$ cho Ch3 + tham số phân phối, $\hat\mu$ cho VaR/ES Ch5 | Ticket mục 7; 5.6 so sánh trên cùng ước lượng |
| 12 | HNX-Index | Chưa có | Toàn bộ tập mô hình và thiết kế, cùng code đã khoá; thước đo phụ chỉ Parkinson | Đề cương 3.7 |

**Cần tác giả quyết** (gói Design): xem mục 10 (3 điểm).

---

## 1. Dữ liệu (3.2.1–3.2.2)

### 1.1. Tệp và quy tắc
| Chuỗi | Tệp | SHA-256 | Phiên | Mẫu | Vai trò |
|---|---|---|---|---|---|
| VN-Index | `_project/data/vnindex_daily_20100104_20260520.csv` | `7c7563691623fe9a…` | 4.081 | 04/01/2010 → 20/05/2026 | Chuỗi chính (3.3–3.6, 3.8) |
| HNX-Index | `_project/data/hnxindex_daily_20100104_20260520.csv` | `79c130bed33c9e21…` | 4.083 | 04/01/2010 → 20/05/2026 | Đối chứng (3.7, Phụ lục D) |

- SHA hai tệp **đã kiểm lại 22/10/2026** trong phiên này: khớp `DATA_MANIFEST.csv`.
- $r_t = 100\ln(P_t/P_{t-1})$ trên giá đóng cửa; không winsorize, không nội suy, không điền ngày (hợp đồng v2). Mỗi chuỗi dùng lịch riêng; so sánh trực tiếp hai chuỗi (3.7.2) dùng 4.081 phiên chung.
- Code Ch3 mới **không** đọc tệp archive, **không** ghi `03. Chuong_03/data/raw/` (sửa lỗi ghi đè B02 đã nêu).

### 1.2. Giới hạn V9 (ghi ở 3.2.2 và Phụ lục B)
VN-Index thiếu phiên 23/01/2018 (bản ghi trong nguồn trùng 22/01, đã loại) và 24/01/2018 (không có trong nguồn). Tỷ suất sinh lời ngày 25/01/2018 (1,565%) gộp ba phiên. Xử lý trong thiết kế: giữ nguyên là một quan sát; không tạo biến giả; nêu trong 3.2.2. Ảnh hưởng tới đánh giá dự báo: chỉ các điểm dự báo có cửa sổ mục tiêu chứa 25/01/2018 (≤ 20 điểm mỗi kỳ dự báo) — không xử lý riêng (thấp hơn mọi ngưỡng ảnh hưởng hợp lý; ghi giới hạn).

### 1.3. Đặc điểm dữ liệu dùng để ra quyết định (thống kê mô tả, phiên này, không chạy mô hình)
| Kiểm | VN-Index | HNX-Index |
|---|---|---|
| Số tỷ suất sinh lời | 4.080 | 4.082 |
| Phiên giá mở cửa = giá đóng cửa hôm trước | 2–20 phiên/năm 2010–2020; **134/250 (2021), 213–233/năm 2022–2025, 89/90 (2026)** | 66–185 phiên/năm từ 2011 (≈ 44% toàn mẫu) |
| Phiên $P^H = P^L$ | 0 | 0 |
| Phiên $P^H, P^L$ trùng max/min$(P^O, P^C)$ | 2–12/năm | 0–7/năm |
| $\lvert r_t\rvert > 4\%$ / $> 6\%$ | 43 / 8 | 75 / 13 |
| Khoảng trống lịch > 5 ngày | 24 (Tết, 30/4–1/5) | 24 (cùng lịch) |
→ Giá cao nhất, thấp nhất dùng được trên toàn mẫu; giá mở cửa không dùng được với VN-Index từ 2021 và với HNX-Index ở hầu hết các năm.

---

## 2. Thước đo biến động đối chứng (3.2.2; ticket mục 2, 8)

Thước đo đối chứng của phương sai kỳ $h$ lập tại $t$: $\tilde\sigma^2_{t,h}$.

| Thước đo | Công thức (theo %²) | Vai trò | Lý do |
|---|---|---|---|
| Bình phương tỷ suất sinh lời | $\tilde\sigma^2_{t,h} = \sum_{j=1}^{h} r_{t+j}^2$ | **Chính** (mọi chuỗi, mọi kỳ) | Không cần giá mở cửa; không chệch có điều kiện khi $\mu_t \approx 0$; khớp kết quả cũ (tái tạo được) |
| Parkinson | $\tilde\sigma^2_{t,h} = \sum_{j=1}^{h} \dfrac{[100\ln(P^H_{t+j}/P^L_{t+j})]^2}{4\ln 2}$ | **Phụ** (độ bền 3.8; với HNX-Index ở 3.7) | Ít nhiễu hơn bình phương tỷ suất sinh lời; chỉ cần $P^H, P^L$ — không chịu lỗi giá mở cửa |
| Garman–Klass | công thức Ch2 (2.1.3) | Chỉ độ bền phụ: VN-Index, điểm dự báo đến 31/12/2020 | Giá mở cửa đáng tin chỉ đến 2020 (mục 1.3) |
| Rogers–Satchell, Yang–Zhang | — | **Không dùng** trong thực nghiệm; nêu ở 3.2.2 lý do không dùng | Cần giá mở cửa (cả khoảng trống qua đêm) |

Ghi chú phương pháp phải nêu trong 3.2.2:
- Parkinson bỏ qua biến động qua đêm (khoảng giữa đóng cửa hôm trước và mở cửa) nên **chệch xuống** về mức; vì vậy không dùng làm thước đo chính cho xếp hạng (điều kiện "không chệch có điều kiện" của Patton (2011) không đạt). Ở 3.8 chỉ so **thứ hạng** và nhóm MCS, không so mức sai số.
- Biến động thực hiện trong ngày (2.5.1) không có dữ liệu (không có giá trong ngày) → nêu ở 6.4.3; không đưa vào Ch3.
- QLIKE cần $\tilde\sigma^2_{t,h} > 0$: với bình phương tỷ suất sinh lời, $h$ = 1 có thể bằng 0 (phiên $r_t$ = 0). Quy tắc định trước: tính QLIKE trên các điểm có $\tilde\sigma^2 > 0$; báo số điểm bị loại; MSE dùng mọi điểm.

---

## 3. Tập mô hình (3.2.3; ticket mục 3)

### 3.1. Phương trình trung bình (cố định trước)
- **Chính:** $r_t = \phi_0 + \phi_1 r_{t-1} + \varepsilon_t$ (AR(1) + hằng số) cho mọi mô hình GARCH, cả hai chuỗi, trong và ngoài mẫu.
- **Lý do:** (i) code cũ chọn ARMA trên toàn mẫu — lọt thông tin của giai đoạn ngoài mẫu vào đặc tả dùng để dự báo; (ii) AR(1) của $r_t$ có ý nghĩa thống kê ở VN-Index (0,088; ±0,031 ở 95%, B02 H4), gần biên ở HNX-Index (0,041) — dùng cùng một đặc tả cho hai chuỗi để so sánh 3.7.2; (iii) dự báo biến động ít nhạy với phương trình trung bình.
- **3.4.1** vẫn báo cáo bảng lưới ARMA(0..3, 0..3) với BIC và Ljung–Box (tái tạo bảng 3.8b cũ) như phần chẩn đoán; không dùng để chọn đặc tả dự báo.
- **Độ bền (3.8):** phương trình trung bình chỉ có hằng số.

### 3.2. Phương trình phương sai × phân phối sai số (lưới đầy đủ)
| | Chuẩn | Student-t | Student-t lệch ($\eta$) |
|---|---|---|---|
| GARCH(1,1) | ✓ (có) | ✓ (có) | **mới** |
| GJR-GARCH(1,1) | **mới** | ✓ (có) | ✓ (có) |
| EGARCH(1,1) | **mới** | ✓ (có) | ✓ (có) |
| APARCH(1,1) | **mới** | ✓ (có) | ✓ (có) |
- 12 mô hình (8 có sẵn + 4 mới). Bậc (1,1) cố định, không chọn bậc theo dữ liệu.
- **Lý do lưới đầy đủ:** 5.6.2 "vai trò của phương trình phương sai và phân phối sai số" và giả thuyết H3, H4 cần so sánh từng chiều khi chiều kia giữ nguyên; lưới 8 mô hình cũ không cho làm việc đó (phân phối chuẩn chỉ đi với GARCH).
- Ước lượng: hợp lý cực đại (rugarch, solver "hybrid" như code cũ). Không ràng buộc thêm ngoài mặc định của gói.
- **Không đưa vào bộ chính:** GARCH bộ nhớ dài (FIGARCH, 2.2.4) — cửa sổ 1.250 phiên ngắn để ước lượng tham số bộ nhớ dài ổn định và ước lượng trượt thường không hội tụ; nêu ở 3.9/6.4.1. Có thể bổ sung ở độ bền nếu tác giả muốn (mục 10, điểm 2).

### 3.3. Mô hình đối chứng (không tham số)
| Mô hình | Dự báo $\hat\sigma^2_{t+1\mid t}$ | Kỳ $h$ |
|---|---|---|
| Lịch sử | phương sai mẫu của $W$ phiên trong cửa sổ | $h \cdot \hat\sigma^2_{t+1\mid t}$ |
| Cửa sổ trượt $m$ = 20, 60, 120, 252 | $\frac{1}{m}\sum_{j=0}^{m-1} r_{t-j}^2$ | $h \cdot \hat\sigma^2_{t+1\mid t}$ |
| EWMA $\lambda$ = 0,94 (chuẩn so sánh RiskMetrics) và 0,97 | $\lambda\hat\sigma^2_{t\mid t-1} + (1-\lambda) r_t^2$, khởi tạo bằng phương sai 60 phiên đầu cửa sổ | $h \cdot \hat\sigma^2_{t+1\mid t}$ |
- Tổng cộng **19 mô hình** cho mọi chuỗi, mọi kỳ. $\lambda$ cố định (không ước lượng) — đúng thực hành RiskMetrics và Ch2.
- Dự báo GARCH nhiều bước: $\hat\sigma^2_{t,h} = \sum_{j=1}^{h}\hat\sigma^2_{t+j\mid t}$ (dự báo đệ quy của từng mô hình).

---

## 4. Thiết kế dự báo ngoài mẫu (3.2.3, 3.5; ticket mục 1, 7)

| Thành phần | Đề xuất | Lý do |
|---|---|---|
| Cửa sổ ước lượng | Trượt, $W$ = 1.250 phiên (~5 năm) | Giữ đặc tả cũ (tái tạo được); đủ dài cho Student-t lệch; khớp ký hiệu notation.md |
| Điểm dự báo | **Mọi phiên** $t = W, \dots, T-h$ | 50 điểm cũ không đủ lực cho DM/MCS và không đủ cho kiểm định ngược 99% ở Ch5 |
| Tái ước lượng | Mỗi 20 phiên; giữa hai lần, **lọc** phương sai với tham số cố định bằng dữ liệu đến $t$ | Giữ tần suất cũ; giới hạn thời gian chạy; không dùng thông tin sau $t$ |
| Số điểm $n$ ($h$ = 1) | VN-Index ≈ 2.830 (từ 13/01/2015); HNX-Index ≈ 2.832 | Tính từ số phiên (mục 1.3) |
| Không hội tụ | Lần ước lượng lỗi → dùng tham số của lần ước lượng hợp lệ trước đó, ghi cờ; tỷ lệ lỗi báo theo mô hình | Không loại điểm dự báo (tránh mẫu khác nhau giữa mô hình) |
| Mẫu đánh giá chung | Mọi mô hình đánh giá trên cùng tập điểm | So sánh công bằng; MCS cần ma trận đủ |
| Hạt giống ngẫu nhiên | `set.seed(20261022)` cho bootstrap MCS; ghi trong README run | Tái lập |

- Kỳ $h$ > 1: điểm dự báo hằng ngày nên mục tiêu chồng lấn → sai số dự báo tự tương quan tới bậc $h-1$; xử lý trong kiểm định (mục 5).
- **Ước lượng chi phí (chưa kiểm):** 12 mô hình × ⌈2.830/20⌉ = 142 lần ước lượng ≈ 1.700 lần cho một chuỗi/một cấu hình; cả thiết kế (2 chuỗi + độ bền mục 7) ≈ 12–15 nghìn lần ước lượng. Chạy với 3 tiến trình (LANES mục 6).

### 4.1. Bộ dự báo dùng chung Ch3 ↔ Ch5 (`analysis/common/`, làn L3b) — khuyến nghị: **có**
- Một lần ước lượng trượt cho 12 mô hình GARCH × 2 chuỗi; lưu theo điểm dự báo: $\hat\mu_{t+1\mid t}$, $\hat\sigma^2_{t+j\mid t}$ ($j$ = 1..20), tham số phân phối ($\nu$, $\eta$), cờ hội tụ, ngày ước lượng gần nhất.
- Ch3 dùng $\hat\sigma^2$; Ch5 tính VaR/ES tham số có điều kiện từ cùng $\hat\mu$, $\hat\sigma$, phân vị phân phối — bảo đảm 5.6 so sánh xếp hạng **trên cùng một ước lượng**, không do khác cửa sổ/tần suất.
- Đủ cho kiểm định ngược 99%: $n$ ≈ 2.830 → kỳ vọng ≈ 28 vi phạm ở $\alpha$ = 0,01 ($h$ = 1).
- Định dạng: một tệp dài (parquet hoặc csv.gz) mỗi chuỗi; README ghi SHA; Ch5 chỉ đọc bản đã khoá (LANES mục 3, 5).
- Các mô hình riêng của Ch5 (mô phỏng lịch sử, EVT, hồi quy phân vị, cửa sổ riêng) thuộc C05-D1.

---

## 5. Đánh giá và so sánh dự báo (3.5; 2.6.2–2.6.3)

### 5.1. Hàm tổn thất
- $\mathrm{MSE} = \frac1n\sum (\tilde\sigma^2_{t,h} - \hat\sigma^2_{t,h})^2$; báo cáo RMSE cho dễ đọc (cùng thứ hạng).
- $\mathrm{QLIKE} = \frac1n\sum\left[\tilde\sigma^2_{t,h}/\hat\sigma^2_{t,h} - \ln(\tilde\sigma^2_{t,h}/\hat\sigma^2_{t,h}) - 1\right]$ (như code cũ).
- **Xếp hạng chính: QLIKE** (ít bị chi phối bởi vài phiên cực trị; bền với thước đo có nhiễu); MSE thứ hai. MAE chỉ báo cáo phụ (không bền với thước đo có nhiễu theo Patton 2011) — giải thích ở 3.5.1 vì kết quả cũ có MAE.

### 5.2. Kiểm định
| Kiểm định | Đặc tả định trước | Phục vụ |
|---|---|---|
| Diebold–Mariano | Mỗi mô hình so với **EWMA 0,94** (cố định); $d_t$ trên QLIKE và MSE; phương sai HAC (Newey–West, độ trễ $\max(h-1, 5)$); hiệu chỉnh Harvey–Leybourne–Newbold; hai phía | H2; thay chuẩn so sánh chọn theo kết quả của code cũ |
| Diebold–Mariano phụ | Từng cặp trong lưới: cùng phân phối khác phương trình phương sai, cùng phương trình khác phân phối | H3, H4; 5.6.2 |
| Bộ tin cậy mô hình (MCS) | Mức 10% (chính) và 25% (phụ); thống kê $T_{\max}$; bootstrap khối, độ dài khối $\max(h, 5)$, $B$ = 5.000; trên QLIKE và MSE | 3.5.2 xếp hạng |
| Mincer–Zarnowitz | $\tilde\sigma^2_{t,h} = a + b\,\hat\sigma^2_{t,h} + u$; kiểm $a=0, b=1$ với HAC; báo $R^2$ | 3.5.1 độ chệch |
- **Nhiều phép so sánh:** DM là thông tin mô tả theo cặp; kết luận xếp hạng dựa trên MCS (đã kiểm soát nhiều phép so sánh). Nêu rõ ở 3.5.2.
- **Xếp hạng chuyển sang 5.6 (định trước):** thứ hạng theo QLIKE trung bình, $h$ = 1, thước đo chính, VN-Index; kèm tư cách thành viên MCS 10%. Cả 12 mô hình GARCH được chuyển sang Ch5 (không lọc theo kết quả Ch3).

---

## 6. Quy tắc chia giai đoạn thị trường (3.6 ↔ 5.7; ticket mục 4) — dùng chung với Ch5

Hai quy tắc, cùng định trước, cùng áp cho VN-Index và HNX-Index. **Không** chọn ngày đỉnh/đáy theo dữ liệu để tránh nhìn trước.

### 6.1. Quy tắc A — khối theo lịch và sự kiện (chính cho diễn giải)
| Khối | Khoảng (điểm dự báo $t$) | Đặc trưng (diễn giải, ghi `[cần xác nhận]` khi viết) | Mốc thể chế có nguồn |
|---|---|---|---|
| G1 | 13/01/2015 → 31/12/2017 | Sau nới biên độ 2013; chuyển T+2 | L10 (15/01/2013), S3 (T+2 từ 01/01/2016) |
| G2 | 2018 → 2019 | Điều chỉnh sau đỉnh 2018 `[cần xác nhận]` | — |
| G3 | 2020 | Cú sốc COVID-19 `[cần xác nhận]` | L20 (không đổi biên độ) |
| G4 | 2021 | Dòng tiền nhà đầu tư cá nhân, nghẽn lệnh `[cần xác nhận]` | T5 (05/07/2021) |
| G5 | 2022 | Sụt giảm mạnh, thị trường trái phiếu doanh nghiệp `[cần xác nhận]` | S4 (29/08/2022) |
| G6 | 2023 → 20/05/2026 | Phục hồi; hệ thống KRX; nâng hạng FTSE (sau mẫu) | T1 (05/05/2025), F4–F5 (21/09/2026, sau mẫu) |
- Ranh giới theo **năm dương lịch** (không theo ngày đỉnh/đáy) — đơn giản, minh bạch, không phụ thuộc kết quả. Mỗi khối ≥ 249 điểm.
- Mô hình **không** ước lượng lại theo khối: chỉ chia mẫu đánh giá của dự báo đã có (mục 4) để tính tổn thất, DM, MCS theo khối.

### 6.2. Quy tắc B — trạng thái biến động ex-ante (chính cho kiểm định H5)
- Chỉ báo: độ lệch chuẩn cửa sổ trượt 60 phiên tính tới $t$: $\hat\sigma_{t,60}$ (chỉ dùng thông tin đến $t$ — không điều kiện hóa trên mục tiêu dự báo).
- Ngưỡng: tam phân vị của $\hat\sigma_{t,60}$ trên **toàn bộ mẫu ước lượng ban đầu + ngoài mẫu** của từng chuỗi → ba trạng thái: thấp / trung bình / cao.
- Lý do dùng ex-ante thay vì ex-post: chia theo biến động thực hiện sau $t$ sẽ chọn các điểm có $\tilde\sigma^2$ lớn và làm lệch so sánh hàm tổn thất.
- Tam phân vị lấy trên toàn mẫu là phân loại phục vụ **đánh giá**, không dùng trong dự báo — chấp nhận được; nêu rõ.

### 6.3. Đo "thứ hạng thay đổi theo giai đoạn" (H5)
- Trong mỗi khối/trạng thái: QLIKE, MSE theo mô hình; MCS 10%; tương quan hạng Spearman của thứ hạng giữa các khối và với toàn mẫu.
- Lực thống kê theo khối thấp hơn toàn mẫu (≈ 250–750 điểm): diễn giải là mô tả, không coi khác biệt không ý nghĩa là bằng chứng ổn định.
- **Cho Ch5:** khối G3 và G5 (~250 điểm) chỉ có kỳ vọng ≈ 2,5 vi phạm ở VaR 99% → L5 quyết định kiểm định nào báo cáo theo khối (ghi ở C05-D1).

---

## 7. Kiểm định độ bền (3.8; ticket mục 5)
Định trước; mỗi kiểm định đổi **một** yếu tố; báo cáo thứ hạng QLIKE $h$ = 1 và $h$ = 10, nhóm MCS 10%, so với cấu hình chính.

| # | Yếu tố | Cấu hình | Mẫu đánh giá |
|---|---|---|---|
| R1 | Cửa sổ ước lượng | $W$ = 750 (trượt) | Chung với cấu hình chính (từ 13/01/2015) |
| R2 | Cửa sổ ước lượng | Mở rộng dần từ 1.250 | Như trên (đáp ứng 3.7.3 cũ "expanding window") |
| R3 | Thước đo đối chứng | Parkinson | Toàn mẫu ngoài mẫu |
| R4 | Thước đo đối chứng | Garman–Klass | VN-Index, điểm dự báo đến 31/12/2020 |
| R5 | Quan sát cực trị | Bỏ 1% điểm có $\tilde\sigma^2_{t,h}$ lớn nhất khỏi **đánh giá** (không bỏ khỏi ước lượng) | Toàn mẫu |
| R6 | Phương trình trung bình | Chỉ hằng số | Toàn mẫu |
| R7 | Mức MCS | 25% | Toàn mẫu |
- R1–R2 chỉ chạy cho VN-Index (HNX-Index chỉ cấu hình chính + R3) để giữ thời gian chạy; mở rộng cho HNX-Index chỉ khi tác giả yêu cầu.
- Không chọn cấu hình "tốt nhất" sau khi xem độ bền; cấu hình chính giữ nguyên.

---

## 8. Tính khái quát trên HNX-Index (3.7; ticket mục 6)
- Toàn bộ 19 mô hình, cùng thiết kế mục 4–5, **cùng code đã khoá** (C03-M3c chạy sau khi M3a/M3b khoá code). Không chỉ số ngành, không VN30.
- 3.7.1: tóm tắt ước lượng trong mẫu (tính bền, bất đối xứng, bậc tự do) + bảng QLIKE/MSE, MCS. Chi tiết ở Phụ lục D.
- 3.7.2: so sánh với VN-Index trên **4.081 phiên chung**: tương quan hạng Spearman của thứ hạng mô hình (theo hàm tổn thất × kỳ); trùng lặp nhóm MCS; khác biệt tham số chính.
- Thước đo phụ HNX-Index: chỉ Parkinson (giá mở cửa không tin cậy ~44% toàn mẫu, B02 H3).
- Diễn giải: khác biệt HOSE–HNX **không** quy thành tác động nhân quả của biên độ giá (lẫn quy mô, thanh khoản, cơ cấu chỉ số) — PROJECT.md "Cần thận trọng".

---

## 9. Giả thuyết (3.1.3) — viết lại thành dạng kiểm định được
| | Giả thuyết | Bằng chứng định trước | Mục |
|---|---|---|---|
| H1 | Tỷ suất sinh lời VN-Index, HNX-Index có cụm biến động và hiệu ứng ARCH | Ljung–Box trên $r_t^2$, ARCH-LM (độ trễ 12, như cũ); kiểm định dấu (sign bias) Engle–Ng cho bất đối xứng | 3.3.2 |
| H2 | Mô hình GARCH không vượt EWMA 0,94 ở mọi kỳ và mọi hàm tổn thất | DM so với EWMA 0,94; EWMA có trong MCS 10% hay không | 3.5 |
| H3 | Phương trình phương sai bất đối xứng cải thiện dự báo so với GARCH đối xứng cùng phân phối | DM theo cặp (GJR/EGARCH/APARCH vs GARCH, giữ phân phối); MCS | 3.4, 3.5 |
| H4 | Phân phối đuôi dày (Student-t, Student-t lệch) cải thiện so với chuẩn | Trong mẫu: AIC/BIC, kiểm định tỷ lệ hợp lý; ngoài mẫu: DM theo cặp giữ phương trình phương sai | 3.4, 3.5 |
| H5 | Thứ hạng mô hình thay đổi theo giai đoạn thị trường | Mục 6.3 | 3.6 |
- Ghi chú: phân phối sai số tác động tới dự báo phương sai chủ yếu qua ước lượng tham số → H4 ngoài mẫu có thể yếu ở Ch3 nhưng mạnh ở Ch5 (VaR/ES); đây chính là câu hỏi 5.6.2 — không coi H4 yếu ở Ch3 là bất lợi cần giấu.

### Tài liệu phương pháp dẫn trong thiết kế (chưa kiểm — C03-M4)
Patton (2011, *Journal of Econometrics*) — hàm tổn thất bền với thước đo có nhiễu; Diebold & Mariano (1995, *JBES*); Harvey, Leybourne & Newbold (1997, *IJF*); Hansen, Lunde & Nason (2011, *Econometrica*) — MCS; Mincer & Zarnowitz (1969); Parkinson (1980, *Journal of Business*); Garman & Klass (1980, *Journal of Business*); Engle & Ng (1993, *Journal of Finance*); Hansen & Lunde (2005, *Journal of Applied Econometrics*). Mọi key bib và số trang kiểm ở C03-M4; chưa kiểm → `[Missing Citation]` khi viết.

---

## 10. Cần tác giả quyết (gói Design)
| # | Câu hỏi | Lựa chọn | Hệ quả | Khuyến nghị |
|---|---|---|---|---|
| 1 | Thiết kế ngoài mẫu | (a) Mọi phiên, $W$ = 1.250 trượt, tái ước lượng 20 phiên, lưới 12 GARCH + 7 đối chứng, bộ dự báo dùng chung Ch5; (b) giữ 50 điểm cũ | (a) $n$ ≈ 2.830, đủ lực cho DM/MCS và kiểm định ngược 99%; chạy ~vài giờ; **số liệu Ch3 hiện có sẽ thay toàn bộ** (bản cũ giữ làm "reported"); (b) nhanh nhưng không đủ cho Ch5, không trả lời được 5.6.2 | **(a)** |
| 2 | Tập mô hình | (a) Lưới 12 GARCH (thêm 4) không FIGARCH; (b) (a) + FIGARCH-Student-t ở độ bền; (c) giữ 8 mô hình cũ | (b) tốn thêm thời gian, rủi ro không hội tụ; (c) không tách được vai trò phân phối ở 5.6.2 | **(a)** |
| 3 | Phương trình trung bình và giai đoạn | (a) AR(1) cố định; giai đoạn theo quy tắc A (khối năm, diễn giải) + B (tam phân vị ex-ante, kiểm H5); (b) giữ ARMA chọn theo BIC toàn mẫu; giai đoạn theo ngày đỉnh/đáy do tác giả chỉ định | (b) lọt thông tin ngoài mẫu; ngày đỉnh/đáy chọn sau khi nhìn dữ liệu | **(a)**; nếu tác giả muốn ranh giới khác cho quy tắc A, nêu trước khi chạy M3 |

Mặc định áp dụng nếu tác giả duyệt không ghi chú: thước đo đối chứng (mục 2), hàm tổn thất và kiểm định (mục 5), độ bền R1–R7 (mục 7), HNX-Index (mục 8).

---

## 11. Ánh xạ sang ticket chạy (sau khi duyệt)
| Ticket (làn) | Nội dung từ thiết kế này | Đầu ra |
|---|---|---|
| C03-M3a (L3a) | Mục 1, 3.1 (lưới ARMA chẩn đoán), 3.2–3.3 trong mẫu; 3.3 thống kê, kiểm định H1 cho hai chuỗi; ước lượng trong mẫu 12 GARCH VN-Index; tái tạo nguyên trạng script cũ trên dữ liệu chuẩn để đối chiếu reported ↔ executed | `analysis/ch03/a_insample/`, `results/C03-M3a_<ts>/` |
| C03-M3b (L3b) | Mục 4 (bộ dự báo dùng chung `analysis/common/`), 5, 6, 7 cho VN-Index | `analysis/common/`, `analysis/ch03/b_forecast/`, `results/C03-M3b_<ts>/` |
| C03-M3c (L3c) | Mục 8 (HNX-Index: chạy bộ dự báo đã khoá + đánh giá + so sánh) | `analysis/ch03/c_hnx/`, `results/C03-M3c_<ts>/` |
- Danh mục exhibit dự kiến (đặt tên ổn định `tbl_3_k`, `fig_3_k` ở M3): 3.3 thống kê mô tả hai chuỗi; kiểm định phân phối/tính dừng/ARCH/dấu; 3.4 lưới ARMA, tiêu chí thông tin 12 mô hình, hệ số, tính bền–chu kỳ bán rã, chẩn đoán phần dư, đường tác động tin tức; 3.5 QLIKE/MSE theo kỳ, MZ, DM so với EWMA, MCS; 3.6 tổn thất theo khối/trạng thái, tương quan hạng; 3.7 bảng tóm tắt HNX-Index + so sánh; 3.8 bảng R1–R7.

## 12. Cần khớp với C05-D1 (L5 đọc mục này)
1. $W$ = 1.250 trượt, tái ước lượng 20 phiên, AR(1) cố định cho mô hình GARCH có điều kiện — Ch5 dùng cùng bộ dự báo; nếu Ch5 cần $W$ = 500 (notation.md ghi "Ch5: 500 — chốt ở C05-D1") thì chỉ cho phương pháp phi tham số/bán tham số riêng của Ch5, hoặc ghi rõ khác biệt khi so sánh 5.6.
2. Kỳ 10 phiên ở Ch3 khớp kỳ hạn nắm giữ 10 ngày của Ch5 (dự báo $\hat\sigma^2_{t,10}$ có sẵn trong bộ dùng chung).
3. Quy tắc giai đoạn A, B (mục 6) dùng nguyên cho 5.7.
4. Tham số phân phối ($\nu$, $\eta$) và $\hat\mu$ lưu theo điểm dự báo trong bộ dùng chung.
5. Chưa có bản `design/C05-D1_design.md` trong phiên này → gói Design chung chưa gộp được; L3 gộp khi bản C05 có.
