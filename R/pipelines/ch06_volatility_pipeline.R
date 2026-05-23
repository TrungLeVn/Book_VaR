if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch06_volatility_pipeline.R.", call. = FALSE)
}

run_ch06_volatility_pipeline <- function(force = NULL) {
  output_dir <- bookvar_derived_path("ch06")
  bookvar_ensure_dir(output_dir)

  list(
    pipeline = "ch06_volatility_pipeline",
    status = "scaffold_only",
    force_recompute = bookvar_should_recompute(force),
    depends_on = c("ch05_data_pipeline"),
    outputs = c(
      file.path(output_dir, "volatility_candidates.rds"),
      file.path(output_dir, "volatility_candidates.meta.yml"),
      file.path(output_dir, "volatility_forecasts.rds"),
      file.path(output_dir, "volatility_forecasts.meta.yml")
    )
  )
}
