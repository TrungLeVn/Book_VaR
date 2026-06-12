# ============================================================
# 05_export_report.R
# Optional Word report collecting all Chapter 1 outputs
# ============================================================

add_plot_if_exists <- function(doc, title, img_file, width = 6.5, height = 4.2) {
  path <- file.path(FIG_DIR, img_file)
  if (file.exists(path)) {
    doc <- officer::body_add_par(doc, title, style = "heading 2")
    doc <- officer::body_add_img(doc, src = path, width = width, height = height)
  }
  doc
}

doc <- officer::read_docx()
doc <- officer::body_add_par(doc, "Outputs for Chapter 1", style = "heading 1")
doc <- officer::body_add_par(doc, paste("Series:", SERIES_NAME), style = "Normal")
doc <- officer::body_add_par(doc, data_note, style = "Normal")

# Tables
doc <- officer::body_add_par(doc, "Tables", style = "heading 1")
doc <- officer::body_add_par(doc, "Bảng 1.1. Vì sao cần dùng tỷ lệ sinh lời thay vì thay đổi giá tuyệt đối?", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_1_1)
doc <- officer::body_add_par(doc, "Bảng 1.2. Các quyết định dữ liệu khi tính tỷ lệ sinh lời trong thực nghiệm", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_1_2)
doc <- officer::body_add_par(doc, "Bảng 1.3. So sánh tỷ lệ sinh lời giản đơn và tỷ lệ sinh lời logarit", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_1_3)
doc <- officer::body_add_par(doc, "Bảng 1.x. Ngôn ngữ cốt lõi của Chương 1", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_risk_language)
doc <- officer::body_add_par(doc, "Bảng 1.x. Thống kê mô tả tỷ lệ sinh lời logarit", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_desc)
doc <- officer::body_add_par(doc, "Bảng 1.x. Kiểm định chẩn đoán sơ bộ chuỗi tỷ lệ sinh lời", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_tests)
doc <- officer::body_add_par(doc, "Bảng 1.x. Ước lượng VaR và ES lịch sử", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_var_es)

# Figures
doc <- officer::body_add_par(doc, "Figures", style = "heading 1")
doc <- add_plot_if_exists(doc, "Hình 1.1. Chuỗi giá và chuỗi tỷ lệ sinh lời logarit", "fig_1_1_price_logreturn.png", 6.5, 4.5)
doc <- add_plot_if_exists(doc, "Hình 1.2. Quan hệ giữa tỷ lệ sinh lời giản đơn và logarit", "fig_1_2_simple_vs_log_return.png", 6.4, 4.2)
doc <- add_plot_if_exists(doc, "Hình 1.3. Từ giá tài sản đến phân phối tổn thất", "fig_1_3_price_to_loss_distribution.png", 6.8, 2.1)
doc <- add_plot_if_exists(doc, "Hình 1.4. Từ chuỗi giá sang tỷ lệ sinh lời và vùng đuôi trái", "fig_1_4_return_language_left_tail.png", 6.6, 4.3)
doc <- add_plot_if_exists(doc, "Hình 1.5. Biến động trượt của tỷ lệ sinh lời logarit", "fig_1_5_rolling_volatility.png", 6.6, 4.0)
doc <- add_plot_if_exists(doc, "Hình 1.6. Hình dạng phân phối tỷ lệ sinh lời", "fig_1_6_histogram_qqplot.png", 6.8, 4.1)
doc <- add_plot_if_exists(doc, "Hình 1.x. Minh họa các ngày lỗ vượt ngưỡng VaR lịch sử", "fig_1_x_var_exceedance.png", 6.6, 4.0)

out_docx <- file.path(DOC_DIR, "ch01_tables_figures_estimates.docx")
print(doc, target = out_docx)
message("Saved Word report: ", out_docx)
