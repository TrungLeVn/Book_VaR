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
source(file.path(project_root, "R/pipelines/ch05_data_pipeline.R"))

run_ch05_data_pipeline_main <- function(data_path = NULL) {
  # Local RStudio test:
  #   1. Open the Book_VaR project in RStudio.
  #   2. source("scripts/run_ch05_data_pipeline.R")
  #   3. result <- run_ch05_data_pipeline_main()
  #   4. Inspect result$vn_daily, result$descriptive_statistics, result$stationarity_tests,
  #      and result$dependence_tests before enabling any saveRDS() step.
  run_ch05_data_pipeline(data_path = data_path)
}

if (sys.nframe() == 0L) {
  result <- run_ch05_data_pipeline_main()
  message("Chapter 5 data pipeline prepared for local testing: ", result$pipeline)
}
