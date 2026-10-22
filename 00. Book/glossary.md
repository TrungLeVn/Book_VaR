# Bảng thuật ngữ Anh–Việt — sách chuyên khảo biến động, VaR/ES Việt Nam

- **Phiên bản:** B01, 22/10/2026. **Nguồn:** bảng "Đối chiếu thuật ngữ dùng trong tiêu đề" và "Ghi chú sử dụng" của `00. Book/outline_v3.docx` (SHA `7fcb6458…ce9c4`); quét 6 tệp `0X. Chuong_0X/chapter.md` (SHA theo `_project/input_manifest_20261022.csv`).
- **Trạng thái (cập nhật 22/10/2026, 16:15):** Phần A **đã chốt** (đề cương 3.1/3.2; tác giả xác nhận lại A16, A17, A20 ngày 22/10/2026). Phần B, C: **dùng làm chuẩn tạm** khi viết bù; tác giả có thể sửa ở vòng review chương. Sau khi chốt, bảng này là nguồn cho Phụ lục A (B10) và cho mọi lần viết bù (C0X-M2).
- **Nguyên tắc:** tiêu đề chỉ dùng tiếng Việt (giữ tên riêng mô hình, chỉ số); thân bài: lần đầu xuất hiện trong mỗi chương ghi "tiếng Việt (tiếng Anh, viết tắt)", các lần sau dùng tiếng Việt hoặc viết tắt đã định nghĩa; tên kiểm định, tên tác giả giữ nguyên trong thân bài.

## A. Thuật ngữ đã chốt (dùng trong tiêu đề)

| # | Tiếng Việt (tiêu đề, thân bài) | Tiếng Anh (thân bài, Phụ lục A) | Nguồn chốt |
|---|---|---|---|
| A1 | Tỷ suất sinh lời | Return | Ghi chú sử dụng, outline 3.1 |
| A2 | Tỷ suất sinh lời logarit | Log return (continuously compounded return) | AGENTS.md (thuật ngữ); outline 3.1 |
| A3 | Tỷ suất sinh lời giản đơn | Simple (arithmetic) return | PROJECT.md (Ch1 so sánh giản đơn và logarit) |
| A4 | Biến động (biến động tỷ suất sinh lời) | Volatility | Ghi chú biên tập ("volatility" → "biến động") |
| A5 | Rủi ro đuôi (bao gồm VaR và ES) | Tail risk | Đã thống nhất 22/10/2026 (thay "rủi ro phân vị") |
| A6 | Giá trị chịu rủi ro | Value-at-Risk (VaR) | Bảng đối chiếu |
| A7 | Tổn thất kỳ vọng có điều kiện | Expected Shortfall (ES) | Bảng đối chiếu |
| A8 | Tổn thất | Loss | AGENTS.md |
| A9 | Trung bình trượt có trọng số mũ | EWMA / RiskMetrics | Bảng đối chiếu |
| A10 | Ước lượng dựa trên biên độ giá | Range-based estimators | Bảng đối chiếu |
| A11 | Hồi quy về trung bình | Mean reversion (half-life: chu kỳ bán rã) | Bảng đối chiếu |
| A12 | Bộ nhớ dài | Long memory (IGARCH, component GARCH, FIGARCH) | Bảng đối chiếu |
| A13 | Phương pháp ước lượng | (Q)MLE | Bảng đối chiếu |
| A14 | Biến động thực hiện / biến động hàm ý | Realized / implied volatility (HAR) | Bảng đối chiếu |
| A15 | Kỳ dự báo | Forecast horizon | Bảng đối chiếu |
| A16 | Thước đo đối chứng | Volatility proxy | Bảng đối chiếu; tác giả xác nhận 22/10/2026 |
| A17 | Hàm tổn thất | Loss function (MSE, QLIKE) | Bảng đối chiếu; tác giả xác nhận 22/10/2026 |
| A18 | Kiểm định so sánh khả năng dự báo | Mincer–Zarnowitz, Diebold–Mariano, MCS | Bảng đối chiếu |
| A19 | Trong mẫu / ngoài mẫu | In-sample / out-of-sample | Bảng đối chiếu |
| A20 | Mô phỏng ngẫu nhiên | Monte Carlo simulation | Bảng đối chiếu; tác giả xác nhận 22/10/2026 |
| A21 | Mô phỏng lịch sử có lọc | Filtered historical simulation (FHS) | Bảng đối chiếu |
| A22 | Lý thuyết giá trị cực trị | Extreme value theory (EVT: POT, GPD, GARCH-EVT) | Bảng đối chiếu |
| A23 | Hồi quy phân vị | Quantile regression, CAViaR | Bảng đối chiếu |
| A24 | Kiểm định ngược | Backtesting | Bảng đối chiếu |
| A25 | Kiểm định độ phủ | Coverage tests (Kupiec, Christoffersen, DQ) | Bảng đối chiếu |
| A26 | Hàm điểm | Scoring function (FZ loss) | Bảng đối chiếu |
| A27 | Kỳ hạn nắm giữ | Holding period | Bảng đối chiếu |
| A28 | Cửa sổ trượt | Rolling window | Bảng đối chiếu |
| A29 | Mô phỏng lịch sử / mô phỏng lịch sử có trọng số | Historical simulation / weighted (age-weighted) historical simulation | Tiêu đề 4.2.1–4.2.2 |
| A30 | Tính bền | Persistence | Tiêu đề 2.2.2 |
| A31 | Phân phối sai số chuẩn hóa | Standardized innovation distribution | Tiêu đề 2.3 |
| A32 | Thước đo rủi ro (tính chất của) | Risk measure (coherence, subadditivity, elicitability) | Tiêu đề 4.1.2 |
| A33 | Rủi ro mô hình | Model risk | Tiêu đề 4.7.2 |
| A34 | Kiểm định độ bền | Robustness checks | Tiêu đề 3.8, 5.9 |
| A35 | Giai đoạn thị trường | Market regimes / sub-periods | Tiêu đề 3.6, 5.7 |

Ghi chú A29–A35: tiếng Việt lấy nguyên từ tiêu đề đề cương 3.1; phần tiếng Anh là đề xuất của B01, chờ tác giả xác nhận.

## B. Thuật ngữ thân bài — đề xuất (chờ tác giả xác nhận)

| # | Tiếng Việt đề xuất | Tiếng Anh | Biến thể đang dùng (số lần ở Ch1…Ch6) | Ghi chú |
|---|---|---|---|---|
| B1 | Cụm biến động | Volatility clustering | "cụm biến động" [2,12,1,0,3,0]; "biến động theo cụm" [3,0,0,0,0,0] | Thống nhất "cụm biến động" |
| B2 | Đuôi dày | Fat/heavy tails | "đuôi dày" [17,8,7,12,12,0] | Đã thống nhất trong thực tế |
| B3 | Hiệu ứng bất đối xứng; hiệu ứng đòn bẩy | Asymmetric (leverage) effect | "bất đối xứng" [8,23,14,10,12,0]; "hiệu ứng đòn bẩy" [1,1,0,0,0,0] | "Hiệu ứng đòn bẩy" chỉ dùng khi nói cơ chế đòn bẩy tài chính (Black, 1976) [Missing Citation] |
| B4 | Độ lệch; độ nhọn (độ nhọn vượt chuẩn) | Skewness; kurtosis (excess kurtosis) | thân bài còn để tiếng Anh: skewness [3,0,4,1,2,0], kurtosis [5,0,4,2,3,0] | |
| B5 | Vi phạm (của VaR) | VaR violation / exceedance / hit | "vi phạm" [0,0,2,29,46,0]; "vượt ngưỡng" [7,0,0,11,6,0] | Đề xuất: "vi phạm" cho sự kiện L_t > VaR; "vượt ngưỡng" chỉ dùng trong EVT (vượt ngưỡng u) |
| B6 | Chuỗi vi phạm | Hit sequence | `Hit_t`, `I_t` (Ch4) | Xem notation.md |
| B7 | Độ phủ không điều kiện / tính độc lập / độ phủ có điều kiện | Unconditional coverage / independence / conditional coverage | để tiếng Anh: conditional coverage [0,0,0,6,2,0] | |
| B8 | Kiểm định phân vị động | Dynamic Quantile (DQ) test | "Dynamic Quantile" [0,0,0,5,1,0] | Giữ tên DQ trong ngoặc |
| B9 | Kiểm định đèn giao thông Basel | Basel traffic-light test | "traffic light" | Tên riêng, thân bài |
| B10 | Mức tin cậy; xác suất đuôi | Confidence level; tail probability (coverage level) | "mức tin cậy" [11,1,1,8,13,0] | VaR ở mức tin cậy 99% ⇔ xác suất đuôi α = 1% (notation.md) |
| B11 | Mức ý nghĩa | Significance level | [0,0,1,0,0,0] | Viết bằng chữ, không dùng α (tránh trùng ký hiệu) |
| B12 | Tập tin cậy mô hình | Model Confidence Set (MCS) | để tiếng Anh [0,0,4,0,0,0] | |
| B13 | Đánh giá dự báo mật độ | Density forecast evaluation (PIT) | — | Chỉ dùng nếu C03-D1 đưa vào |
| B14 | Hàm hợp lý; logarit hàm hợp lý | Likelihood; log-likelihood | — | |
| B15 | Tiêu chí thông tin | Information criteria (AIC, BIC) | | Tiêu đề 2.4.2 |
| B16 | Phần dư chuẩn hóa | Standardized residuals | | |
| B17 | Tính dừng | Stationarity (ADF, KPSS) | | Tiêu đề 3.3.2 |
| B18 | Hiệu ứng ARCH | ARCH effects (ARCH-LM) | | Tiêu đề 3.3.2 |
| B19 | Giao dịch không đồng bộ; giá đứng yên | Non-synchronous trading; stale prices | | HNX-Index (B02 phần 2) |
| B20 | Biên độ dao động giá | Daily price limit | | Dữ kiện có ngày hiệu lực: `context/vn_market_facts.md` (B11) |
| B21 | Quy tắc căn bậc hai thời gian | Square-root-of-time rule | | 4.3.3 |
| B22 | Kiểm tra sức chịu đựng | Stress testing | [1,0,0,0,2,0] | |
| B23 | Dự báo một bước / nhiều bước | One-step / multi-step-ahead forecast | | |
| B24 | Cửa sổ mở rộng | Expanding (recursive) window | "cửa sổ mở rộng" [0,5,0,0,0,0] | Đối lập với A28 |
| B25 | Ngưỡng (trong EVT) | Threshold | | |
| B26 | Tham số hình dạng; tham số thang đo; tham số độ lệch | Shape; scale; skewness parameter | | |
| B27 | Phân phối Student-t; phân phối sai số tổng quát; phân phối lệch | Student-t; generalized error distribution (GED); skewed distributions (sstd, sged, SGT) | | Tên phân phối giữ nguyên |
| B28 | Lãi/lỗ của vị thế | Profit and loss (P&L) | | Tiêu đề 1.2.2 |
| B29 | Khung rà soát cơ bản sổ kinh doanh (của Basel) | Fundamental Review of the Trading Book (FRTB) | FRTB [1,0,0,0,0,0] | Thân bài; dữ kiện ở B11 |

## C. Biến thể cần thay khi viết bù (C0X-M2) — đề xuất

| Đang dùng | Thay bằng | Số lần (Ch1…Ch6) | Ghi chú |
|---|---|---|---|
| tỷ lệ sinh lời | tỷ suất sinh lời | [131,78,5,28,14,0] | Lệch lớn nhất; Ch1–Ch2 đã dùng song song "tỷ suất sinh lời" [88,61,0,0,0,0] |
| lợi suất | tỷ suất sinh lời | [0,1,5,0,1,0] | Giữ nguyên khi trích tên công trình |
| độ dao động; mức biến động; độ biến động | biến động | [8,2,1,0,0,0]; [8,5,0,0,0,0]; [16,0,0,0,4,0] | |
| volatility (chữ Anh trong thân bài) | biến động | [27,2,69,41,41,0] | Chỉ giữ trong ngoặc ở lần định nghĩa |
| hàm mất mát | hàm tổn thất | [0,0,0,5,0,0] | |
| giá trị cực đoan | giá trị cực trị | [0,6,0,0,0,0] | |
| tính dai dẳng; mức độ dai dẳng | tính bền | [0,4,1,0,0,0]; [0,3,0,0,0,0] | |
| kỳ nắm giữ | kỳ hạn nắm giữ | [3,0,0,0,5,0] | |
| horizon (chữ Anh) | kỳ dự báo | [0,0,39,0,0,0] | Ch3 |
| proxy (chữ Anh) | thước đo đối chứng | [0,0,12,0,0,0] | Ch3 |
| backtesting / backtest (chữ Anh) | kiểm định ngược | [1,0,0,10,15,0] | Ch4–Ch5 |
| historical simulation (chữ Anh) | mô phỏng lịch sử | [0,0,0,14,15,0] | Ch4–Ch5 |
| return / log return (chữ Anh) | tỷ suất sinh lời / tỷ suất sinh lời logarit | [9,0,33,1,3,0] / [1,0,10,0,2,0] | Ch3 |

## D. Tên riêng giữ nguyên (không dịch)
- Mô hình: ARCH, GARCH, GARCH-M, EGARCH, GJR-GARCH, TGARCH/TARCH, APARCH, IGARCH, CGARCH (GARCH thành phần), FIGARCH, HAR, EWMA/RiskMetrics, CAViaR, GARCH-EVT.
- Ước lượng biên độ giá: Parkinson, Garman–Klass, Rogers–Satchell, Yang–Zhang.
- Kiểm định: Jarque–Bera, ADF, KPSS, Ljung–Box, ARCH-LM, Engle–Ng (sign bias), Mincer–Zarnowitz, Diebold–Mariano, MCS, Kupiec (POF), Christoffersen, DQ (Engle–Manganelli), Acerbi–Székely, McNeil–Frey, hàm điểm Fissler–Ziegel (FZ).
- Chỉ số: VN-Index, HNX-Index.

## E. Trạng thái xác nhận
- 22/10/2026: tác giả đồng ý mục 1 (giữ ba thuật ngữ như đề cương). Mục 2–4 áp dụng như đề xuất cho đến khi tác giả sửa.

1. Ba thuật ngữ ticket B01 nêu đích danh: **hàm tổn thất** (A17), **thước đo đối chứng** (A16), **mô phỏng ngẫu nhiên** (A20) — giữ như đề cương 3.1?
2. "Vi phạm" (VaR) và "vượt ngưỡng" (EVT) tách nghĩa như B5?
3. Phần tiếng Anh của A29–A35 và toàn bộ phần B.
4. Thay hàng loạt "tỷ lệ sinh lời" → "tỷ suất sinh lời" khi tích hợp chương (Lead làm ở bước C0X-M2), trừ tên công trình được trích.
