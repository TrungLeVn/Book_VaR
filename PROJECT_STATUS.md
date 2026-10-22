> **Đã thay thế từ 22/10/2026** bởi `PROJECT.md`, `CHAPTERS.md`, `tickets/TASKS.md`. Giữ làm lịch sử; không cập nhật file này.

# Project Status

Updated: 2026-08-15

## Current state

- Workspace đã chuyển sang Word-first, chapter-first.
- Outline chuẩn đã được đặt tại `00. Book/outline.docx`.
- Chương 1–5 có DOCX và Markdown; Chương 2 là chương đang hoàn thiện/đã có nội dung chính.
- Chương 6 mới là scaffold, chưa có nội dung học thuật.
- Mỗi chương có code/data/references/output riêng; dữ liệu và output đánh số cũ chưa chắc chắn được archive.

## Authoritative chapter mapping

1. Nền tảng về tỷ lệ sinh lời, biến động và rủi ro đuôi.
2. Các phương pháp và mô hình đo lường, dự báo volatility.
3. Thực nghiệm đo lường và dự báo volatility trên thị trường Việt Nam.
4. Các phương pháp đo lường VaR và Expected Shortfall.
5. Thực nghiệm đo lường VaR/ES trên thị trường Việt Nam.
6. Kết luận, hàm ý và xu hướng mới.

## Source-of-truth rules

- Markdown là nguồn chuẩn cho agents.
- DOCX là bản biên soạn được tạo/đồng bộ từ Markdown.
- Không sửa trực tiếp output để thay thế source.
- Mọi di chuyển và bản trùng được ghi trong `_project/migration_manifest.csv`.

## Next action

1. Kiểm tra Markdown Chương 1–2 sau chuyển đổi.
2. Xác nhận mapping dữ liệu legacy trong `99. Archive/2026-08-15_pre-restructure/legacy_numbering_pending_review/`.
3. Tiếp tục biên soạn Chương 3 theo cùng layout.
