# Sách chuyên khảo VaR/biến động Việt Nam — hướng dẫn cho Claude (Cowork và Claude Code)

@AGENTS.md

## Bắt đầu mỗi phiên (Lead = phiên chính, skill `lht-academic-suite:paper-team`)
1. Đọc `PROJECT.md` → `tickets/TASKS.md` (chỉ Active, Waiting On) → 10 dòng cuối `LOG.md` → `CHAPTERS.md`. Phiên làn: đọc thêm `tickets/LANES.md` và chỉ mục của làn mình.
2. Báo trạng thái ≤ 6 dòng; làm ticket được giao; mở `tickets/<mã>.md` để lấy chi tiết.
3. Cowork không tự đọc file này: tin nhắn đầu phải nêu dự án, thứ tự file cần đọc, ticket, nơi ghi, điểm dừng (mẫu ở cuối `PROJECT.md`).

## Đội agent (role card trên agent gốc của plugin lht-academic-suite)
| Card (`team/agents/`) | Agent gốc | Ghi vào |
|---|---|---|
| var-reproduction-analyst | empirical-analyst | `analysis/`, `results/<mã>_<YYYYMMDD-HHMM>/` |
| var-replication-tester | empirical-analyst | `results/<mã>_<YYYYMMDD-HHMM>/` |
| var-source-auditor | literature-scout | `context/` |
| var-chapter-writer | section-writer (BOOK: monograph) | `chapters/drafts/` |
| var-monograph-reviewer | independent-reviewer | `reviews/` |
| var-number-tracer | state-reconciler | `reviews/reconcile_*.md` |
- Giao việc: `subagent_type` = agent gốc; prompt mở đầu "Read your role card `team/agents/<file>` first and follow it; it narrows, never widens, your base rules." + handoff của ticket.
- Tập ghi không trùng nhau. Mỗi ticket chỉ một bên thực hiện (Claude Code **hoặc** Cowork **hoặc** Codex), ghi `Nơi làm` trên ticket.
- **Phiên song song (làn) — `tickets/LANES.md`:** nhiều phiên Claude Code chạy cùng lúc, mỗi phiên một chương (L1–L6) hoặc một cấu phần (L3a/b/c, L5a/b/c); phiên chính là L0 (Lead sách). Mỗi phiên ≤ 2 agent con; ≤ 3 phiên chạy R nặng cùng lúc. Không worktree/git (B06): mọi phiên cùng thư mục `02. Drafts/`, tách bằng tập ghi.
- L0 sửa: `PROJECT.md`, `team/`, `AGENTS.md`, `CLAUDE.md`, `00. Book/`, `_project/`, `tickets/B*.md`, `tickets/LANES.md`, cấu trúc `tickets/TASKS.md`. Làn chương sửa: thư mục chương của mình (gồm `chapter.md`, `code/`, `release/`; trừ `data/raw/`, `chapter.docx`) và tập ghi ở LANES.md mục 3.
- `tickets/TASKS.md`, `LOG.md`, `CHAPTERS.md` dùng chung: mỗi làn chỉ sửa mục/dòng của mình bằng Edit (đọc lại ngay trước khi sửa; không Write cả tệp, không sed); LOG thêm dòng có tiền tố `[Lx]`.

## Bề mặt làm việc
| Việc | Nơi làm |
|---|---|
| Chạy R (tái tạo, mô hình, kiểm định ngược), dựng LaTeX, pandoc, smoke test, `trace_numbers.py` | **Code** (máy Mac) |
| Đọc tài liệu, kiểm trích dẫn, viết/sửa chương, file Word, Drive/Gmail | **Cowork** (hoặc Code) |
| Review độc lập, đọc gói duyệt | Cả hai |
- Trong Cowork, bước cần Code không được thay thế (không giả lập kết quả R): ghi `NOT RUN`, chuyển ticket sang Code.
- Đổi bề mặt chỉ ở cuối một khối việc: ghi LOG.md (file đã chạm + ngày/SHA, việc đã chạy vs đã kiểm, bước kế và nơi làm).

## Runtime
- R 4.5.3 theo `renv.lock` (B04 xong 22/10/2026: 154 gói, gồm rugarch, MCS, forecast, FinTS, tseries). Chạy `Rscript` với `LANG=en_US.UTF-8` và `cd` vào thư mục chứa script (Rscript đổi dấu cách thành `~+~`). Mac mới: `gdtools` cần XQuartz hoặc build từ source (`results/B04_20261022-1420/`). Stata: không dùng.
- pandoc ≥ 3 (VM của Cowork chỉ có 2.9 — dựng docx/LaTeX ở Code hoặc container cloud). xelatex + latexmk có sẵn.
- Crossref API bị chặn trong Cowork/cloud: kiểm DOI bằng WebSearch/WebFetch.
