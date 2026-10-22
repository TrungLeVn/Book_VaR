# Rà soát legacy — Chương 3

## Phạm vi đã kiểm tra

- `99. Archive/2026-08-15_pre-restructure/legacy_numbering_pending_review/vnindex_daily.csv`
- `99. Archive/2026-08-15_pre-restructure/legacy_numbering_pending_review/build_ch05_ch07_pipeline.R`
- `99. Archive/2026-08-15_pre-restructure/legacy_numbering_pending_review/ch05_ch07_pipeline.rds`
- `99. Archive/2026-08-15_pre-restructure/legacy_numbering_pending_review/ch05_descriptive_stats.csv`

## Kết luận mapping

| Legacy asset | Kết luận | Cách xử lý |
| --- | --- | --- |
| `vnindex_daily.csv` | Chuỗi OHLC VN-Index hợp lệ về cấu trúc, 4.081 quan sát giá, 2010-01-05–2026-05-20; ngày tăng dần và không có OHLC không dương | Dùng làm fallback có ghi nhãn cho Chương 3; sao chép bằng script vào `data/raw/`, không sửa archive |
| `build_ch05_ch07_pipeline.R` và `.rds` | Nội dung là VaR/ES, EVT, quantile regression và backtesting; tên và logic phục vụ legacy Ch.5/7, không phải pipeline Chương 3 | Không tái sử dụng mã hay output cho Chương 3 |
| `ch05_descriptive_stats.csv` | Phụ phẩm của pipeline legacy, không đủ provenance độc lập cho Chương 3 | Không chuyển vào output hiện hành |
| Hình cũ trong `03. Chuong_03/output/figures/` | Có dấu hiệu lẫn nội dung VaR/ES, không khớp vai trò volatility của Chương 3 | Giữ nguyên để bảo toàn lịch sử; không tham chiếu trong kết quả mới |

## Trạng thái nguồn trực tuyến

Lần chạy có `--refresh` ngày 2026-08-16 thử endpoint `finfo-api.vndirect.com.vn` với timeout 15 giây. Endpoint không phản hồi. Do đó, output hiện tại **không phải dữ liệu cập nhật sau 2026-05-20**. Mọi câu chữ trong bản thảo phải nêu đúng cut-off này cho tới khi có nguồn OHLC thay thế đã xác minh.
