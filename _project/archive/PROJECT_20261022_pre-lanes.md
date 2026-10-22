# Sách chuyên khảo — Đo lường và dự báo biến động, giá trị chịu rủi ro và tổn thất kỳ vọng có điều kiện trên thị trường chứng khoán Việt Nam — bắt đầu ở đây

**Trạng thái:** thiết lập 22/10/2026; chỉ điền từ nguồn, phần chưa kiểm ghi CHƯA XÁC NHẬN.
**Loại dự án:** sách chuyên khảo (monograph), tiếng Việt. **Chế độ:** LHT book mode. **Gốc dự án:** thư mục `02. Drafts/`.

## Mở gì?
| Cần làm | Mở |
|---|---|
| Việc tiếp theo | `tickets/TASKS.md` (Active, Waiting On) → chi tiết `tickets/<mã>.md` |
| Trạng thái chương | `CHAPTERS.md` |
| Nhật ký | `LOG.md` |
| Đội agent, quy trình, điểm duyệt | `team/TEAM.md`, `team/agents/` |
| Đề cương chuẩn | `00. Book/outline_v3.docx` (bản 3.1) |
| Chương | `0X. Chuong_0X/chapter.md` (nguồn chuẩn) |
| Quy tắc chung (Claude + Codex) | `AGENTS.md`; Claude: `CLAUDE.md` |
| Quy trình biên tập | `../01. Documents/02. Ban_giao/Handbook Quy Trình Biên Tập.pdf` |

## Luận điểm và phạm vi
- **Luận điểm trung tâm (tác giả, 22/10/2026):** Cung cấp bằng chứng thực nghiệm về các phương pháp đo lường biến động tỷ suất sinh lời và rủi ro đuôi của tỷ suất sinh lời ở thị trường mới nổi với mẫu là Việt Nam. Ở thị trường mới nổi có biên độ giá, thanh khoản không đều và nhà đầu tư cá nhân chiếm đa số như Việt Nam, điều này đặc biệt quan trọng bởi rủi ro mô hình có thể dẫn tới các quyết định đầu tư, phòng ngừa rủi ro kém hiệu quả.
- **Câu hỏi nối hai phần thực nghiệm:** mô hình dự báo biến động tốt (Chương 3) có cho dự báo rủi ro đuôi tốt (Chương 5) không — mục 5.6.
- **Kiến trúc:** 6 chương + Mở đầu + Phụ lục A–D; 46 mục, 78 tiểu mục (đề cương 3.1, SHA `7fcb6458b8eb1c79…`).
- **Độc giả / văn phong:** học thuật, mạch lạc, dễ tiếp cận với độc giả chưa có nhiều kiến thức nền; mã R không đặt trong thân sách (phụ lục kỹ thuật / gói kèm).

## Dữ liệu (đã thống nhất 22/10/2026)
| Chuỗi | Vai trò | Trạng thái |
|---|---|---|
| VN-Index | Chuỗi chính, phân tích đầy đủ Ch3 và Ch5 | Có; bản chuẩn `vni_data.xlsx` (tác giả xác nhận trước đây) — B02 kiểm lại |
| HNX-Index | Chuỗi đối chứng, toàn bộ tập mô hình, báo cáo gọn ở 3.7 và 5.8 | **Tác giả cung cấp** (B05) |
| Chỉ số ngành HOSE | Dùng chọn lọc theo quy tắc định trước (B07); một bảng trong thân bài, chi tiết Phụ lục D | **Tác giả cung cấp** (B05) |
| VN30 | **Bỏ** (tác giả quyết định 22/10/2026) | — |
| Cổ phiếu riêng lẻ | **Không dùng**; nêu ở 6.5 | — |
Yêu cầu chung: cùng nguồn, cùng ngày cuối mẫu (mặc định 20/05/2026), có OHLC, có khối lượng nếu được, SHA-256 trong data manifest; tỷ suất sinh lời logarit cho các chương thực nghiệm (Ch1 so sánh giản đơn và logarit).

## Sản phẩm bàn giao mỗi chương
```
0X. Chuong_0X/
  chapter.md                    nguồn chuẩn
  release/chXX_vYYYYMMDD.docx   dựng từ chapter.md; không ghi đè chapter.docx gốc
  release/latex/                chXX.tex, preamble, figures/, tables/, references.bib, latexmkrc (dùng được trên Overleaf)
  code/R/run_chXX_all.R         một lệnh tái tạo mọi bảng, hình
  data/raw, data/derived, data/DATA_MANIFEST.csv (SHA-256)
  references/bibliography.bib   key ổn định
  REPRODUCE.md
```
PDF sách tham khảo có bản quyền (`02. Chuong_02/references/books/`) không đưa vào gói.

## Quyết định đã chốt
- 22/10/2026 — Đề cương 3.1 (`00. Book/outline_v3.docx`) thay thế `outline.docx` làm kiến trúc chuẩn — căn cứ: tác giả sửa v2 và đồng ý 4 điểm của v3.
- 22/10/2026 — Thuật ngữ tiêu đề: tỷ suất sinh lời; giá trị chịu rủi ro (VaR); tổn thất kỳ vọng có điều kiện (ES); rủi ro đuôi; tiêu đề không đan xen tiếng Anh — căn cứ: góp ý của tác giả trên v2 và xác nhận v3.
- 22/10/2026 — Phương án dữ liệu như bảng trên; bỏ VN30; không dùng cổ phiếu — căn cứ: tin nhắn tác giả 13:50.
- 22/10/2026 — Đội agent và quy trình trong `team/TEAM.md` (Scope approved) — căn cứ: tin nhắn tác giả 13:50; SHA ở LOG.md.

## Giả định đang áp dụng (tác giả có thể đổi)
- A1 — `chapter.md` là nguồn chuẩn; docx và LaTeX dựng bằng pandoc ≥ 3 + xelatex/biblatex; trích dẫn APA tĩnh (`_project/apa.csl`), không phải field Zotero động.
- A2 — Ngày cuối mẫu 20/05/2026 cho mọi chuỗi; mẫu chính bắt đầu 2010 (khớp Ch3).
- A3 — Chạy R chính thức trên máy Mac bằng Claude Code. Máy có R 4.5.3 (kiểm 22/10/2026, B04); `renv.lock` hiện ghi 4.5.0 — bản đề xuất 4.5.3 chờ duyệt (`results/B04_20261022-1420/`).
- A4 — Không commit git từ thư mục Google Drive cho đến khi xong B06.

## Lựa chọn khoa học còn mở
- Thiết kế dự báo ngoài mẫu Ch3: hiện chỉ 50 điểm dự báo (cửa sổ 1.250, tái ước lượng mỗi 20 ngày) — chốt ở C03-D1.
- Quy tắc chia giai đoạn thị trường (dùng chung Ch3, Ch5) — C03-D1.
- Quy tắc chọn chỉ số ngành — B07.
- Dùng đoạn 2007–2009 (khủng hoảng 2008) làm kiểm định độ bền Ch5 hay không — C05-D1 (dữ liệu đầu 2007 có dấu hiệu OHLC kém).

## Cần thận trọng
- Kết quả Ch3 hiện tại chạy trên dữ liệu "archive fallback" (16/08/2026): **executed**, chưa **checked**.
- Số liệu Ch5 (`ch07_*`) là kết quả cũ không có code: **reported**, chưa **executed**.
- Ch4 dùng dữ liệu mô phỏng nhưng không có script và seed.
- Khác biệt HOSE–HNX không quy thành tác động nhân quả của biên độ giá (lẫn quy mô, thanh khoản).
- Git: repo trong Drive thiếu object và lệch HEAD (xem B06).

## Mở phiên Cowork (Claude app) — dán vào tin nhắn đầu
> Dự án sách VaR, gốc `02. Drafts/`. Đọc lần lượt: PROJECT.md → tickets/TASKS.md (Active, Waiting On) → 10 dòng cuối LOG.md → CHAPTERS.md → team/TEAM.md. Làm ticket <mã>; ràng buộc theo ticket; ghi vào <đường dẫn>; dừng ở <điểm dừng>.
