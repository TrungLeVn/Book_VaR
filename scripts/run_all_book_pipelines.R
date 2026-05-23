script_path <- normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]), winslash = "/", mustWork = TRUE)
project_root <- dirname(script_path)
project_root <- dirname(project_root)

source(file.path(project_root, "R/helpers/path_helpers.R"))
source(file.path(project_root, "R/helpers/cache_helpers.R"))
source(file.path(project_root, "R/data/prepare_vnindex.R"))
source(file.path(project_root, "R/models/volatility_models.R"))
source(file.path(project_root, "R/models/var_es_models.R"))
source(file.path(project_root, "R/models/backtesting_tests.R"))
source(file.path(project_root, "R/pipelines/ch01_concept_examples.R"))
source(file.path(project_root, "R/pipelines/ch02_volatility_examples.R"))
source(file.path(project_root, "R/pipelines/ch04_backtesting_examples.R"))
source(file.path(project_root, "R/pipelines/ch05_data_pipeline.R"))
source(file.path(project_root, "R/pipelines/ch06_volatility_pipeline.R"))
source(file.path(project_root, "R/pipelines/ch07_var_es_pipeline.R"))

results <- list(
  ch01 = run_ch01_concept_examples(),
  ch02 = run_ch02_volatility_examples(),
  ch04 = run_ch04_backtesting_examples(),
  ch05 = run_ch05_data_pipeline(),
  ch06 = run_ch06_volatility_pipeline(),
  ch07 = run_ch07_var_es_pipeline()
)

message("Book pipeline scaffold loaded for: ", paste(names(results), collapse = ", "))
