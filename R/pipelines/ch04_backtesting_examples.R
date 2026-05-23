if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch04_backtesting_examples.R.", call. = FALSE)
}

run_ch04_backtesting_examples <- function(force = NULL) {
  output_dir <- bookvar_derived_path("ch04")
  bookvar_ensure_dir(output_dir)

  list(
    pipeline = "ch04_backtesting_examples",
    status = "scaffold_only",
    force_recompute = bookvar_should_recompute(force),
    outputs = c(
      file.path(output_dir, "backtesting_example_paths.rds"),
      file.path(output_dir, "backtesting_example_paths.meta.yml")
    )
  )
}
