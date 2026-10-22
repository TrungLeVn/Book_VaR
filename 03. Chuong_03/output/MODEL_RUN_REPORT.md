# Báo cáo ngắn — mô hình volatility Chương 3

- **Dữ liệu:** VN-Index ngày, 4.080 log returns, 06/01/2010–20/05/2026. Nguồn online không phản hồi; dùng archive fallback đã được audit.
- **Phương trình trung bình:** ARMA(2,1), chọn theo BIC thấp nhất trong các ứng viên ARMA(0:3,0:3) có Ljung–Box residual p >= 0,05. BIC = 2,897283; p = 0,053656.
- **Tập mô hình chạy:** GARCH-normal; GARCH-Student-t; GJR-GARCH-Student-t/skewed-t; EGARCH-Student-t/skewed-t; APARCH-Student-t/skewed-t. HAR không có trong pipeline.
- **Phù hợp trong mẫu:** EGARCH-skewed-t có AIC/BIC thấp nhất (2,859223 / 2,871603); APARCH-skewed-t đứng thứ hai theo BIC (2,875776).
- **Chẩn đoán:** tất cả mô hình không còn ARCH ở residual bình phương. GJR-GARCH-skewed-t còn Ljung–Box residual p = 0,0115; không dùng làm đặc tả ưu tiên dù có MAE h=1 thấp nhất.
- **OOS (50 origins, rolling window 1.250 ngày):** h=1 GJR-t tốt nhất RMSE/QLIKE, GJR-skewed-t tốt nhất MAE; h=5 EGARCH-t tốt nhất RMSE, EGARCH-skewed-t tốt nhất MAE/QLIKE; h=10 EGARCH-skewed-t tốt nhất MAE, GJR-skewed-t RMSE, GARCH-normal QLIKE; h=20 EGARCH-skewed-t tốt nhất MAE, APARCH-skewed-t RMSE, GARCH-normal QLIKE.

## Hạn chế diễn giải

- QLIKE, RMSE và MAE có thể chọn mô hình khác nhau; không có bằng chứng cho một mô hình thống trị mọi horizon.
- Proxy OOS là tổng squared returns tương lai, không phải realized volatility intraday. Vì vậy không suy diễn kết quả như một kiểm định HAR-RV.
- Chưa cập nhật `chapter.md` hoặc `chapter.docx`.
