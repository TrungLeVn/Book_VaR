# B04 — install the R packages needed by the existing Ch1–Ch3 scripts into the
# project renv library. Run from the project root (02. Drafts/) so .Rprofile
# activates renv: Rscript results/B04_20261022-1420/install_packages.R
# Does not touch renv.lock; the proposed lockfile is written by snapshot_proposed.R.

pkgs_scripts <- c(
  # Ch1 (01. Chuong_01/code/R/)
  "dplyr", "tibble", "ggplot2", "scales", "patchwork", "zoo", "readr",
  "quantmod", "flextable", "officer",
  # Ch2 (02. Chuong_02/code/R/)
  "tidyr", "sgt",
  # Ch3 (03. Chuong_03/code/R/)
  "rugarch", "tseries", "FinTS", "jsonlite", "forecast", "MCS", "car", "moments"
)
# Planned for B02/C0X-M3 (vni_data.xlsx) and the rmarkdown stack already in renv.lock
pkgs_extra <- c("readxl", "rmarkdown", "knitr")

pkgs <- unique(c(pkgs_scripts, pkgs_extra))
renv::install(pkgs, prompt = FALSE)

ok <- vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)
print(data.frame(package = pkgs, loadable = ok,
                 version = vapply(pkgs, function(p) if (ok[[p]]) as.character(packageVersion(p)) else NA_character_, "")),
      row.names = FALSE)
if (!all(ok)) stop("Not loadable: ", paste(pkgs[!ok], collapse = ", "))
