# Review độc lập — thiết kế thực nghiệm Chương 3 (C03-D1)

- **Đối tượng:** `design/C03-D1_design.md` (v1, 22/10/2026). Người review không soạn bản này (review độc lập, ngữ cảnh riêng).
- **Vai trò:** var-monograph-reviewer (agent gốc independent-reviewer), chế độ review bản thiết kế (design memo).
- **Đã đọc (chỉ các tệp này):** `tickets/C03-D1.md`; `00. Book/architecture.md` (Ch3, Ch5); `00. Book/notation.md`; `_project/data/README.md`; `results/B02_20261022-1616_HNX/data_contract.md`; `03. Chuong_03/code/R/run_chapter03_volatility.R`; `tickets/C05-D1.md`.
- **Không làm:** không chạy R, không chạy mô hình, không sửa tệp nào ngoài báo cáo này. Mọi số trong thiết kế được kiểm bằng số học/đối chiếu tài liệu, không bằng chạy lại.
- **Nhãn bằng chứng:** số trong thiết kế = *reported*; khi ghi "khớp" là đã đối chiếu với tài liệu dữ liệu (*checked against docs*), không phải *executed*. Trích dẫn: *unverified* (đúng như thiết kế tự khai).

## Kết luận
**Sẵn sàng sau khi sửa (ready after fixes).** Khung thiết kế tốt: bỏ chuẩn so sánh chọn theo kết quả, bỏ chọn ARMA trên toàn mẫu, dự báo mọi phiên, lưới mô hình đầy đủ, bộ dự báo dùng chung. Còn 5 phát hiện Major — đều sửa được trên giấy, không cần chạy — liên quan quy tắc quyết định của giả thuyết, đặc tả phương sai DM, quy tắc B chia trạng thái, giao diện bộ dự báo dùng chung cho Ch5 và điều kiện gói Design chung.

---

## 1. Độ phủ yêu cầu 1–11 của ticket
| # | Yêu cầu | Mục thiết kế | Đánh giá |
|---|---|---|---|
| 1 | Dự báo mọi ngày ngoài mẫu, tái ước lượng 20 ngày | 4 | Đủ |
| 2 | Thước đo đối chứng + MSE, QLIKE | 2, 5.1 | Đủ (xem m1, m2) |
| 3 | Tập mô hình (8 GARCH + lịch sử, cửa sổ trượt, EWMA) | 3 | Đủ, mở rộng lên 12 + 7 có lý do |
| 4 | Quy tắc giai đoạn định trước (sự kiện + trạng thái), dùng chung Ch5 | 6 | Có; quy tắc B cần sửa (M3) |
| 5 | Độ bền: cửa sổ, thước đo biên độ, cực trị | 7 | Có; R5 chỉ xử lý cực trị ở khâu đánh giá, không ở khâu ước lượng (m6) |
| 6 | HNX-Index toàn bộ tập mô hình, không chỉ số ngành | 8 | Đủ |
| 7 | Bộ dự báo dùng chung, đủ cho kiểm định ngược 99% | 4.1, 12 | Có; giao diện thiếu trường Ch5 cần (M4) |
| 8 | Thước đo biên độ không cần giá mở cửa hoặc giới hạn mẫu | 2, 1.3 | Đủ (Parkinson; GK giới hạn đến 2020 — m5) |
| 9 | Đọc `chapter.md` và `code/` | đầu bản, 0 | Code: có. `chapter.md`: không nêu rõ đã đọc (chỉ gián tiếp qua "3.7.3 cũ" ở R2) — n3 |
| 10 | Mô tả giới hạn V9 | 1.2 | Đủ, khớp `_project/data/README.md` (1,565%) |
| 11 | Trình cùng C05-D1 trong một gói Design | 12.5 | **Chưa đạt** — C05-D1 chưa có (M5) |

## 2. Kiểm số và đếm (checked bằng số học / đối chiếu tài liệu)
| Mục | Khẳng định | Kiểm | Kết quả |
|---|---|---|---|
| 0, 3.3 | 19 mô hình | 12 GARCH + lịch sử 1 + cửa sổ trượt 4 + EWMA 2 = 19 | Khớp; mục 10 "12 + 7" khớp |
| 4 | $n$ ≈ 2.830 VN-Index, $h$=1 | 4.081 giá → 4.080 tỷ suất sinh lời; $t$ = 1.250…4.079 → 2.830 | Khớp |
| 4 | HNX ≈ 2.832 | 4.083 giá → 4.082 → 2.832 | Khớp |
| 4 | 142 lần ước lượng/mô hình, ≈1.700/cấu hình | ⌈2.830/20⌉ = 142; ×12 = 1.704 | Khớp |
| 4 | 12–15 nghìn lần ước lượng toàn thiết kế | Cần ước lượng lại: VN chính, HNX chính, R1, R2, R6 (+R6 HNX nếu có) = 5–6 cấu hình ≈ 8.500–10.200 | Có vẻ ước cao; không ảnh hưởng thiết kế (n1) |
| 4.1 | ≈28 vi phạm ở 1% | 0,01 × 2.830 = 28,3 | Khớp ($h$=1) |
| 1.1 | 4.081 / 4.083 phiên; V9 | `_project/data/README.md`, hợp đồng v2 (H1) | Khớp |
| 3.1 | AR(1) 0,088 ±0,031; HNX 0,041 | Hợp đồng v2, H4 | Khớp |
| 1.3 | 43/8, 75/13, 134/250… | Không có tài liệu đối chiếu trong phạm vi đọc | *reported, chưa kiểm* |
| 6.1 | Khối 250–750 điểm (6.3) | G6 = 2023 → 20/05/2026 ≈ 3 năm + ~90 phiên ≈ 840 điểm | Không khớp (m10) |

---

## 3. Bảng phát hiện
Mức: **Major** = phải sửa trước khi tác giả duyệt (ảnh hưởng tính hợp lệ của suy luận hoặc buộc chạy lại sau này); **Minor** = sửa trong bản v2 thiết kế, không chặn; **Note** = ghi để L3a/L3b/L5 xử lý.

### Major
| # | Vị trí | Vấn đề | Vì sao quan trọng | Cách sửa cụ thể | Bằng chứng để kiểm | Ticket |
|---|---|---|---|---|---|---|
| M1 | Mục 9 (H2–H5); 5.2; 6.3 | Giả thuyết "dạng kiểm định được" nhưng **không có quy tắc quyết định định trước**. (a) H2 viết theo chiều phủ định ("GARCH không vượt EWMA ở mọi kỳ và mọi hàm tổn thất") — ngược chiều H3, H4; không rõ là $H_0$ hay kỳ vọng; "mọi kỳ × mọi hàm" = 12 mô hình × 4 kỳ × 2 hàm = 96 phép DM, không nêu kết luận khi kết quả lẫn lộn. (b) H3, H4 dựa trên DM theo cặp (18 + 12 = 30 cặp × 4 kỳ × 2 hàm) trong khi 5.2 nói DM chỉ "mô tả" và kết luận dựa MCS — mâu thuẫn. (c) H5 chỉ có thống kê mô tả (Spearman, MCS theo khối): không có $H_0$, không có kiểm định. | Không có quy tắc quyết định trước thì việc đọc "giả thuyết được ủng hộ" sẽ chọn sau khi xem kết quả — đúng điều ticket cấm ("định trước khi xem kết quả"). Cách viết H2 cũng có nguy cơ bị hiểu là rút từ kết quả cũ (EWMA tốt ở 50 điểm cũ). | (1) Viết mỗi giả thuyết thành $H_0$/$H_1$ cùng chiều (vd. H2: $H_0$: $E[d_t]=0$ giữa GARCH-$k$ và EWMA 0,94; $H_1$ hai phía). (2) Nêu quy tắc quyết định: kết luận chính = EWMA 0,94 (hoặc mô hình bất đối xứng/đuôi dày) có/không nằm trong MCS 10% theo QLIKE, $h$=1 (và $h$=10); DM là bổ trợ, đọc với hiệu chỉnh Holm trong từng họ (H2: 12 phép; H3: 9 cặp; H4: 12 cặp) cho mỗi kỳ × hàm. (3) H5: dùng kiểm định khả năng dự báo có điều kiện kiểu Giacomini–White — hồi quy $d_t$ lên hằng số và biến giả khối/trạng thái với sai số HAC, kiểm định Wald các hệ số khối bằng nhau; giữ Spearman làm mô tả. (4) Ghi một dòng: lý do chọn EWMA 0,94 làm chuẩn là chuẩn RiskMetrics, không phải kết quả cũ. | Bản v2 mục 9 có cột "$H_0$ / thống kê / quy tắc quyết định / hiệu chỉnh đa kiểm định" | C03-D1 (v2) |
| M2 | 5.2, dòng Diebold–Mariano | Phương sai DM ghép **Newey–West, độ trễ $\max(h-1,5)$** với **hiệu chỉnh Harvey–Leybourne–Newbold**. Hệ số HLN được suy ra cho ước lượng phương sai với nhân chữ nhật và đúng $h-1$ tự hiệp phương sai; ghép với nhân Bartlett và độ trễ khác (5 khi $h$=1) là không nhất quán — thống kê không còn phân phối $t_{n-1}$ như HLN lập luận. Code cũ (`forecast::dm.test`, dòng 235) dùng dạng HLN chuẩn. | Ảnh hưởng mọi giá trị $p$ của H2–H4 và là thay đổi đặc tả so với code cũ mà không có lý do. Với QLIKE trên bình phương tỷ suất sinh lời, $d_t$ thường tự tương quan vượt $h-1$ do cụm biến động → độ trễ $h-1$ có thể quá ít. | Chọn một trong hai và ghi rõ: (a) **chính:** Newey–West nhân Bartlett, độ trễ định trước $\max(h-1, \lfloor 4(n/100)^{2/9}\rfloor)$ (≈ 8 với $n$≈2.830), giá trị tới hạn $N(0,1)$ hoặc $t_{n-1}$, **không** nhân hệ số HLN; (b) **phụ:** DM–HLN chuẩn (nhân chữ nhật, $h-1$ trễ) để đối chiếu với code cũ. Nêu cách xử lý khi phương sai ước lượng âm (nhân chữ nhật). | Mục 5.2 v2 nêu nhân, độ trễ, phân phối tham chiếu | C03-D1 (v2) |
| M3 | 6.2 (quy tắc B) | (a) Ngưỡng tam phân vị tính trên **mẫu ước lượng ban đầu + ngoài mẫu** (2010–2026): phân loại dựa trên phân phối gồm cả tương lai so với $t$ và gồm giai đoạn 2010–2014 không thuộc mẫu đánh giá → số điểm ngoài mẫu mỗi trạng thái có thể rất lệch (không còn là "tam phân vị" của mẫu đánh giá), ảnh hưởng trực tiếp tới Ch5 (VaR 99% theo trạng thái). (b) Chỉ báo $\hat\sigma_{t,60}$ **trùng đúng dự báo của đối thủ "cửa sổ trượt 60"** (mục 3.3): chia trạng thái theo chính dự báo của một mô hình tạo hiệu ứng cơ học — trạng thái "cao" là nơi dự báo cửa sổ 60 cao nhất, trong khi biến động hồi quy về trung bình → bất lợi cơ học cho cửa sổ 60 và các mô hình bền cao, thuận lợi cho mô hình hồi quy nhanh. | H5 (và 5.7) dựa vào quy tắc này; một khi khoá trong bộ dùng chung, sửa sau phải chạy lại phần đánh giá của cả hai chương. | (a) Chọn và ghi một quy tắc ngưỡng: **ưu tiên** ngưỡng cố định từ cửa sổ ước lượng ban đầu (1.250 phiên đầu, hoàn toàn ex-ante), báo số điểm mỗi trạng thái; hoặc tam phân vị trên các điểm ngoài mẫu (cân bằng số điểm, nêu rõ là phân loại phục vụ đánh giá). Không dùng phương án lai hiện tại. Định trước số điểm tối thiểu mỗi ô (vd. ≥ 300 cho Ch5 VaR 99%). (b) Dùng chỉ báo không trùng dự báo của mô hình nào trong tập — vd. trung bình Parkinson 20 phiên đến $t$ (cửa sổ trượt 20 dùng $r^2$ nên không trùng) — tác giả chọn; hoặc giữ $\hat\sigma_{t,60}$ nhưng ghi rõ hiệu ứng cơ học với cửa sổ trượt 60 và không diễn giải thứ hạng của mô hình này theo trạng thái. | Mục 6.2 v2 + bảng số điểm dự kiến mỗi trạng thái (tính được không cần chạy mô hình) | C03-D1 (v2), C05-D1 |
| M4 | 4.1; 12.4 | Giao diện bộ dự báo dùng chung **thiếu trường Ch5 cần**: chỉ lưu $\hat\mu_{t+1\mid t}$, $\hat\sigma^2_{t+j\mid t}$, $\nu$, $\eta$. Ch5 (C05-D1 mục 1) có mô phỏng lịch sử **có lọc** — cần phần dư chuẩn hóa $z$ của cửa sổ ước lượng theo cùng tham số; VaR/ES 10 ngày cần $\hat\mu_{t+j\mid t}$, $j$=1..10 (AR(1) cho $\hat\mu$ nhiều bước khác nhau theo $j$) và/hoặc mô phỏng đường đi cần toàn bộ véc-tơ tham số; mô tả tính bền theo thời gian cần $\hat\Theta$. | Nếu khoá bộ dự báo rồi Ch5 mới thấy thiếu thì phải chạy lại toàn bộ ~1.700 lần ước lượng/chuỗi — đúng rủi ro mà bộ dùng chung muốn tránh. | Lưu thêm: (i) toàn bộ $\hat\Theta$ (mọi hệ số + cờ hội tụ + log-likelihood) **theo mỗi lần tái ước lượng**, khóa bằng ngày ước lượng; (ii) $\hat\mu_{t+j\mid t}$, $j$=1..20; (iii) $z_t$ lọc theo tham số cố định cho mọi phiên (để FHS dựng lại cửa sổ $z$ không cần ước lượng lại). Ghi trong 4.1 và 12; L5 xác nhận đủ trong C05-D1 trước khi M3b chạy. | Mục 4.1 v2 có lược đồ cột (schema) được L5 xác nhận | C03-D1 (v2), C05-D1, C03-M3b |
| M5 | 12.5; ticket mục 11 | Ticket yêu cầu trình **cùng C05-D1 trong một gói Design**; C05-D1 chưa có. Nhiều lựa chọn ở đây ràng buộc Ch5 ($W$ = 1.250 cho GARCH ở Ch5 trái với `notation.md` "Ch5: 500", quy tắc giai đoạn, kỳ 10 ngày). | Tác giả duyệt riêng C03-D1 thì các quyết định chung bị chốt trước khi L5 đánh giá được hệ quả (vd. 10 ngày chồng lấn ở kiểm định ngược, M4). | Không trình duyệt riêng; hoặc tác giả ghi rõ chấp nhận duyệt tách với điều kiện mục 12 mở lại được khi có C05-D1. Đánh dấu `NEEDS DECISION` cho L0. | Gói Design gồm cả hai tệp | C03-D1, C05-D1 |

### Minor
| # | Vị trí | Vấn đề | Cách sửa |
|---|---|---|---|
| m1 | 2 (ghi chú QLIKE); 5.1 | Loại điểm có $\tilde\sigma^2=0$ khỏi QLIKE là không cần thiết và làm mẫu QLIKE ≠ mẫu MSE (trái "mẫu đánh giá chung", mục 4). Dạng $\tilde\sigma^2/\hat\sigma^2 + \ln\hat\sigma^2$ cho cùng thứ hạng và cùng $d_t$ (số hạng $\ln\tilde\sigma^2$ triệt tiêu), xác định cả khi $\tilde\sigma^2=0$. | Dùng dạng $\tilde\sigma^2/\hat\sigma^2+\ln\hat\sigma^2$ cho $d_t$, DM, MCS (không loại điểm nào); dạng chuẩn hóa hiện tại chỉ để báo mức, trên điểm $\tilde\sigma^2>0$, báo số điểm. |
| m2 | 2 (ghi chú Parkinson); 7 R3 | Câu "ở 3.8 chỉ so thứ hạng" ngụ ý thứ hạng bền với thước đo chệch — sai: thước đo chệch có điều kiện có thể đổi cả thứ hạng theo QLIKE/MSE (đây chính là điều kiện của Patton 2011). | Sửa câu: kết quả Parkinson trả lời câu hỏi khác (biến động trong phiên, không gồm qua đêm). Tùy chọn định trước: nhân Parkinson với hệ số $c$ = trung bình $r_t^2$ / trung bình Parkinson **trên cửa sổ ước lượng ban đầu** (ex-ante), báo cả bản chưa và đã nhân. |
| m3 | 3.1 lý do (ii) | Biện minh AR(1) bằng hệ số AR(1) **toàn mẫu 2010–2026** (B02 H4) — cùng loại lọt thông tin mà thiết kế phê phán ở code cũ (dù tác động nhỏ). | Biện minh bằng lý do tiên nghiệm (giao dịch không đồng bộ ở chỉ số, thực hành chuẩn) hoặc chỉ dẫn hệ số trên 1.250 phiên đầu; giữ R6 (chỉ hằng số) làm kiểm tra. |
| m4 | 9 (H4, trong mẫu) | Kiểm định tỷ lệ hợp lý chuẩn vs Student-t: $1/\nu=0$ nằm trên biên → $\chi^2_1$ thông thường không đúng (phân phối hỗn hợp $\tfrac12\chi^2_0+\tfrac12\chi^2_1$). Student-t vs Student-t lệch: tham số đối xứng nằm trong miền, $\chi^2_1$ dùng được. | Nêu phân phối tham chiếu cho từng cặp; hoặc chỉ dùng AIC/BIC cho cặp chuẩn–Student-t. |
| m5 | 2 (GK); 7 R4 | "Điểm dự báo đến 31/12/2020": với $h$ = 20, cửa sổ mục tiêu của điểm cuối 2020 rơi vào 2021 (giá mở cửa không tin cậy). | Đổi thành "điểm dự báo có cửa sổ mục tiêu kết thúc ≤ 31/12/2020". |
| m6 | 7 R5 vs 6.2 | R5 bỏ 1% điểm có $\tilde\sigma^2$ lớn nhất = chọn mẫu theo kết quả — chính lý do 6.2 bác bỏ chia ex-post. Hợp lệ như phân tích ảnh hưởng, nhưng chệch có hệ thống về phía mô hình dự báo thấp/trơn. Ticket mục 5 cũng có thể hiểu là xử lý cực trị ở khâu ước lượng — chưa có. | Ghi R5 là "phân tích ảnh hưởng, có điều kiện trên kết quả, không dùng để xếp hạng"; thêm (tùy tác giả) R5b: loại các ngày sự kiện định trước theo lịch (vd. 25/01/2018 V9) hoặc ghi rõ không xử lý cực trị ở khâu ước lượng và lý do. |
| m7 | 5.2 MZ | Không nêu độ trễ HAC (mục tiêu chồng lấn $h-1$); MZ theo mức phương sai với bình phương tỷ suất sinh lời bị vài phiên cực trị chi phối. | Nêu độ trễ (như M2); thêm MZ có trọng số $1/\hat\sigma^2_{t,h}$ (dạng bền) làm phụ — `[Missing Citation]` đến C03-M4. |
| m8 | 5.2 MCS; 7 R7 | Đổi thống kê $T_R$ (code cũ, dòng 251) sang $T_{\max}$ không nêu lý do; R7 (MCS 25%) trùng với "25% phụ" đã có ở 5.2 — không phải kiểm định độ bền một yếu tố. Độ dài khối $\max(h,5)$ có thể ngắn với $d_t$ có cụm biến động. | Nêu lý do chọn thống kê (hoặc báo cả hai); bỏ R7 hoặc thay bằng độ dài khối khác (vd. 20) làm độ bền. |
| m9 | 0 dòng 8 vs 5.1 | Mục 0: "xếp hạng chính: QLIKE **và** MSE"; 5.1: QLIKE chính, MSE thứ hai. Chưa có quy tắc khi hai hàm bất đồng. | Thống nhất: QLIKE chính; MSE báo cáo song song; bất đồng được báo, không chọn. |
| m10 | 6.3 | "≈ 250–750 điểm" theo khối; G6 ≈ 840 điểm; với $h$>1 khối cuối mất $h-1$ điểm; khối gán theo ngày lập dự báo nên mục tiêu của điểm cuối năm tràn sang khối sau. | Sửa khoảng; ghi khối gán theo $t$ (ngày lập dự báo). |
| m11 | 4 (không hội tụ) | Không có quy tắc khi **lần ước lượng đầu tiên** lỗi (chưa có tham số trước). Solver "hybrid" của rugarch có thể dùng bước khởi tạo ngẫu nhiên → cần seed cho ước lượng, không chỉ cho MCS; chạy 3 tiến trình cần dòng ngẫu nhiên tái lập được. | Nêu: lần đầu lỗi → thử solver thay thế định trước, rồi đánh dấu thiếu và báo; seed theo (chuỗi, mô hình, ngày ước lượng) hoặc RNG L'Ecuyer; ghi trong README run. |
| m12 | 3.2–3.4; 11 (M3a) | Mẫu ước lượng trong mẫu cho 3.4 và H4 (AIC/BIC) không nêu: toàn mẫu 2010–2026 hay 1.250 phiên đầu. | Nêu rõ (đề xuất: toàn mẫu cho mô tả 3.4, ghi là mô tả, không dùng để chọn dự báo). |
| m13 | 3.3 | Mô hình "lịch sử" dùng phương sai mẫu (trừ trung bình) còn cửa sổ trượt dùng trung bình $r^2$ (không trừ) — hai đối chứng khác định nghĩa. | Thống nhất (đề xuất: không trừ trung bình, như cửa sổ trượt và thước đo đối chứng). |
| m14 | 12.1; notation.md mục D | Đề xuất Ch5 dùng $W$ = 1.250 cho GARCH trái với `notation.md` ("Ch5: 500 — chốt ở C03-D1, C05-D1"). | Sau gói Design, L0 cập nhật `notation.md`; 12.1 nêu mẫu đánh giá chung của Ch5 bắt đầu cùng ngày 13/01/2015 dù phương pháp $W$ = 500 có thể bắt đầu sớm hơn. |
| m15 | 9 (H1) | Kiểm định dấu Engle–Ng: không nêu áp dụng trên phần dư chuẩn hóa của mô hình đối xứng nào hay trên $r_t$. | Nêu: trên $z_t$ của AR(1)-GARCH(1,1) (chuẩn hoặc Student-t). |

### Note
| # | Vị trí | Ghi chú |
|---|---|---|
| n1 | 4 (chi phí) | Ước 12–15 nghìn lần ước lượng có vẻ cao (đếm ≈ 8,5–10,2 nghìn); R2 cửa sổ mở rộng tốn thời gian hơn mỗi lần. Không ảnh hưởng thiết kế. |
| n2 | Code cũ dòng 34–37, 187 | **Lỗi trong code cũ** (liên quan đối chiếu reported ↔ executed ở M3a): `ewma_var` trả `out[n]` = $\hat\sigma^2_{t\mid t-1}$ (chưa cập nhật $r_t$) nhưng được dùng làm dự báo cho $t+1$ → EWMA cũ chậm một phiên, bất lợi cho EWMA. Công thức ở mục 3.3 thiết kế là đúng; M3a cần ghi khác biệt này khi tái tạo. Ngoài ra MCS cũ dùng `drop_na()` (dòng 248) → mẫu MCS có thể khác khi có mô hình không hội tụ; thiết kế mục 4 đã sửa. |
| n3 | Đầu bản; ticket mục 9 | Nêu rõ đã đọc `03. Chuong_03/chapter.md` (ngày/SHA) để đáp ứng mục 9. |
| n4 | 3.3 | Dự báo $\sigma^2$ nhiều bước của EGARCH/APARCH ($\delta\neq2$) từ rugarch là $(\hat\sigma_{t+j\mid t})^2$, không đúng bằng $E[\sigma^2_{t+j}]$ (bất đẳng thức Jensen); nêu là xấp xỉ hoặc dùng mô phỏng ở độ bền. |
| n5 | 7 R2 | Cửa sổ mở rộng nằm ngoài khung Giacomini–White (cửa sổ trượt cố định) biện minh DM khi tham số được ước lượng; diễn giải R2 thận trọng. |
| n6 | 12.2 | Ch5: dự báo 10 ngày lập hằng ngày → vi phạm chồng lấn, Kupiec/Christoffersen chuẩn không hợp lệ; L5 nêu cách xử lý (lấy mẫu không chồng lấn hoặc hiệu chỉnh) trong C05-D1. |
| n7 | 2 (Parkinson) | Câu hỏi: khi giá mở cửa = giá đóng cửa hôm trước, $P^H$/$P^L$ của nhà cung cấp có gồm mức mở cửa này không? Nếu có, Parkinson từ 2021 bao một phần biến động qua đêm (điểm gãy trong thước đo). Bảng 1.3 (trùng max/min chỉ 2–12/năm) gợi ý ảnh hưởng nhỏ — nêu như giới hạn. |
| n8 | 6.1 | Mốc thể chế (L10, S3, T5, S4, T1, F4–F5) dẫn từ `context/vn_market_facts.md` — tệp này ngoài phạm vi đọc của review; không kiểm. Đặc trưng khối đã gắn `[cần xác nhận]` — đúng quy tắc. |

---

## 4. Trả lời 5 câu hỏi của Lead
1. **Độ phủ 1–11:** đủ 1–10 (mục 9 cần ghi rõ đã đọc `chapter.md`); mục 11 chưa đạt (M5).
2. **Tính đúng phương pháp:**
   - *Không thấy nhìn trước trong dự báo:* cửa sổ trượt, lọc tham số cố định giữa hai lần ước lượng chỉ dùng dữ liệu đến $t$; chuẩn so sánh cố định; tập mô hình và bậc cố định; $\lambda$ cố định; quy tắc A theo năm dương lịch; mẫu đánh giá chung. Đây là cải thiện thực chất so với code cũ (ARMA chọn toàn mẫu, chuẩn DM chọn theo RMSE tốt nhất).
   - *Nhìn trước/không nhất quán còn lại:* ngưỡng quy tắc B (M3a), biện minh AR(1) bằng hệ số toàn mẫu (m3), R5 chọn theo kết quả (m6).
   - *Sai/không nhất quán thống kê:* NW + HLN (M2); LR ở biên (m4); loại $\tilde\sigma^2=0$ (m1); câu "chỉ so thứ hạng" với Parkinson (m2).
   - *Đếm:* 19 mô hình, $n$ ≈ 2.830/2.832, 142 lần, 28 vi phạm — khớp; khoảng điểm theo khối (m10) và chi phí (n1) lệch nhẹ.
3. **Định trước, có lý do:** gần như mọi lựa chọn có lý do phương pháp/dữ liệu và khai báo đã thấy kết quả cũ. Thiếu: quy tắc quyết định cho giả thuyết (M1), lý do đổi $T_R$→$T_{\max}$ (m8), quy tắc ngưỡng B (M3). Không thấy lựa chọn nào rõ ràng rút từ thứ hạng cũ; chiều phát biểu H2 nên viết lại để tránh hiểu nhầm (M1).
4. **Ch3↔Ch5:** hướng đúng (một lần ước lượng, $W$, kỳ 10, quy tắc giai đoạn chung, chuyển cả 12 mô hình không lọc). Thiếu trường dữ liệu cho FHS và VaR 10 ngày (M4); xung đột $W$ với notation.md (m14); chưa có C05-D1 để khớp (M5); chồng lấn 10 ngày ở kiểm định ngược (n6).
5. **Bịa dữ kiện/trích dẫn:** không thấy. Chín tài liệu ở mục 9 là tài liệu kinh điển, được khai báo *chưa kiểm* đến C03-M4 — đúng quy tắc; review này cũng không kiểm (unverified). Số liệu dữ liệu khớp hợp đồng v2/v2.1. Bảng 1.3 và mốc thể chế: *reported*, chưa kiểm trong review này.

## 5. Điểm mạnh
- Khai báo minh bạch đã thấy kết quả cũ; mỗi lựa chọn có cột lý do; bảng "hiện trạng → đề xuất" giúp tác giả duyệt nhanh.
- Sửa đúng ba lỗi thiết kế của code cũ: chọn ARMA toàn mẫu, chuẩn DM chọn theo kết quả, 50 điểm dự báo.
- Lưới 4 × 3 cho phép tách vai trò phương trình phương sai và phân phối (5.6.2) — đóng góp thực chất cho cầu nối Ch3–Ch5.
- Xử lý dữ liệu cẩn thận: Parkinson thay GK vì giá mở cửa, V9 được nêu, lịch riêng/lịch chung tách rõ.
- Diễn giải HOSE–HNX không quy nhân quả; giữ kết quả bất lợi (ghi chú H4).

## 6. Câu hỏi mở (không phải lỗi)
1. Tác giả muốn quy tắc B dùng ngưỡng ex-ante (cửa sổ đầu) hay tam phân vị mẫu ngoài mẫu? (M3)
2. $\hat\sigma_{t,60}$ có được giữ làm chỉ báo dù trùng mô hình cửa sổ trượt 60? (M3b)
3. Ticket mục 5 "xử lý quan sát cực trị" có gồm khâu ước lượng không? (m6)
4. Nhà cung cấp tính $P^H$/$P^L$ có gồm giá mở cửa giả không? (n7)

## 7. Điểm rủi ro nhất quán (1 = thấp, 5 = cao)
| Nhóm | Điểm | Ghi chú |
|---|---|---|
| Dữ liệu ↔ hợp đồng | 1 | Khớp v2/v2.1 |
| Thiết kế ngoài mẫu | 2 | Đúng; còn m11 |
| Suy luận thống kê | 4 | M1, M2, m1, m4 |
| Quy tắc giai đoạn | 3 | M3 |
| Ch3 ↔ Ch5 | 4 | M4, M5, m14 |
| Ký hiệu ↔ notation.md | 2 | Nhất quán ($\tilde\sigma^2_{t,h}$, $\eta$, $\nu$, $\lambda$, mức MCS viết bằng chữ); $W$ Ch5 (m14); cần định nghĩa $\hat\sigma^2_{t,h}$ (tổng $h$ bước) trong 3.2.3 |
| Trích dẫn | 2 | Khai báo chưa kiểm; C03-M4 |

## 8. Thuật ngữ Anh–Việt dùng trong review
| Anh | Việt |
|---|---|
| Model Confidence Set (MCS) | bộ tin cậy mô hình |
| loss differential | chênh lệch hàm tổn thất ($d_t$) |
| HAC / Newey–West | sai số chuẩn bền với phương sai thay đổi và tự tương quan |
| conditional predictive ability (Giacomini–White) | khả năng dự báo có điều kiện |
| filtered historical simulation (FHS) | mô phỏng lịch sử có lọc |
| volatility proxy | thước đo biến động đối chứng |
| look-ahead bias | thiên lệch nhìn trước |
| boundary parameter (LR test) | tham số trên biên |

## 9. Kế hoạch kiểm nguồn (cho C03-M4)
Kiểm DOI/trang: Patton (2011) — dạng QLIKE và kết quả thước đo chệch đổi thứ hạng (m1, m2); Harvey–Leybourne–Newbold (1997) — điều kiện nhân/độ trễ (M2); Hansen–Lunde–Nason (2011) — $T_R$ vs $T_{\max}$ (m8). Nếu dùng: Giacomini–White (kiểm định khả năng dự báo có điều kiện, H5) và tài liệu MZ có trọng số — chưa có trong danh mục, `[Missing Citation]`.

---
**Verdict:** Sẵn sàng sau khi sửa — 5 Major (M1–M5) chặn trình duyệt; sửa được trên giấy, không cần chạy.
**Suggested next task:** C03-D1 v2 — L3 sửa M1–M4 và m1–m15 trong `design/C03-D1_design.md`, rồi gộp với C05-D1 thành gói Design (M5); reviewer recheck chỉ các Major.
