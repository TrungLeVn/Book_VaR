# ============================================================
# C02-M3 — one-command reproduction of Chapter 2 quantitative content
#
# Run from this folder (paths are relative to it):
#   cd "analysis/ch02" && LANG=en_US.UTF-8 Rscript run_ch02_all.R <out_dir>
# <out_dir> defaults to ../../results/C02-M3_<YYYYMMDD-HHMM> (Asia/Ho_Chi_Minh).
#
# What it does
#   1. Checks the SHA-256 of the chapter script against the locked version.
#   2. Runs 02. Chuong_02/code/R/ch02_all_tables_figures_appendix.R unchanged,
#      on a copy inside <out_dir>/_sandbox, so the chapter's output/ is never
#      overwritten; collects its output into <out_dir>/output/.
#   3. Regenerates the two legacy figures still embedded in chapter.docx
#      (Hình 2.3, Hình 2.6) from verbatim chunks of the legacy Quarto chapter
#      (legacy_qmd_chunks.R) into <out_dir>/output/figures_legacy/.
#   4. Writes file hashes and sessionInfo().
# Chapter 2 uses simulated series only; it reads no market data.
# ============================================================

CHAPTER_SCRIPT <- "../../02. Chuong_02/code/R/ch02_all_tables_figures_appendix.R"
CHAPTER_SCRIPT_SHA <- "bba67fa6e7e75179b1dba91866a4d6399f11f390e8238b9c0c502e70ad211c88"
LEGACY_CHUNKS <- "legacy_qmd_chunks.R"

sha256_file <- function(path) {
  path <- normalizePath(path, mustWork = TRUE)
  cmd <- if (nzchar(Sys.which("sha256sum"))) "sha256sum" else "shasum -a 256"
  out <- system(paste(cmd, shQuote(path)), intern = TRUE)
  sub("\\s.*$", "", out[1])
}

args <- commandArgs(trailingOnly = TRUE)
stamp <- format(Sys.time(), "%Y%m%d-%H%M", tz = "Asia/Ho_Chi_Minh")
out_dir <- if (length(args) >= 1) args[1] else file.path("../../results", paste0("C02-M3_", stamp))
if (dir.exists(file.path(out_dir, "output"))) {
  stop("Output folder already exists; refusing to overwrite: ", out_dir, call. = FALSE)
}
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
out_dir <- normalizePath(out_dir, mustWork = TRUE)

# ---- 1. Input check -------------------------------------------------------
actual_sha <- sha256_file(CHAPTER_SCRIPT)
if (!identical(actual_sha, CHAPTER_SCRIPT_SHA)) {
  stop("Chapter script SHA mismatch: ", actual_sha, " (expected ", CHAPTER_SCRIPT_SHA, ")", call. = FALSE)
}
cat("Input OK:", CHAPTER_SCRIPT, actual_sha, "\n")

# ---- 2. Chapter script on a sandbox copy ---------------------------------
# The chapter script finds its project root by the Volatility-VaR.Rproj marker
# and writes to <root>/02. Chuong_02/output, so the sandbox carries its own marker.
sandbox <- file.path(out_dir, "_sandbox")
sandbox_code <- file.path(sandbox, "02. Chuong_02", "code", "R")
dir.create(sandbox_code, recursive = TRUE, showWarnings = FALSE)
file.create(file.path(sandbox, "Volatility-VaR.Rproj"))
file.copy(CHAPTER_SCRIPT, sandbox_code)

rscript <- file.path(R.home("bin"), "Rscript")
log_file <- file.path(out_dir, "ch02_script.log")
t0 <- Sys.time()
status <- local({
  old <- setwd(sandbox_code)
  on.exit(setwd(old))
  system2(rscript, "ch02_all_tables_figures_appendix.R", stdout = log_file, stderr = log_file)
})
cat("Chapter script exit:", status, "| seconds:", round(as.numeric(difftime(Sys.time(), t0, units = "secs")), 1), "\n")
if (status != 0) stop("Chapter script failed; see ", log_file, call. = FALSE)

file.rename(file.path(sandbox, "02. Chuong_02", "output"), file.path(out_dir, "output"))
unlink(sandbox, recursive = TRUE)

# ---- 3. Legacy figures (Hình 2.3, Hình 2.6 in chapter.docx) --------------
suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(tidyr); library(tibble); library(zoo); library(scales)
})
legacy_env <- new.env()
sys.source(LEGACY_CHUNKS, envir = legacy_env)
legacy_dir <- file.path(out_dir, "output", "figures_legacy")
dir.create(legacy_dir, showWarnings = FALSE)
# Size from the chunk options (fig-width 8, fig-height 4.8); 300 dpi gives the
# 2400 x 1440 px of the existing PNGs in 02. Chuong_02/output/figures/.
for (nm in c("fig-ewma-vs-rolling-demo-1.png", "fig-news-impact-curve-1.png")) {
  plot_obj <- if (grepl("ewma", nm)) legacy_env$legacy_fig_ewma_vs_rolling else legacy_env$legacy_fig_news_impact
  ggplot2::ggsave(file.path(legacy_dir, nm), plot_obj, width = 8, height = 4.8, dpi = 300,
                  device = ragg::agg_png, bg = "white")
}

# ---- 4. Hashes and session ------------------------------------------------
files <- list.files(file.path(out_dir, "output"), recursive = TRUE, full.names = TRUE)
hashes <- data.frame(
  file = sub(paste0("^", out_dir, "/"), "", files),
  bytes = file.size(files),
  sha256 = vapply(files, sha256_file, character(1)),
  row.names = NULL
)
write.csv(hashes, file.path(out_dir, "output_sha256.csv"), row.names = FALSE)
writeLines(c(paste("chapter_script_sha256:", actual_sha), capture.output(sessionInfo())),
           file.path(out_dir, "sessionInfo.txt"))
cat("Done:", nrow(hashes), "files in", file.path(out_dir, "output"), "\n")
