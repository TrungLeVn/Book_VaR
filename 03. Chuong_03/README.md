# Chương 3

Vai trò: thực nghiệm đo lường và dự báo volatility trên thị trường Việt Nam.

Khung nội dung theo outline chuẩn: bối cảnh và literature; câu hỏi/giả thuyết; dữ liệu; mô hình thực nghiệm; thiết kế forecast; kết quả in-sample và out-of-sample; phân tích theo regime; robustness; kết luận thực nghiệm volatility.

Nguồn chuẩn là `chapter.md`; DOCX là `chapter.docx`. Mã lệnh, dữ liệu, tài liệu và output được giữ trong các thư mục tương ứng của chương.

## Pipeline thực nghiệm

- Chạy từ thư mục này: `Rscript code/R/run_chapter03_volatility.R`.
- Thử cập nhật dữ liệu: thêm cờ `--refresh`. Khi endpoint không phản hồi, script tự dùng bản archive đã kiểm tra và ghi rõ `archive fallback` trong `data/derived/data_manifest.csv` và `output/RUN_REPORT.md`.
- Pipeline sinh dữ liệu sạch, Bảng 3–18 (CSV), 12 biểu đồ thực nghiệm, lựa chọn ARMA cho phương trình trung bình, tám đặc tả GARCH-type và forecast paths. Kết quả chỉ được đưa vào `chapter.md` sau khi rà soát riêng.
