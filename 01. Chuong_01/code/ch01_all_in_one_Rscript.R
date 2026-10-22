# ============================================================
# ch01_all_in_one_Rscript.R
# Standalone runner for Chapter 1 tables, figures, estimates
# Run: Rscript '01. Chuong_01/code/ch01_all_in_one_Rscript.R'
# ============================================================

args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)

SCRIPT_ROOT <- if (length(file_arg) > 0) {
  dirname(normalizePath(sub("^--file=", "", file_arg[1]), winslash = "/", mustWork = TRUE))
} else {
  normalizePath(getwd(), winslash = "/", mustWork = TRUE)
}

source_ch01 <- function(file_name) {
  path <- file.path(SCRIPT_ROOT, "R", file_name)
  if (!file.exists(path)) {
    stop("Cannot find Chapter 1 module: ", path, call. = FALSE)
  }
  source(path, local = FALSE, echo = FALSE)
}

message("Running Chapter 1 pipeline from: ", SCRIPT_ROOT)

ch01_modules <- c(
  "00_ch01_setup.R",
  "01_ch01_appendix_tables_figures.R",
  "99_ch01_export.R"
)

invisible(lapply(ch01_modules, source_ch01))

message("Chapter 1 pipeline completed.")
