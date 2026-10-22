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
| Phiên song song (làn), tập ghi | `tickets/LANES.md` |
| Đề cương chuẩn | `00. Book/outline_v3.2.docx` (bản 3.2; bản md: `00. Book/architecture.md`; thuật ngữ `glossary.md`, ký hiệu `notation.md`) |
| Chương | `0X. Chuong_0X/chapter.md` (nguồn chuẩn) |
| Quy tắc chung (Claude + Codex) | `AGENTS.md`; Claude: `CLAUDE.md` |
| Quy trình biên tập | `../01. Documents/02. Ban_giao/Handbook Quy Trình Biên Tập.pdf` |

## Luận điểm và phạm vi
- **Luận điểm trung tâm (tác giả, 22/10/2026):** Cung cấp bằng chứng thực nghiệm về các phương pháp đo lường biến động tỷ suất sinh lời và rủi ro đuôi của tỷ suất sinh lời ở thị trường mới nổi với mẫu là Việt Nam. Ở thị trường mới nổi có biên độ giá, thanh khoản không đều và nhà đầu tư cá nhân chiếm đa số như Việt Nam, điều này đặc biệt quan trọng bởi rủi ro mô hình có thể dẫn tới các quyết định đầu tư, phòng ngừa rủi ro kém hiệu quả.
- **Câu hỏi nối hai phần thực nghiệm:** mô hình dự báo biến động tốt (Chương 3) có cho dự báo rủi ro đuôi tốt (Chương 5) không — mục 5.6.
- **Kiến trúc:** 6 chương + Mở đầu + Phụ lục A–D; 46 mục, 78 tiểu mục (đề cương 3.2, SHA `93fcabb82666c7b0…`). Từ 22/10/2026, mọi chỗ trong ticket/TASKS.md ghi "đề cương 3.1" hoặc `outline_v3.docx` được hiểu là đề cương 3.2 (`outline_v3.2.docx`); tiêu đề khác nhau chỉ ở 3.7, 3.7.1–3.7.2, 5.8, 5.8.1–5.8.2, Phụ lục D.
- **Độc giả / văn phong:** học thuật, mạch lạc, dễ tiếp cận với độc giả chưa có nhiều kiến thức nền; mã R không đặt trong thân sách (phụ lục kỹ thuật / gói kèm).

## Dữ liệu (đã thống nhất 22/10/2026)
| Chuỗi | Vai trò | Trạng thái |
|---|---|---|
| VN-Index | Chuỗi chính, mọi chương (kể cả Ch1); phân tích đầy đủ Ch3 và Ch5 | Nguồn Investing.com (tác giả xác nhận 22/10/2026); tệp chuẩn `_project/data/vnindex_daily_20100104_20260520.csv` (4.081 phiên, SHA 7c756369…); giới hạn V9: bỏ phiên giả 23/01/2018, thiếu 24/01/2018 (tác giả chọn) |
| HNX-Index | Chuỗi đối chứng **duy nhất**, toàn bộ tập mô hình; báo cáo gọn ở 3.7 và 5.8, chi tiết Phụ lục D | Investing.com; tệp chuẩn `_project/data/hnxindex_daily_20100104_20260520.csv` (4.083 phiên, SHA 79c130be…); hợp đồng dữ liệu v2 (`results/B02_20261022-1616_HNX/`) + v2.1 (`_project/data/README.md`) |
| Chỉ số ngành HOSE | **Bỏ** (tác giả quyết định 22/10/2026; B07 hủy) | — |
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
- 22/10/2026 — Chỉ dùng HNX-Index làm chuỗi đối chứng; **bỏ chỉ số ngành HOSE** (B07 hủy; 3.7.2, 5.8.2 "Khác biệt giữa các ngành" cần đổi trong đề cương 3.2) — căn cứ: yêu cầu tác giả trong phiên Claude Code.
- 22/10/2026 — **Thực nghiệm chạy trước** ở các chương mô hình hóa (Ch2–Ch5): thiết kế (D1) → chạy (M3) → kiểm kết quả (E) rồi mới ánh xạ (M1), kiểm nguồn (M4), viết (M2). **Phiên Claude Code song song** theo chương hoặc cấu phần chương, cùng ghi vào thư mục sách — quy tắc ở `tickets/LANES.md`; `team/TEAM.md` v2 — căn cứ: yêu cầu tác giả, cùng phiên.

- 22/10/2026 16:15 — **Đề cương 3.2** (`00. Book/outline_v3.2.docx`) thay 3.1: 3.7/5.8 "Tính khái quát trên HNX-Index", 3.7.2/5.8.2 "So sánh với VN-Index", Phụ lục D "Bảng kết quả bổ sung với HNX-Index"; **thuật ngữ, ký hiệu** (`00. Book/glossary.md`, `notation.md`) chốt — α là xác suất đuôi, r_t theo %, η cho tham số độ lệch, dấu phẩy thập phân — căn cứ: tác giả đồng ý trong chat Cowork.
- 22/10/2026 16:15 — Dữ liệu: nguồn **Investing.com**; **mọi chương (kể cả Ch1) dùng tệp chuẩn** 04/01/2010 → 20/05/2026; bỏ chỉ số ngành, chỉ HNX-Index — căn cứ: tác giả, chat Cowork.
- 22/10/2026 16:15 — Dữ kiện thể chế: không cần số văn bản cho các mốc; chỗ chưa xác minh ghi **`[cần xác nhận]`** khi viết để tác giả tự bổ sung — căn cứ: tác giả, chat Cowork.

## Giả định đang áp dụng (tác giả có thể đổi)
- A1 — `chapter.md` là nguồn chuẩn; docx và LaTeX dựng bằng pandoc ≥ 3 + xelatex/biblatex; trích dẫn APA tĩnh (`_project/apa.csl`), không phải field Zotero động.
- A2 — Ngày cuối mẫu 20/05/2026 cho mọi chuỗi; mẫu chính bắt đầu 2010 (khớp Ch3).
- A3 — Chạy R chính thức trên máy Mac bằng Claude Code. Máy có R 4.5.3 (kiểm 22/10/2026, B04); `renv.lock` ghi 4.5.3 từ 22/10/2026 (tác giả duyệt; `results/B04_20261022-1448_verify/`).
- A4 — Không commit git từ thư mục Google Drive cho đến khi xong B06.

## Lựa chọn khoa học còn mở
- Thiết kế dự báo ngoài mẫu Ch3: hiện chỉ 50 điểm dự báo (cửa sổ 1.250, tái ước lượng mỗi 20 ngày) — chốt ở C03-D1.
- Quy tắc chia giai đoạn thị trường (dùng chung Ch3, Ch5) — C03-D1.
- Dùng đoạn 2007–2009 (khủng hoảng 2008) làm kiểm định độ bền Ch5 hay không — C05-D1 (dữ liệu đầu 2007 có dấu hiệu OHLC kém).

## Cần thận trọng
- Ước lượng biên độ giá dùng giá mở cửa: giá mở cửa = giá đóng cửa hôm trước ở phần lớn phiên (VN-Index từ 2021; HNX-Index 44% toàn mẫu) — xử lý ở C03-D1.
- Kết quả Ch3 hiện tại chạy trên dữ liệu "archive fallback" (16/08/2026): **executed**, chưa **checked**.
- Số liệu Ch5 (`ch07_*`) là kết quả cũ không có code: **reported**, chưa **executed**.
- Ch4 dùng dữ liệu mô phỏng nhưng không có script và seed.
- Khác biệt HOSE–HNX không quy thành tác động nhân quả của biên độ giá (lẫn quy mô, thanh khoản).
- Git: repo trong Drive thiếu object và lệch HEAD (xem B06); các dòng `D code/rscripts/…` trong `git status` là di sản đó — không khôi phục, không commit.
- Code R hiện có (22/10/2026, B04 exit 0): Ch1 `code/R/run_ch01_all.R`, Ch2 `code/R/ch02_all_tables_figures_appendix.R`, Ch3 `code/R/run_chapter03_volatility.R` (~200 s); Ch4–Ch6 chưa có code. Chạy cả bộ trên bản sao: `bash results/B04_20261022-1448_verify/run_scripts_sandbox.sh <sandbox_dir>` từ gốc `02. Drafts/`. Script ghi thẳng vào `output/` của chương (Ch3 ghi cả `data/`).
- Ch3 vẫn đọc `../99. Archive/2026-08-15_pre-restructure/legacy_numbering_pending_review/vnindex_daily.csv`, chưa đọc tệp chuẩn `_project/data/`; Ch1 tải `^GSPC` từ Yahoo mỗi lần chạy (C01-M3 cố định).
- `PROJECT_STATUS.md` là lịch sử (thay từ 22/10/2026), không dùng làm căn cứ.

## Mở phiên làn Claude Code (chương / cấu phần)
Dùng mẫu ở `tickets/LANES.md` mục 7.

## Mở phiên Cowork (Claude app) — dán vào tin nhắn đầu
> Dự án sách VaR, gốc `02. Drafts/`. Đọc lần lượt: PROJECT.md → tickets/TASKS.md (Active, Waiting On) → 10 dòng cuối LOG.md → CHAPTERS.md → team/TEAM.md. Làm ticket <mã>; ràng buộc theo ticket; ghi vào <đường dẫn>; dừng ở <điểm dừng>.
