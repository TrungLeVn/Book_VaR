script_arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
if (length(script_arg) == 1L) {
  script_path <- normalizePath(sub("^--file=", "", script_arg), winslash = "/", mustWork = TRUE)
  project_root <- dirname(dirname(script_path))
} else {
  project_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
  if (basename(project_root) == "scripts") {
    project_root <- dirname(project_root)
  }
}

source(file.path(project_root, "R/helpers/path_helpers.R"))
source(file.path(project_root, "R/helpers/cache_helpers.R"))
source(file.path(project_root, "R/data/prepare_vnindex.R"))
source(file.path(project_root, "R/models/volatility_models.R"))
source(file.path(project_root, "R/pipelines/ch05_data_pipeline.R"))
source(file.path(project_root, "R/pipelines/ch06_volatility_pipeline.R"))

run_ch06_volatility_pipeline_main <- function(data_path = NULL) {
  # Local RStudio test:
  #   1. source("scripts/run_ch06_volatility_pipeline.R")
  #   2. result <- run_ch06_volatility_pipeline_main()
  #   3. Inspect result$rolling_panel, result$ewma_panel, result$garch_ic_comparison,
  #      result$garch_diagnostics, result$forecast_eval, and result$forecast_losses.
  #   4. Check indexing and horizon alignment before enabling any saveRDS() step.
  run_ch06_volatility_pipeline(data_path = data_path)
}

if (sys.nframe() == 0L) {
  result <- run_ch06_volatility_pipeline_main()
  message("Chapter 6 volatility pipeline prepared for local testing: ", result$pipeline)
}
