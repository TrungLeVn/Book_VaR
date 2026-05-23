if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch07_var_es_pipeline.R.", call. = FALSE)
}

run_ch07_var_es_pipeline <- function(force = NULL) {
  output_dir <- bookvar_derived_path("ch07")
  bookvar_ensure_dir(output_dir)

  list(
    pipeline = "ch07_var_es_pipeline",
    status = "scaffold_only",
    force_recompute = bookvar_should_recompute(force),
    depends_on = c("ch05_data_pipeline", "ch06_volatility_pipeline"),
    outputs = c(
      file.path(output_dir, "var_es_forecasts.rds"),
      file.path(output_dir, "var_es_forecasts.meta.yml"),
      file.path(output_dir, "backtesting_summary.rds"),
      file.path(output_dir, "backtesting_summary.meta.yml")
    )
  )
}
