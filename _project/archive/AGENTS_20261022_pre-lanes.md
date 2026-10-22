# Quy tắc làm việc chung — sách chuyên khảo biến động, VaR/ES Việt Nam

Áp dụng cho mọi bề mặt (Claude Cowork, Claude Code, Codex, ChatGPT Work). Claude đọc thêm `CLAUDE.md`. Bản trước 22/10/2026: `_project/archive/AGENTS_20261022_pre-team.md`.

## Bắt đầu
1. Đọc `PROJECT.md`, rồi chỉ mục Active và Waiting On trong `tickets/TASKS.md`; mở `tickets/<mã>.md` của việc được giao.
2. Chỉ mở phần chương/code/kết quả liên quan. Không đọc lại toàn bộ `../99. Archive/` mỗi phiên.
3. Xong một việc: lưu đầu ra; Lead chuyển mục sang Done với dòng `Bằng chứng:`; ghi một dòng vào `LOG.md` (đã kiểm tra, còn thiếu, bước sau). Chỉ đánh dấu Xong khi bằng chứng tồn tại và đạt tiêu chí.

## Hình dạng dự án
- Sách chuyên khảo tiếng Việt, 6 chương + Mở đầu + Phụ lục A–D. **Kiến trúc chuẩn: `00. Book/outline_v3.docx` (đề cương 3.1, từ 22/10/2026)**; `outline.docx` chỉ là lịch sử. Không suy vai trò chương từ tên file cũ.
- Mỗi chương tự chứa: `chapter.md` (nguồn chuẩn), `chapter.docx` (bản gốc, không ghi đè), `code/`, `data/`, `references/`, `output/`, `release/` (docx + LaTeX dựng từ `chapter.md`).
- Điều phối: `team/` (đội agent), `tickets/` (bảng việc + chi tiết), `PROJECT.md`, `CHAPTERS.md`, `LOG.md`. Kiểm soát tài sản: `_project/` (asset_register, manifest, apa.csl).
- Thư mục làm việc của agent: `analysis/`, `results/<mã>_<YYYYMMDD-HHMM>/`, `context/`, `chapters/drafts/`, `reviews/`, `design/`.

## Vai trò
- **Lead:** giữ mạch luận điểm–phương pháp–dữ liệu–kết quả–kết luận; ưu tiên việc; tích hợp vào `chapter.md`; quản lý `PROJECT.md`, `CHAPTERS.md`, `LOG.md`, `tickets/`, `team/`.
- **Empirical:** audit dữ liệu/code, tái tạo kết quả hiện có trước, chạy bổ sung theo thiết kế đã duyệt, lưu code/log/kết quả; không sửa chương.
- **Context:** tài liệu, trích dẫn, dữ kiện thể chế; ghi vào `context/`; không sửa chương.
- Một người ghi mỗi file tại một thời điểm; mỗi ticket chỉ một bề mặt thực hiện (ghi `Nơi làm`). Bàn giao nêu rõ phiên bản đầu vào (ngày/SHA); đầu vào đổi thì đối chiếu lại trước khi tích hợp.

## Bảo vệ nguồn và bằng chứng
- Chỉ đọc: `0X. Chuong_0X/data/raw/`, `chapter.docx` gốc, `00. Book/outline*.docx`, `../99. Archive/`. Trước khi sửa đáng kể `chapter.md`, lưu bản trước vào `0X. Chuong_0X/archive/` và ghi manifest.
- Không bịa dữ liệu, hệ số, công thức, tài liệu, quy định hay trạng thái chạy. Thiếu nguồn ghi `[Missing Citation]`; số chưa có run ghi `[RESULT PENDING: <mã>]`.
- Tách **được báo cáo trong bài**, **đã chạy**, **đã đối chiếu**. Chạy không lỗi ≠ tái lập đúng ≠ nhân quả.
- Tái tạo giữ đặc tả hiện có; mọi thay đổi đặc tả/mẫu/cửa sổ/số điểm dự báo có ticket và thiết kế được duyệt; không ghi đè baseline. Không chọn mô hình theo ý nghĩa thống kê; giữ kết quả bất lợi.
- Mỗi lần chạy lưu `results/<mã>_<YYYYMMDD-HHMM>/README.md`: đã chạy gì, đầu vào (SHA), mẫu, đặc tả, log, đối chiếu, giới hạn.
- Không chạy mô hình chỉ vì đang sắp xếp file. Nếu đổi gói R, kiểm `renv`.
- Trước khi dựng docx/LaTeX: kiểm mạch chương, tham chiếu bảng/hình, trích dẫn ↔ bib. Giữ key trích dẫn ổn định.

## Văn phong và thuật ngữ
- Tiếng Việt học thuật, mạch lạc, dễ tiếp cận; mã R không đặt trong thân sách.
- Tiêu đề không đan xen tiếng Anh; thuật ngữ: tỷ suất sinh lời, tỷ suất sinh lời logarit, giá trị chịu rủi ro (VaR), tổn thất kỳ vọng có điều kiện (ES), rủi ro đuôi, tổn thất; bảng chuẩn ở `00. Book/glossary.md` (B01).

## tickets/TASKS.md (checkbox, dùng chung với skill task-management của plugin productivity)
- Bốn mục cố định: `## Active`, `## Waiting On`, `## Someday`, `## Done`. Mỗi việc: `- [ ] **Mã — Tên việc** - người phụ trách, mốc` + sub-bullet (Đầu ra + tiêu chí, Phụ thuộc, Nơi làm, Chi tiết). Chi tiết đầy đủ ở `tickets/<mã>.md`.
- Trạng thái: Chưa làm = Active không có dòng Trạng thái; Đang làm = Active + `Trạng thái: Đang làm (từ <ngày>)`; Cần quyết định = Waiting On + `since <ngày>` + điều cần quyết; Hoãn = Someday + lý do; Xong = Done `- [x] ~~…~~ (ngày)` + `Bằng chứng:` bắt buộc.
- Ghi đè hành vi mặc định của productivity: **không** xoá mục Done; **không** tạo TASKS.md mới; nhật ký ở `LOG.md`; `dashboard.html` chỉ ở gốc `02. Drafts/`.

## Git
- Repo `TrungLeVn/Book_VaR` trong Google Drive đang hỏng (ticket B06). Không commit, pull, checkout từ thư mục Drive cho đến khi B06 xong.

## Giao tiếp
Trao đổi ngắn bằng tiếng Việt. Báo: việc đã làm | đã kiểm tra | còn thiếu | bước kế tiếp.
