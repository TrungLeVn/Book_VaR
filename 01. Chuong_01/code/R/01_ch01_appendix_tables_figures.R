# ============================================================
# Chapter 1 technical appendix code: tables and figures only
# This file intentionally excludes package installation and export.
# Run after: 00_ch01_setup.R
# ============================================================

set.seed(20260703)

# ============================================================
# TABLE 1.1. Price change and return
# ============================================================

tbl_1_1 <- tibble::tribble(
  ~`Tài sản`, ~`Giá đầu kỳ`, ~`Giá cuối kỳ`,
  "A",  20000,  22000,
  "B", 200000, 202000
) |>
  dplyr::mutate(
    `Thay đổi giá` = `Giá cuối kỳ` - `Giá đầu kỳ`,
    `Tỷ suất sinh lời` = (`Giá cuối kỳ` - `Giá đầu kỳ`) / `Giá đầu kỳ`
  )

tbl_1_1_display <- tbl_1_1 |>
  dplyr::mutate(
    dplyr::across(
      c(`Giá đầu kỳ`, `Giá cuối kỳ`, `Thay đổi giá`),
      ~ scales::number(.x, accuracy = 1, big.mark = ".", decimal.mark = ",")
    ),
    `Tỷ suất sinh lời` = scales::percent(`Tỷ suất sinh lời`, accuracy = 1)
  )

# ============================================================
# TABLE 1.2. Simple return versus log return
# ============================================================

tbl_1_2_display <- tibble::tribble(
  ~`Tiêu chí`, ~`Tỷ suất sinh lời giản đơn`, ~`Tỷ suất sinh lời logarit`,
  "Công thức cơ bản", "R_t = P_t / P_{t-1} - 1", "r_t = ln(P_t / P_{t-1})",
  "Diễn giải kinh tế", "Trực quan, phản ánh lãi/lỗ tương đối trong một kỳ", "Ít trực quan hơn, nhưng thuận tiện về mặt toán học",
  "Tổng hợp theo thời gian", "Tổng hợp bằng phép nhân lãi kép", "Có thể cộng trực tiếp qua thời gian",
  "Tổng hợp theo danh mục", "Danh mục là trung bình gia quyền của return thành phần", "Không có tính chất trung bình gia quyền chính xác",
  "Phù hợp nhất khi", "Phân tích hiệu quả đầu tư, lãi/lỗ danh mục, phân bổ tài sản", "Mô hình hóa chuỗi thời gian, volatility, GARCH, VaR"
)

# ============================================================
# TABLE 1.3. Descriptive statistics and risk interpretation
# ============================================================

tbl_1_3_display <- tibble::tribble(
  ~`Thống kê`, ~`Ý nghĩa thống kê`, ~`Ý nghĩa trong đo lường rủi ro`,
  "Trung bình", "Mức sinh lời trung tâm của chuỗi", "Cho biết xu hướng sinh lời bình quân, nhưng thường ít quan trọng hơn biến động trong dữ liệu ngày",
  "Độ lệch chuẩn", "Mức độ phân tán quanh trung bình", "Thước đo biến động cơ bản; là đầu vào của nhiều mô hình VaR tham số",
  "Độ lệch", "Mức độ bất đối xứng của phân phối", "Độ lệch âm hàm ý rủi ro đuôi trái lớn hơn",
  "Độ nhọn", "Mức độ nhọn và độ dày của đuôi phân phối", "Độ nhọn lớn hơn 3 hàm ý xác suất biến động cực đoan cao hơn so với phân phối chuẩn",
  "Phân vị thấp", "Giá trị nằm ở vùng đuôi trái của phân phối", "Liên quan trực tiếp đến VaR và ES"
)

# ============================================================
# FIGURE 1.1. Price series and return series
# ============================================================

n_obs <- 260
ret_1_1 <- c(
  rnorm(120, mean = 0.0004, sd = 0.007),
  rnorm(60,  mean = -0.0002, sd = 0.020),
  rnorm(80,  mean = 0.0005, sd = 0.009)
)
price_1_1 <- 100 * exp(cumsum(ret_1_1))

fig_1_1_data <- tibble::tibble(
  time = seq_len(n_obs),
  price = price_1_1,
  log_return = ret_1_1
)

fig_1_1_price <- ggplot2::ggplot(fig_1_1_data, ggplot2::aes(x = time, y = price)) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::labs(x = NULL, y = "Giá tài sản", title = "Chuỗi giá") +
  theme_ch01()

fig_1_1_return <- ggplot2::ggplot(fig_1_1_data, ggplot2::aes(x = time, y = log_return)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.4) +
  ggplot2::geom_line(linewidth = 0.7) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  ggplot2::labs(x = "Thời gian", y = "Tỷ suất sinh lời logarit", title = "Chuỗi tỷ suất sinh lời") +
  theme_ch01()

fig_1_1 <- fig_1_1_price / fig_1_1_return +
  patchwork::plot_annotation(
    title = "Hình 1.1. So sánh chuỗi giá và chuỗi tỷ suất sinh lời của cùng một tài sản",
    caption = "Nguồn: Ví dụ minh họa của tác giả."
  )

# ============================================================
# FIGURE 1.2. Empirical log-return distribution versus normal
# ============================================================

sp500_symbol <- "^GSPC"
sp500_start_date <- as.Date("2000-01-01")
sp500_end_date <- as.Date("2026-07-02")

sp500_raw <- quantmod::getSymbols(
  Symbols = sp500_symbol,
  src = "yahoo",
  from = sp500_start_date,
  to = sp500_end_date,
  auto.assign = FALSE
)

sp500_return <- diff(log(quantmod::Ad(sp500_raw))) |>
  stats::na.omit()

sp500_df <- tibble::tibble(
  date = as.Date(zoo::index(sp500_return)),
  r = as.numeric(sp500_return)
)

sp500_mu <- mean(sp500_df$r, na.rm = TRUE)
sp500_sd <- stats::sd(sp500_df$r, na.rm = TRUE)

sp500_normal_df <- tibble::tibble(
  r = seq(min(sp500_df$r), max(sp500_df$r), length.out = 2000),
  density = stats::dnorm(r, mean = sp500_mu, sd = sp500_sd)
)

fig_1_2 <- ggplot2::ggplot(sp500_df, ggplot2::aes(x = r)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    bins = 100,
    alpha = 0.35,
    color = "white"
  ) +
  ggplot2::geom_density(ggplot2::aes(linetype = "Phân phối thực nghiệm"), linewidth = 1) +
  ggplot2::geom_line(
    data = sp500_normal_df,
    ggplot2::aes(x = r, y = density, linetype = "Phân phối chuẩn tham chiếu"),
    linewidth = 1
  ) +
  ggplot2::scale_x_continuous(labels = scales::label_percent(accuracy = 1)) +
  ggplot2::scale_linetype_manual(
    name = NULL,
    values = c("Phân phối thực nghiệm" = "solid", "Phân phối chuẩn tham chiếu" = "dashed")
  ) +
  ggplot2::labs(
    title = "Hình 1.2. Phân phối thực nghiệm của tỷ suất sinh lời logarit ngày S&P 500",
    subtitle = "So sánh với phân phối chuẩn có cùng trung bình và độ lệch chuẩn mẫu",
    x = "Tỷ suất sinh lời logarit ngày",
    y = "Mật độ",
    caption = paste0(
      "Nguồn: Yahoo Finance, tải bằng R. Ký hiệu: ", sp500_symbol,
      ". Giai đoạn: ", min(sp500_df$date), " đến ", max(sp500_df$date),
      ". Đường đứt nét là phân phối chuẩn tham chiếu."
    )
  ) +
  theme_ch01()

# ============================================================
# FIGURE 1.3. Rolling volatility
# ============================================================

fig_1_3_data <- fig_1_1_data |>
  dplyr::mutate(
    rolling_vol = zoo::rollapplyr(
      log_return,
      width = 30,
      FUN = stats::sd,
      fill = NA
    )
  )

fig_1_3 <- ggplot2::ggplot(fig_1_3_data, ggplot2::aes(x = time, y = rolling_vol)) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 0.1)) +
  ggplot2::labs(
    title = "Hình 1.3. Minh họa biến động tỷ suất sinh lời theo cửa sổ trượt",
    subtitle = "Độ lệch chuẩn trượt 30 phiên của chuỗi tỷ suất sinh lời mô phỏng",
    x = "Thời gian",
    y = "Biến động trượt",
    caption = "Nguồn: Ví dụ minh họa của tác giả."
  ) +
  theme_ch01()

# ============================================================
# FIGURES 1.4 and 1.5. VaR from loss and return distributions
# ============================================================

meanlog_var <- log(0.0115)
sdlog_var <- 0.55

loss_var_df <- tibble::tibble(
  loss = seq(0, 0.08, length.out = 2000),
  density = stats::dlnorm(loss, meanlog = meanlog_var, sdlog = sdlog_var)
)

var99_loss <- stats::qlnorm(0.99, meanlog = meanlog_var, sdlog = sdlog_var)
loss_tail_df <- dplyr::filter(loss_var_df, loss >= var99_loss)

fig_1_4 <- ggplot2::ggplot(loss_var_df, ggplot2::aes(x = loss, y = density)) +
  ggplot2::geom_area(data = loss_tail_df, fill = "grey80") +
  ggplot2::geom_line(linewidth = 1) +
  ggplot2::geom_vline(xintercept = var99_loss, linetype = "dashed", linewidth = 1) +
  ggplot2::annotate("text", x = var99_loss + 0.002, y = max(loss_var_df$density) * 0.60,
                    label = "VaR 99%", hjust = 0, size = 6) +
  ggplot2::scale_x_continuous(labels = percent_vn, breaks = seq(0, 0.08, 0.02), limits = c(0, 0.08)) +
  ggplot2::labs(
    title = "Hình 1.4. Giá trị VaR với phân phối tỷ lệ tổn thất",
    subtitle = "Phân vị phải 99% là ngưỡng mà xác suất tổn thất vượt qua bằng 1%",
    x = "Tỷ lệ lỗ của danh mục",
    y = "Mật độ xác suất tương đối",
    caption = "Nguồn: Minh họa của tác giả."
  ) +
  theme_ch01()

return_var_df <- tibble::tibble(
  return = seq(-0.08, 0, length.out = 2000),
  density = stats::dlnorm(-return, meanlog = meanlog_var, sdlog = sdlog_var)
)

var99_return <- -var99_loss
return_tail_df <- dplyr::filter(return_var_df, return <= var99_return)

fig_1_5 <- ggplot2::ggplot(return_var_df, ggplot2::aes(x = return, y = density)) +
  ggplot2::geom_area(data = return_tail_df, fill = "grey80") +
  ggplot2::geom_line(linewidth = 1) +
  ggplot2::geom_vline(xintercept = var99_return, linetype = "dashed", linewidth = 1) +
  ggplot2::annotate("text", x = var99_return - 0.002, y = max(return_var_df$density) * 0.60,
                    label = "VaR 99%", hjust = 1, size = 6) +
  ggplot2::scale_x_continuous(labels = percent_vn, breaks = seq(-0.08, 0, 0.02), limits = c(-0.08, 0)) +
  ggplot2::labs(
    title = "Hình 1.5. Giá trị VaR với phân phối tỷ suất sinh lời",
    subtitle = "Phân vị trái 1% là ngưỡng mà xác suất tỷ suất sinh lời thấp hơn bằng 1%",
    x = "Tỷ suất sinh lời của danh mục",
    y = "Mật độ xác suất tương đối",
    caption = "Nguồn: Minh họa của tác giả."
  ) +
  theme_ch01()

# ============================================================
# FIGURE 1.6. VaR and Expected Shortfall
# ============================================================

alpha <- 0.99
w_main <- 0.94
w_tail <- 0.06
shape_main <- 7
scale_main <- 0.0042
shape_tail <- 18
scale_tail <- 0.0048

loss_es_df <- tibble::tibble(
  loss = seq(0, 0.20, length.out = 3000),
  density = w_main * stats::dgamma(loss, shape = shape_main, scale = scale_main) +
    w_tail * stats::dgamma(loss, shape = shape_tail, scale = scale_tail)
)

# Quantile and ES are computed by simulation because the mixture has no closed-form quantile.
loss_es_sample <- {
  n <- 400000
  u <- stats::runif(n)
  ifelse(
    u <= w_main,
    stats::rgamma(n, shape = shape_main, scale = scale_main),
    stats::rgamma(n, shape = shape_tail, scale = scale_tail)
  )
}

var99_es <- as.numeric(stats::quantile(loss_es_sample, probs = alpha))
es99 <- mean(loss_es_sample[loss_es_sample >= var99_es])
loss_es_tail_df <- dplyr::filter(loss_es_df, loss >= var99_es)

fig_1_6 <- ggplot2::ggplot(loss_es_df, ggplot2::aes(x = loss, y = density)) +
  ggplot2::geom_area(data = loss_es_tail_df, fill = "grey70") +
  ggplot2::geom_line(linewidth = 1) +
  ggplot2::geom_vline(xintercept = var99_es, linetype = "dashed", linewidth = 1) +
  ggplot2::geom_vline(xintercept = es99, linetype = "dotted", linewidth = 1) +
  ggplot2::annotate("label", x = var99_es - 0.010, y = max(loss_es_df$density) * 0.36,
                    label = paste0("VaR 99%\n", scales::percent(var99_es, accuracy = 0.1)), size = 4.5) +
  ggplot2::annotate("label", x = es99 + 0.010, y = max(loss_es_df$density) * 0.43,
                    label = paste0("ES 99%\n", scales::percent(es99, accuracy = 0.1)), size = 4.5) +
  ggplot2::annotate("text", x = es99 + 0.028, y = max(loss_es_df$density) * 0.20,
                    label = "Vùng tổn thất vượt VaR", hjust = 0, size = 4.8) +
  ggplot2::scale_x_continuous(labels = percent_vn, breaks = seq(0, 0.20, 0.05), limits = c(0, 0.20)) +
  ggplot2::labs(
    title = "Hình 1.6. Giá trị ES với phân phối tỷ lệ tổn thất",
    subtitle = "VaR là ngưỡng phân vị; ES là mức tổn thất trung bình trong vùng vượt VaR",
    x = "Tỷ lệ lỗ",
    y = "Mật độ xác suất",
    caption = "Nguồn: Minh họa của tác giả."
  ) +
  theme_ch01()
