# Làn làm việc song song — phiên Claude Code theo chương / cấu phần

Phiên bản 1, 22/10/2026 (tác giả: "cho phép Claude Code chạy song song các phiên cho từng chương hoặc từng cấu phần từng chương, liên tục update vào same book"). Áp dụng cùng `team/TEAM.md` v2. Bảng việc: `tickets/TASKS.md` (mỗi mục có dòng `Làn:`).

## 1. Nguyên tắc
- Mọi phiên làm trên **cùng một thư mục** `02. Drafts/` (không worktree, không git — B06). Vì vậy tách nhau bằng **tập ghi không trùng**, không bằng nhánh.
- Mỗi làn là **Lead của chương mình**: chạy giao thức `paper-team` trong phạm vi ticket của làn, giao agent con (≤ 2 cùng lúc mỗi phiên), kiểm kết quả, **tích hợp thẳng vào `0X. Chuong_0X/`** sau khi qua điểm kiểm của ticket. Đó là cách "liên tục cập nhật vào cùng một cuốn sách".
- **L0 — Lead sách** (phiên chính) giữ phần dùng chung của cả sách và là nơi duy nhất đổi cấu trúc bảng việc, quy tắc, đội agent.
- Điểm duyệt Design / Evidence / Delivery vẫn do tác giả quyết; làn dừng ở đó và báo L0 (dòng LOG `→ L0:`), không tự vượt.

## 2. Danh sách làn và tập ghi
| Làn | Phạm vi (ticket) | Được ghi | Ghi chú |
|---|---|---|---|
| **L0** Lead sách | B01–B11, cấu trúc TASKS.md, LANES.md | `PROJECT.md`, `team/`, `AGENTS.md`, `CLAUDE.md`, `00. Book/`, `_project/`, `tickets/B*.md`, `tickets/LANES.md`, `results/B*`, `design/B*`, `reviews/*_book*` | Duy nhất được chuyển dữ liệu chuẩn vào `_project/data/` và sửa glossary/notation |
| **L1** Ch1 | C01-* | tập ghi chương (mục 3) với X = 1 | Không phải chương mô hình hóa: thứ tự cũ |
| **L2** Ch2 | C02-* | tập ghi chương, X = 2 | Mô phỏng chạy trước (C02-M3) |
| **L3** Ch3 | C03-D1, C03-M3, C03-E, C03-M1…M6 | tập ghi chương, X = 3 | Có thể tách 3 phiên: **L3a** = C03-M3a, **L3b** = C03-M3b (+ `analysis/common/`), **L3c** = C03-M3c; phiên L3 (điều phối chương) giữ D1, E, M1…M6 |
| **L4** Ch4 | C04-* | tập ghi chương, X = 4 | Mô phỏng chạy trước (C04-M3) |
| **L5** Ch5 | C05-D1, C05-M3, C05-E, C05-M1…M6 | tập ghi chương, X = 5 | Có thể tách: **L5a** = C05-M3a, **L5b** = C05-M3b, **L5c** = C05-M3c |
| **L6** Ch6 + Mở đầu | C06-*, B09 | tập ghi chương, X = 6; `chapters/drafts/B09_*` | Bắt đầu sau C03-E, C05-E |

## 3. Tập ghi của một làn chương (X = số chương)
- `0X. Chuong_0X/` — `chapter.md`, `code/`, `data/derived/`, `output/`, `references/`, `release/`, `archive/`, `REPRODUCE.md`. **Trừ** `data/raw/` và `chapter.docx` (chỉ đọc).
- `analysis/ch0X/`, `results/C0X-*`, `design/C0X-*`, `chapters/drafts/C0X-*`, `context/ch0X_*`, `reviews/*ch0X*`, `tickets/C0X-*.md`.
- Phiên tách theo cấu phần chỉ ghi thư mục con của mình: `analysis/ch0X/<a|b|c>_*/`, `results/C0X-M3<a|b|c>_*`. Script tổng `analysis/ch0X/run_ch0X_all.R` và `chapter.md` thuộc phiên điều phối chương.
- **`analysis/common/`** (bộ dự báo dùng chung Ch3 ↔ Ch5, nếu C03-D1 duyệt): chỉ **L3b** ghi; làn khác đọc bản có SHA ghi trong README của run C03-M3b.

## 4. Ba tệp trạng thái dùng chung: `tickets/TASKS.md`, `LOG.md`, `CHAPTERS.md`
- Làn chỉ sửa **mục của ticket mình** trong TASKS.md (dòng `Trạng thái`, chuyển sang Waiting On/Done với `Bằng chứng:`), **dòng chương mình** trong CHAPTERS.md, và **thêm dòng** cuối LOG.md có tiền tố làn: `- DD/MM/YYYY — [L3b] C03-M3b — …`.
- Chỉ dùng công cụ Edit (thay đúng đoạn nhỏ); **không** Write cả tệp, **không** sed/awk/python lên ba tệp này. Đọc lại ngay trước khi Edit; Edit báo tệp đã đổi → đọc lại rồi sửa lại, không ghi đè.
- Sắp xếp lại, thêm/xoá ticket, đổi phụ thuộc: chỉ L0. Làn cần đổi → ghi `→ L0:` trong LOG.md hoặc mục "Yêu cầu sang L0" trong ticket của mình.
- Trạng thái chi tiết, ghi chú làm việc: để trong `tickets/C0X-*.md` của làn (tệp riêng, không đụng nhau).

## 5. Phụ thuộc giữa làn
- Làn dùng kết quả của làn khác **chỉ khi** ticket nguồn đã Done (hoặc README run nguồn ghi "đã khoá" kèm SHA). Ghi SHA bản đã dùng vào README của mình; nguồn đổi → làn phụ thuộc mở ticket kiểm lại `<mã>-R` qua L0.
- Số liệu của chương khác đưa vào thân bài: chỉ số đã qua Evidence (C03-E, C05-E).
- Tham chiếu chéo giữa chương: theo số mục trong `00. Book/architecture.md`; thuật ngữ, ký hiệu theo `00. Book/glossary.md`, `notation.md` (chỉ đọc; đề xuất sửa → L0).

## 6. Tài nguyên máy (Mac: 12 lõi, 18 GB RAM — kiểm 22/10/2026)
- Tối đa **3 phiên chạy R nặng** cùng lúc (ước lượng trượt GARCH, mô phỏng). Mỗi phiên dùng ≤ 3 tiến trình song song (`parallel`/`future` workers = 3) và ghi số workers vào README run.
- Không cài/gỡ gói R trong làn; môi trường do B04 (L0) quản lý theo `renv.lock`. Thiếu gói → `→ L0:`.
- Kết quả nặng (> 50 MB) để trong `results/`, không chép vào thư mục chương; thư mục chương chỉ nhận bảng/hình đã dùng.

## 7. Mở một phiên làn (dán làm tin nhắn đầu, hoặc L0 dùng làm brief khi tạo phiên)
> Dự án sách VaR, gốc `02. Drafts/`. Bạn là làn **<Lx>** — Lead của <chương / cấu phần>. Đọc: `PROJECT.md` → `tickets/LANES.md` → mục của làn trong `tickets/TASKS.md` → `tickets/<mã>.md` → 10 dòng cuối `LOG.md` → card agent cần dùng trong `team/agents/`. Chỉ ghi trong tập ghi của làn (LANES.md mục 2–4). Làm ticket <mã> theo giao thức `lht-academic-suite:paper-team`, chế độ `to-approval`; dừng ở điểm duyệt của ticket, ở `Cần quyết định`, hoặc khi phụ thuộc chưa Done. Cuối mỗi khối việc: cập nhật mục ticket trong TASKS.md, thêm một dòng LOG có tiền tố `[Lx]`.

## 8. Thứ tự khởi động khuyến nghị (sau khi B04 được duyệt)
| Đợt | Làn chạy song song | Điều kiện |
|---|---|---|
| A | L3 (C03-D1) + L5 (C05-D1) soạn thiết kế; L2 (C02-M3); L4 (C04-M3) | B04 duyệt (renv.lock); B02 phần 2 xong cho phần HNX |
| B | L3a, L3b, L5a (R nặng: tối đa 3) ; L1 chạy C01-M1/M4 (không nặng) | C03-D1, C05-D1 duyệt (một gói Design chung) |
| C | L3c, L5b, L5c | C03-M3a/b khoá code; C05-M3a xong |
| D | L3, L5: C0X-E → M1 → M4 → M2 …; L6 | Evidence duyệt |

## 9. Đợt A — mở 22/10/2026 20:50 (L0)
Điều kiện đã đạt: B04 xong (renv.lock R 4.5.3); B02 xong — dữ liệu chuẩn ở `_project/data/` (đọc `_project/data/README.md`). Chạy song song 4 phiên Claude Code trên Mac; chỉ C02-M3, C04-M3 chạy R (nhẹ, mô phỏng); C03-D1, C05-D1 là thiết kế (không chạy mô hình, chỉ được đọc code/output hiện có).

| Phiên | Ticket | Dừng ở |
|---|---|---|
| L3 | C03-D1 → `design/C03-D1_design.md` | Điểm duyệt Design (gói chung với C05-D1) |
| L5 | C05-D1 → `design/C05-D1_design.md` | Điểm duyệt Design (gói chung với C03-D1) |
| L2 | C02-M3 → `analysis/ch02/`, `results/C02-M3_<ts>/` | Hết ticket, hoặc số tái tạo lệch số trong bài |
| L4 | C04-M3 → `analysis/ch04/`, `results/C04-M3_<ts>/` | Hết ticket, hoặc cần đặc tả ngoài ticket |

Brief dán làm tin nhắn đầu mỗi phiên (thay <Lx>, <mã>):
> Dự án sách VaR, gốc `02. Drafts/`. Bạn là làn **<Lx>**. Đọc: `PROJECT.md` → `tickets/LANES.md` (mục 1–5, 9) → mục <mã> trong `tickets/TASKS.md` → `tickets/<mã>.md` → `_project/data/README.md` → 10 dòng cuối `LOG.md` → card trong `team/agents/` mà ticket nêu. Thuật ngữ/ký hiệu theo `00. Book/glossary.md`, `notation.md`; tiêu đề theo `00. Book/architecture.md` (đề cương 3.2). Chỉ ghi trong tập ghi của làn. Làm ticket <mã> theo `lht-academic-suite:paper-team`, chế độ `to-approval`. Cuối mỗi khối việc: sửa mục ticket trong TASKS.md bằng Edit, thêm một dòng LOG có tiền tố `[<Lx>]`.

Phối hợp L3 ↔ L5: C05-D1 dùng mẫu, giai đoạn thị trường và bộ dự báo của C03-D1; L5 đọc bản nháp `design/C03-D1_design.md` khi có, ghi điểm chưa khớp vào `design/C05-D1_design.md` mục "Cần khớp với C03-D1". L3 gộp hai bản thành một gói Design trình tác giả.
