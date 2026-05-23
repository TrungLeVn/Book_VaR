if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch05_data_pipeline.R.", call. = FALSE)
}

run_ch05_data_pipeline <- function(data_path = NULL, force = NULL) {
  output_dir <- bookvar_derived_path("ch05")
  bookvar_ensure_dir(output_dir)

  list(
    pipeline = "ch05_data_pipeline",
    status = "scaffold_only",
    force_recompute = bookvar_should_recompute(force),
    source_file = data_path %||% bookvar_guess_vnindex_file(),
    outputs = c(
      file.path(output_dir, "vnindex_daily.rds"),
      file.path(output_dir, "vnindex_daily.meta.yml"),
      file.path(output_dir, "stylized_facts.rds"),
      file.path(output_dir, "stylized_facts.meta.yml")
    )
  )
}
