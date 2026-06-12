# ============================================================
# run_ch01_all.R
# Main runner for Chapter 1 R scripts
# Run from terminal: Rscript run_ch01_all.R
# ============================================================

args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)

if (length(file_arg) > 0) {
  ROOT_DIR <- dirname(normalizePath(sub("^--file=", "", file_arg)))
} else {
  ROOT_DIR <- getwd()
}

setwd(ROOT_DIR)
message("Project root: ", ROOT_DIR)

source(file.path("R", "00_setup.R"), encoding = "UTF-8")
source(file.path("R", "01_data.R"), encoding = "UTF-8")
source(file.path("R", "02_tables.R"), encoding = "UTF-8")
source(file.path("R", "03_figures.R"), encoding = "UTF-8")
source(file.path("R", "04_estimates.R"), encoding = "UTF-8")
source(file.path("R", "05_export_report.R"), encoding = "UTF-8")

message("Done. Outputs are in: ", OUT_DIR)
