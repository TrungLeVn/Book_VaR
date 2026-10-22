# Sách chuyên khảo VaR/biến động Việt Nam — Drafts

Thư mục làm việc của sách chuyên khảo về đo lường và dự báo biến động, giá trị chịu rủi ro (VaR) và tổn thất kỳ vọng có điều kiện (ES) trên thị trường chứng khoán Việt Nam. Bắt đầu ở [`PROJECT.md`](PROJECT.md).

## Kiến trúc sách
Đề cương chuẩn: [`00. Book/outline_v3.2.docx`](<00. Book/outline_v3.2.docx>) (đề cương 3.2; bản md [`00. Book/architecture.md`](<00. Book/architecture.md>)). `outline.docx`, `outline_v2.docx`, `outline_v3.docx` chỉ là lịch sử. Thuật ngữ: `00. Book/glossary.md`; ký hiệu: `00. Book/notation.md`.

| Chương | Tên |
|---|---|
| 1 | Cơ sở lý luận về tỷ suất sinh lời, biến động và rủi ro đuôi |
| 2 | Mô hình đo lường và dự báo biến động |
| 3 | Thực nghiệm đo lường và dự báo biến động trên thị trường Việt Nam |
| 4 | Các phương pháp đo lường giá trị chịu rủi ro và tổn thất kỳ vọng có điều kiện |
| 5 | Thực nghiệm đo lường và dự báo rủi ro đuôi trên thị trường Việt Nam |
| 6 | Tổng hợp, hàm ý và hướng phát triển |

Kèm Mở đầu và Phụ lục A–D.

## Bố cục thư mục
- `0X. Chuong_0X/` — mỗi chương tự chứa: `chapter.md` (nguồn chuẩn), `chapter.docx` (bản gốc, chỉ đọc), `code/`, `data/` (`data/raw/` chỉ đọc), `references/`, `output/`, `release/` (docx + LaTeX dựng từ `chapter.md`).
- `_project/` — dữ liệu chuẩn (`_project/data/`), manifest, `apa.csl`, archive.
- `team/`, `tickets/` — đội agent, bảng việc, làn song song.
- `analysis/`, `results/`, `context/`, `chapters/drafts/`, `reviews/`, `design/` — thư mục làm việc của agent.
- Trạng thái và nhật ký: `PROJECT.md`, `CHAPTERS.md`, `tickets/TASKS.md`, `LOG.md`.
- Quy tắc làm việc: `AGENTS.md` (mọi bề mặt), `CLAUDE.md` (Claude).

Bản cũ và tài liệu chưa xác định chương nằm ở `../99. Archive/`, không đặt trong thư mục này.
