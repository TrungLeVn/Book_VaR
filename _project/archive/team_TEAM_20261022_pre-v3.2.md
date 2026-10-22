# Team — Sách chuyên khảo biến động, VaR/ES Việt Nam — version 2 (2026-10-22)

**Approval (Scope):** v1 approved 22/10/2026; **v2** (chỉ HNX-Index, thực nghiệm trước, làn song song) theo yêu cầu tác giả trong phiên Claude Code 22/10/2026 — SHA ở `LOG.md`. v1: (tin nhắn tác giả 13:50: "cập nhật gói duyệt phạm vi … rồi tạo đội agent") — SHA-256 của file này ghi ở `LOG.md` dòng B00.
**Mode:** LHT book (monograph) · **Orchestrator:** `lht-academic-suite:paper-team` (Lead = phiên chính) · **Gốc dự án:** `02. Drafts/` · **Tickets:** `tickets/`

## Project profile
- Type: monograph (sách chuyên khảo), tiếng Việt.
- Mốc hiện tại: M0 gần xong (đề cương 3.1 đã thống nhất; còn B01). Mọi chương: bản nháp cũ chưa khớp đề cương 3.1.
- Luận điểm: xem `PROJECT.md` → Luận điểm và phạm vi.
- Mục tiêu đợt này (tác giả): hoàn thiện bản thảo trên nền hiện tại; mỗi chương có file docx, gói LaTeX, script tái tạo, dữ liệu tái tạo và file bib.

## Inputs
| Role | Path (từ `02. Drafts/`) | Version (mtime / SHA-256) | Status |
|---|---|---|---|
| Đề cương chuẩn (3.1) | `00. Book/outline_v3.docx` | 2026-10-22 / `7fcb6458b8eb1c79…` | verified |
| Đề cương cũ (lịch sử) | `00. Book/outline.docx` | 2026-08-14 / `ccb7c9b23c87d8a1…` | supplied |
| Chương 1 – nguồn | `01. Chuong_01/chapter.md` | 2026-08-15 / `f5355c8213fb616d…` | verified |
| Chương 2 – nguồn | `02. Chuong_02/chapter.md` | 2026-08-15 / `ac8d466402d4ccac…` | verified |
| Chương 3 – nguồn | `03. Chuong_03/chapter.md` | 2026-08-16 / `2c6e42298c5164a4…` | verified |
| Chương 4 – nguồn | `04. Chuong_04/chapter.md` | 2026-08-14 / `0b68c142217c9036…` | verified |
| Chương 5 – nguồn | `05. Chuong_05/chapter.md` | 2026-08-14 / `53236b2607562d22…` | verified |
| Chương 6 – khung | `06. Chuong_06/chapter.md` | 2026-08-14 / `d521f696a7d95634…` | verified |
| VN-Index – bản chuẩn (2010-01-04 → 2026-05-20, OHLC) | `04. Chuong_04/data/raw/vni_data.xlsx` | 2026-06-12 / `79f69303fa73be87…` | supplied |
| VN-Index – Ch1 (2007 → 2026-03, có khối lượng) | `01. Chuong_01/data/raw/vnindex.csv` | 2026-06-20 / `289e0a51aa5714eb…` | supplied |
| VN-Index – Ch3 (archive fallback, đến 2026-05-20) | `03. Chuong_03/data/raw/vnindex_daily.csv` | 2026-08-16 / `b23d33a7c506a007…` | supplied |
| Ch5 – kết quả cũ (không có code) | `05. Chuong_05/data/derived/ch07_backtesting_summary.csv` | 2026-06-12 / `175057a155ca5b05…` | supplied |
| Bib Ch1 | `01. Chuong_01/references/bibliography.bib` | 2026-06-12 / `7d4168dc7cbec2f6…` | supplied |
| Bib Ch2 | `02. Chuong_02/references/bibliography.bib` | 2026-06-12 / `5029cace118a244a…` | supplied |
| Bib Ch3 | `03. Chuong_03/references/bibliography.bib` | 2026-08-16 / `e85bed98ab6a33a0…` | supplied |
| Pipeline Ch3 | `03. Chuong_03/code/R/run_chapter03_volatility.R` | 2026-08-16 / `bd58c52349625e1a…` | supplied |
| Script Ch2 | `02. Chuong_02/code/R/ch02_all_tables_figures_appendix.R` | 2026-08-14 / `c30766ef52025d2e…` | supplied |
| Môi trường R | `renv.lock` | 2026-05-22 / `5539d874652d693a…` | supplied |
| Kiểu trích dẫn | `_project/apa.csl` | 2026-05-22 / `258a4e3a4ba8ea18…` | supplied |
| HNX-Index | `_project/data_incoming/Dữ liệu Lịch sử HNX.csv` | 2026-10-22 / `de05a6118e12a8a7…` | supplied (B02 phần 2 audit) |
SHA đầy đủ: `_project/input_manifest_20261022.csv`.

## Constraints and assumptions
- Mô hình mới: **có**, trong phạm vi đề cương 3.1 và thiết kế đã duyệt (C03-D1, C05-D1); luôn tái tạo kết quả hiện có trước.
- Phạm vi sửa: 6 chương, Mở đầu, Phụ lục A–D.
- Ngôn ngữ: tiếng Việt; tiêu đề không đan xen tiếng Anh; thuật ngữ theo bảng cuối `00. Book/outline_v3.docx` (B01 chuyển thành bảng thuật ngữ chuẩn).
- Loại trừ: chỉ số ngành HOSE (từ v2); VN30; cổ phiếu riêng lẻ; Stata; PDF sách có bản quyền không vào gói.
- Deadline: CHƯA XÁC NHẬN.
- Giả định A1–A4: xem `PROJECT.md`.

### Ánh xạ đường dẫn (tập ghi của agent gốc → bố cục dự án)
| Agent gốc ghi | Ở dự án này | Lead chuyển bản đã duyệt sang |
|---|---|---|
| `analysis/` | `analysis/ch0X/` | `0X. Chuong_0X/code/R/` |
| `results/<ID>_<ts>/` | `results/<ID>_<ts>/` | `0X. Chuong_0X/output/`, `data/derived/` |
| `context/` | `context/` | `0X. Chuong_0X/references/bibliography.bib` |
| `chapters/drafts/` | `chapters/drafts/` | `0X. Chuong_0X/chapter.md` (bản cũ → `0X. Chuong_0X/archive/`) |
| `reviews/` | `reviews/` | — |
Chỉ đọc với mọi agent: `0X. Chuong_0X/data/raw/`, `chapter.docx` gốc, `../99. Archive/`, `00. Book/outline*.docx`.

## Team
| Agent card | Base agent | Mode | Owns steps | Write set | Why in this team |
|---|---|---|---|---|---|
| `var-reproduction-analyst` | empirical-analyst | audit / reproduce / modified-run | B02, B04 (phần R), C0X-M3, cấu phần C03-M3a/b/c, C05-M3a/b/c | `analysis/`, `results/` | Chương 3–5 cần chạy lại và bổ sung; Ch1, Ch2, Ch4 cần script có seed |
| `var-replication-tester` | empirical-analyst | smoke test (replication-package) | C0X-M6 (chạy lại gói) | `results/` | Gói chương phải tái tạo được từ bản sạch, tách khỏi người viết code |
| `var-source-auditor` | literature-scout | citation-check, context-facts, literature-matrix | B11, C0X-M4 | `context/` | Trích dẫn dạng chữ chưa có key; Ch4, Ch5 không có bib; dữ kiện thể chế Việt Nam cần kiểm |
| `var-chapter-writer` | section-writer (BOOK: monograph) | chapter draft | C0X-M2, B09 | `chapters/drafts/` | Viết bù các mục theo đề cương 3.1, viết Ch6, Mở đầu |
| `var-monograph-reviewer` | independent-reviewer | monograph review; results-audit | C0X-M5, C03-E, C05-E | `reviews/` | Review độc lập: luận điểm, công thức, diễn giải vượt bằng chứng |
| `var-number-tracer` | state-reconciler | trace_numbers + 7-pass | C0X-E, C0X-M6 (số liệu), B08 | `reviews/reconcile_*` | Mọi con số trong chương phải truy được về output |

**Lead sách (L0) giữ:** B00, B01, B03 (quy ước + khuôn sản xuất), B06, B10; cấu trúc bảng việc, quy tắc làn. **Lead chương (làn L1–L6, `tickets/LANES.md`) giữ:** C0X-M1 (ánh xạ dàn ý); C0X-D1 (gói duyệt thiết kế); tích hợp bản nháp vào `chapter.md`; chuyển code/dữ liệu/bib vào thư mục chương; dựng docx và LaTeX (C0X-M6); file trạng thái; gói duyệt.
**Không kích hoạt:** vai trò riêng cho VN30 hay cổ phiếu (bị loại); theory-mapper/closest-papers-scout (đã gộp vào source-auditor).

## Workflow
| Bước (ticket) | Mốc | Owner | Nơi làm | Phụ thuộc | Nhóm song song | Điểm duyệt | Sửa tối đa |
|---|---|---|---|---|---|---|---|
| B00 Thiết lập đội và trạng thái | — | Lead | Cowork | — | — | **Scope** | — |
| B01 Kiến trúc sách: bản md, ký hiệu, thuật ngữ | M0 | Lead | Either | B00 | P0 | — | 2 |
| B02 Hợp đồng dữ liệu VN-Index + HNX-Index | — | analyst | Either | B00 (phần HNX: tệp B05 đã nhận) | P0 | — | 2 |
| B03 Quy ước toàn sách + khuôn docx/LaTeX, thử trên Ch1 | M0/M6 | Lead | Code | B01 | — | **Design** | 2 |
| B04 Môi trường R (renv đầy đủ) | — | Lead/analyst | Code | — | P0 | — | — |
| B05 Tác giả cung cấp HNX-Index (đã nhận; chờ xác nhận nguồn) | — | tác giả | — | — | — | — | — |
| B06 Git: xử lý repo hỏng | — | tác giả + Lead | Code | — | — | quyết định | — |
| B11 Dữ kiện thị trường Việt Nam (biên độ, KRX, quy định rủi ro thị trường) | — | source-auditor | Cowork | B00 | P0 | — | 2 |
| C03-D1, C05-D1 Thiết kế thực nghiệm (một gói duyệt chung) | — | Lead chương (+ analyst, reviewer) | Either | B02 (C05-D1: + C03-D1) | L3 ∥ L5 | **Design** | 2 |
| C02-M3, C04-M3 Định lượng (mô phỏng, minh họa) — chạy trước | M3 | analyst | Code | B02, B04 | L2 ∥ L4 | — | 2 |
| C03-M3a/b/c, C05-M3a/b/c Định lượng theo cấu phần | M3 | analyst | Code | D1, B02, B04 (+ cấu phần nguồn, xem ticket) | L3a ∥ L3b ∥ L5a; rồi L3c, L5b, L5c | — | 2 |
| C03-M3, C05-M3 Gộp cấu phần, script `run_ch0X_all.R` | M3 | Lead chương + analyst | Code | các cấu phần | — | — | 2 |
| C03-E, C05-E Kiểm kết quả + đối chiếu số | — | reviewer + tracer | Either | C0X-M3 (C05-E: số Ch3 qua C03-E) | — | **Evidence** | 2 |
| C0X-M1 Ánh xạ chương → đề cương 3.1 (Ch2–Ch5: sau M3) | M1 | Lead chương | Either | B01 (+ C0X-M3 với Ch2–Ch5) | theo làn | — | — |
| C0X-M4 Kiểm nguồn + bib | M4 | source-auditor | Cowork | C0X-M1 | theo làn | — | 2 |
| C0X-M2 Viết bù theo đề cương 3.1 | M2 | writer → Lead tích hợp | Cowork | M1, M4 (+ E với Ch3, Ch5) | P2 | — | 2 |
| C0X-M5 Review độc lập | M5 | reviewer | Either | M2 | P2 | — | 2 |
| C0X-M6 Gói chương + smoke test + đối chiếu số | M6 | Lead + tester + tracer | Code | M5, B03 | — | **Delivery** | 2 |
| B08 Đối chiếu toàn sách | — | tracer | Code | mọi C0X-M6 | — | **Delivery** (sách) | 2 |
| B09 Mở đầu · B10 Phụ lục A–D | M2/M6 | writer / Lead | Either | C06-M2 / mọi C0X-M6 | — | Delivery | 2 |
Đợt (v2, `tickets/LANES.md` mục 8): A = D1 Ch3+Ch5, C02-M3, C04-M3 · B = C03-M3a, C03-M3b, C05-M3a (+ Ch1 M1/M4) · C = C03-M3c, C05-M3b, C05-M3c · D = E, M1, M4, M2, M5, M6 từng chương; Ch6, Mở đầu, Phụ lục, B08 cuối.
Quy tắc (v2): phiên song song theo làn, tập ghi không trùng; mỗi phiên ≤ 2 agent con; ≤ 3 phiên chạy R nặng cùng lúc; một owner mỗi bước; một người ghi mỗi file; Lead chương tích hợp vào `chapter.md` của chương mình; tệp trạng thái dùng chung sửa theo LANES.md mục 4. Chi tiết từng bước: `tickets/<mã>.md`; bảng việc: `tickets/TASKS.md`.

## Approval points
| Point | Ticket | Tác giả xem | Tác giả quyết |
|---|---|---|---|
| Scope | B00 | file này + 6 card | đội, quy trình, ràng buộc — **đã duyệt 22/10/2026** |
| Design | B03, C03-D1 + C05-D1 (một gói) | quy ước + bản dựng thử Ch1; thiết kế thực nghiệm | khuôn sản xuất; thiết kế dự báo, bộ dự báo dùng chung, giai đoạn, kiểm định độ bền |
| Evidence | C03-E, C05-E (và báo cáo lệch số của M3 Ch1, Ch2, Ch4) | báo cáo kiểm kết quả, bảng đối chiếu số, README các lần chạy | kết quả nào tin được; chương được phép kết luận gì |
| Delivery | C0X-M6, B08, B10 | gói chương, danh sách thay đổi, báo cáo kiểm | chương/sách sẵn sàng |

## Readiness (22/10/2026)
| Check | Result | Note |
|---|---|---|
| Rscript | blocked (Cowork VM, cloud) / CHƯA XÁC NHẬN (Mac) | renv.lock ghi R 4.5.0 nhưng chỉ 27 gói, thiếu rugarch, MCS, forecast, FinTS, tseries → B04 |
| Stata | not needed | |
| python3 | ready | VM 3.10, có python-docx, openpyxl |
| pandoc | ready (cloud 3.1.3) / cũ (VM 2.9.2) | dựng ở Code hoặc cloud |
| LaTeX | ready | xelatex, latexmk; font tiếng Việt kiểm ở B03 |
| Network (lit_tools) | blocked | Crossref API 403; dùng WebSearch/WebFetch |
| Inputs present and synced | ready | đọc được, đã băm SHA; HNX-Index đã nhận 22/10/2026 (chưa audit) |
| Git | blocked | thiếu object `1419bb4…`, cây làm việc lệch HEAD, `.git` trên Drive → B06 |
| Subagent dispatch | ready có điều kiện | agent con có thể không thấy thư mục trên máy; khi đó Lead chuyển file hoặc tự làm bước đó |

## Dispatch
`subagent_type` = agent gốc (ví dụ `lht-academic-suite:empirical-analyst`); prompt: "Read your role card `team/agents/<file>` first and follow it; it narrows, never widens, your base rules." + nội dung handoff của ticket (mã, đầu vào + SHA, việc, đầu ra, tiêu chí, điểm dừng). Lead kiểm SHA đầu vào trước khi giao cho agent không có Bash (writer, reviewer).

## Change log
| Version | Date | Change | Approved |
|---|---|---|---|
| 1 | 2026-10-22 | Thiết lập đội 6 card theo đề cương 3.1 và phương án dữ liệu (bỏ VN30) | tác giả, 22/10/2026 |
| 2 | 2026-10-22 | Bỏ chỉ số ngành (B07 hủy; card analyst, reviewer v2); thực nghiệm chạy trước ở Ch2–Ch5; tách M3 Ch3, Ch5 thành cấu phần a/b/c; phiên song song theo làn (`tickets/LANES.md`). Bản v1: `_project/archive/TEAM_20261022_pre-lanes.md` | tác giả (yêu cầu trong phiên Claude Code), 22/10/2026 |
