script_path <- normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE)[1]), winslash = "/", mustWork = TRUE)
project_root <- dirname(script_path)
project_root <- dirname(project_root)

source(file.path(project_root, "R/helpers/path_helpers.R"))
source(file.path(project_root, "R/helpers/cache_helpers.R"))
source(file.path(project_root, "R/pipelines/ch04_backtesting_examples.R"))

result <- run_ch04_backtesting_examples()
message("Pipeline scaffold ready: ", result$pipeline)
