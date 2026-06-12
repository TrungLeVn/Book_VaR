# ============================================================
# 04_estimates.R
# Descriptive statistics, diagnostics, VaR/ES estimates
# ============================================================

x <- price_data$log_return
loss <- -x

# ---- Descriptive statistics ---------------------------------
desc_stats <- tibble::tibble(
  n = length(stats::na.omit(x)),
  mean = mean(x, na.rm = TRUE),
  sd = stats::sd(x, na.rm = TRUE),
  min = min(x, na.rm = TRUE),
  q01 = as.numeric(stats::quantile(x, 0.01, na.rm = TRUE)),
  q05 = as.numeric(stats::quantile(x, 0.05, na.rm = TRUE)),
  median = stats::median(x, na.rm = TRUE),
  q95 = as.numeric(stats::quantile(x, 0.95, na.rm = TRUE)),
  q99 = as.numeric(stats::quantile(x, 0.99, na.rm = TRUE)),
  max = max(x, na.rm = TRUE),
  skewness = skewness_manual(x),
  kurtosis = kurtosis_manual(x),
  excess_kurtosis = kurtosis_manual(x) - 3
)

readr::write_csv(desc_stats, file.path(EST_DIR, "desc_stats_log_return.csv"))

ft_desc <- desc_stats |>
  dplyr::mutate(dplyr::across(where(is.numeric), ~ round(.x, 6))) |>
  flextable::flextable() |>
  format_ft(font_size = 8.5)

save_ft_docx(ft_desc, "Bảng 1.x. Thống kê mô tả tỷ lệ sinh lời logarit", "tbl_desc_stats_log_return.docx")

# ---- Diagnostic tests ---------------------------------------
normality_jb <- function(x) {
  x <- stats::na.omit(x)
  n <- length(x)
  s <- skewness_manual(x)
  k <- kurtosis_manual(x)
  jb <- n / 6 * (s^2 + (k - 3)^2 / 4)
  p <- stats::pchisq(jb, df = 2, lower.tail = FALSE)
  tibble::tibble(test = "Jarque-Bera", statistic = jb, p_value = p, null = "Normality")
}

extract_test <- function(obj, test_name, null_name) {
  if (length(obj) == 1 && is.na(obj)) {
    return(tibble::tibble(test = test_name, statistic = NA_real_, p_value = NA_real_, null = null_name))
  }
  tibble::tibble(
    test = test_name,
    statistic = as.numeric(obj$statistic[1]),
    p_value = as.numeric(obj$p.value),
    null = null_name
  )
}

lag_lb <- min(20, floor(length(x) / 5))
lag_arch <- min(12, floor(length(x) / 10))

diagnostic_tests <- dplyr::bind_rows(
  normality_jb(x),
  extract_test(stats::Box.test(x, lag = lag_lb, type = "Ljung-Box"), paste0("Ljung-Box return, lag ", lag_lb), "No autocorrelation"),
  extract_test(stats::Box.test(x^2, lag = lag_lb, type = "Ljung-Box"), paste0("Ljung-Box squared return, lag ", lag_lb), "No autocorrelation"),
  extract_test(safe_test(tseries::adf.test(x)), "ADF", "Unit root"),
  extract_test(safe_test(tseries::pp.test(x)), "Phillips-Perron", "Unit root"),
  extract_test(safe_test(tseries::kpss.test(x)), "KPSS", "Stationarity"),
  extract_test(safe_test(FinTS::ArchTest(x, lags = lag_arch)), paste0("ARCH-LM, lag ", lag_arch), "No ARCH effect")
) |>
  dplyr::mutate(
    statistic = round(statistic, 4),
    p_value = round(p_value, 4)
  )

readr::write_csv(diagnostic_tests, file.path(EST_DIR, "diagnostic_tests_log_return.csv"))

ft_tests <- diagnostic_tests |>
  flextable::flextable() |>
  format_ft(font_size = 9)

save_ft_docx(ft_tests, "Bảng 1.x. Kiểm định chẩn đoán sơ bộ chuỗi tỷ lệ sinh lời", "tbl_diagnostic_tests.docx")

# ---- Simple VaR and ES estimates ----------------------------
var_es_estimates <- purrr::map_dfr(VAR_LEVELS, function(cl) {
  alpha <- 1 - cl
  q_return <- as.numeric(stats::quantile(x, probs = alpha, na.rm = TRUE, type = 7))
  var_rate <- -q_return
  es_rate <- -mean(x[x <= q_return], na.rm = TRUE)

  tibble::tibble(
    confidence_level = cl,
    tail_probability = alpha,
    return_quantile = q_return,
    VaR_rate = var_rate,
    ES_rate = es_rate,
    VaR_money = POSITION_VALUE * var_rate,
    ES_money = POSITION_VALUE * es_rate
  )
})

readr::write_csv(var_es_estimates, file.path(EST_DIR, "historical_var_es.csv"))

ft_var_es <- var_es_estimates |>
  dplyr::mutate(
    confidence_level = scales::percent(confidence_level, accuracy = 1),
    tail_probability = scales::percent(tail_probability, accuracy = 1),
    return_quantile = scales::percent(return_quantile, accuracy = 0.01),
    VaR_rate = scales::percent(VaR_rate, accuracy = 0.01),
    ES_rate = scales::percent(ES_rate, accuracy = 0.01),
    VaR_money = scales::comma(round(VaR_money, 0), big.mark = ".", decimal.mark = ","),
    ES_money = scales::comma(round(ES_money, 0), big.mark = ".", decimal.mark = ",")
  ) |>
  flextable::flextable() |>
  format_ft(font_size = 8.8)

save_ft_docx(ft_var_es, "Bảng 1.x. Ước lượng VaR và ES lịch sử", "tbl_historical_var_es.docx")

# ---- VaR exceedance plot ------------------------------------
var_99_rate <- var_es_estimates |>
  dplyr::filter(confidence_level == max(VAR_LEVELS)) |>
  dplyr::pull(VaR_rate)

var_plot_data <- price_data |>
  dplyr::mutate(
    loss_rate = -log_return,
    VaR_rate = var_99_rate,
    exceedance = loss_rate > VaR_rate
  )

fig_var_exceedance <- ggplot2::ggplot(var_plot_data, ggplot2::aes(x = Date)) +
  ggplot2::geom_line(ggplot2::aes(y = loss_rate), linewidth = 0.30) +
  ggplot2::geom_hline(yintercept = var_99_rate, linetype = "dashed", linewidth = 0.45) +
  ggplot2::geom_point(
    data = dplyr::filter(var_plot_data, exceedance),
    ggplot2::aes(y = loss_rate),
    size = 1.2
  ) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::labs(
    title = "Hình 1.x. Minh họa các ngày lỗ vượt ngưỡng VaR lịch sử",
    x = NULL,
    y = "Tỷ lệ lỗ",
    caption = paste0(data_note, " Đường đứt nét là VaR lịch sử ở mức tin cậy ", scales::percent(max(VAR_LEVELS), accuracy = 1), ".")
  ) +
  theme_ch01()

save_plot_png(fig_var_exceedance, "fig_1_x_var_exceedance.png", width = 7.5, height = 4.5)
