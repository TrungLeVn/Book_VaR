if (!exists("bookvar_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing ch01_concept_examples.R.", call. = FALSE)
}

run_ch01_concept_examples <- function(force = NULL) {
  output_dir <- bookvar_derived_path("ch01")
  bookvar_ensure_dir(output_dir)

  list(
    pipeline = "ch01_concept_examples",
    status = "scaffold_only",
    force_recompute = bookvar_should_recompute(force),
    outputs = c(
      file.path(output_dir, "return_language_example.rds"),
      file.path(output_dir, "return_language_example.meta.yml")
    )
  )
}
