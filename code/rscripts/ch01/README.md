# Chapter 1 R scripts

Bộ script này dùng Rscript để tạo bảng, hình và các ước lượng minh họa cho Chương 1. Không phụ thuộc Quarto.

## Cách chạy

Từ thư mục `ch01_rscripts`, chạy:

```bash
Rscript run_ch01_all.R
```

## Dữ liệu đầu vào

Đặt file dữ liệu tại:

```text
data/vnindex.csv
```

File nên có tối thiểu hai cột:

- `Date`: ngày giao dịch
- `Adjusted`, `AdjClose`, `Close`, `Price` hoặc `Index`: giá/chỉ số

Nếu chưa có dữ liệu, script sẽ dùng dữ liệu mô phỏng để kiểm tra pipeline. Để bắt buộc dùng dữ liệu thật, mở `R/00_setup.R` và đặt:

```r
USE_DEMO_IF_NO_DATA <- FALSE
```

## Kết quả đầu ra

Tất cả kết quả được lưu trong:

```text
output/ch01/
```

Gồm:

- `figures/`: hình `.png`
- `tables/`: bảng `.docx` và `.csv`
- `estimates/`: thống kê mô tả, kiểm định, VaR/ES dạng `.csv`
- `docx/`: file Word tổng hợp bảng/hình/ước lượng

## Cấu trúc scripts

- `run_ch01_all.R`: chạy toàn bộ pipeline
- `R/00_setup.R`: cấu hình, packages, style và helper functions
- `R/01_data.R`: đọc dữ liệu, tính simple return, log return và loss
- `R/02_tables.R`: tạo bảng cho mục 1.2 và bảng ngôn ngữ cốt lõi
- `R/03_figures.R`: tạo các hình minh họa Chương 1
- `R/04_estimates.R`: thống kê mô tả, kiểm định chẩn đoán, VaR/ES lịch sử
- `R/05_export_report.R`: gom kết quả vào một file Word
