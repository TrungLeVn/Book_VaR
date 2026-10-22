# ============================================================
# Chapter 1 export script (not for printed appendix)
# Run after: 00_ch01_setup.R and 01_ch01_appendix_tables_figures.R
# ============================================================

# ---- Export tables -----------------------------------------
readr::write_csv(tbl_1_1, file.path(TAB_DIR, "tbl_1_1_price_return.csv"))
readr::write_csv(tbl_1_1_display, file.path(TAB_DIR, "tbl_1_1_price_return_display.csv"))
readr::write_csv(tbl_1_2_display, file.path(TAB_DIR, "tbl_1_2_simple_vs_log_return.csv"))
readr::write_csv(tbl_1_3_display, file.path(TAB_DIR, "tbl_1_3_descriptive_statistics.csv"))

save_table_docx(
  tbl_1_1_display,
  "Bảng 1.1. So sánh thay đổi giá và tỷ suất sinh lời của hai tài sản",
  "Nguồn: Ví dụ minh họa của tác giả.",
  "tbl_1_1_price_return.docx"
)

save_table_docx(
  tbl_1_2_display,
  "Bảng 1.2. So sánh tỷ suất sinh lời giản đơn và tỷ suất sinh lời logarit",
  "Nguồn: Tác giả tổng hợp.",
  "tbl_1_2_simple_vs_log_return.docx"
)

save_table_docx(
  tbl_1_3_display,
  "Bảng 1.3. Ý nghĩa của một số thống kê mô tả trong phân tích tỷ suất sinh lời",
  "Nguồn: Tổng hợp của tác giả.",
  "tbl_1_3_descriptive_statistics.docx"
)

# ---- Export figures ----------------------------------------
save_plot(fig_1_1, "fig_1_1_price_and_return.png", width = 8, height = 6)
save_plot(fig_1_2, "fig_1_2_sp500_empirical_vs_normal.png", width = 8, height = 5)
save_plot(fig_1_3, "fig_1_3_rolling_volatility.png", width = 8, height = 5)
save_plot(fig_1_4, "fig_1_4_var_loss_distribution.png", width = 8, height = 5)
save_plot(fig_1_5, "fig_1_5_var_return_distribution.png", width = 8, height = 5)
save_plot(fig_1_6, "fig_1_6_var_es_loss_distribution.png", width = 8.6, height = 5.6)

# ---- Export figure/table register --------------------------
ch01_register <- tibble::tribble(
  ~type, ~number, ~title, ~file,
  "table", "Bảng 1.1", "So sánh thay đổi giá và tỷ suất sinh lời của hai tài sản", "tbl_1_1_price_return.docx",
  "table", "Bảng 1.2", "So sánh tỷ suất sinh lời giản đơn và tỷ suất sinh lời logarit", "tbl_1_2_simple_vs_log_return.docx",
  "table", "Bảng 1.3", "Ý nghĩa của một số thống kê mô tả trong phân tích tỷ suất sinh lời", "tbl_1_3_descriptive_statistics.docx",
  "figure", "Hình 1.1", "So sánh chuỗi giá và chuỗi tỷ suất sinh lời của cùng một tài sản", "fig_1_1_price_and_return.png",
  "figure", "Hình 1.2", "Phân phối thực nghiệm của tỷ suất sinh lời logarit ngày S&P 500", "fig_1_2_sp500_empirical_vs_normal.png",
  "figure", "Hình 1.3", "Minh họa biến động tỷ suất sinh lời theo cửa sổ trượt", "fig_1_3_rolling_volatility.png",
  "figure", "Hình 1.4", "Giá trị VaR với phân phối tỷ lệ tổn thất", "fig_1_4_var_loss_distribution.png",
  "figure", "Hình 1.5", "Giá trị VaR với phân phối tỷ suất sinh lời", "fig_1_5_var_return_distribution.png",
  "figure", "Hình 1.6", "Giá trị ES với phân phối tỷ lệ tổn thất", "fig_1_6_var_es_loss_distribution.png"
)

readr::write_csv(ch01_register, file.path(OUT_DIR, "ch01_figure_table_register.csv"))

message("Chapter 1 outputs exported to: ", normalizePath(OUT_DIR, mustWork = FALSE))
