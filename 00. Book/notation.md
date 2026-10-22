# Bảng ký hiệu — sách chuyên khảo biến động, VaR/ES Việt Nam

- **Phiên bản:** B01, 22/10/2026 — **đã chốt** (tác giả đồng ý mục F, 22/10/2026 16:15). Sau khi chốt: nguồn cho Phụ lục A (B10), cho viết bù (C0X-M2) và cho tên biến trong code R (C0X-M3).
- **Cách lập:** quét toàn bộ biểu thức toán `$…$` trong 6 tệp `chapter.md` (SHA theo `_project/input_manifest_20261022.csv`); Ch1: 43, Ch2: 132, Ch3: 14, Ch4: 41, Ch5: 10, Ch6: 0 biểu thức khác nhau. Ký hiệu đang dùng khác nhau ghi ở mục E.

## A. Quy ước chung
| Quy ước | Đề xuất |
|---|---|
| Chỉ số thời gian | $t = 1,\dots,T$ (phiên giao dịch); $T$ = số quan sát của mẫu |
| Tập thông tin | $\mathcal{F}_{t-1}$ — thông tin đến hết phiên $t-1$ (đang dùng thống nhất ở Ch1, Ch2, Ch4) |
| Ước lượng / dự báo | dấu mũ: $\hat{\theta}$; dự báo cho $t+h$ lập tại $t$: $\hat{\sigma}_{t+h\mid t}$ |
| Logarit | $\ln$ (logarit tự nhiên); không dùng $\log$ |
| Đơn vị tỷ suất sinh lời | Ch1 (lý thuyết): dạng thập phân; Ch3–Ch5 (thực nghiệm): **phần trăm** ($\times 100$), như Ch3 hiện dùng |
| Dấu thập phân | dấu phẩy (0,94), dấu chấm phân nhóm nghìn (4.931) — theo chuẩn tiếng Việt; trong LaTeX cần gói `icomma` hoặc `{,}` (ghi cho B03) |
| Tên thước đo rủi ro | chữ đứng: $\mathrm{VaR}$, $\mathrm{ES}$, $\mathrm{RV}$, $\mathrm{AIC}$ |
| Hàm chỉ thị | $\mathbb{1}\{\cdot\}$ |
| Phân phối | $D(0,1)$: phân phối chuẩn hóa tổng quát; $N(0,1)$; $\Phi(\cdot)$, $\phi(\cdot)$: hàm phân phối, hàm mật độ chuẩn tắc |

## B. Giá, tỷ suất sinh lời, tổn thất
| Ký hiệu | Ý nghĩa | Ghi chú |
|---|---|---|
| $P_t$ | Giá đóng cửa (điểm chỉ số) phiên $t$ | |
| $P_t^{O}, P_t^{H}, P_t^{L}$ | Giá mở cửa, cao nhất, thấp nhất | thay $O_t, H_t, L_t, C_t$ ở Ch2 (xung đột E2) |
| $R_t = P_t/P_{t-1} - 1$ | Tỷ suất sinh lời giản đơn | Ch1 |
| $r_t = \ln(P_t/P_{t-1})$; thực nghiệm $r_t = 100\ln(P_t/P_{t-1})$ | Tỷ suất sinh lời logarit | Ch3 dùng $100[\log P_t - \log P_{t-1}]$ → đổi $\log$ thành $\ln$ |
| $L_t = -r_t$ | Tổn thất (theo tỷ suất sinh lời, %) | Ch4, Ch5 đã dùng; dương = lỗ |
| $V_{t-1}$ | Giá trị vị thế đầu phiên $t$ | Ch1; tổn thất tiền tệ $= V_{t-1} L_t/100$ (Ch5: $V \times \mathrm{VaR}/100$) |
| $w_{i,t-1}$, $R_{p,t}$ | Tỷ trọng tài sản $i$; tỷ suất sinh lời danh mục | Ch1, 1.2.2 |
| $\bar{r}$, $s$ | Trung bình, độ lệch chuẩn mẫu | Ch1 dùng cả $\bar r$ và $\overline{r}$ — chọn $\bar r$ |

## C. Biến động và mô hình
| Ký hiệu | Ý nghĩa | Ghi chú |
|---|---|---|
| $\mu_t = E(r_t\mid\mathcal{F}_{t-1})$ | Trung bình có điều kiện | |
| $\varepsilon_t = r_t - \mu_t$ | Sai số (cú sốc) | Ch2: $\varepsilon_t$ (thống nhất) |
| $\sigma_t^2$, $\sigma_t$ | Phương sai, biến động có điều kiện | **không dùng $h_t$ cho phương sai** ($h$ dành cho kỳ dự báo) |
| $z_t = \varepsilon_t/\sigma_t \sim$ i.i.d. $D(0,1)$ | Sai số chuẩn hóa | |
| $\hat{\sigma}_{t,m}$ | Biến động lịch sử, cửa sổ $m$ phiên | Ch1, Ch2 |
| $\lambda$ | Hệ số phân rã EWMA ($\lambda = 0{,}94$) | chỉ dùng $\lambda$ cho EWMA (xung đột E5) |
| $\omega,\ \alpha_i,\ \beta_j$ | Hằng số, hệ số ARCH, hệ số GARCH | luôn có chỉ số dưới ($\alpha_1, \beta_1$) để phân biệt với xác suất đuôi $\alpha$ |
| $\gamma$ | Hệ số bất đối xứng (GJR, EGARCH, APARCH) | |
| $\delta$ | Số mũ lũy thừa (APARCH) | |
| $\alpha_1+\beta_1(+\gamma/2)$ | Tính bền; chu kỳ bán rã $\mathrm{HL} = \ln 0{,}5/\ln(\alpha_1+\beta_1)$ | 2.2.2 |
| $\mathbb{1}\{\varepsilon_{t-1}<0\}$ | Chỉ thị cú sốc âm (GJR) | thay $I_{t-1}$ ở Ch2 (xung đột E4) |
| $\nu$ | Bậc tự do Student-t | thay $v$ ở Ch2 (xung đột E3) |
| $\kappa$ | Tham số hình dạng GED | Ch2 đang dùng |
| $\eta$ | Tham số độ lệch của phân phối lệch (sstd, sged, SGT) | thay $\xi$ (Ch2 ST/SGED) và $\lambda$ (Ch2 SGT) — xung đột E5, E6 |
| $\Theta$, $\ell_t(\Theta)$ | Véc-tơ tham số; logarit hàm hợp lý phiên $t$ | Ch2 |
| $k$ | Số tham số (AIC, BIC) | |
| $\mathrm{RV}_t$, $r_{t,j}$, $M$ | Phương sai thực hiện; tỷ suất sinh lời trong ngày; số khoảng trong ngày | Ch1 |

## D. Dự báo, đánh giá dự báo, rủi ro đuôi
| Ký hiệu | Ý nghĩa | Ghi chú |
|---|---|---|
| $h$ | Kỳ dự báo (số phiên) | Ch3 đã dùng |
| $W$ | Độ dài cửa sổ trượt (Ch3: 1.250; Ch5: 500 — chốt ở C03-D1, C05-D1) | Ch2 dùng $W$; Ch2 còn $T_0$ cho mẫu ước lượng ban đầu |
| $n$ | Số dự báo ngoài mẫu | Ch4 dùng $n$ cho số quan sát kiểm định ngược |
| $\tilde{\sigma}^2_{t,h}$ | Thước đo đối chứng của phương sai kỳ $h$ | Ch3 dùng; thay $v_t$ ở Ch2 (xung đột E7) |
| $\mathcal{L}(\tilde\sigma^2,\hat\sigma^2)$ | Hàm tổn thất (MSE, QLIKE, MAE) | chữ hoa nét hoa để khỏi trùng $L_t$ |
| $d_t$ | Chênh lệch hàm tổn thất (Diebold–Mariano) | |
| $a,\ b$ | Hệ số hồi quy Mincer–Zarnowitz | Ch3 đã dùng |
| $\alpha$ | **Xác suất đuôi** (0,01; 0,025; 0,05); mức tin cậy $= 1-\alpha$ | xung đột E1 |
| $q_\alpha(\cdot)$, $z_\alpha = \Phi^{-1}(\alpha)$ | Phân vị mức $\alpha$; phân vị chuẩn tắc ($z_{0{,}01}\approx -2{,}33$) | Ch1, Ch4 |
| $\mathrm{VaR}_{\alpha,t+1\mid t}$ | VaR một phiên, dương: $P(L_{t+1} > \mathrm{VaR}_{\alpha,t+1\mid t}\mid\mathcal{F}_t) = \alpha$ | rút gọn $\mathrm{VaR}_\alpha$ khi không cần chỉ số thời gian |
| $\mathrm{ES}_{\alpha,t+1\mid t} = E(L_{t+1}\mid L_{t+1} > \mathrm{VaR}_{\alpha,t+1\mid t},\mathcal{F}_t)$ | ES một phiên, dương | |
| $\mathrm{VaR}^{(h)}$, $\mathrm{ES}^{(h)}$ | Cho kỳ hạn nắm giữ $h$ phiên | 4.3.3, 5.2.2 |
| $\tau = 1-\alpha$ | Mức phân vị của tổn thất trong hồi quy phân vị, CAViaR | Ch4 đã dùng |
| $I_t = \mathbb{1}\{L_t > \mathrm{VaR}_{\alpha,t\mid t-1}\}$ | Chỉ thị vi phạm | Ch4 |
| $\mathrm{Hit}_t = I_t - \alpha$ | Chuỗi vi phạm đã trừ trung bình (DQ) | Ch4 |
| $x$, $\hat{p} = x/n$ | Số vi phạm; tỷ lệ vi phạm | Ch4 |
| $LR_{uc}, LR_{ind}, LR_{cc}$ | Thống kê kiểm định độ phủ | Kupiec, Christoffersen |
| $S_{FZ}$ | Hàm điểm Fissler–Ziegel cho cặp (VaR, ES) | 4.7.1 |
| $u$, $N_u$ | Ngưỡng EVT; số quan sát vượt ngưỡng | Ch4 |
| $\xi$, $\beta$ | Tham số hình dạng, thang đo của GPD | chỉ dùng $\xi$ cho GPD; $\beta$ không chỉ số dưới chỉ là thang đo GPD |
| $B$, $z^{(b)}_{t+1}$ | Số lần mô phỏng/bootstrap; lần rút thứ $b$ | Ch4 đã dùng $(b)$ |

## E. Xung đột hiện tại giữa các chương (sửa khi viết bù C0X-M2)
| # | Ký hiệu | Đang dùng | Đề xuất |
|---|---|---|---|
| E1 | $\alpha$ | Ch1: mức tin cậy ($\alpha = 99\%$, $\mathrm{VaR}_{99\%}$); Ch4, Ch5: xác suất đuôi ($\alpha = 0{,}01$); Ch3: mức ý nghĩa MCS ($\alpha = 0{,}10$); Ch2: hệ số ARCH | $\alpha$ = xác suất đuôi; hệ số ARCH luôn $\alpha_i$; mức ý nghĩa viết bằng chữ; Ch1 đổi $\mathrm{VaR}_{99\%}$ thành "VaR ở mức tin cậy 99% ($\alpha = 1\%$)" |
| E2 | $L_t$ | Ch2 (2.1.3): giá thấp nhất; Ch1, Ch4, Ch5: tổn thất | $L_t$ = tổn thất; giá dùng $P_t^{O,H,L}$. $H_t$ ở Ch2 cũng trùng với $H_0$ (giả thuyết) |
| E3 | bậc tự do | Ch2: $v$ (và $t_v$, $\Theta_v$) lẫn $\nu$ | $\nu$ |
| E4 | chỉ thị | Ch2: $I_{t-1}$ (GJR); Ch4: $I_t$ (vi phạm) | GJR: $\mathbb{1}\{\varepsilon_{t-1}<0\}$; $I_t$ chỉ cho vi phạm |
| E5 | $\lambda$ | Ch2: EWMA và tham số độ lệch SGT | $\lambda$ chỉ cho EWMA; độ lệch $\eta$ |
| E6 | $\xi$ | Ch2: độ lệch (ST, SGED); Ch4: hình dạng GPD | $\xi$ chỉ cho GPD; độ lệch $\eta$ |
| E7 | thước đo đối chứng | Ch2: $v_t$, $\hat v_{t\mid t-1}$; Ch3: $\tilde{\sigma}^2_{t,h}$ | $\tilde{\sigma}^2_{t,h}$ |
| E8 | $\beta$ | Ch2: hệ số GARCH; Ch4: thang đo GPD | GARCH luôn $\beta_j$ |
| E9 | logarit | Ch2: $ln(\cdot)$ dạng chữ nghiêng; Ch3: $\log$ | $\ln$ |
| E10 | dấu thập phân | Ch1, Ch2, Ch4 dùng cả 0.94 / 0,94; 0.03 / 0,08 | dấu phẩy |
| E11 | $\nu$ trong công thức SGT (Ch2) | hằng số chuẩn hóa | đổi tên khi viết lại 2.3.1 để khỏi trùng bậc tự do |
| E12 | biến động lịch sử | Ch1: $\hat\sigma_{daily}$; Ch2: $\hat\sigma_{t,m}$ | $\hat\sigma_{t,m}$ |
| E13 | $\tau$ | Ch2 (2.3.2): mức phân vị đuôi trái của tỷ suất sinh lời ($q_{\tau,t}(r)$, tức $\tau=\alpha$); Ch4: mức phân vị của tổn thất ($\tau = 1-\alpha$) | Ch2 viết $q_{\alpha,t}(r)$; $\tau$ chỉ dùng cho hồi quy phân vị của tổn thất |

## F. Quy ước đã chốt (tác giả đồng ý 22/10/2026)
1. $\alpha$ là **xác suất đuôi** (VaR 1% ⇔ mức tin cậy 99%) cho toàn sách (E1).
2. Thực nghiệm (Ch3–Ch5) dùng tỷ suất sinh lời logarit **theo %**; VaR, ES báo cáo **số dương** theo % tổn thất.
3. $\eta$ cho tham số độ lệch; giữ $\xi$, $\beta$ cho GPD theo quy ước EVT thông dụng.
4. Dấu phẩy thập phân trong cả công thức và bảng (ảnh hưởng khuôn LaTeX B03).
