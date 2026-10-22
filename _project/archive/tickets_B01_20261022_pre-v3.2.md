# B01 — Kiến trúc sách: đề cương dạng md, bảng ký hiệu, bảng thuật ngữ

- **Chủ trì:** Lead · **Mốc:** M0 · **Nơi làm:** Either · **Điểm duyệt:** — · **Làn:** L0
- **Phụ thuộc:** B00
- **Trạng thái:** Cần quyết định (từ 22/10/2026) — xem tickets/TASKS.md, Waiting On

## Đầu vào
00. Book/outline_v3.docx (SHA trong _project/input_manifest_20261022.csv); 6 chapter.md — kiểm SHA theo `_project/input_manifest_20261022.csv` trước khi làm.

## Việc cần làm
1. Xuất cấu trúc outline_v3.docx sang md (kèm luận điểm, vai trò từng chương, câu hỏi nối 5.6)
2. Lập bảng thuật ngữ Anh–Việt từ bảng cuối outline_v3 + thuật ngữ trong 6 chương
3. Lập bảng ký hiệu; ghi ký hiệu đang dùng khác nhau giữa các chương
4. Tác giả xác nhận bảng thuật ngữ (chốt “hàm tổn thất”, “thước đo đối chứng”, “mô phỏng ngẫu nhiên”…)

## Đầu ra + tiêu chí nghiệm thu
- Đầu ra: 00. Book/architecture.md; 00. Book/glossary.md; 00. Book/notation.md
- Tiêu chí: Khớp 100% outline_v3.docx (46 mục, 78 tiểu mục); mỗi thuật ngữ tiêu đề có cặp Anh–Việt; ký hiệu thống nhất (r_t, σ_t, VaR_α, ES_α, h, L_t …)

## Dừng và báo Lead nếu
Đầu vào khác phiên bản ghi trong ticket; việc cần ngoài tập ghi của card.

## Giao việc (prompt mẫu)
> Việc của Lead (không giao agent). Ticket `tickets/B01.md`. Gốc dự án `02. Drafts/`. Trả về theo mục Return to the Lead.
