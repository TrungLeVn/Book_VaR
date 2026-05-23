if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch07_var_es_pipeline.R.", call. = FALSE)
}

run_ch07_var_es_pipeline <- function(data_path = NULL, force = NULL, estimation_window = 500, holding_period = 1, alpha_levels = c(0.05, 0.01), refit_every = 25, pot_threshold_prob = 0.90, run_garch_models = TRUE, backtest_buffer = 100) {
  output_dir <- bookvar_derived_path("ch07")
  bookvar_ensure_dir(output_dir)

  ch05_result <- run_ch05_data_pipeline(
    data_path = data_path,
    estimation_window = estimation_window,
    holding_period = holding_period,
    alpha_levels = alpha_levels,
    refit_every = refit_every,
    pot_threshold_prob = pot_threshold_prob,
    backtest_buffer = backtest_buffer
  )

  vn_daily <- ch05_result$vn_daily
  metadata <- ch05_result$metadata

  hs_forecasts <- do.call(rbind, lapply(alpha_levels, function(alpha) {
    bookvar_rolling_historical_var_es(vn_daily$ret, vn_daily$date, alpha, estimation_window)
  }))

  normal_forecasts <- do.call(rbind, lapply(alpha_levels, function(alpha) {
    bookvar_rolling_parametric_var_es(vn_daily$ret, vn_daily$date, alpha, estimation_window, dist = "normal")
  }))

  student_forecasts <- do.call(rbind, lapply(alpha_levels, function(alpha) {
    bookvar_rolling_parametric_var_es(vn_daily$ret, vn_daily$date, alpha, estimation_window, dist = "student")
  }))

  ewma_forecasts <- do.call(rbind, lapply(alpha_levels, function(alpha) {
    bookvar_rolling_ewma_var_es(vn_daily$ret, vn_daily$date, alpha, estimation_window, lambda = 0.94)
  }))

  garch_spec_t <- bookvar_make_var_garch_spec("sGARCH", "std")
  gjr_spec_t <- bookvar_make_var_garch_spec("gjrGARCH", "std")

  garch_forecasts <- bookvar_run_ugarchroll_var(
    vn_daily$ret, vn_daily$date, garch_spec_t,
    "GARCH-t", estimation_window, refit_every, alpha_levels,
    run_garch_models = run_garch_models
  )

  gjr_forecasts <- bookvar_run_ugarchroll_var(
    vn_daily$ret, vn_daily$date, gjr_spec_t,
    "GJR-GARCH-t", estimation_window, refit_every, alpha_levels,
    run_garch_models = run_garch_models
  )

  qr_forecasts <- do.call(rbind, lapply(alpha_levels, function(alpha) {
    bookvar_rolling_quantile_regression_var(vn_daily, alpha, estimation_window)
  }))

  evt_forecasts <- do.call(rbind, lapply(alpha_levels, function(alpha) {
    bookvar_rolling_evt_pot_var_es(vn_daily$loss, vn_daily$date, alpha, estimation_window, pot_threshold_prob)
  }))

  all_forecasts <- do.call(
    rbind,
    list(hs_forecasts, normal_forecasts, student_forecasts, ewma_forecasts, garch_forecasts, gjr_forecasts, qr_forecasts, evt_forecasts)
  )
  all_forecasts$alpha_label <- dplyr::recode(as.character(all_forecasts$alpha), "0.05" = "95%", "0.01" = "99%")

  eval_data <- bookvar_build_eval_data(all_forecasts, vn_daily, metadata$backtest_start)

  model_summary <- data.frame(
    `Mô hình` = c(
      "Historical simulation",
      "Normal rolling",
      "Student-t rolling",
      "EWMA-normal",
      "GARCH-t",
      "GJR-GARCH-t",
      "Quantile regression",
      "EVT-POT"
    ),
    `Loại phương pháp` = c(
      "Phi tham số",
      "Tham số tĩnh rolling",
      "Tham số đuôi dày rolling",
      "Volatility động",
      "Volatility động",
      "Volatility động bất đối xứng",
      "Bán tham số",
      "Extreme value"
    ),
    `Giả định chính` = c(
      "Phân phối quá khứ gần đại diện cho phân phối ngày tới",
      "Tỷ lệ sinh lời có điều kiện xấp xỉ chuẩn",
      "Tỷ lệ sinh lời có điều kiện có đuôi dày Student-t",
      "Volatility cập nhật theo trọng số hàm mũ",
      "Phương sai có điều kiện GARCH; innovation Student-t",
      "Cú sốc âm có thể làm volatility tăng mạnh hơn; innovation Student-t",
      "VaR là conditional quantile phụ thuộc biến trạng thái",
      "Đuôi phân phối lỗ tuân theo GPD trên ngưỡng cao"
    ),
    `ES được tính trong chương` = c("Có", "Có", "Có", "Có", "Không", "Không", "Không", "Có"),
    check.names = FALSE
  )

  hs_plot_data <- merge(
    subset(hs_forecasts, alpha == 0.01 & date >= metadata$backtest_start),
    vn_daily[, c("date", "loss"), drop = FALSE],
    by = "date",
    all.x = TRUE
  )

  param_plot_data <- merge(
    subset(
      rbind(normal_forecasts, student_forecasts, ewma_forecasts, garch_forecasts, gjr_forecasts),
      alpha == 0.01 & date >= metadata$backtest_start
    ),
    vn_daily[, c("date", "loss"), drop = FALSE],
    by = "date",
    all.x = TRUE
  )

  semi_plot_data <- merge(
    subset(
      rbind(qr_forecasts, evt_forecasts, hs_forecasts),
      alpha == 0.01 & date >= metadata$backtest_start
    ),
    vn_daily[, c("date", "loss"), drop = FALSE],
    by = "date",
    all.x = TRUE
  )

  result <- list(
    pipeline = "ch07_var_es_pipeline",
    status = "ready_for_local_testing",
    force_recompute = bookvar_should_recompute(force),
    depends_on = c("ch05_data_pipeline"),
    output_dir = output_dir,
    planned_output_paths = c(
      file.path(output_dir, "all_forecasts.rds"),
      file.path(output_dir, "all_forecasts.meta.yml"),
      file.path(output_dir, "model_summary.rds"),
      file.path(output_dir, "model_summary.meta.yml"),
      file.path(output_dir, "backtesting_summary.rds"),
      file.path(output_dir, "backtesting_summary.meta.yml"),
      file.path(output_dir, "tail_severity.rds"),
      file.path(output_dir, "tail_severity.meta.yml")
    ),
    vn_daily = vn_daily,
    metadata = metadata,
    hs_forecasts = hs_forecasts,
    normal_forecasts = normal_forecasts,
    student_forecasts = student_forecasts,
    ewma_forecasts = ewma_forecasts,
    garch_forecasts = garch_forecasts,
    gjr_forecasts = gjr_forecasts,
    qr_forecasts = qr_forecasts,
    evt_forecasts = evt_forecasts,
    all_forecasts = all_forecasts,
    eval_data = eval_data,
    model_summary = model_summary,
    backtesting_summary = bookvar_build_backtesting_summary(eval_data),
    tail_severity = bookvar_build_tail_severity_summary(eval_data),
    hs_plot_data = hs_plot_data,
    param_plot_data = param_plot_data,
    semi_plot_data = semi_plot_data
  )

  # TODO: After local RStudio testing, enable cache saving with bookvar_save_cached()
  # under data/derived/ch07/. Recommended targets:
  #   data/derived/ch07/all_forecasts.rds
  #   data/derived/ch07/model_summary.rds
  #   data/derived/ch07/backtesting_summary.rds
  #   data/derived/ch07/tail_severity.rds
  #
  # TODO: Align the final Ch. 7 model set with the Ch. 6 shortlist before connecting
  # these objects to the active chapter.

  result
}
