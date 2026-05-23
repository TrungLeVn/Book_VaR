if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch02_volatility_examples.R.", call. = FALSE)
}

run_ch02_volatility_examples <- function(force = NULL) {
  output_dir <- bookvar_derived_path("ch02")
  bookvar_ensure_dir(output_dir)

  list(
    pipeline = "ch02_volatility_examples",
    status = "scaffold_only",
    force_recompute = bookvar_should_recompute(force),
    outputs = c(
      file.path(output_dir, "ewma_weight_grid.rds"),
      file.path(output_dir, "ewma_weight_grid.meta.yml")
    )
  )
}
