# B04 — Môi trường R đầy đủ (renv) — lần chạy 22/10/2026 14:20

- **Nơi làm:** Claude Code trên Mac (Lead). **Ticket:** `tickets/B04.md`.
- **Kết luận ngắn:** môi trường R đã dựng lại và **đủ gói**; `renv.lock.proposed` sẵn sàng để duyệt. Script Ch3 chạy được nguyên trạng. Script Ch1, Ch2 **không chạy được nguyên trạng** do một lỗi code (không phải lỗi gói); sửa một dòng (chỉ trong bản sao sandbox) thì chạy được. `renv.lock` gốc **chưa thay**.

## 1. Hiện trạng trước khi làm
| Mục | Kết quả |
|---|---|
| R trên máy | 4.5.3 (2026-03-11), aarch64-apple-darwin20, macOS 26.6.2 — **lệch** `renv.lock` (4.5.0) |
| renv | 1.1.8; `.Rprofile` kích hoạt renv bình thường |
| `renv.lock` gốc | 27 gói (chỉ bộ rmarkdown/knitr); SHA-256 `5539d874652d693a0d2b9d9fe8cb5118e5eb20cfd646e9bbc61f43f82d2b86cd` — **không đổi sau lần chạy** |
| Thư viện dự án `renv/library/macos/R-4.5/…` | 127 mục, **125 là symlink hỏng**: trỏ vào cache renv `~/Library/Caches/org.R-project.R/R/renv/cache` đã bị xoá (cache còn 4 KB). Thực tế không gói nào nạp được. |

## 2. Đã làm
1. `install_packages.R` — `renv::install()` 20 gói mà các script Ch1–Ch3 gọi (dò `library()` và `pkg::`) + `readxl`, `rmarkdown`, `knitr`. Cài 143 gói (binary PPM). Log: `install.log`.
2. `flextable` không nạp được: binary `gdtools` của PPM liên kết `/opt/X11/lib/libXrender.1.dylib` (XQuartz, máy không có). Xử lý: `install_gdtools_source.R` build `gdtools` 0.5.2 từ source theo cairo/fontconfig/freetype của Homebrew; cần `Makevars.gdtools` (`LDFLAGS += -L/opt/homebrew/lib` cho `-lintl`), truyền qua `R_MAKEVARS_USER` — **không** sửa `~/.R/Makevars`. Log: `install_gdtools.log`.
3. `snapshot_proposed.R` — `renv::snapshot(packages = …)` ghi **`renv.lock.proposed`** (R 4.5.3, 154 gói, SHA-256 `b20dbb696f2c92543d753441b491bd2a69e0573edb1795e907cdb5658baa75b8`); `lockfile_diff.csv` (127 thêm, 17 đổi phiên bản, 10 giữ nguyên, 0 bỏ); `sessionInfo.txt`.
4. `run_scripts_sandbox.sh` — chạy thử mọi script R hiện có của Ch1–Ch3 trong **bản sao** dự án ở scratchpad (lý do: các script ghi vào `0X. Chuong_0X/output/`, Ch3 còn ghi `03. Chuong_03/data/raw/vnindex_daily.csv`; chạy tại chỗ sẽ ghi đè bằng chứng cũ và dữ liệu thô). Thư viện sandbox là symlink tới thư viện dự án nên dùng đúng các gói vừa cài.

Gói chính trong lockfile đề xuất: rugarch 1.5-6, MCS 0.2.1, forecast 9.0.2, FinTS 0.4-9, tseries 0.10-63, zoo 1.9-1, readxl 1.6.0, car 3.1-5, moments 0.14.1, sgt 2.0-2, quantmod 0.4.29, flextable 0.10.3, officer 0.7.7, gdtools 0.5.2, ggplot2 4.0.3, dplyr 1.2.1, renv 1.1.8.

## 3. Đầu vào (SHA-256)
| Tệp | SHA-256 |
|---|---|
| `../99. Archive/2026-08-15_pre-restructure/legacy_numbering_pending_review/vnindex_daily.csv` (đầu vào "archive fallback" của Ch3) | `f292c43a5ac108597940273d1c5c833f8465a6d561ce2c714374d0a5321d3d2d` |
| `01. Chuong_01/data/raw/vnindex.csv` | `289e0a51aa5714eb567e31dc9699182be9fb236dec2a7617a3daf6662c75d484` |
| `01. Chuong_01/code/R/00_ch01_setup.R` | `f8a164d45a84b679f43c78cff715fc3b0c3f73d38147b376d9a70a33fc368704` |
| `01. Chuong_01/code/R/01_ch01_appendix_tables_figures.R` | `751ec48521eabb9bb919437b8f811936df0a69859bf4515740c33195e8e8ba66` |
| `01. Chuong_01/code/R/99_ch01_export.R` | `727e5bc6f6b881daf546d7aa260e4debe33e667a50cc0e92046e6e94680d6c4e` |
| `01. Chuong_01/code/R/run_ch01_all.R` | `749698080b9b799051b315d1719a84a01d770973ec6da2f20afedac73f10b019` |
| `01. Chuong_01/code/ch01_all_in_one_Rscript.R` | `b64bb26f70123a085c22ccfc5a6963b33ab10accc367b7c033ed0819bae0e720` |
| `02. Chuong_02/code/R/ch02_all_tables_figures_appendix.R` | `c30766ef52025d2e58665b090f9f7c8ce5728a01b068cb273d55c3e83832625c` |
| `03. Chuong_03/code/R/run_chapter03_volatility.R` | `bd58c52349625e1a15faead82c201957b8bde6caaffd8df03715ecd3652b2b63` |

## 4. Kết quả chạy script (3 lượt, log giữ nguyên)
| Script | Lượt 1 `logs_attempt1/` | Lượt 2 `logs/` (nguyên trạng) | Lượt 3 `logs_patched/` (vá 1 dòng trong sandbox) |
|---|---|---|---|
| Ch1 `run_ch01_all.R` | lỗi locale | **lỗi code** | chạy xong (3 s) |
| Ch1 `ch01_all_in_one_Rscript.R` | lỗi đường dẫn | **lỗi code** | lỗi mạng: Yahoo `^GSPC` "Unable to import" |
| Ch2 `ch02_all_tables_figures_appendix.R` | lỗi đường dẫn | **lỗi code** | chạy xong (6 s) |
| Ch3 `run_chapter03_volatility.R` | chạy xong, nhưng ghi sai thư mục | **chạy xong** (196 s) | chạy xong (201 s) |

Nguyên nhân từng lỗi:
- **Lượt 1, locale:** shell của Claude Code không đặt `LANG` → R chạy locale `C`, `source(…, encoding = "UTF-8")` không parse được tên cột tiếng Việt (`unexpected INCOMPLETE_STRING`). Từ lượt 2 runner đặt `LANG=LC_ALL=en_US.UTF-8`. RStudio/Terminal thường đã có UTF-8; khi chạy tự động phải đặt rõ.
- **Lượt 1, đường dẫn:** Rscript mã hoá dấu cách trong `--file=` thành `~+~`. Script Ch1 all-in-one và Ch2 dùng `normalizePath(…, mustWork = TRUE)` nên dừng; Ch3 không kiểm nên **lặng lẽ tạo thư mục `03.~+~Chuong_03/` và ghi toàn bộ output vào đó** (đã kiểm: thư mục này không tồn tại trong dự án thật). Cách chạy an toàn: `cd` vào thư mục chứa script rồi `Rscript <tên tệp>` (runner làm như vậy từ lượt 2).
- **Lượt 2, lỗi code:** `00_ch01_setup.R:105` và `ch02_all_tables_figures_appendix.R:115` gọi `officer::body_add_flextable()`; hàm này thuộc `flextable` (officer 0.7.7 không export). Lượt 3 thay bằng `flextable::body_add_flextable()` **chỉ trong bản sao sandbox**; code chương không bị sửa.
- **Lượt 3, Ch1 all-in-one:** `01_ch01_appendix_tables_figures.R:102` tải S&P 500 trực tiếp từ Yahoo (`quantmod::getSymbols`). Lần gọi trong `run_ch01_all.R` thành công, lần gọi thứ hai vài giây sau thất bại. Ch1 vì vậy phụ thuộc mạng và dữ liệu Yahoo có thể đổi theo thời điểm tải.

## 5. Đối chiếu output sandbox với output hiện có trong dự án (`output_comparison.tsv`, lượt 3)
| Chương | Kết quả |
|---|---|
| Ch3 | 25/26 CSV, 12/12 PNG và `RUN_REPORT.md` **trùng byte** với output chạy 16/08/2026; tệp khác duy nhất là `data/derived/data_manifest.csv`, chỉ khác dấu thời gian chạy. Nghĩa là pipeline Ch3 tái tạo được nguyên trạng trong môi trường mới (cùng đầu vào archive fallback). Đây là **executed + tái lập được**, chưa phải **checked** với số trong `chapter.md` (việc của C03-M3/C03-E). |
| Ch2 | 16/16 PNG trùng byte; 9 CSV và 8 docx là tệp mới (dự án chưa có bản cũ để so). |
| Ch1 | Code hiện tại sinh **bộ output khác** bộ đang có trong `01. Chuong_01/output/`: ví dụ `tbl_1_1_price_return.csv` đổi nội dung (bản cũ A 50→55, B 200→206; bản mới A 20.000→22.000, B 200.000→202.000) và tên cột ("Tỷ lệ sinh lời" → "Tỷ suất sinh lời"); 12 tệp mới (4 CSV, 2 docx, 6 PNG). Output Ch1 hiện có vì vậy không đến từ code hiện tại → C01-M3 phải xử lý. |

## 6. Đối chiếu với tiêu chí nghiệm thu
| Tiêu chí | Trạng thái |
|---|---|
| Có `results/B04_<ts>/README.md` | Đạt |
| Có `renv.lock` đề xuất, liệt kê đủ gói | Đạt — `renv.lock.proposed`, mọi gói các script gọi đều có và nạp được |
| R chạy được mọi script Ch1–Ch3 hiện có | **Đạt một phần.** Môi trường đủ. Ch3 chạy nguyên trạng. Ch1, Ch2 cần sửa một dòng code (`officer::` → `flextable::`); Ch1 còn phụ thuộc mạng (Yahoo). |

## 7. Giới hạn
- Lockfile đề xuất ghi R 4.5.3, không phải 4.5.0. Muốn đúng 4.5.0 thì phải cài R 4.5.0 riêng; không khuyến nghị.
- `gdtools` trong lockfile ghi Source = Repository (CRAN). `renv::restore()` trên máy Mac khác sẽ lấy lại binary PPM, binary này cần XQuartz. Máy khác phải cài XQuartz, hoặc build từ source như mục 2.2.
- Thư viện Windows `renv/library/windows/R-4.6/` gần như rỗng (1 mục); chưa kiểm môi trường Windows.
- Ch4, Ch5 chưa có script R nên chưa kiểm; các gói cho chúng (kiểm định ngược VaR/ES, EVT…) sẽ bổ sung khi có C04-M3/C05-M3.
- Sandbox nằm ngoài dự án (scratchpad của phiên, tạm thời); bằng chứng lưu lại là log, `sandbox_outputs*.tsv` (đường dẫn, kích thước, SHA-256 từng output) và `output_comparison.tsv`.

## 8. Cần Lead/tác giả quyết định
1. Thay `renv.lock` bằng `renv.lock.proposed` (R 4.5.3)? Trước khi thay, lưu bản cũ vào `_project/archive/`.
2. Sửa `officer::body_add_flextable` → `flextable::body_add_flextable` ở `01. Chuong_01/code/R/00_ch01_setup.R:105` và `02. Chuong_02/code/R/ch02_all_tables_figures_appendix.R:115` ngay (Lead), hay để vào C01-M3/C02-M3?
3. Chuỗi S&P 500 của Ch1: chụp một bản cố định vào `01. Chuong_01/data/raw/` có SHA (đề xuất, giao cho B02/C01-M3) thay vì tải Yahoo mỗi lần chạy.
4. Ghi vào `REPRODUCE.md`/AGENTS: chạy R với UTF-8 và `cd` vào thư mục script (vì dấu cách trong tên thư mục chương).
