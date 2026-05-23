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
source(file.path(project_root, "R/models/var_es_models.R"))
source(file.path(project_root, "R/models/backtesting_tests.R"))
source(file.path(project_root, "R/pipelines/ch05_data_pipeline.R"))
source(file.path(project_root, "R/pipelines/ch07_var_es_pipeline.R"))

run_ch07_var_es_pipeline_main <- function(data_path = NULL) {
  # Local RStudio test:
  #   1. source("scripts/run_ch07_var_es_pipeline.R")
  #   2. result <- run_ch07_var_es_pipeline_main()
  #   3. Inspect result$all_forecasts, result$eval_data, result$backtesting_summary,
  #      and result$tail_severity before enabling any saveRDS() step.
  #   4. Confirm date alignment, alpha labels, and exceedance logic carefully.
  run_ch07_var_es_pipeline(data_path = data_path)
}

if (sys.nframe() == 0L) {
  result <- run_ch07_var_es_pipeline_main()
  message("Chapter 7 VaR/ES pipeline prepared for local testing: ", result$pipeline)
}
