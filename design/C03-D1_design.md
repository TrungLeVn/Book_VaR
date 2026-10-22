# C03-D1 — Thiết kế thực nghiệm Chương 3 (bản trình duyệt)

- **Làn:** L3 (Lead Chương 3) · **Ticket:** `tickets/C03-D1.md` · **Điểm duyệt:** Design (gói chung với C05-D1) · **Trạng thái:** chờ gộp với C05-D1 rồi trình tác giả.
- **Phiên bản:** **v2, 22/10/2026**. Bản này sửa v1 (git `c84eebc`) theo review độc lập `reviews/20261022_ch03_design-review.md`: xử lý 4 Major M1–M4 và 15 Minor m1–m15. M5 (chưa có C05-D1 để gộp gói) là điểm dừng, xem mục 10, 12. Bảng đối chiếu sửa đổi ở mục 13.
- **Phạm vi:** chỉ thiết kế, **không chạy mô hình**. Đã đọc: `03. Chuong_03/chapter.md` (SHA `2c6e42298c5164a4…`, 711 dòng; 3.7 cũ "Thiết kế dự báo", bảng 3.14, giả thuyết H1–H5 ở 3.3.6), `code/R/run_chapter03_volatility.R` (SHA `bd58c52349625e1a…`), output cũ trong `03. Chuong_03/output/`. Đã làm thống kê mô tả dữ liệu (đếm phiên, giá mở cửa, khoảng trống lịch) ở mục 1.3.
- **Khai báo trước khi xem kết quả:** kết quả cũ của Ch3 (50 điểm dự báo, dữ liệu "archive fallback") đã có, tác giả và agent đã xem. Các lựa chọn dưới đây **không** dựa vào thứ hạng mô hình trong kết quả cũ. Lý do của từng lựa chọn là lý do phương pháp hoặc dữ liệu. Sau khi duyệt, đổi đặc tả phải mở ticket mới. Kết quả bất lợi được giữ.
- **Căn cứ:** đề cương 3.2 (`00. Book/architecture.md`, SHA docx `93fcabb8…`); `00. Book/glossary.md`, `notation.md` (chốt 22/10/2026); hợp đồng dữ liệu v2 (`results/B02_20261022-1616_HNX/data_contract.md`) và v2.1 (`_project/data/README.md`); dữ kiện thể chế từ `context/vn_market_facts.md`.
- **Trích dẫn phương pháp** (mục 9): tài liệu kinh điển, **chưa kiểm trong dự án**. var-source-auditor kiểm ở C03-M4. Khi viết, chỗ chưa kiểm ghi `[Missing Citation]`.

---

## 0. Tóm tắt quyết định (đề xuất)
| # | Thành phần | Hiện trạng (code cũ) | Đề xuất | Lý do chính |
|---|---|---|---|---|
| 1 | Dữ liệu | Tệp archive cũ; ghi đè `data/raw/` | Tệp chuẩn `_project/data/`, kiểm SHA trước khi chạy; không ghi `data/raw/` | Hợp đồng dữ liệu v2.1 |
| 2 | Phương trình trung bình | ARMA(p,q) chọn theo BIC **trên toàn mẫu**, nên thông tin ngoài mẫu lọt vào dự báo | **AR(1) + hằng số, cố định tiên nghiệm** cho mọi mô hình GARCH. Lưới ARMA chỉ báo cáo mô tả ở 3.4 | Tránh nhìn trước |
| 3 | Tập mô hình GARCH | 8 đặc tả, lưới không đầy đủ | **Lưới 4 × 3 = 12**: {GARCH, GJR-GARCH, EGARCH, APARCH} × {chuẩn, Student-t, Student-t lệch} | Tách vai trò phương trình phương sai và phân phối (H3, H4, 5.6.2) |
| 4 | Mô hình đối chứng | Cửa sổ trượt 60, 120; EWMA 0,94 | Lịch sử ($W$ phiên); cửa sổ trượt 20, 60, 120, 252; EWMA 0,94 và 0,97 | Khớp mục 2.1 của Ch2 |
| 5 | Thiết kế ngoài mẫu | 50 điểm, mỗi 20 phiên | **Dự báo mọi phiên**; cửa sổ trượt $W$ = 1.250; tái ước lượng mỗi 20 phiên, giữa hai lần thì lọc với tham số cố định; $n$ ≈ 2.830 (VN-Index, $h$ = 1) | Đủ lực kiểm định; dùng chung cho kiểm định ngược 99% ở Ch5 |
| 6 | Kỳ dự báo | 1, 5, 10, 20 | Giữ 1, 5, 10, 20. **Kỳ chính để kết luận: 1 và 10** | Đã báo cáo; kỳ 10 khớp VaR 10 ngày ở Ch5 |
| 7 | Thước đo đối chứng | Tổng bình phương tỷ suất sinh lời | **Chính:** tổng bình phương tỷ suất sinh lời. **Phụ:** Parkinson (chỉ cần $P^H, P^L$). Garman–Klass chỉ ở độ bền, VN-Index, giai đoạn 2015–2020 | Giá mở cửa không tin cậy (B02 D1, H3) |
| 8 | Hàm tổn thất | RMSE, MAE, QLIKE | **QLIKE chính**; MSE báo cáo song song, khi hai hàm cho kết quả khác nhau thì báo cả hai, không chọn; MAE chỉ là phụ lục | Patton (2011) |
| 9 | Quy tắc quyết định | Không có | **MCS 10% trên QLIKE, $h$ = 1 và 10** là quy tắc chính cho H2–H4. DM theo cặp có hiệu chỉnh Holm trong từng họ kiểm định. H5 dùng hồi quy chênh lệch tổn thất lên biến giả giai đoạn, kiểm định Wald với sai số HAC | Định trước; kiểm soát nhiều phép so sánh |
| 10 | Giai đoạn thị trường | Chưa có | **A:** khối năm dương lịch gắn mốc thể chế. **B:** trạng thái biến động ex-ante theo chỉ báo Parkinson 20 phiên (không trùng mô hình nào), ngưỡng tam phân vị trên mẫu ngoài mẫu | Dùng chung với 5.7 |
| 11 | Bộ dự báo dùng chung | Không | `analysis/common/` (L3b) lưu đủ trường cho Ch5: mô phỏng lịch sử có lọc, VaR/ES 10 ngày (mục 4.1) | Ticket mục 7 |
| 12 | HNX-Index | Chưa có | Toàn bộ tập mô hình và thiết kế, dùng cùng code đã khoá; thước đo phụ chỉ Parkinson | Đề cương 3.7 |

---

## 1. Dữ liệu (3.2.1–3.2.2)

### 1.1. Tệp và quy tắc
| Chuỗi | Tệp | SHA-256 | Phiên | Mẫu | Vai trò |
|---|---|---|---|---|---|
| VN-Index | `_project/data/vnindex_daily_20100104_20260520.csv` | `7c7563691623fe9a…` | 4.081 | 04/01/2010 → 20/05/2026 | Chuỗi chính (3.3–3.6, 3.8) |
| HNX-Index | `_project/data/hnxindex_daily_20100104_20260520.csv` | `79c130bed33c9e21…` | 4.083 | 04/01/2010 → 20/05/2026 | Đối chứng (3.7, Phụ lục D) |
- Đã kiểm lại SHA hai tệp ngày 22/10/2026 trong phiên này: khớp `DATA_MANIFEST.csv`.
- $r_t = 100\ln(P_t/P_{t-1})$ trên giá đóng cửa. Không winsorize, không nội suy, không điền ngày. Mỗi chuỗi dùng lịch riêng; so sánh trực tiếp hai chuỗi (3.7.2) dùng 4.081 phiên chung.
- Code mới không đọc tệp archive và không ghi vào `03. Chuong_03/data/raw/`.

### 1.2. Giới hạn V9 (ghi ở 3.2.2 và Phụ lục B)
VN-Index thiếu phiên 23/01/2018 (bản ghi trùng 22/01, đã loại) và 24/01/2018 (nguồn không có). Tỷ suất sinh lời ngày 25/01/2018 (1,565%) gộp ba phiên. Thiết kế giữ nguyên quan sát này, không tạo biến giả, và nêu ở 3.2.2. Chỉ những điểm dự báo có cửa sổ mục tiêu chứa 25/01/2018 bị ảnh hưởng (≤ 20 điểm mỗi kỳ). Độ bền R5b (mục 7) loại các điểm này khỏi đánh giá.

### 1.3. Đặc điểm dữ liệu dùng để ra quyết định (thống kê mô tả trong phiên này, không chạy mô hình; *executed* bằng Python, chưa có run folder)
| Kiểm | VN-Index | HNX-Index |
|---|---|---|
| Số tỷ suất sinh lời | 4.080 | 4.082 |
| Phiên giá mở cửa = giá đóng cửa hôm trước | 2–20 phiên/năm giai đoạn 2010–2020; **134/250 (2021), 213–233/năm (2022–2025), 89/90 (2026)** | 66–185 phiên/năm từ 2011 (≈ 44% toàn mẫu) |
| Phiên $P^H = P^L$ | 0 | 0 |
| Phiên có $P^H, P^L$ trùng max/min$(P^O, P^C)$ | 2–12/năm | 0–7/năm |
| $\lvert r_t\rvert > 4\%$ / $> 6\%$ | 43 / 8 | 75 / 13 |
| Khoảng trống lịch > 5 ngày | 24 (Tết, 30/4–1/5) | 24 (cùng lịch) |
→ Giá cao nhất và thấp nhất dùng được trên toàn mẫu. Giá mở cửa không dùng được với VN-Index từ 2021 và với HNX-Index ở hầu hết các năm. C03-M3a lưu lại bảng này trong run folder.

---

## 2. Thước đo biến động đối chứng (3.2.2; ticket mục 2, 8)

Ký hiệu $\tilde\sigma^2_{t,h}$ là thước đo đối chứng của phương sai kỳ $h$, lập tại $t$.

| Thước đo | Công thức (đơn vị %²) | Vai trò | Lý do |
|---|---|---|---|
| Bình phương tỷ suất sinh lời | $\tilde\sigma^2_{t,h} = \sum_{j=1}^{h} r_{t+j}^2$ | **Chính** (mọi chuỗi, mọi kỳ) | Không cần giá mở cửa; xấp xỉ không chệch có điều kiện khi $\mu_t \approx 0$; khớp kết quả cũ nên tái tạo được |
| Parkinson | $\tilde\sigma^2_{t,h} = \sum_{j=1}^{h} \dfrac{[100\ln(P^H_{t+j}/P^L_{t+j})]^2}{4\ln 2}$ | **Phụ** (độ bền R3; cùng dùng cho HNX-Index ở 3.7) | Ít nhiễu hơn; chỉ cần $P^H, P^L$ |
| Parkinson điều chỉnh mức | $c \cdot$ Parkinson, với $c$ = trung bình $r_t^2$ / trung bình Parkinson, tính **trên cửa sổ ước lượng đầu tiên (1.250 phiên)** của từng chuỗi | Phụ (R3b) | Bù phần biến động qua đêm mà Parkinson bỏ qua; $c$ tính ex-ante |
| Garman–Klass | công thức ở mục 2.1.3 Ch2 | Chỉ độ bền R4: VN-Index, điểm dự báo có **cửa sổ mục tiêu kết thúc trước hoặc vào 31/12/2020** | Giá mở cửa chỉ tin cậy đến 2020 |
| Rogers–Satchell, Yang–Zhang | — | **Không dùng.** Mục 3.2.2 nêu lý do | Cần giá mở cửa |

Ghi chú phương pháp, đưa vào 3.2.2:
- Parkinson bỏ qua biến động qua đêm nên chệch xuống về mức. Thước đo chệch có điều kiện có thể làm đổi cả thứ hạng theo QLIKE hoặc MSE, vì điều kiện của Patton (2011) không còn thỏa. Do đó kết quả theo Parkinson trả lời một câu hỏi khác: mô hình dự báo biến động **trong phiên** tốt đến đâu. Kết quả này không dùng để thay kết luận chính. R3b (bản điều chỉnh mức) chỉ sửa chệch về mức trung bình, không sửa chệch có điều kiện.
- Từ 2021, nếu nhà cung cấp tính $P^H$/$P^L$ có gộp cả mức "mở cửa = đóng cửa hôm trước" thì Parkinson bao một phần biến động qua đêm, tạo điểm gãy trong thước đo. Bảng 1.3 cho thấy số phiên trùng max/min$(P^O,P^C)$ ít, nên ảnh hưởng có lẽ nhỏ. Điểm này ghi là giới hạn `[cần xác nhận với nhà cung cấp]`.
- Không có dữ liệu trong ngày nên không tính được biến động thực hiện (2.5.1); nêu ở 6.4.3.

---

## 3. Tập mô hình (3.2.3; ticket mục 3)

### 3.1. Phương trình trung bình (cố định tiên nghiệm)
- **Chính:** $r_t = \phi_0 + \phi_1 r_{t-1} + \varepsilon_t$ (AR(1) + hằng số) cho mọi mô hình GARCH, cả hai chuỗi, cả trong mẫu và ngoài mẫu.
- **Lý do (tiên nghiệm, không dựa trên hệ số ước lượng toàn mẫu):**
  - Tỷ suất sinh lời của chỉ số thường có tự tương quan bậc 1 dương do giao dịch không đồng bộ giữa các cổ phiếu thành phần.
  - AR(1) + hằng số là đặc tả chuẩn, đơn giản nhất bao được hiện tượng này.
  - Dùng cùng một đặc tả cho hai chuỗi để so sánh được ở 3.7.2.
  - Dự báo phương sai ít nhạy với phương trình trung bình.
- Code cũ chọn ARMA trên toàn mẫu, tức đặc tả dùng để dự báo đã dùng thông tin của giai đoạn ngoài mẫu. Thiết kế mới bỏ cách làm này.
- **3.4.1** vẫn báo cáo bảng lưới ARMA(0..3, 0..3) với BIC và Ljung–Box (tái tạo bảng 3.8b cũ) như phần chẩn đoán mô tả. Bảng này không dùng để chọn đặc tả.
- **Độ bền R6:** phương trình trung bình chỉ có hằng số.

### 3.2. Phương trình phương sai × phân phối sai số (lưới đầy đủ)
| | Chuẩn | Student-t | Student-t lệch ($\eta$) |
|---|---|---|---|
| GARCH(1,1) | ✓ (có) | ✓ (có) | **mới** |
| GJR-GARCH(1,1) | **mới** | ✓ (có) | ✓ (có) |
| EGARCH(1,1) | **mới** | ✓ (có) | ✓ (có) |
| APARCH(1,1) | **mới** | ✓ (có) | ✓ (có) |
- 12 mô hình (8 có sẵn, 4 mới). Bậc (1,1) cố định, không chọn bậc theo dữ liệu.
- **Lý do dùng lưới đầy đủ:** H3, H4 và 5.6.2 cần so sánh từng chiều khi giữ chiều kia cố định. Lưới cũ không làm được việc này.
- Ước lượng bằng hợp lý cực đại (rugarch, solver "hybrid" như code cũ).
- **Ước lượng trong mẫu (3.4):** dùng **toàn mẫu** của từng chuỗi, chỉ để mô tả (tham số, tính bền, bất đối xứng, đuôi, chẩn đoán). Không dùng để chọn mô hình cho dự báo, vì tập mô hình dự báo đã cố định.
- **Không đưa vào bộ chính:** GARCH bộ nhớ dài (FIGARCH, 2.2.4). Lý do: cửa sổ 1.250 phiên quá ngắn để ước lượng ổn định tham số bộ nhớ dài, và ước lượng trượt dễ không hội tụ. Nêu ở 3.9 và 6.4.1.
- Dự báo nhiều bước của EGARCH/APARCH ($\delta \ne 2$): rugarch trả về $(\hat\sigma_{t+j\mid t})^2$. Đây là xấp xỉ của $E[\sigma^2_{t+j}\mid\mathcal F_t]$ (bất đẳng thức Jensen). Nêu là xấp xỉ ở 3.2.3.

### 3.3. Mô hình đối chứng (không tham số)
| Mô hình | Dự báo $\hat\sigma^2_{t+1\mid t}$ (dùng dữ liệu đến hết $t$) | Kỳ $h$ |
|---|---|---|
| Lịch sử | $\frac{1}{W}\sum_{j=0}^{W-1} r_{t-j}^2$ (không trừ trung bình, thống nhất với cửa sổ trượt và thước đo đối chứng) | $h \cdot \hat\sigma^2_{t+1\mid t}$ |
| Cửa sổ trượt $m$ = 20, 60, 120, 252 | $\frac{1}{m}\sum_{j=0}^{m-1} r_{t-j}^2$ | $h \cdot \hat\sigma^2_{t+1\mid t}$ |
| EWMA $\lambda$ = 0,94 (chuẩn so sánh RiskMetrics) và 0,97 | $\hat\sigma^2_{t+1\mid t} = \lambda\hat\sigma^2_{t\mid t-1} + (1-\lambda) r_t^2$ (**đã cập nhật $r_t$**). Khởi tạo bằng trung bình $r^2$ của 60 phiên đầu cửa sổ | $h \cdot \hat\sigma^2_{t+1\mid t}$ |
- Tổng cộng **19 mô hình** (12 GARCH + 7 đối chứng) cho mọi chuỗi, mọi kỳ. $\lambda$ cố định, không ước lượng.
- Dự báo GARCH nhiều bước: $\hat\sigma^2_{t,h} = \sum_{j=1}^{h}\hat\sigma^2_{t+j\mid t}$.
- **Ghi cho C03-M3a (đối chiếu số cũ):** hàm `ewma_var` trong code cũ trả về $\hat\sigma^2_{t\mid t-1}$ nhưng dùng làm dự báo cho $t+1$, nên EWMA cũ chậm một phiên và bị bất lợi. Khi tái tạo nguyên trạng, ghi rõ khác biệt reported ↔ executed do lỗi này.

---

## 4. Thiết kế dự báo ngoài mẫu (3.2.3, 3.5; ticket mục 1, 7)

| Thành phần | Đề xuất | Lý do |
|---|---|---|
| Cửa sổ ước lượng | Trượt, $W$ = 1.250 phiên (khoảng 5 năm) | Giữ đặc tả cũ; đủ dài cho Student-t lệch; khung cửa sổ cố định của Giacomini–White hợp với DM khi tham số được ước lượng |
| Điểm dự báo | **Mọi phiên** $t = W, \dots, T-h$ | 50 điểm cũ không đủ lực và không đủ cho Ch5 |
| Tái ước lượng | Mỗi 20 phiên. Giữa hai lần, **lọc** phương sai với tham số cố định, chỉ dùng dữ liệu đến $t$ | Giữ tần suất cũ; giới hạn thời gian chạy |
| Số điểm $n$ ($h$ = 1) | VN-Index 2.830 (từ 13/01/2015); HNX-Index 2.832. Với $h$ > 1: $n - (h-1)$ | Tính từ số phiên |
| Không hội tụ | (i) Thử lại theo thứ tự định trước: "hybrid" → "solnp" với nhiều điểm khởi tạo → "nlminb". (ii) Vẫn lỗi: dùng tham số của lần ước lượng hợp lệ gần nhất và gắn cờ. (iii) **Lần ước lượng đầu tiên** vẫn lỗi: đánh dấu mô hình thiếu cho đến lần hợp lệ đầu tiên, báo cáo, và so sánh trên tập điểm chung | Không loại điểm dự báo một cách âm thầm. Báo tỷ lệ lỗi theo mô hình |
| Mẫu đánh giá chung | Mọi mô hình đánh giá trên cùng tập điểm (của từng chuỗi × kỳ) | MCS cần ma trận tổn thất đầy đủ |
| Tái lập ngẫu nhiên | RNG `L'Ecuyer-CMRG`, `set.seed(20261022)`; dòng ngẫu nhiên con theo (chuỗi, mô hình, ngày ước lượng) cho mọi bước có ngẫu nhiên (khởi tạo solver, bootstrap MCS); chạy với 3 tiến trình; ghi trong README của run | Kết quả tái lập được dù chạy song song |

- Với $h$ > 1, điểm dự báo hằng ngày làm các cửa sổ mục tiêu chồng lấn, nên sai số dự báo tự tương quan tới bậc $h-1$. Cách xử lý ở mục 5.2.
- **Ước lượng chi phí (chưa kiểm):** 12 mô hình × ⌈2.830/20⌉ = 142 lần ước lượng, tức khoảng 1.700 lần cho mỗi chuỗi và mỗi cấu hình. Cần ước lượng lại ở 5–6 cấu hình (VN chính, HNX chính, R1, R2, R6), tổng khoảng 8.500–10.200 lần. R2 (cửa sổ mở rộng) tốn thời gian hơn mỗi lần.

### 4.1. Bộ dự báo dùng chung Ch3 ↔ Ch5 (`analysis/common/`, làn L3b). Khuyến nghị: **có**
Một lần ước lượng trượt cho 12 mô hình GARCH × 2 chuỗi. Lưu hai bảng cho mỗi chuỗi (parquet hoặc csv.gz, có SHA trong README):

**(a) Bảng theo lần ước lượng** (khoảng 142 dòng × 12 mô hình): ngày ước lượng; cửa sổ (đầu, cuối); **toàn bộ véc-tơ tham số** $\hat\Theta$ ($\phi_0, \phi_1, \omega, \alpha_1, \beta_1, \gamma_1, \delta, \nu, \eta$, tùy mô hình); log-likelihood; cờ hội tụ; solver đã dùng.

**(b) Bảng theo điểm dự báo $t$** (khoảng 2.830 dòng × 12 mô hình):
- $\hat\mu_{t+j\mid t}$ và $\hat\sigma^2_{t+j\mid t}$ với $j$ = 1..20;
- $\hat\sigma^2_{t,h}$ với $h$ = 1, 5, 10, 20;
- **phần dư chuẩn hóa đã lọc $z_t = \hat\varepsilon_t/\hat\sigma_t$** theo tham số đang dùng tại $t$. Mô phỏng lịch sử có lọc của Ch5 dựng lại $z$ của cả cửa sổ từ bảng (a) cộng dữ liệu, nên không cần lưu ma trận $z$ cho mỗi điểm;
- mã lần ước lượng đang dùng; cờ "dùng tham số cũ".

Lý do và điều kiện:
- Ch3 dùng $\hat\sigma^2$. Ch5 tính VaR/ES tham số có điều kiện, mô phỏng lịch sử có lọc và VaR/ES 10 ngày từ cùng $\hat\Theta$, $\hat\mu$, $\hat\sigma$. Nhờ vậy 5.6 so sánh xếp hạng trên **cùng một lần ước lượng**.
- Đủ cho kiểm định ngược 99%: $n$ ≈ 2.830 → kỳ vọng khoảng 28 vi phạm ở $\alpha$ = 0,01 ($h$ = 1).
- **L5 phải xác nhận lược đồ cột này trước khi C03-M3b chạy.** Nếu thiếu trường mà đã khoá bộ dự báo thì phải chạy lại khoảng 1.700 lần ước lượng mỗi chuỗi.
- Các mô hình riêng của Ch5 (mô phỏng lịch sử, EVT, hồi quy phân vị, cửa sổ riêng) thuộc C05-D1.

---

## 5. Đánh giá, so sánh và quy tắc quyết định (3.5; 2.6.2–2.6.3)

### 5.1. Hàm tổn thất
- **QLIKE (chính).**
  - Để tính $d_t$, DM, MCS: dùng dạng $\mathcal L^{Q} = \tilde\sigma^2_{t,h}/\hat\sigma^2_{t,h} + \ln\hat\sigma^2_{t,h}$. Dạng này cho cùng thứ hạng và cùng $d_t$ như dạng chuẩn hóa, và xác định được cả khi $\tilde\sigma^2 = 0$, nên **không loại điểm nào**.
  - Để báo mức: dạng chuẩn hóa $\tilde\sigma^2/\hat\sigma^2 - \ln(\tilde\sigma^2/\hat\sigma^2) - 1$ (như code cũ), tính trên các điểm có $\tilde\sigma^2 > 0$, kèm số điểm bị loại.
- **MSE** $= \frac1n\sum(\tilde\sigma^2_{t,h} - \hat\sigma^2_{t,h})^2$, báo cáo song song (dạng RMSE cho dễ đọc, cùng thứ hạng). Khi QLIKE và MSE cho kết quả khác nhau, báo cả hai và không chọn.
- **MAE:** chỉ đưa vào phụ lục, vì không bền với thước đo có nhiễu (Patton, 2011). Mục 3.5.1 giải thích lý do kết quả cũ có MAE.

### 5.2. Kiểm định
| Kiểm định | Đặc tả định trước | Vai trò |
|---|---|---|
| Bộ tin cậy mô hình (MCS) | Mức 10%. Báo **cả hai thống kê $T_R$ và $T_{\max}$**: $T_R$ là chính (như code cũ, giữ để đối chiếu), $T_{\max}$ là phụ. Bootstrap khối, độ dài khối $\max(h, 5)$, $B$ = 5.000. Chạy trên QLIKE (chính) và MSE | **Quy tắc quyết định chính** (mục 5.3) |
| Diebold–Mariano (chính) | $d_t$ trên QLIKE và MSE. Phương sai Newey–West nhân Bartlett, độ trễ $\max(h-1, \lfloor 4(n/100)^{2/9}\rfloor)$; với $n$ ≈ 2.830 thì độ trễ là $\max(h-1, 8)$. So với phân phối chuẩn. **Không** nhân hệ số HLN | Đọc kèm MCS; giá trị $p$ hiệu chỉnh Holm trong từng họ |
| Diebold–Mariano (phụ) | Dạng Harvey–Leybourne–Newbold chuẩn (nhân chữ nhật, đúng $h-1$ độ trễ, phân phối $t_{n-1}$), tức `forecast::dm.test` như code cũ | Đối chiếu với code cũ; không dùng để kết luận |
| Mincer–Zarnowitz | $\tilde\sigma^2_{t,h} = a + b\,\hat\sigma^2_{t,h} + u$; kiểm định Wald $a = 0, b = 1$ với HAC (cùng độ trễ như DM chính); báo $R^2$. **Phụ:** bản có trọng số $1/\hat\sigma^2_{t,h}$ (ít bị phiên cực trị chi phối) `[Missing Citation]` đến C03-M4 | Kiểm độ chệch (3.5.1) |
| Trong mẫu (H4) | Student-t lệch so với Student-t: kiểm định tỷ lệ hợp lý $\chi^2_1$ (tham số độ lệch nằm trong miền). Chuẩn so với Student-t: $1/\nu = 0$ nằm trên biên, phân phối giới hạn là $\tfrac12\chi^2_0 + \tfrac12\chi^2_1$. Báo kèm AIC/BIC | 3.4.1 |

**Các họ kiểm định để hiệu chỉnh Holm** (theo từng chuỗi × kỳ × hàm tổn thất):
- F2: 18 mô hình so với EWMA 0,94.
- F3: 9 cặp bất đối xứng so với đối xứng, giữ nguyên phân phối: {GJR, EGARCH, APARCH} × {chuẩn, t, t lệch}, mỗi cặp so với GARCH cùng phân phối.
- F4: 8 cặp đuôi dày so với chuẩn, giữ nguyên phương trình phương sai: {t, t lệch} × 4 phương trình.

### 5.3. Quy tắc quyết định cho giả thuyết (định trước)
Áp dụng cho VN-Index, thước đo chính, QLIKE, **$h$ = 1 và $h$ = 10**. Mỗi kỳ có kết luận riêng. Kỳ 5, 20 và MSE chỉ báo cáo để đối chiếu. Mỗi giả thuyết nhận một trong ba nhãn: **ủng hộ / không ủng hộ / lẫn lộn**.

| | $H_0$ | $H_1$ (giả thuyết của sách) | Ủng hộ $H_1$ khi | Không ủng hộ khi | Bằng chứng phụ |
|---|---|---|---|---|---|
| H1 | Không có hiệu ứng ARCH | Có cụm biến động và hiệu ứng ARCH | Ljung–Box trên $r_t^2$ và ARCH-LM (độ trễ 12) bác bỏ ở mức 5% | Không bác bỏ | Kiểm định dấu Engle–Ng trên $z_t$ của AR(1)-GARCH(1,1)-Student-t, toàn mẫu (bất đối xứng) |
| H2 | EWMA 0,94 dự báo tốt ngang các mô hình GARCH | Ít nhất một mô hình GARCH dự báo tốt hơn EWMA 0,94 | EWMA 0,94 **bị loại** khỏi MCS 10% và có ≥ 1 mô hình GARCH được giữ lại | EWMA 0,94 được giữ trong MCS 10% | Họ F2 (DM–Holm): số mô hình GARCH tốt hơn hoặc kém hơn có ý nghĩa |
| H3 | Phương trình phương sai bất đối xứng không cải thiện so với GARCH đối xứng cùng phân phối | Bất đối xứng cải thiện | Ở ≥ 2/3 phân phối, GARCH đối xứng bị loại khỏi MCS 10% trong khi ≥ 1 mô hình bất đối xứng cùng phân phối được giữ | Ở cả 3 phân phối, GARCH đối xứng được giữ | Họ F3 (DM–Holm); trong mẫu: $\gamma$ và đường tác động tin tức |
| H4 | Phân phối đuôi dày không cải thiện so với chuẩn cùng phương trình phương sai | Đuôi dày cải thiện | Ở ≥ 3/4 phương trình, mô hình chuẩn bị loại khỏi MCS 10% trong khi ≥ 1 mô hình đuôi dày cùng phương trình được giữ | Ở cả 4 phương trình, mô hình chuẩn được giữ | Họ F4; trong mẫu: kiểm định tỷ lệ hợp lý (5.2), AIC/BIC |
| H5 | Chênh lệch tổn thất không phụ thuộc giai đoạn | Thứ hạng hoặc chênh lệch tổn thất thay đổi theo giai đoạn | Với quy tắc B: hồi quy $d_t = c + \sum_k \delta_k D_{k,t} + u_t$ (sai số HAC như DM chính, kiểm định Wald $\delta = 0$, kiểu Giacomini–White) cho 18 cặp (mỗi mô hình so với EWMA 0,94) bác bỏ ở ≥ 1 cặp sau Holm | Không cặp nào bác bỏ sau Holm | Quy tắc A (cùng hồi quy, biến giả theo khối); tương quan hạng Spearman giữa các giai đoạn (mô tả) |

- Trường hợp không rơi vào hai cột "ủng hộ" hoặc "không ủng hộ", hoặc $h$ = 1 và $h$ = 10 cho kết luận khác nhau: ghi **lẫn lộn** và mô tả, không chọn kết quả thuận lợi.
- Ghi chú H4: phân phối sai số tác động tới dự báo phương sai chủ yếu qua ước lượng tham số. Vì vậy H4 có thể không được ủng hộ ở Ch3 nhưng được ủng hộ ở Ch5 (VaR/ES), và đây chính là câu hỏi của 5.6.2. Không coi kết quả H4 yếu ở Ch3 là bất lợi cần giấu.
- **Xếp hạng chuyển sang 5.6 (định trước):** thứ hạng theo QLIKE trung bình, $h$ = 1, thước đo chính, VN-Index, kèm tư cách thành viên MCS 10%. Chuyển cả 12 mô hình GARCH, không lọc theo kết quả Ch3.

---

## 6. Quy tắc chia giai đoạn thị trường (3.6 ↔ 5.7; ticket mục 4), dùng chung với Ch5

Hai quy tắc, cùng định trước, cùng áp dụng cho VN-Index và HNX-Index. Không chọn ngày đỉnh hoặc đáy theo dữ liệu. Mô hình **không** được ước lượng lại theo giai đoạn: chỉ chia mẫu đánh giá của các dự báo đã có (mục 4). Mỗi điểm dự báo được gán giai đoạn theo **ngày lập dự báo $t$**. Cửa sổ mục tiêu của điểm cuối năm có thể kéo sang năm sau.

### 6.1. Quy tắc A: khối theo năm dương lịch gắn mốc thể chế (diễn giải; bằng chứng phụ cho H5)
| Khối | Khoảng (theo $t$) | Số điểm ≈ ($h$ = 1) | Đặc trưng (ghi `[cần xác nhận]` khi viết) | Mốc thể chế có nguồn (`context/vn_market_facts.md`) |
|---|---|---|---|---|
| G1 | 13/01/2015 → 31/12/2017 | ≈ 740 | Sau đợt nới biên độ 2013; chuyển sang T+2 | L10 (15/01/2013), S3 (01/01/2016) |
| G2 | 2018 → 2019 | ≈ 500 | Điều chỉnh sau đỉnh 2018 `[cần xác nhận]` | — |
| G3 | 2020 | ≈ 250 | Cú sốc COVID-19 `[cần xác nhận]` | L20 |
| G4 | 2021 | ≈ 250 | Dòng tiền nhà đầu tư cá nhân, nghẽn lệnh `[cần xác nhận]` | T5 (05/07/2021) |
| G5 | 2022 | ≈ 250 | Sụt giảm mạnh, thị trường trái phiếu doanh nghiệp `[cần xác nhận]` | S4 (29/08/2022) |
| G6 | 2023 → 20/05/2026 | ≈ 840 (với $h$ > 1: trừ $h-1$) | Phục hồi; hệ thống KRX | T1 (05/05/2025); nâng hạng FTSE F4–F5 (21/09/2026, sau mẫu) |
- Ranh giới theo năm dương lịch, không theo ngày đỉnh hay đáy, để đơn giản, minh bạch và không phụ thuộc kết quả. Số điểm mỗi khối chỉ là ước tính, sẽ tính chính xác ở M3b.

### 6.2. Quy tắc B: trạng thái biến động ex-ante (quy tắc chính cho H5)
- **Chỉ báo:** biến động Parkinson trung bình của 20 phiên kết thúc tại $t$: $\hat\sigma^{P}_{t,20} = \big[\frac{1}{20}\sum_{j=0}^{19} \frac{(100\ln(P^H_{t-j}/P^L_{t-j}))^2}{4\ln 2}\big]^{1/2}$. Chỉ dùng thông tin đến $t$, nên không điều kiện hóa trên mục tiêu dự báo.
- **Vì sao không dùng $\hat\sigma_{t,60}$ như v1:** $\hat\sigma_{t,60}$ trùng đúng dự báo của mô hình đối chứng "cửa sổ trượt 60". Chia trạng thái theo dự báo của một mô hình sẽ tạo bất lợi cơ học cho chính mô hình đó. Chỉ báo Parkinson dùng $P^H, P^L$, khác thông tin đầu vào của mọi mô hình trong tập (mọi mô hình chỉ dùng giá đóng cửa). Đây là thước đo biến động của chính kỳ $t$, không phải dự báo, và chỉ dùng để phân loại.
- **Ngưỡng:** tam phân vị của $\hat\sigma^{P}_{t,20}$ **trên các điểm ngoài mẫu** của từng chuỗi → ba trạng thái thấp / trung bình / cao, mỗi trạng thái khoảng 943 điểm.
  - Ngưỡng dùng phân phối của mẫu đánh giá. Đây là phân loại phục vụ **đánh giá**, không đi vào dự báo, và bảo đảm ba ô có cỡ bằng nhau (quan trọng cho kiểm định ngược 99% theo trạng thái ở Ch5).
  - Phương án thay thế, đưa tác giả chọn (mục 10): ngưỡng cố định ex-ante từ 1.250 phiên đầu. Nhược điểm: giai đoạn 2010–2014 có mức biến động khác, nên số điểm mỗi ô có thể rất lệch.
- **Cỡ ô tối thiểu (định trước):** ≥ 250 điểm mỗi ô cho Ch3. Với tam phân vị ngoài mẫu, điều kiện này luôn đạt.

### 6.3. Đo "thứ hạng thay đổi theo giai đoạn" (H5)
- Kiểm định chính: hồi quy chênh lệch tổn thất (mục 5.3).
- Mô tả: trong mỗi khối hoặc trạng thái, tính QLIKE, MSE theo mô hình, MCS 10%, và tương quan hạng Spearman giữa các giai đoạn và với toàn mẫu.
- Lực thống kê theo khối thấp hơn toàn mẫu (khoảng 250–840 điểm theo quy tắc A). Không coi khác biệt không có ý nghĩa là bằng chứng của sự ổn định.
- **Cho Ch5:** các khối G3, G4, G5 (khoảng 250 điểm) chỉ có kỳ vọng khoảng 2,5 vi phạm ở VaR 99%. L5 quyết định báo kiểm định nào theo khối. Quy tắc B (khoảng 943 điểm mỗi ô) phù hợp hơn cho kiểm định ngược theo trạng thái.

---

## 7. Kiểm định độ bền (3.8; ticket mục 5)
Định trước. Mỗi kiểm định chỉ đổi **một** yếu tố. Báo thứ hạng QLIKE ở $h$ = 1 và $h$ = 10, nhóm MCS 10%, và nhãn H2–H4 theo quy tắc 5.3, so với cấu hình chính.

| # | Yếu tố | Cấu hình | Mẫu đánh giá | Ghi chú |
|---|---|---|---|---|
| R1 | Cửa sổ ước lượng | $W$ = 750 (trượt) | Chung với cấu hình chính (từ 13/01/2015) | |
| R2 | Cửa sổ ước lượng | Mở rộng dần từ 1.250 | Như trên | Ra ngoài khung Giacomini–White (cửa sổ cố định), nên diễn giải DM thận trọng |
| R3 | Thước đo đối chứng | Parkinson | Toàn bộ mẫu ngoài mẫu | Trả lời câu hỏi biến động trong phiên (mục 2) |
| R3b | Thước đo đối chứng | Parkinson điều chỉnh mức ($c$ tính ex-ante) | Như trên | |
| R4 | Thước đo đối chứng | Garman–Klass | VN-Index; điểm có cửa sổ mục tiêu kết thúc trước hoặc vào 31/12/2020 | |
| R5 | Quan sát cực trị, khâu đánh giá | Bỏ 1% điểm có $\tilde\sigma^2_{t,h}$ lớn nhất | Toàn mẫu | **Phân tích ảnh hưởng, có điều kiện trên kết quả, không dùng để xếp hạng.** Có thể chệch về phía mô hình dự báo thấp hoặc trơn |
| R5b | Quan sát cực trị, theo lịch định trước | Loại khỏi đánh giá các điểm có cửa sổ mục tiêu chứa 25/01/2018 (V9) | Toàn mẫu | Không chọn theo kết quả |
| R6 | Phương trình trung bình | Chỉ hằng số | Toàn mẫu | |
| R7 | Độ dài khối bootstrap MCS | 20 (thay vì $\max(h,5)$) | Toàn mẫu | Chênh lệch tổn thất có cụm biến động |
- **Khâu ước lượng không xử lý cực trị** (không winsorize, không dùng biến giả), theo hợp đồng dữ liệu v2. Lý do: phân phối Student-t và Student-t lệch đã cho phép đuôi dày; cắt cực trị sẽ làm sai lệch chính rủi ro đuôi mà Ch5 cần đo. Nêu ở 3.8.
- R1, R2, R4 chỉ chạy cho VN-Index. HNX-Index chạy cấu hình chính cộng R3, R3b, R5, R5b, R7 (không cần ước lượng lại). Mở rộng R1, R2, R6 cho HNX-Index chỉ khi tác giả yêu cầu.
- Không chọn cấu hình "tốt nhất" sau khi xem độ bền. Cấu hình chính giữ nguyên.

---

## 8. Tính khái quát trên HNX-Index (3.7; ticket mục 6)
- Dùng toàn bộ 19 mô hình, cùng thiết kế ở mục 4–5 và **cùng code đã khoá** (C03-M3c chạy sau khi M3a/M3b khoá code). Không chỉ số ngành, không VN30.
- **3.7.1:** tóm tắt ước lượng trong mẫu (tính bền, bất đối xứng, bậc tự do), bảng QLIKE/MSE, MCS, nhãn H1–H5 theo mục 5.3. Chi tiết đưa vào Phụ lục D.
- **3.7.2:** so sánh với VN-Index trên **4.081 phiên chung**: tương quan hạng Spearman giữa thứ hạng mô hình (theo hàm tổn thất × kỳ); mức trùng lặp nhóm MCS; khác biệt các tham số chính.
- Thước đo phụ của HNX-Index chỉ có Parkinson, vì giá mở cửa không tin cậy ở khoảng 44% toàn mẫu (B02 H3).
- Diễn giải: không quy khác biệt HOSE–HNX thành tác động nhân quả của biên độ giá, vì lẫn với quy mô, thanh khoản và cơ cấu chỉ số.

---

## 9. Giả thuyết (3.1.3)
Phát biểu ở dạng $H_0$/$H_1$ cùng chiều. Quy tắc quyết định ở mục 5.3. Giả thuyết H1–H5 của 3.3.6 cũ được viết lại như sau:
- **H1:** Tỷ suất sinh lời VN-Index và HNX-Index có cụm biến động và hiệu ứng ARCH.
- **H2:** Ít nhất một mô hình GARCH dự báo phương sai tốt hơn EWMA 0,94.
- **H3:** Phương trình phương sai bất đối xứng dự báo tốt hơn GARCH đối xứng có cùng phân phối.
- **H4:** Phân phối đuôi dày (Student-t, Student-t lệch) cải thiện so với phân phối chuẩn khi giữ nguyên phương trình phương sai.
- **H5:** Chênh lệch khả năng dự báo giữa các mô hình thay đổi theo giai đoạn thị trường.

### Tài liệu phương pháp dẫn trong thiết kế (chưa kiểm, kiểm ở C03-M4)
Patton (2011, *Journal of Econometrics*); Diebold & Mariano (1995, *JBES*); Harvey, Leybourne & Newbold (1997, *IJF*); Newey & West (1987, 1994); Hansen, Lunde & Nason (2011, *Econometrica*); Giacomini & White (2006, *Econometrica*); Holm (1979, *Scandinavian Journal of Statistics*); Mincer & Zarnowitz (1969); Parkinson (1980, *Journal of Business*); Garman & Klass (1980, *Journal of Business*); Engle & Ng (1993, *Journal of Finance*); Self & Liang (1987, *JASA*), về kiểm định tỷ lệ hợp lý khi tham số nằm trên biên; Hansen & Lunde (2005, *Journal of Applied Econometrics*). C03-M4 kiểm mọi key bib và số trang.

---

## 10. Cần tác giả quyết (gói Design)
| # | Câu hỏi | Lựa chọn | Hệ quả | Khuyến nghị |
|---|---|---|---|---|
| 1 | Thiết kế ngoài mẫu và tập mô hình | (a) Dự báo mọi phiên, $W$ = 1.250 trượt, tái ước lượng mỗi 20 phiên, lưới 12 GARCH + 7 đối chứng, bộ dự báo dùng chung với Ch5, quy tắc quyết định ở mục 5.3; (b) giữ 50 điểm và 8 mô hình cũ | (a) $n$ ≈ 2.830, đủ lực, trả lời được 5.6.2; chạy mất vài giờ; **thay toàn bộ số liệu Ch3 hiện có** (bản cũ giữ làm "reported"). (b) Không đủ cho Ch5 | **(a)** |
| 2 | Quy tắc B: ngưỡng chia trạng thái | (a) Tam phân vị trên mẫu ngoài mẫu (chỉ báo Parkinson 20 phiên); (b) ngưỡng ex-ante từ 1.250 phiên đầu | (a) Ba ô bằng nhau, khoảng 943 điểm mỗi ô. (b) Hoàn toàn ex-ante nhưng các ô có thể rất lệch | **(a)** |
| 3 | Trình gói Design khi nào | (a) Chờ bản `design/C05-D1_design.md`, L5 xác nhận lược đồ ở mục 4.1, rồi L3 gộp thành một gói; (b) tác giả duyệt riêng C03-D1 ngay, với điều kiện mục 12 được mở lại khi có C05-D1 | (b) Các quyết định chung (W, giai đoạn, lược đồ) bị chốt trước khi L5 đánh giá hệ quả | **(a)** (đúng ticket mục 11) |

Nếu tác giả duyệt mà không ghi chú thêm, các phần sau áp dụng mặc định: thước đo đối chứng (mục 2), phương trình trung bình AR(1) (mục 3.1), kiểm định (mục 5.2), quy tắc A (mục 6.1), độ bền R1–R7 (mục 7), HNX-Index (mục 8). Nếu tác giả muốn đổi ranh giới khối của quy tắc A, cần nêu trước khi chạy M3.

---

## 11. Ánh xạ sang ticket chạy (sau khi duyệt)
| Ticket (làn) | Nội dung từ thiết kế này | Đầu ra |
|---|---|---|
| C03-M3a (L3a) | Mục 1 (gồm bảng 1.3); 3.1 (lưới ARMA mô tả); 3.2–3.3 trong mẫu, toàn mẫu; 3.3 thống kê, H1 cho hai chuỗi; ước lượng trong mẫu 12 GARCH với VN-Index; kiểm định tỷ lệ hợp lý H4; tái tạo nguyên trạng script cũ trên dữ liệu chuẩn để đối chiếu reported ↔ executed (gồm lỗi EWMA chậm một phiên) | `analysis/ch03/a_insample/`, `results/C03-M3a_<ts>/` |
| C03-M3b (L3b) | Mục 4 (bộ dự báo dùng chung `analysis/common/`, lược đồ 4.1 sau khi L5 xác nhận), 5, 6, 7 cho VN-Index | `analysis/common/`, `analysis/ch03/b_forecast/`, `results/C03-M3b_<ts>/` |
| C03-M3c (L3c) | Mục 8 (HNX-Index: chạy bộ dự báo đã khoá, đánh giá, so sánh) | `analysis/ch03/c_hnx/`, `results/C03-M3c_<ts>/` |
- Danh mục exhibit dự kiến (tên ổn định `tbl_3_k`, `fig_3_k` ở M3):
  - 3.3: thống kê mô tả hai chuỗi; kiểm định phân phối, tính dừng, ARCH, kiểm định dấu.
  - 3.4: lưới ARMA, tiêu chí thông tin 12 mô hình, hệ số, tính bền và chu kỳ bán rã, chẩn đoán phần dư, đường tác động tin tức, kiểm định tỷ lệ hợp lý.
  - 3.5: QLIKE/MSE theo kỳ, MZ, DM so với EWMA, MCS, bảng nhãn H2–H4.
  - 3.6: tổn thất theo khối và trạng thái, hồi quy H5, tương quan hạng.
  - 3.7: bảng tóm tắt HNX-Index và so sánh.
  - 3.8: bảng R1–R7.

## 12. Cần khớp với C05-D1 (L5 đọc mục này)
1. **$W$:** mô hình GARCH có điều kiện ở Ch5 dùng cùng bộ dự báo ($W$ = 1.250 trượt, tái ước lượng mỗi 20 phiên, AR(1)). `notation.md` hiện ghi "Ch5: 500". Nếu Ch5 dùng $W$ = 500 thì chỉ cho các phương pháp phi tham số và bán tham số riêng của Ch5, và **mẫu đánh giá chung của Ch5 vẫn bắt đầu từ 13/01/2015**, dù phương pháp $W$ = 500 có thể bắt đầu sớm hơn. Sau khi duyệt gói Design → L0 cập nhật `notation.md`.
2. **Lược đồ bộ dự báo dùng chung (mục 4.1):** L5 xác nhận đủ trường trước khi C03-M3b chạy.
3. **Kỳ 10 phiên:** $\hat\sigma^2_{t,10}$ và $\hat\mu_{t+j\mid t}$ ($j \le 10$) có sẵn. Dự báo 10 ngày lập hằng ngày làm các vi phạm chồng lấn, nên kiểm định Kupiec/Christoffersen chuẩn không hợp lệ. L5 nêu cách xử lý trong C05-D1 (lấy mẫu không chồng lấn hoặc hiệu chỉnh).
4. **Giai đoạn:** quy tắc A, B (mục 6) dùng nguyên cho 5.7. Ch5 nên dùng quy tắc B cho kiểm định ngược theo trạng thái.
5. **Trạng thái gói:** chưa có `design/C05-D1_design.md` trong thư mục làm việc của phiên này, nên gói Design chung chưa gộp được. L3 gộp khi có bản C05-D1.

## 13. Đối chiếu sửa đổi v1 → v2 (theo `reviews/20261022_ch03_design-review.md`)
| Phát hiện | Đã sửa ở |
|---|---|
| M1 quy tắc quyết định | 5.2 (họ F2–F4, Holm), 5.3 (bảng $H_0$/$H_1$, ngưỡng ủng hộ), 9 |
| M2 phương sai DM | 5.2 (Newey–West Bartlett chính; HLN chuẩn phụ) |
| M3 quy tắc B | 6.2 (chỉ báo Parkinson 20 phiên; tam phân vị ngoài mẫu; cỡ ô tối thiểu); 10 điểm 2 |
| M4 lược đồ bộ dự báo dùng chung | 4.1 (bảng a, b); 12.2 |
| M5 gói chung | Chưa xử lý được trong làn này → 10 điểm 3, 12.5 (điểm dừng) |
| m1 QLIKE khi $\tilde\sigma^2$ = 0 | 5.1 |
| m2 Parkinson và thứ hạng | 2 (ghi chú), R3b |
| m3 lý do chọn AR(1) | 3.1 |
| m4 kiểm định tỷ lệ hợp lý trên biên | 5.2 |
| m5 Garman–Klass ranh giới 2020 | 2, R4 |
| m6 R5 chọn theo kết quả; xử lý cực trị khi ước lượng | 7 (R5 ghi rõ, R5b, đoạn khâu ước lượng) |
| m7 độ trễ HAC của MZ; MZ có trọng số | 5.2 |
| m8 $T_R$ / $T_{\max}$; R7 | 5.2; R7 đổi thành độ dài khối 20 |
| m9 QLIKE/MSE khi kết quả khác nhau | 0, 5.1 |
| m10 số điểm theo khối, gán theo $t$ | 6 (đầu mục), 6.1, 6.3 |
| m11 lỗi ở lần ước lượng đầu; RNG | 4 |
| m12 mẫu ước lượng trong mẫu | 3.2 |
| m13 định nghĩa mô hình lịch sử | 3.3 |
| m14 $W$ và notation.md | 12.1 |
| m15 kiểm định dấu dùng phần dư nào | 5.3 (H1) |
| n2 lỗi EWMA trong code cũ | 3.3, 11 |
| n3 đã đọc chapter.md | đầu bản |
| n4 Jensen ở EGARCH/APARCH | 3.2 |
| n5 R2 ngoài khung Giacomini–White | 7 |
| n6 vi phạm 10 ngày chồng lấn | 12.3 |
| n7 $P^H$/$P^L$ và giá mở cửa giả | 2 (ghi chú) |
| n1 chi phí | 4 |
