# B04 — write a PROPOSED lockfile (not renv.lock) covering the packages the
# existing Ch1–Ch3 scripts need, plus their recursive dependencies, and record
# sessionInfo and the diff against the current renv.lock.
# Run from 02. Drafts/: Rscript results/B04_20261022-1420/snapshot_proposed.R
run_dir <- "results/B04_20261022-1420"
pkgs <- c("dplyr", "tibble", "ggplot2", "scales", "patchwork", "zoo", "readr",
          "quantmod", "flextable", "officer", "tidyr", "sgt",
          "rugarch", "tseries", "FinTS", "jsonlite", "forecast", "MCS", "car", "moments",
          "readxl", "rmarkdown", "knitr", "renv")
proposed <- file.path(run_dir, "renv.lock.proposed")
renv::snapshot(packages = pkgs, lockfile = proposed, prompt = FALSE, force = TRUE)

old <- jsonlite::fromJSON("renv.lock")
new <- jsonlite::fromJSON(proposed)
ver <- function(lock) vapply(lock$Packages, function(p) p$Version, "")
vo <- ver(old); vn <- ver(new)
all_pk <- sort(union(names(vo), names(vn)))
diff <- data.frame(package = all_pk,
                   current_lock = unname(vo[all_pk]), proposed_lock = unname(vn[all_pk]))
diff$status <- ifelse(is.na(diff$current_lock), "added",
               ifelse(is.na(diff$proposed_lock), "removed",
               ifelse(diff$current_lock == diff$proposed_lock, "same", "version changed")))
write.csv(diff, file.path(run_dir, "lockfile_diff.csv"), row.names = FALSE, na = "")
cat("R in current lock:", old$R$Version, "| proposed:", new$R$Version, "\n")
print(table(diff$status))

for (p in pkgs) suppressPackageStartupMessages(library(p, character.only = TRUE))
writeLines(capture.output(sessionInfo()), file.path(run_dir, "sessionInfo.txt"))
