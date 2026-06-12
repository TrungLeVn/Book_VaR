# ============================================================
# 03_figures.R
# Figures for Chapter 1
# ============================================================

# ---- Figure 1.1: price and log return -----------------------
p_price <- ggplot2::ggplot(price_data, ggplot2::aes(x = Date, y = Price)) +
  ggplot2::geom_line(linewidth = 0.35) +
  ggplot2::labs(
    title = "Panel A. Chuỗi giá",
    x = NULL,
    y = "Giá/chỉ số"
  ) +
  theme_ch01()

p_return <- ggplot2::ggplot(price_data, ggplot2::aes(x = Date, y = log_return)) +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_line(linewidth = 0.30) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::labs(
    title = "Panel B. Tỷ lệ sinh lời logarit",
    x = NULL,
    y = "Log return"
  ) +
  theme_ch01()

fig_1_1 <- p_price / p_return +
  patchwork::plot_annotation(
    title = "Hình 1.1. Chuỗi giá và chuỗi tỷ lệ sinh lời logarit",
    caption = data_note
  )

save_plot_png(fig_1_1, "fig_1_1_price_logreturn.png", width = 7.5, height = 5.2)

# ---- Figure 1.2: simple vs log return -----------------------
return_relation <- tibble::tibble(
  simple_return = seq(-0.30, 0.30, by = 0.001),
  log_return = log1p(simple_return)
)

fig_1_2 <- ggplot2::ggplot(return_relation, ggplot2::aes(x = simple_return, y = log_return)) +
  ggplot2::geom_abline(intercept = 0, slope = 1, linetype = "dashed", linewidth = 0.5) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::labs(
    title = "Hình 1.2. Quan hệ giữa tỷ lệ sinh lời giản đơn và logarit",
    subtitle = "Đường đứt nét là đường 45 độ: log return xấp xỉ simple return khi mức sinh lời nhỏ",
    x = "Tỷ lệ sinh lời giản đơn",
    y = "Tỷ lệ sinh lời logarit",
    caption = "Ghi chú: Hình minh họa r_t = ln(1 + R_t). Khi |R_t| lớn, chênh lệch giữa hai thước đo tăng lên."
  ) +
  theme_ch01()

save_plot_png(fig_1_2, "fig_1_2_simple_vs_log_return.png", width = 7.2, height = 4.8)

# ---- Figure 1.3: price to loss distribution -----------------
flow_nodes <- tibble::tibble(
  id = 1:7,
  label = c(
    "Giá tài sản",
    "Giá điều chỉnh",
    "Tỷ lệ sinh lời",
    "P&L vị thế",
    "Biến tổn thất",
    "Phân phối tổn thất",
    "Volatility,\nVaR, ES"
  ),
  x = 1:7,
  y = 1
)

flow_edges <- tibble::tibble(
  x = flow_nodes$x[-nrow(flow_nodes)] + 0.36,
  xend = flow_nodes$x[-1] - 0.36,
  y = 1,
  yend = 1
)

fig_1_3 <- ggplot2::ggplot() +
  ggplot2::geom_segment(
    data = flow_edges,
    ggplot2::aes(x = x, xend = xend, y = y, yend = yend),
    arrow = grid::arrow(length = grid::unit(0.16, "inches")),
    linewidth = 0.45
  ) +
  ggplot2::geom_rect(
    data = flow_nodes,
    ggplot2::aes(xmin = x - 0.36, xmax = x + 0.36, ymin = y - 0.20, ymax = y + 0.20),
    fill = "white",
    color = "black",
    linewidth = 0.45
  ) +
  ggplot2::geom_text(
    data = flow_nodes,
    ggplot2::aes(x = x, y = y, label = stringr::str_wrap(label, width = 12)),
    size = 3.3,
    lineheight = 0.9
  ) +
  ggplot2::annotate(
    "text", x = 2, y = 0.55,
    label = "Xử lý cổ tức,\nchia tách, quyền mua",
    size = 3,
    lineheight = 0.9
  ) +
  ggplot2::annotate(
    "segment", x = 2, xend = 2, y = 0.70, yend = 0.82,
    arrow = grid::arrow(length = grid::unit(0.12, "inches")),
    linewidth = 0.35
  ) +
  ggplot2::annotate(
    "text", x = 4.5, y = 0.55,
    label = "Quy mô vị thế,\ndấu vị thế, kỳ nắm giữ",
    size = 3,
    lineheight = 0.9
  ) +
  ggplot2::annotate(
    "segment", x = 4.5, xend = 4.5, y = 0.70, yend = 0.82,
    arrow = grid::arrow(length = grid::unit(0.12, "inches")),
    linewidth = 0.35
  ) +
  ggplot2::labs(
    title = "Hình 1.3. Từ giá tài sản đến phân phối tổn thất",
    caption = "Ghi chú: Sơ đồ mô tả quy trình nền tảng trước khi ước lượng volatility, VaR và ES."
  ) +
  ggplot2::coord_cartesian(xlim = c(0.55, 7.45), ylim = c(0.35, 1.35), expand = FALSE) +
  ggplot2::theme_void(base_size = 12, base_family = "Arial") +
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
    plot.caption = ggplot2::element_text(hjust = 0.5)
  )

save_plot_png(fig_1_3, "fig_1_3_price_to_loss_distribution.png", width = 9.5, height = 2.8)

# ---- Figure 1.4: original return-language figure ------------
p_price_overview <- ggplot2::ggplot(price_data, ggplot2::aes(x = Date, y = Price)) +
  ggplot2::geom_line(linewidth = 0.40) +
  ggplot2::labs(title = "Chuỗi giá", x = NULL, y = "Giá/chỉ số") +
  theme_ch01()

p_return_hist <- ggplot2::ggplot(price_data, ggplot2::aes(x = log_return)) +
  ggplot2::geom_histogram(bins = 32, fill = "grey75", color = "white", linewidth = 0.25) +
  ggplot2::geom_vline(xintercept = 0, linetype = "dashed", linewidth = 0.45) +
  ggplot2::labs(title = "Phân phối tỷ lệ sinh lời", x = "Log return", y = "Tần suất") +
  theme_ch01()

fig_1_4 <- p_price_overview + p_return_hist +
  patchwork::plot_layout(ncol = 2) +
  patchwork::plot_annotation(
    title = "Hình 1.4. Từ chuỗi giá sang tỷ lệ sinh lời và vùng đuôi trái",
    caption = data_note
  )

save_plot_png(fig_1_4, "fig_1_4_return_language_left_tail.png", width = 8.0, height = 5.2)

# ---- Figure 1.5: rolling volatility -------------------------
rolling_data <- price_data |>
  dplyr::mutate(
    rolling_vol = zoo::rollapply(
      log_return,
      width = ROLLING_WINDOW,
      FUN = stats::sd,
      align = "right",
      fill = NA_real_
    )
  )

fig_1_5 <- ggplot2::ggplot(rolling_data, ggplot2::aes(x = Date, y = rolling_vol)) +
  ggplot2::geom_line(linewidth = 0.35) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 0.1)) +
  ggplot2::labs(
    title = paste0("Hình 1.5. Biến động trượt ", ROLLING_WINDOW, " ngày của tỷ lệ sinh lời logarit"),
    x = NULL,
    y = "Rolling volatility",
    caption = data_note
  ) +
  theme_ch01()

save_plot_png(fig_1_5, "fig_1_5_rolling_volatility.png", width = 7.5, height = 4.5)

# ---- Figure 1.6: histogram and QQ plot ----------------------
p_hist <- ggplot2::ggplot(price_data, ggplot2::aes(x = log_return)) +
  ggplot2::geom_histogram(ggplot2::aes(y = after_stat(density)), bins = 45, fill = "grey80", color = "white") +
  ggplot2::geom_density(linewidth = 0.55) +
  ggplot2::labs(title = "Panel A. Histogram và mật độ thực nghiệm", x = "Log return", y = "Mật độ") +
  theme_ch01()

p_qq <- ggplot2::ggplot(price_data, ggplot2::aes(sample = log_return)) +
  ggplot2::stat_qq(size = 1.1) +
  ggplot2::stat_qq_line(linewidth = 0.45) +
  ggplot2::labs(title = "Panel B. Q-Q plot so với phân phối chuẩn", x = "Phân vị chuẩn lý thuyết", y = "Phân vị mẫu") +
  theme_ch01()

fig_1_6 <- p_hist + p_qq +
  patchwork::plot_layout(ncol = 2) +
  patchwork::plot_annotation(
    title = "Hình 1.6. Hình dạng phân phối tỷ lệ sinh lời",
    caption = data_note
  )

save_plot_png(fig_1_6, "fig_1_6_histogram_qqplot.png", width = 8.0, height = 4.8)
