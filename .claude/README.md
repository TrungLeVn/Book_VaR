# Cấu hình Claude Code của dự án (`.claude/`)

Chỉ có hiệu lực trong **Claude Code** (CLI, desktop, cloud). Cowork không đọc thư mục này, nên quy tắc bảo vệ nguồn trong Cowork vẫn dựa vào prompt (bản Cowork do `lane-handoff` dựng đã chèn sẵn).

| Thành phần | Tệp | Việc |
|---|---|---|
| Hook PreToolUse | `settings.json` → `hooks/protect_sources.py` | Chặn ghi `data/raw/`, `chapter.docx`, `00. Book/outline*.docx`, `../99. Archive/`, ghi đè bản lưu `archive/`; chặn Write cả tệp / lệnh shell ghi lên `tickets/TASKS.md`, `LOG.md`, `CHAPTERS.md`; hỏi trước khi ghi `_project/data/`, `_project/data_incoming/`, `renv.lock`; chặn `git` ghi khi dự án nằm trong Google Drive (B06) |
| Skill `/lane-handoff` | `skills/lane-handoff/` | Dựng khối "Prompt mở phiên" từ `tickets/TASKS.md` + `tickets/<mã>.md` (script `ready_tickets.py`, chỉ đọc) |

## Cài trên Mac
- Chép cả thư mục `.claude/` vào gốc `02. Drafts/`. Mở phiên Claude Code mới (hoặc `/hooks` để nạp lại).
- Cần `python3` (có sẵn khi đã cài Xcode Command Line Tools: `xcode-select --install`). Thiếu python3 → hook báo lỗi nhưng **không chặn** (không có bảo vệ).
- Tự kiểm: `python3 .claude/hooks/test_protect_sources.py` (kỳ vọng `0/34 lỗi`).

## Giới hạn
- Lệnh Bash được kiểm bằng heuristic: chuyển hướng `>`/`>>`, `rm`/`mv`/`cp`/`tee`/`sed -i`, mã nội tuyến `python -c`/`Rscript -e`/`awk`. Không nhìn vào bên trong script chạy từ tệp (vd. script Ch3 ghi `data/raw/`) và không khai triển biến shell (`"$SB"`). Vẫn chạy script chương trên bản sao (CLAUDE.md, Runtime).
- Cần ghi vào vùng bị chặn có chủ đích (L0, có quyết định của tác giả): tắt tạm hook bằng `/hooks`, hoặc tác giả tự thao tác; ghi LOG.
- Thêm hay bớt vùng bảo vệ: sửa `DENY_RULES`, `ASK_RULES` trong `hooks/protect_sources.py`, thêm ca vào `hooks/test_protect_sources.py`.
