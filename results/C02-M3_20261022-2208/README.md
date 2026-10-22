# C02-M3 — Tái tạo nội dung định lượng Chương 2 — lần chạy 22/10/2026 22:08

- **Làn:** L2 (Claude Code). **Ticket:** `tickets/C02-M3.md`. **Card:** `team/agents/var-reproduction-analyst.md`.
- **Nơi chạy:** container cloud của Claude Code (Ubuntu 24.04, 4 lõi), **không phải máy Mac** như A3 trong `PROJECT.md`. Lý do: phiên được mở trên cloud. Hệ quả ở mục 5.
- **Lệnh:** `cd analysis/ch02 && LANG=C.UTF-8 LC_ALL=C.UTF-8 Rscript run_ch02_all.R` (container không có locale `en_US.UTF-8`; trên Mac dùng `LANG=en_US.UTF-8`). Exit 0; script chương chạy 14,4 s; workers = 1 (không chạy song song).
- **Kết luận:** mọi bảng/hình của script chương tái tạo được và tất định. **Dừng theo ticket:** 4/11 hình trong `chapter.md` không khớp output của script hiện tại (Hình 2.1 và 2.4 khác lần mô phỏng; Hình 2.3 và 2.6 là hình cũ, không khớp chú thích/lời). Cần quyết định, mục 6.

## 1. Đầu vào
| Tệp | SHA-256 | Ghi chú |
|---|---|---|
| `02. Chuong_02/code/R/ch02_all_tables_figures_appendix.R` | `bba67fa6e7e75179b1dba91866a4d6399f11f390e8238b9c0c502e70ad211c88` | runner kiểm SHA trước khi chạy; chạy nguyên trạng trên bản sao |
| `renv.lock` | `b20dbb696f2c92543d753441b491bd2a69e0573edb1795e907cdb5658baa75b8` | phiên bản gói so ở mục 4 |
| `02. Chuong_02/chapter.md` | đọc, không sửa | danh mục 11 hình, 0 bảng |
| `02. Chuong_02/chapter.docx` | đọc, không sửa | trích `word/media/image1–11.png` → `docx_media_reference/` (SHA ở mục 3) |
| Quarto cũ `archive_pre_word_workflow/chapters/legacy-ch02.qmd` | blob `ad394fa663797a7c6b33e95f2a563dc33a1188fb`, commit `5b648173c77a…` | đã xoá ở commit 5c085fb; đọc từ lịch sử git (chỉ đọc), chép nguyên văn 4 chunk vào `analysis/ch02/legacy_qmd_chunks.R` |
| `_project/data/*.csv` | 7c756369… / 79c130be… (đã kiểm khớp `DATA_MANIFEST.csv`) | **Chương 2 không đọc dữ liệu thị trường**: mọi hình là mô phỏng hoặc hàm tất định |

Code của lần chạy: `analysis/ch02/run_ch02_all.R` (SHA `d0d939e21da38ddcc7293f35e1579df0162bb2a2c6622616faace0267f749a41`), `analysis/ch02/legacy_qmd_chunks.R` (`8b09e9145434bbfa5e210ea979648b57cd69aa284c0ddc24d71ca9b93421677b`).

## 2. Đã chạy
1. Script chương, nguyên trạng, trên bản sao trong `_sandbox/` (đã xoá sau khi chạy) → `output/figures/` (16 PNG), `output/tables/` (8 CSV + 8 docx), `output/ch02_output_register.csv`. Output chương trong `02. Chuong_02/output/` **không bị ghi**.
2. Hai hình cũ đang nhúng trong `chapter.docx` (Hình 2.3, 2.6) từ chunk qmd → `output/figures_legacy/`.
3. Chạy thêm 2 lượt sandbox giống hệt (scratchpad) để kiểm tính tất định; `sandbox_run1.log` là log lượt 1.
4. `seedscan.R`: dò seed 1–200.000 cho Hình 2.1 bản docx (mục 3).
- Không chạy mô hình mới, không đổi đặc tả, không chạy minh họa biên độ giá (việc 2 của ticket — chờ tác giả).

## 3. Đối chiếu
**Tính tất định và đa nền tảng**
- Lượt 1 = lượt 2 = lần chạy chính thức: 16/16 PNG và 9/9 CSV trùng byte. 8 docx chỉ khác `docProps/core.xml` (thời điểm tạo); mọi phần khác trong tệp nén trùng byte.
- So với lượt Mac của B04 (`results/B04_20261022-1448_verify/sandbox_outputs.tsv`): **9/9 CSV trùng byte** (gồm `table_A2_2_tail_quantiles.csv`, bảng số duy nhất). 16/16 PNG khác byte: 2,5–10,6% điểm ảnh lệch, toàn ở chữ (Linux thay font, tiêu đề dài bị cắt); đường đồ thị trùng khi so bằng mắt (`compare_legacy_and_mac_vs_linux.png`, hàng 3). Trên Mac, B04 đã xác nhận 16/16 PNG trùng byte với `02. Chuong_02/output/figures/`.
- Hai hình cũ tái tạo: cùng kích thước 2400×1440, 3,7% và 2,5% điểm ảnh lệch (font), dữ liệu trùng khi so bằng mắt. Cảnh báo ggplot "No shared levels…" là đặc điểm của code qmd gốc (`book_cols["x"]` làm sai tên trong `scale_color_manual`, nên nét vẽ màu xám); giữ nguyên để tái tạo đúng.

**Bài (chapter.md / chapter.docx) ↔ chạy** — chi tiết từng exhibit: `exhibit_map.csv`.
| Kết quả | Exhibit |
|---|---|
| Khớp (checked, so bằng mắt) | Hình 2.2, 2.5, 2.7, 2.8 (= fig_A2_4), 2.9 (= fig_A2_4A), 2.10 (= fig_A2_4B), 2.11 (= fig_A2_7); số: phân vị trái 1% Student-t (−2,6065 với ν = 5; −2,5084 với ν = 8; chuẩn −2,3263) |
| **Lệch: khác lần mô phỏng** | Hình 2.1, 2.4 — cùng thiết kế, khác đường dữ liệu; không tìm được code/seed tạo ảnh docx; không có số trích trong văn bản |
| **Lệch hình–lời** | Hình 2.3, 2.6 — ảnh docx là hình cũ (qmd), tái tạo được; nhưng chú thích/đoạn văn mô tả phiên bản của script (`fig_2_3_ewma_shock_response`, `fig_2_6_news_impact_curves`) |
| Ví dụ giả định | δ = 1,67 (APARCH) |
| Chạy, chưa dùng trong bài | fig_2_3, fig_2_6, fig_2_8, fig_A2_2, fig_A2_3, fig_A2_5, fig_A2_6; 8 bảng (tổng hợp/mẫu, không phải ước lượng) |

Ảnh docx đánh số khác bài (vd. ảnh của Hình 2.1 ghi "Hình 2.2", ảnh của 2.8–2.11 ghi "A2.4", "A2.4A", "A2.4B", "A2.7"). Sẽ xử lý khi dựng lại hình (M2/M6).

SHA ảnh trong docx: image1 `13422b23…`, image2 `3b9c6e0e…`, image3 `6749ffba…`, image4 `4d72d928…`, image5 `9c498175…`, image6 `9b6cd3ee…`, image7 `e9056d79…`, image8 `e2f69377…`, image9 `53e27bfe…`, image10 `0a293a48…`, image11 `b236a767…` (đầy đủ: `sha256sum docx_media_reference/*`).

## 4. Môi trường
- R 4.5.3 (conda-forge, x86_64-conda-linux-gnu), cài trong scratchpad của phiên (CRAN và Posit PM bị proxy chặn). Không đụng `renv/` của dự án.
- Trùng phiên bản `renv.lock`: ggplot2 4.0.3, dplyr 1.2.1, tidyr 1.3.2, tibble 3.3.1, scales 1.4.0, patchwork 1.3.2, readr 2.2.0, flextable 0.10.3, officer 0.7.7, ragg 1.5.2, systemfonts 1.3.2, textshaping 1.0.5, optimx 2025-4.9, numDeriv 2016.8-1.1. **sgt 2.0-2** dựng từ mã nguồn `github.com/cran/sgt` (tag 2.0-2).
- Khác: **zoo 1.9-0** (lock 1.9-1). CSV trùng byte với lượt Mac, nên khác biệt này không ảnh hưởng output.
- `sessionInfo.txt`; hash từng tệp output: `output_sha256.csv`.

## 5. Giới hạn
- Không chạy trên Mac. Số liệu (CSV) đã đối chiếu chéo với lượt Mac; PNG thì không trùng byte do font. Bộ PNG chuẩn cho sách vẫn là bản Mac. Nên chạy lại `run_ch02_all.R` trên Mac (~20 s) để có bộ PNG trùng byte với `02. Chuong_02/output/figures/`.
- So khớp ảnh docx ↔ output là **so bằng mắt** (ảnh docx bị Word thu nhỏ, cắt lề), không so số. Số đọc từ ảnh docx là ước lượng bằng mắt.
- Không tìm được nguồn của ảnh Hình 2.1/2.4 trong docx: script hiện có một commit duy nhất (a887632); lịch sử git không có bản cũ hơn.
- Năm hình cũ khác (`fig-garch-conditional-vol-demo`, `fig-realized-volatility-demo`, `fig-rolling-volatility-demo`, `fig-simple-vol-limit`, `fig-ewma-weights-demo`) không có trong `chapter.md` nên chưa tái tạo; `fig-garch-conditional-vol-demo` cần rugarch.
- Chưa có `0X. Chuong_02/code/R/run_ch02_all.R` (chuyển ở M6 sau khi duyệt).

## 6. NEEDS DECISION (→ L2 Lead / tác giả)
1. **Hình 2.1, 2.4:** thay ảnh docx bằng output script hiện tại (`fig_2_1`, `fig_2_4`; tái tạo được, seed 20260708)? Đề xuất: **thay**. Văn bản chỉ mô tả định tính nên không phải sửa lời.
2. **Hình 2.3:** dùng `fig_2_3_ewma_shock_response.png` (khớp chú thích và đoạn văn dòng 135)? Hay giữ hình cũ (phải viết lại lời; nhãn tiếng Anh)? Đề xuất: **dùng fig_2_3**.
3. **Hình 2.6:** dùng `fig_2_6_news_impact_curves.png` (GARCH, GJR-GARCH, EGARCH; khớp lời mô tả trục) và sửa chú thích thành "… GARCH, GJR-GARCH và EGARCH"? Hay giữ hình cũ? Đề xuất: **dùng fig_2_6** (EGARCH được trình bày ngay sau ở 2.2.3).
4. **Việc 2 của ticket, mục 2.1.3:** có làm minh họa ước lượng dựa trên biên độ giá bằng VN-Index OHLC không? Nếu có, cần chọn cách xử lý giá mở cửa (= đóng cửa hôm trước ở phần lớn phiên từ 2021), nhất quán với C03-D1.

## 7. Tệp trong thư mục này
`README.md`, `exhibit_map.csv`, `output/` (+ `figures_legacy/`), `output_sha256.csv`, `sessionInfo.txt`, `ch02_script.log`, `sandbox_run1.log`, `seedscan.R`, `docx_media_reference/` (11 ảnh trích từ docx), `contact_docx_media.png`, `contact_chapter_output_mac.png`, `compare_docx_vs_script_fig2_1_2_4_2_5.png` (trái: docx, phải: script), `compare_legacy_and_mac_vs_linux.png` (hàng 1–2: hình cũ Mac ↔ tái tạo; hàng 3: fig_2_6 Mac ↔ Linux).
