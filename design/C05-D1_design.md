# C05-D1 — Thiết kế thực nghiệm Chương 5 (rủi ro đuôi: VaR, ES)

- **Phiên bản:** nháp 1, 22/10/2026 — làn L5 (Lead Chương 5). **Trạng thái:** chờ duyệt Design (gói chung với C03-D1, L3 gộp).
- **Nguyên tắc:** mọi lựa chọn dưới đây **định trước khi chạy**; không chạy mô hình nào trong ticket này. Số duy nhất được tính là đếm phiên/ngày từ tệp chuẩn (Python, đọc tệp, không ước lượng) — nhãn *computed*.
- **Công bố minh bạch:** người soạn đã đọc kết quả cũ `ch07_*` và Bảng 7 của `05. Chuong_05/chapter.md` (*reported*, không có code). Để tránh chọn mô hình theo kết quả cũ, tập mô hình lấy theo danh mục phương pháp của Chương 4 (đề cương 3.2, mục 4.2–4.7) và tập GARCH của Chương 3, không theo mô hình nào "tốt" trong `ch07_*`.
- **C03-D1:** chưa có `design/C03-D1_design.md` lúc soạn (22/10/2026). Các tham số dùng chung được đặt theo giả định ghi rõ (ký hiệu **[khớp C03-D1]**) và liệt kê ở mục 12.

## 1. Đầu vào (đã kiểm SHA-256 ngày 22/10/2026)
| Tệp | SHA-256 | Phiên | Tỷ suất sinh lời |
|---|---|---|---|
| `_project/data/vnindex_daily_20100104_20260520.csv` | `7c7563691623fe9a85e0ceffe356aa179224e2f07758d6efecd4e663172ff05b` | 4.081 | 4.080 |
| `_project/data/hnxindex_daily_20100104_20260520.csv` | `79c130bed33c9e2123c8a664cc87442502e067ceb580703b5a59360581bc322c` | 4.083 | 4.082 |

Khớp `_project/data/DATA_MANIFEST.csv`. Đọc thêm: `_project/data/README.md` (hợp đồng v2.1, giới hạn V9), `05. Chuong_05/chapter.md`, `05. Chuong_05/data/derived/ch07_*.csv`, `03. Chuong_03/code/R/run_chapter03_volatility.R`, `00. Book/architecture.md`, `notation.md`, `glossary.md`, `context/vn_market_facts.md` (L10).

## 2. Câu hỏi và giả thuyết (cho 5.1.3) — định trước
| Mã | Câu hỏi | Giả thuyết định trước (chiều kỳ vọng) | Mục |
|---|---|---|---|
| Q1 | Nhóm phương pháp nào cho VaR đạt kiểm định độ phủ và độc lập với VN-Index ở α = 5%; 2,5%; 1%? | H1: mô hình không điều kiện (mô phỏng lịch sử, chuẩn/Student-t trượt) có vi phạm tập trung (bác bỏ độc lập/DQ) dù độ phủ có thể đạt | 5.3 |
| Q2 | ES của mô hình nào phản ánh đúng mức nghiêm trọng của tổn thất vượt VaR? | H2: phân phối chuẩn đánh giá thấp ES ở α ≤ 2,5% | 5.4 |
| Q3 | Đánh đổi giữa độ chính xác và khả năng triển khai giữa các nhóm | Mô tả, không giả thuyết có hướng | 5.5 |
| Q4 | Mô hình dự báo biến động tốt (Ch3) có dự báo rủi ro đuôi tốt không? | H4a: tương quan hạng dương nhưng không hoàn hảo; H4b: ở α = 1%, phân phối sai số quan trọng hơn phương trình phương sai | 5.6 |
| Q5 | Kết quả có đổi theo giai đoạn thị trường, và trên HNX-Index? | Mô tả; không giả thuyết có hướng cho HNX-Index | 5.7, 5.8 |

Giả thuyết là phát biểu thống kê về dự báo, không phải nhân quả (khác biệt HOSE–HNX không quy về biên độ giá — PROJECT.md "Cần thận trọng").

## 3. Chuỗi tổn thất (5.2.1)
- $r_t = 100\ln(P_t/P_{t-1})$ trên giá đóng cửa; $L_t = -r_t$ (vị thế mua, thiết kế chính). Vị thế bán: $L_t = r_t$ (độ bền R3).
- Không winsorize, không nội suy, không điền ngày (hợp đồng v2). Không dùng giá mở/cao/thấp — Chương 5 chỉ cần giá đóng cửa, nên hạn chế giá mở cửa (B02 D1/H3) không ảnh hưởng thiết kế chính.
- V9: tỷ suất sinh lời 25/01/2018 (1,565%) gộp 22/01 → 25/01, giữ nguyên, ghi ở 5.2.1 (dẫn 3.2.2). Trong kiểm định ngược coi là một phiên.
- Biên độ giá HOSE ±7% từ 15/01/2013, HNX ±10% (`context/vn_market_facts.md` L10): với chỉ số, kiểm dữ liệu cho thấy max |r_t| VN-Index 6,91% sau 15/01/2013 (Lead B11). Không hiệu chỉnh kiểm duyệt (censoring) cho chỉ số; ghi là giới hạn.

## 4. Tập mô hình (5.2.1) — định trước, 24 mô hình
Mọi mô hình dự báo một bước $\mathrm{VaR}_{\alpha,t+1\mid t}$, $\mathrm{ES}_{\alpha,t+1\mid t}$ từ $\mathcal{F}_t$ (không nhìn trước).

| Mã | Nhóm (5.5.1) | Mô hình | VaR | ES | Tái ước lượng | Ch4 |
|---|---|---|---|---|---|---|
| N1 | Phi tham số | Mô phỏng lịch sử (HS), cửa sổ $W$ | phân vị thực nghiệm (type 7) | trung bình tổn thất ≥ VaR | mỗi ngày | 4.2.1 |
| N2 | Phi tham số | HS có trọng số theo thời gian (Boudoukh, Richardson & Whitelaw, 1998), λ = 0,99 | phân vị có trọng số | trung bình có trọng số vùng đuôi | mỗi ngày | 4.2.2 |
| P1 | Tham số không điều kiện | Chuẩn trượt | $\bar r$, $s$ trên $W$ | công thức đóng | mỗi ngày | 4.3.1 |
| P2 | Tham số không điều kiện | Student-t trượt (ν ước lượng hợp lý cực đại, ν ∈ [2,1; 100]) | phân vị t chuẩn hóa | công thức đóng | mỗi ngày | 4.3.1 |
| P3 | Tham số có điều kiện | EWMA (RiskMetrics, λ = 0,94), phân phối chuẩn | | công thức đóng | không ước lượng | 4.3.2 |
| G1–G12 | Tham số có điều kiện | Lưới 4 phương trình phương sai {GARCH, GJR, EGARCH, APARCH}(1,1) × 3 phân phối {chuẩn, Student-t, Student-t lệch} | phân vị của $D(0,1)$ | tích phân số vùng đuôi của $D(0,1)$ | tham số mỗi 20 phiên **[khớp C03-D1]**, lọc $\sigma_t$ mỗi ngày | 4.3.2 |
| S1–S4 | Mô phỏng | Mô phỏng lịch sử có lọc (FHS; Barone-Adesi, Giannopoulos & Vosper, 1999): phần dư chuẩn hóa của G1, G4, G7, G10 (lọc QML chuẩn) trong cửa sổ $W$ | phân vị thực nghiệm của $z$ × $\hat\sigma_{t+1\mid t}$ | trung bình vùng đuôi của $z$ × $\hat\sigma$ | như G | 4.4.2 |
| E1 | Bán tham số | EVT-POT không điều kiện: ngưỡng $u$ = phân vị 90% tổn thất trong cửa sổ, GPD ước lượng hợp lý cực đại | công thức POT | công thức POT (ξ < 1) | mỗi ngày | 4.5.1 |
| E2 | Bán tham số | EVT có điều kiện (McNeil & Frey, 2000): GPD trên phần dư chuẩn hóa của G4 (GJR, lọc QML chuẩn), $u$ = phân vị 90% | | | như G | 4.5.1 |
| Q1 | Bán tham số | Hồi quy phân vị tuyến tính của $L_t$ theo $1$, $\lvert r_{t-1}\rvert$, $r_{t-1}$, $\hat\sigma_{t-1,20}$ (độ lệch chuẩn 20 phiên đến $t-1$) | phân vị $\tau = 1-\alpha$ dự báo | trung bình 10 phân vị dự báo đều trên $(1-\alpha, 1)$ | mỗi ngày | 4.5.2 |

Lý do:
- **Lưới 4 × 3 cân đối** (thay vì 8 đặc tả hiện có của Ch3) để 5.6.2 tách được vai trò phương trình phương sai và phân phối sai số; cột thứ tư "phân phối thực nghiệm" do FHS S1–S4 cung cấp (cùng bộ lọc với cột chuẩn). Cần thêm 4 đặc tả so với Ch3 (GJR-chuẩn, EGARCH-chuẩn, APARCH-chuẩn, GARCH-Student-t lệch) — mục 12, 13.
- **Phương trình trung bình:** cố định trước, không chọn trên toàn mẫu **[khớp C03-D1]**. Code Ch3 hiện chọn ARMA theo BIC trên toàn mẫu (`run_chapter03_volatility.R` dòng 118–133: ARMA(0:3, 0:3) trên toàn mẫu, BIC nhỏ nhất) — là nhìn trước khi dùng cho dự báo ngoài mẫu. Đề xuất: hằng số + AR(1) cho cả hai chuỗi (HNX-Index có AR(1) = 0,041, B02).
- **Bỏ ra ngoài tập chính:** CAViaR (chỉ cho VaR, tối ưu hóa không ổn định khi tái ước lượng hàng nghìn lần) — ghi vào Someday; mô phỏng Monte Carlo chỉ dùng cho kỳ hạn 10 ngày (mục 5).
- **Tái tạo kết quả cũ (T0, không thuộc tập chính):** HS, chuẩn trượt, Student-t trượt (ν suy từ độ nhọn dư như bài cũ), EWMA-chuẩn, EVT-POT với $W$ = 500, α = 5%, 1%; đối chiếu *reported* (`ch07_backtesting_summary.csv`, Bảng 7) ↔ *executed*. Đã thấy hai bản *reported* lệch nhau: EVT-POT n = 3.373 (CSV) vs 3.573 (Bảng 7); EWMA 95% 218 vs 217 vi phạm; Bảng 7 ghi Christoffersen "NA" trong khi CSV có p. Ghi lệch, không sửa ngầm. Bảng 7 cũ không có GARCH-t, GJR-GARCH-t, hồi quy phân vị dù văn bản mô tả — các mô hình này *reported* không có số.

## 5. Mức tin cậy, kỳ hạn, cửa sổ (5.2.2)
- **Xác suất đuôi:** α ∈ {5%; 2,5%; 1%} (mức tin cậy 95%; 97,5%; 99%). ES chính ở α = 2,5% (chuẩn FRTB, BCBS 2019); báo thêm ES ở 1% và 5%.
- **Cửa sổ chính:** $W$ = 1.250 phiên **[khớp C03-D1]** (cửa sổ hiện có của Ch3). Lý do: (i) 5.6 cần cùng cửa sổ, cùng ngày ngoài mẫu với Ch3; (ii) đủ dài cho Student-t lệch và GPD (≈ 125 quan sát vượt ngưỡng $u$ 90%); (iii) điểm ngoài mẫu vẫn đủ cho 99%.
- **Ngày ngoài mẫu (computed):**

| $W$ | Ngày dự báo đầu | $n$ VN-Index | Vi phạm kỳ vọng 1% | 2,5% | Vai trò |
|---|---|---|---|---|---|
| 1.250 | 13/01/2015 | 2.830 | 28,3 | 70,8 | chính |
| 750 | 07/01/2013 | 3.330 | 33,3 | 83,2 | độ bền R1 |
| 500 | 06/01/2012 | 3.580 | 35,8 | 89,5 | độ bền R1 + tái tạo T0 (khớp ngày đầu 06/01/2012 của bài cũ) |

HNX-Index: $n$ = 2.832 với $W$ = 1.250 (cùng ngày đầu).
- **Kỳ hạn 1 phiên:** thiết kế chính.
- **Kỳ hạn 10 phiên** (5.2.2, độ bền R4), tập con 6 mô hình: N1 (tổng 10 phiên chồng lấn trong cửa sổ), P1 và P3 (quy tắc căn bậc hai thời gian), G2, G6 (mô phỏng Monte Carlo đường đi GARCH, B = 5.000, seed cố định), S2 (FHS bootstrap đường đi). Kiểm định ngược trên khối 10 phiên **không chồng lấn**: n = 283, kỳ vọng 2,8 vi phạm ở 1% — quá ít, nên chỉ kiểm định ở α = 5% và 2,5%; α = 1% báo mô tả.

## 6. Kiểm định ngược và so sánh (5.3–5.5)
| Đối tượng | Kiểm định / thước đo | Thiết lập định trước |
|---|---|---|
| VaR độ phủ | Kupiec (1995) $LR_{uc}$ | mức ý nghĩa 5% |
| VaR độc lập | Christoffersen (1998) $LR_{ind}$, $LR_{cc}$ | Markov bậc 1; nếu không có cặp vi phạm liên tiếp ghi rõ, không ghi NA |
| VaR động | DQ (Engle & Manganelli, 2004) | hồi quy $\mathrm{Hit}_t$ trên hằng số, 4 trễ của $\mathrm{Hit}$, VaR dự báo |
| VaR quy định | Đèn giao thông Basel (BCBS, 1996) ở 99% | đếm vi phạm trên các cửa sổ 250 phiên trượt; tỷ lệ cửa sổ xanh (0–4) / vàng (5–9) / đỏ (≥ 10) |
| ES | McNeil & Frey (2000) | phần dư vượt ngưỡng chuẩn hóa, bootstrap một phía, B = 10.000 |
| ES | Acerbi & Székely (2014) $Z_2$ | giá trị tới hạn mô phỏng từ phân phối dự báo của mô hình (M = 5.000); HS, N2, Q1: từ phân phối thực nghiệm của cửa sổ |
| Hàm điểm | tổn thất phân vị (VaR); $S_{FZ}$ dạng FZ0 (Fissler & Ziegel, 2016; Patton, Ziegel & Chen, 2019) cho (VaR, ES) | FZ0 yêu cầu ES, VaR cùng dấu — đổi sang quy ước của hàm (ghi trong code) |
| So sánh | MCS (Hansen, Lunde & Nason, 2011) trên tổn thất phân vị (α = 1%) và FZ0 (α = 2,5%) | thống kê $T_{max}$, bootstrap khối, B = 5.000, mức ý nghĩa 10% (viết bằng chữ, không dùng α) |

- **Quy tắc phân loại (thay nhãn cũ "Underestimates risk"…):** "đạt" ở mức α khi $LR_{uc}$, $LR_{cc}$ và DQ đều không bác bỏ ở 5%; "đánh giá thấp" khi bác bỏ $LR_{uc}$ và $\hat p > \alpha$; "quá thận trọng" khi bác bỏ $LR_{uc}$ và $\hat p < \alpha$; "vi phạm tập trung" khi đạt $LR_{uc}$ nhưng bác bỏ $LR_{ind}$ hoặc DQ.
- **Đa kiểm định:** 24 mô hình × 3 mức α × 2 chuỗi. Báo p gốc; bảng phụ lục thêm Holm trong từng họ (một chuỗi, một mức α, một kiểm định). Không diễn giải một p đơn lẻ.
- **5.5.2 khả năng triển khai:** mô tả định tính + đo thời gian chạy và số lần ước lượng không hội tụ (ghi trong README run); không chấm điểm chủ quan.
- **Lỗi hội tụ:** GARCH không hội tụ ở một lần tái ước lượng → giữ tham số lần trước, đánh dấu; tỷ lệ > 5% số lần → báo `NEEDS DECISION`, không loại mô hình ngầm. EVT ξ ≥ 1 (ES không xác định) → ES bỏ trống ngày đó, đếm và báo.

## 7. Cầu nối Chương 3 → Chương 5 (5.6)
- **Bộ dự báo dùng chung** `analysis/common/` (L3b ghi, L5 chỉ đọc bản có SHA trong README C03-M3b): một lần ước lượng trượt cho G1–G12 trên mỗi chuỗi, lưu theo ngày dự báo: $\hat\mu_{t+1\mid t}$, $\hat\sigma_{t+1\mid t}$, tham số phân phối (ν, η), phần dư chuẩn hóa trong cửa sổ (cho S1–S4, E2), cờ hội tụ. Ch3 lấy $\hat\sigma^2$; Ch5 lấy phân vị/ES. Bảo đảm cùng $W$, cùng ngày ngoài mẫu, cùng tham số.
- **5.6.1:** tương quan hạng Spearman giữa xếp hạng Ch3 (QLIKE, h = 1, cùng ngày ngoài mẫu) và xếp hạng Ch5 (tổn thất phân vị 1%; FZ0 2,5%) trên các mô hình chung (G1–G12, P3) — 13 mô hình; kèm bảng đối chiếu thành viên MCS hai chương. Khoảng tin cậy bootstrap của Spearman (bootstrap khối theo ngày, B = 2.000).
- **5.6.2:** bảng 4 × 4 (phương trình phương sai × {chuẩn, Student-t, Student-t lệch, thực nghiệm FHS}) với FZ0 trung bình, tỷ lệ vi phạm, p của $LR_{cc}$; so sánh trung bình theo hàng và theo cột; MCS trong từng hàng và từng cột. Diễn giải là so sánh dự báo, không phải tách nhân quả.

## 8. Giai đoạn thị trường (5.7)
- Dùng **đúng quy tắc chia giai đoạn của C03-D1** **[khớp C03-D1]**; không tái ước lượng — chỉ đánh giá lại dự báo của thiết kế chính trong từng giai đoạn.
- Kiểm định chỉ báo khi $n_k\alpha \ge 5$ (số vi phạm kỳ vọng trong giai đoạn $k$); dưới ngưỡng báo tỷ lệ vi phạm và tổn thất trung bình, ghi "không đủ quan sát để kiểm định".
- Nếu C03-D1 dùng giai đoạn theo trạng thái biến động ước lượng, trạng thái phải xác định từ thông tin đến $t$ (hoặc nêu rõ là phân loại hậu nghiệm, chỉ để mô tả).

## 9. HNX-Index (5.8)
- Toàn bộ 24 mô hình, cùng $W$, α, kiểm định; lịch giao dịch riêng (4.082 tỷ suất sinh lời).
- 5.8.2 so sánh với VN-Index: trên 4.081 phiên chung (hợp đồng v2) — bảng tỷ lệ vi phạm, đạt/không đạt, thứ hạng FZ0, tương quan hạng giữa hai chuỗi.
- Giao dịch không đồng bộ/giá đứng yên (B19): AR(1) trong phương trình trung bình (mục 4); ghi giới hạn. Không quy khác biệt cho biên độ ±10%.
- Báo gọn ở 5.8, chi tiết Phụ lục D.

## 10. Kiểm định độ bền (5.9) — danh sách đóng
| Mã | Thay đổi | Phạm vi | Đánh giá |
|---|---|---|---|
| R1 | $W$ = 500, 750 | toàn tập, VN-Index | trên **giai đoạn ngoài mẫu chung** từ 13/01/2015 (tách tác động cửa sổ khỏi tác động giai đoạn), và trên toàn giai đoạn riêng |
| R2 | Tái ước lượng mỗi phiên thay vì 20 phiên | G2, G6 | so tỷ lệ vi phạm, FZ0 |
| R3 | Vị thế bán ($L_t = r_t$) | toàn tập, VN-Index | như thiết kế chính |
| R4 | Kỳ hạn 10 phiên | 6 mô hình (mục 5) | khối không chồng lấn |
| R5 | Trước/sau cú sốc | thiết kế chính | các mốc sự kiện của C03-D1, cửa sổ ±250 phiên quanh mốc **[khớp C03-D1]** |
| R6 | Ngưỡng EVT $u$ = 85%, 95% | E1, E2 | |
| R7 | Ước lượng Student-t trượt bằng moment (như bài cũ) | P2 | nối với T0 |

Không thêm kiểm định độ bền sau khi xem kết quả; muốn thêm → ticket mới, ghi là *thăm dò*.

## 11. Đoạn 2007–2009
- **Khuyến nghị: không dùng** trong thiết kế chính lẫn độ bền.
- Lý do: (i) nằm ngoài tệp chuẩn và hợp đồng dữ liệu v2.1 (nguồn `01. Chuong_01/data/raw/vnindex.csv`, khác tệp chuẩn); (ii) OHLC đầu 2007 kém (B02) — dù Ch5 chỉ cần giá đóng cửa, chất lượng nguồn chưa được đối chiếu độc lập; (iii) biên độ HOSE ±5% trước 15/01/2013 khác chế độ hiện tại; (iv) với $W$ = 1.250, dữ liệu 2007–2009 chỉ nằm trong cửa sổ ước lượng, không thành điểm ngoài mẫu khủng hoảng 2008 nếu không đổi điểm đầu mẫu — tức phải đổi mẫu chuẩn của cả sách. Giai đoạn căng thẳng trong mẫu (2020, 2022) đủ cho 5.7.
- Phương án khác (cần L0 mở rộng hợp đồng dữ liệu): R8 = HS, P3, G2, G6 với dữ liệu từ 2007, đánh giá riêng 2008–2009, chỉ mô tả.

## 12. Cần khớp với C03-D1
| # | Điểm | Giả định trong bản này | Cần từ C03-D1 |
|---|---|---|---|
| K1 | Cửa sổ $W$ | 1.250 | xác nhận; nếu khác, Ch5 theo C03-D1 và cập nhật bảng mục 5 |
| K2 | Tái ước lượng | tham số mỗi 20 phiên, lọc mỗi ngày, mọi ngày ngoài mẫu (thay 50 điểm) | xác nhận dự báo **mọi ngày** (C03-D1 việc 1) |
| K3 | Tập GARCH | lưới 12 = 8 hiện có + GJR-chuẩn, EGARCH-chuẩn, APARCH-chuẩn, GARCH-Student-t lệch | đưa 12 đặc tả vào `analysis/common/` (Ch3 có thể chỉ báo 8) |
| K4 | Phương trình trung bình | hằng số + AR(1), cố định trước | bỏ chọn ARMA theo BIC trên toàn mẫu (nhìn trước) |
| K5 | Nội dung lưu của bộ dự báo chung | μ, σ, ν, η, phần dư chuẩn hóa trong cửa sổ, cờ hội tụ, theo ngày | định dạng tệp, tên cột, SHA |
| K6 | Quy tắc giai đoạn | dùng nguyên quy tắc C03-D1 | mốc sự kiện + cách xác định trạng thái (tiền nghiệm hay hậu nghiệm) |
| K7 | Mốc cú sốc cho R5 | theo danh sách sự kiện C03-D1 | danh sách mốc |
| K8 | HNX-Index | cùng tập, cùng $W$ | xác nhận cùng phương trình trung bình |
| K9 | Bộ giải và seed | rugarch `solver = "hybrid"`, seed cố định ghi README | thống nhất |
| K10 | Ký hiệu | α = xác suất đuôi; mức ý nghĩa MCS viết bằng chữ (notation E1) | Ch3 hiện dùng α cho MCS |

## 13. Phân công thực hiện sau duyệt
| Ticket | Làn | Nội dung | Phụ thuộc |
|---|---|---|---|
| C05-M3a | L5a | T0 (tái tạo ch07) + N1, N2, P1–P3, E1, Q1 (không cần bộ chung) ngay; G, S, E2 sau khi `analysis/common/` khoá; 5.3–5.5 | C05-D1 duyệt; C03-M3b khoá bộ chung |
| C05-M3b | L5b | 5.6.1, 5.6.2 | C05-M3a, C03-M3b |
| C05-M3c | L5c | 5.7, 5.8, 5.9 (R1–R7) | C05-M3a code khoá |

Ước lượng khối lượng: bộ chung 12 đặc tả × ≈ 142 lần tái ước lượng × 2 chuỗi ≈ 3.400 lần ước lượng GARCH cho thiết kế chính (+ R1, R2); chạy ≤ 3 workers (LANES mục 6). Chưa đo thời gian.

## 14. Exhibit dự kiến (tên ổn định)
`tbl_5_1` thiết kế; `tbl_5_2` tập mô hình; `tbl_5_3` kiểm định ngược VaR VN-Index (3 mức α); `fig_5_1` VaR 1% vs tổn thất (mô hình đại diện mỗi nhóm, chọn trước: N1, P3, G6, S4, E2, Q1); `tbl_5_4` đèn giao thông; `tbl_5_5` mức nghiêm trọng vượt VaR; `tbl_5_6` kiểm định ES + FZ0; `tbl_5_7` MCS; `tbl_5_8` theo nhóm; `tbl_5_9` hạng Ch3 ↔ Ch5; `tbl_5_10` lưới 4 × 4; `tbl_5_11` giai đoạn; `tbl_5_12` HNX-Index (gọn) + Phụ lục D; `tbl_5_13` độ bền; `tbl_5_T0` reported vs executed.

## 15. Yêu cầu sang làn khác
- **→ L4:** Chương 4 phải trình bày mọi mô hình/kiểm định dùng ở Ch5 (kiến trúc: "Ch4 → Ch5"). `04. Chuong_04/chapter.md` hiện (cấu trúc cũ) chưa thấy: HS có trọng số, FHS, EVT có điều kiện, McNeil–Frey, đèn giao thông Basel, MCS; Acerbi–Székely, Fissler–Ziegel chỉ được nhắc (grep 22/10/2026).
- **→ L0:** không cần đổi dữ liệu nếu tác giả theo khuyến nghị mục 11.

## 16. Nguồn trích dẫn trong thiết kế
Boudoukh, Richardson & Whitelaw (1998); Barone-Adesi, Giannopoulos & Vosper (1999); McNeil & Frey (2000); Kupiec (1995); Christoffersen (1998); Engle & Manganelli (2004); Acerbi & Székely (2014); Fissler & Ziegel (2016); Patton, Ziegel & Chen (2019); Hansen, Lunde & Nason (2011); BCBS (1996, đèn giao thông); BCBS (2019, FRTB, ES 97,5%). Trạng thái: **unverified** (chưa đối chiếu bib, DOI) — kiểm ở C05-M4.

## 17. Tự kiểm (Lead, chưa có review độc lập)
- [x] Mọi lựa chọn có lý do và định trước; danh sách độ bền đóng.
- [x] Phủ đủ 7 việc của ticket (tập mô hình; α, kỳ hạn, cửa sổ, tái ước lượng; kiểm định; giai đoạn; độ bền + 2007–2009; HNX-Index; đọc chương + ch07).
- [x] Không chỉ số ngành, VN30, cổ phiếu; chỉ tệp chuẩn.
- [x] Không chạy mô hình; số duy nhất là đếm ngày (computed).
- [ ] Review độc lập thiết kế (var-monograph-reviewer) — chưa chạy; đề xuất L3 chạy một lần trên gói chung.
- [ ] Khớp C03-D1 (mục 12) — chờ bản nháp L3.
