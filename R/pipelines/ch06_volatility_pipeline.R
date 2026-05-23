if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch06_volatility_pipeline.R.", call. = FALSE)
}

run_ch06_volatility_pipeline <- function(data_path = NULL, force = NULL, horizons = c(1, 5, 10, 20), forecast_step = 20, max_forecast_origins = 50) {
  output_dir <- bookvar_derived_path("ch06")
  bookvar_ensure_dir(output_dir)

  ch05_result <- run_ch05_data_pipeline(data_path = data_path)
  vn_raw <- ch05_result$vn_raw
  vn_daily <- ch05_result$vn_daily
  metadata <- ch05_result$metadata
  returns <- vn_daily$ret
  dates <- vn_daily$date

  rolling_panel <- bookvar_build_rolling_volatility_panel(returns, dates)
  ewma_panel <- bookvar_build_ewma_panel(returns, dates)

  fit_garch_norm <- bookvar_fit_garch_safe(returns, model = "sGARCH", dist = "norm")
  fit_garch_std <- bookvar_fit_garch_safe(returns, model = "sGARCH", dist = "std")
  fit_gjr_std <- bookvar_fit_garch_safe(returns, model = "gjrGARCH", dist = "std")
  fit_egarch_std <- bookvar_fit_garch_safe(returns, model = "eGARCH", dist = "std")

  model_fits <- list(
    "GARCH-normal" = fit_garch_norm,
    "GARCH-Student-t" = fit_garch_std,
    "GJR-GARCH-Student-t" = fit_gjr_std,
    "EGARCH-Student-t" = fit_egarch_std
  )

  model_fits_ok <- Filter(Negate(is.null), model_fits)
  range_data <- bookvar_compute_range_based_volatility(vn_daily)
  forecast_spec <- bookvar_prepare_forecast_exercise(
    returns = returns,
    horizons = horizons,
    forecast_step = forecast_step,
    max_forecast_origins = max_forecast_origins
  )
  forecast_eval <- bookvar_run_volatility_forecast_exercise(returns, dates, forecast_spec)
  forecast_losses <- bookvar_summarise_forecast_losses(forecast_eval)

  result <- list(
    pipeline = "ch06_volatility_pipeline",
    status = "ready_for_local_testing",
    force_recompute = bookvar_should_recompute(force),
    depends_on = c("ch05_data_pipeline"),
    output_dir = output_dir,
    planned_output_paths = c(
      file.path(output_dir, "historical_volatility.rds"),
      file.path(output_dir, "historical_volatility.meta.yml"),
      file.path(output_dir, "rolling_volatility.rds"),
      file.path(output_dir, "rolling_volatility.meta.yml"),
      file.path(output_dir, "ewma_volatility.rds"),
      file.path(output_dir, "ewma_volatility.meta.yml"),
      file.path(output_dir, "garch_model_summaries.rds"),
      file.path(output_dir, "garch_model_summaries.meta.yml"),
      file.path(output_dir, "garch_diagnostics.rds"),
      file.path(output_dir, "garch_diagnostics.meta.yml"),
      file.path(output_dir, "range_based_volatility.rds"),
      file.path(output_dir, "range_based_volatility.meta.yml"),
      file.path(output_dir, "forecast_eval.rds"),
      file.path(output_dir, "forecast_eval.meta.yml"),
      file.path(output_dir, "forecast_losses.rds"),
      file.path(output_dir, "forecast_losses.meta.yml"),
      file.path(output_dir, "best_by_metric.rds"),
      file.path(output_dir, "best_by_metric.meta.yml")
    ),
    vn_raw = vn_raw,
    vn_daily = vn_daily,
    metadata = metadata,
    historical_volatility = bookvar_build_historical_vol_table(returns),
    rolling_panel = rolling_panel,
    rolling_summary = bookvar_build_rolling_volatility_summary(rolling_panel),
    ewma_panel = ewma_panel,
    ewma_summary = bookvar_build_ewma_summary(ewma_panel),
    rolling_ewma_comparison = bookvar_build_rolling_ewma_comparison(returns, dates),
    model_fits = model_fits,
    model_fits_ok = model_fits_ok,
    garch_ic_comparison = bookvar_build_garch_ic_comparison(model_fits),
    garch_coefficients = bookvar_garch_journal_table(model_fits),
    garch_persistence = bookvar_build_garch_persistence_table(model_fits),
    conditional_volatility_panel = bookvar_build_conditional_volatility_panel(model_fits_ok, dates),
    news_impact_data = bookvar_build_news_impact_data(fit_gjr_std, returns),
    garch_diagnostics = bookvar_build_garch_diagnostics(model_fits),
    range_data = range_data,
    range_plot_data = bookvar_build_range_based_plot_data(range_data),
    volatility_measure_comparison = bookvar_build_volatility_measure_comparison(),
    forecast_spec = forecast_spec,
    forecast_exercise_design = bookvar_build_forecast_exercise_design(forecast_spec),
    forecast_eval = forecast_eval,
    forecast_losses = forecast_losses,
    forecast_rmse_panel = if (nrow(forecast_losses)) bookvar_make_metric_panel(forecast_losses, "RMSE") else data.frame(),
    forecast_mae_panel = if (nrow(forecast_losses)) bookvar_make_metric_panel(forecast_losses, "MAE") else data.frame(),
    forecast_qlike_panel = if (nrow(forecast_losses)) bookvar_make_metric_panel(forecast_losses, "QLIKE") else data.frame(),
    best_by_metric = if (nrow(forecast_losses)) bookvar_best_model_by_horizon(forecast_losses) else data.frame(),
    forecast_plot_data = if (nrow(forecast_eval)) bookvar_build_forecast_plot_data(forecast_eval) else data.frame(),
    multistep_forecast_data = bookvar_build_multistep_forecast_data(returns, forecast_spec$estimation_window)
  )

  # TODO: After local RStudio testing, enable cache saving with bookvar_save_cached()
  # under data/derived/ch06/. Recommended targets:
  #   data/derived/ch06/historical_volatility.rds
  #   data/derived/ch06/rolling_volatility.rds
  #   data/derived/ch06/ewma_volatility.rds
  #   data/derived/ch06/garch_model_summaries.rds
  #   data/derived/ch06/garch_diagnostics.rds
  #   data/derived/ch06/range_based_volatility.rds
  #   data/derived/ch06/forecast_eval.rds
  #   data/derived/ch06/forecast_losses.rds
  #   data/derived/ch06/best_by_metric.rds

  result
}
