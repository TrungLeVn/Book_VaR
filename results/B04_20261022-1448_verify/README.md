# B04 — Xác nhận sau duyệt — lần chạy 22/10/2026 14:48

- **Nơi làm:** Claude Code trên Mac, làn L0. **Căn cứ:** tác giả duyệt trong chat ngày 22/10/2026: thay `renv.lock` bằng `renv.lock.proposed` (bản cũ lưu vào `_project/archive/`), sửa `officer::body_add_flextable` thành `flextable::body_add_flextable` ở Ch1, Ch2, rồi chạy lại để xác nhận.
- **Lần chạy trước:** `results/B04_20261022-1420/` (chẩn đoán, lockfile đề xuất).
- **Kết luận:** cả 4 script R hiện có của Ch1–Ch3 chạy xong (exit 0) trên `renv.lock` mới và code đã sửa.

## 1. Thay đổi đã áp dụng
| Tệp | Trước (SHA-256) | Sau (SHA-256) | Ghi chú |
|---|---|---|---|
| `renv.lock` | `5539d874652d693a0d2b9d9fe8cb5118e5eb20cfd646e9bbc61f43f82d2b86cd` (R 4.5.0, 27 gói) | `b20dbb696f2c92543d753441b491bd2a69e0573edb1795e907cdb5658baa75b8` (R 4.5.3, 154 gói) | Bản cũ: `_project/archive/renv_20261022_pre-B04.lock` |
| `01. Chuong_01/code/R/00_ch01_setup.R` | `f8a164d45a84b679f43c78cff715fc3b0c3f73d38147b376d9a70a33fc368704` | `5fa0ef1f5a0439d9ae57dab3ac5c2ba1a020a8a71187aabd2c9aa3d4e5387b42` | Dòng 105 |
| `02. Chuong_02/code/R/ch02_all_tables_figures_appendix.R` | `c30766ef52025d2e58665b090f9f7c8ce5728a01b068cb273d55c3e83832625c` | `bba67fa6e7e75179b1dba91866a4d6399f11f390e8238b9c0c502e70ad211c88` | Dòng 115 |

- Bản gốc hai script: `pre_edit/`. Diff: `code_fix.diff`. Đây là hai dòng duy nhất bị đổi.
- Hai script thuộc tập ghi của làn L1, L2 (`tickets/LANES.md`). L0 sửa theo duyệt trực tiếp của tác giả, khi chưa có phiên làn nào chạy. Trước khi sửa, SHA hai tệp vẫn khớp bản đã ghi lúc 14:20.

## 2. Kiểm môi trường
- `renv::status()` (`renv_status.txt`): thư viện khớp lockfile. renv chỉ báo `readxl` (cùng `cellranger`, `rematch`) có cài, có ghi trong lockfile nhưng chưa script nào gọi. Đây là chủ ý: gói dành cho việc đọc `vni_data.xlsx` (B02/C0X-M3).

## 3. Chạy script (sandbox, `logs/`)
Runner: `run_scripts_sandbox.sh`, giống bản 14:20 nhưng ghi kết quả vào thư mục này. Runner chạy trên bản sao dự án, dùng locale `en_US.UTF-8` và `cd` vào thư mục chứa từng script.

| Script | Exit | Thời gian |
|---|---|---|
| Ch1 `run_ch01_all.R` | 0 | 3 s |
| Ch1 `ch01_all_in_one_Rscript.R` | 0 | 3 s |
| Ch2 `ch02_all_tables_figures_appendix.R` | 0 | 5 s |
| Ch3 `run_chapter03_volatility.R` | 0 | 196 s |

## 4. Đối chiếu output (`output_comparison.tsv`, 86 tệp)
- **So với lượt vá trong sandbox lúc 14:20:** mọi CSV và PNG trùng byte. 11 tệp docx khác nhau; docx là tệp nén có ghi thời điểm tạo, nên khác byte là bình thường, không phải khác nội dung (chưa so nội dung docx). Tệp `03. Chuong_03/data/derived/data_manifest.csv` chỉ khác dấu thời gian chạy.
- **So với output hiện có trong dự án:**
  - Ch3: 38/39 tệp trùng byte với output chạy 16/08/2026.
  - Ch2: 16/16 PNG trùng byte.
  - Ch1: `tbl_1_1_price_return` khác bản cũ, 12 tệp mới. Đã nêu ở README 14:20; việc này của C01-M3.

## 5. Giới hạn còn lại
- Ch1 tải S&P 500 (`^GSPC`) từ Yahoo mỗi lần chạy. Lần này tải được; lần 14:20 có một lượt thất bại. Kết quả Ch1 vì vậy phụ thuộc mạng và thời điểm tải → đề xuất C01-M3 (L1) chụp một bản cố định có SHA.
- Cách chạy bắt buộc: locale UTF-8, và `cd` vào thư mục script trước khi gọi `Rscript` (Rscript đổi dấu cách thành `~+~`; Ch3 chạy từ gốc dự án sẽ ghi vào thư mục lạ `03.~+~Chuong_03/`). Cần ghi vào `REPRODUCE.md` của từng chương.
- Máy Mac khác: binary `gdtools` của PPM cần XQuartz. Không có XQuartz thì build từ source như `results/B04_20261022-1420/install_gdtools_source.R`.
- Ch4, Ch5 chưa có script R nên chưa kiểm; gói bổ sung cho hai chương này đi qua L0 (`tickets/LANES.md` mục 6).
- Output chạy trong sandbox không được chép vào thư mục chương. Output trong `0X. Chuong_0X/output/` giữ nguyên.
