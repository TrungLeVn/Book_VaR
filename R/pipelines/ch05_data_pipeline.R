if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch05_data_pipeline.R.", call. = FALSE)
}

run_ch05_data_pipeline <- function(data_path = NULL, force = NULL, estimation_window = 500, holding_period = 1, alpha_levels = c(0.05, 0.01), refit_every = 25, pot_threshold_prob = 0.90, backtest_buffer = 100) {
  output_dir <- bookvar_derived_path("ch05")
  bookvar_ensure_dir(output_dir)

  vn_raw <- bookvar_load_vnindex(data_path = data_path)
  vn_daily <- bookvar_prepare_vnindex_daily(data_path = data_path, scale = 100)
  metadata <- bookvar_build_ch05_metadata(
    vn_raw = vn_raw,
    vn_daily = vn_daily,
    estimation_window = estimation_window,
    holding_period = holding_period,
    alpha_levels = alpha_levels,
    refit_every = refit_every,
    pot_threshold_prob = pot_threshold_prob,
    backtest_buffer = backtest_buffer
  )

  result <- list(
    pipeline = "ch05_data_pipeline",
    status = "ready_for_local_testing",
    force_recompute = bookvar_should_recompute(force),
    source_file = attr(vn_raw, "source_file"),
    output_dir = output_dir,
    planned_output_paths = c(
      file.path(output_dir, "vnindex_daily.rds"),
      file.path(output_dir, "vnindex_daily.meta.yml"),
      file.path(output_dir, "research_design.rds"),
      file.path(output_dir, "research_design.meta.yml"),
      file.path(output_dir, "descriptive_statistics.rds"),
      file.path(output_dir, "descriptive_statistics.meta.yml"),
      file.path(output_dir, "stationarity_tests.rds"),
      file.path(output_dir, "stationarity_tests.meta.yml"),
      file.path(output_dir, "dependence_tests.rds"),
      file.path(output_dir, "dependence_tests.meta.yml")
    ),
    vn_raw = vn_raw,
    vn_daily = vn_daily,
    metadata = metadata,
    research_design = bookvar_build_ch05_research_design(vn_daily, metadata),
    descriptive_statistics = bookvar_build_ch05_data_summary(vn_daily, metadata),
    price_return_data = bookvar_build_ch05_price_return_data(vn_raw, vn_daily),
    hist_qq_data = bookvar_build_ch05_hist_qq_data(vn_daily),
    stationarity_tests = bookvar_build_ch05_stationarity_tests(vn_daily),
    acf_data = bookvar_build_ch05_acf_data(vn_daily),
    dependence_tests = bookvar_build_ch05_dependence_tests(vn_daily)
  )

  # TODO: After local RStudio testing, enable cache saving with bookvar_save_cached()
  # and write outputs under data/derived/ch05/.
  # Example target paths:
  #   data/derived/ch05/vnindex_daily.rds
  #   data/derived/ch05/research_design.rds
  #   data/derived/ch05/descriptive_statistics.rds
  #   data/derived/ch05/stationarity_tests.rds
  #   data/derived/ch05/dependence_tests.rds

  result
}
