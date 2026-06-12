# ============================================================
# 00_setup.R
# Chapter 1 - shared configuration and helper functions
# ============================================================

if (!exists("ROOT_DIR")) ROOT_DIR <- getwd()

# ---- User configuration -------------------------------------
INSTALL_MISSING <- TRUE
USE_DEMO_IF_NO_DATA <- TRUE

if (is.null(getOption("repos")) || identical(getOption("repos")[["CRAN"]], "@CRAN@")) {
  options(repos = c(CRAN = "https://cloud.r-project.org"))
}

DATA_FILE <- file.path(ROOT_DIR, "data", "vnindex.csv")
OUT_DIR <- file.path(ROOT_DIR, "output", "ch01")
FIG_DIR <- file.path(OUT_DIR, "figures")
TAB_DIR <- file.path(OUT_DIR, "tables")
EST_DIR <- file.path(OUT_DIR, "estimates")
DOC_DIR <- file.path(OUT_DIR, "docx")

SERIES_NAME <- "VN-Index"
ROLLING_WINDOW <- 30
VAR_LEVELS <- c(0.95, 0.99)
POSITION_VALUE <- 100e9

# ---- Packages ------------------------------------------------
required_packages <- c(
  "dplyr", "tibble", "tidyr", "readr", "stringr", "lubridate", "purrr",
  "ggplot2", "patchwork", "scales", "flextable", "officer",
  "ragg", "zoo", "tseries", "FinTS"
)

install_if_missing <- function(pkgs, install = TRUE) {
  missing <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) > 0 && isTRUE(install)) install.packages(missing)
  missing_after <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing_after) > 0) {
    stop("Missing packages: ", paste(missing_after, collapse = ", "), call. = FALSE)
  }
  invisible(TRUE)
}

install_if_missing(required_packages, INSTALL_MISSING)
invisible(lapply(required_packages, library, character.only = TRUE))

# ---- Directories --------------------------------------------
dir.create(FIG_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(TAB_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(EST_DIR, recursive = TRUE, showWarnings = FALSE)
dir.create(DOC_DIR, recursive = TRUE, showWarnings = FALSE)

# ---- Styling -------------------------------------------------
theme_ch01 <- function(base_size = 11, base_family = "Arial") {
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = base_size + 1),
      plot.subtitle = ggplot2::element_text(size = base_size),
      plot.caption = ggplot2::element_text(size = base_size - 2, hjust = 0),
      panel.grid.minor = ggplot2::element_blank()
    )
}

format_ft <- function(ft, font_size = 9.5) {
  ft |>
    flextable::theme_booktabs() |>
    flextable::bold(part = "header") |>
    flextable::align(align = "center", part = "header") |>
    flextable::valign(valign = "top", part = "body") |>
    flextable::fontsize(size = font_size, part = "all") |>
    flextable::autofit()
}

save_ft_docx <- function(ft, title, file_name) {
  out_path <- file.path(TAB_DIR, file_name)
  flextable::save_as_docx(structure(list(ft), names = title), path = out_path)
  message("Saved table: ", out_path)
  invisible(out_path)
}

save_plot_png <- function(plot, file_name, width = 7.2, height = 4.8, dpi = 300) {
  out_path <- file.path(FIG_DIR, file_name)
  ggplot2::ggsave(
    filename = out_path,
    plot = plot,
    width = width,
    height = height,
    dpi = dpi,
    device = ragg::agg_png
  )
  message("Saved figure: ", out_path)
  invisible(out_path)
}

safe_test <- function(expr) {
  tryCatch(expr, error = function(e) NA)
}

skewness_manual <- function(x) {
  x <- stats::na.omit(x)
  m <- mean(x)
  s <- stats::sd(x)
  if (length(x) < 3 || is.na(s) || s == 0) return(NA_real_)
  mean(((x - m) / s)^3)
}

kurtosis_manual <- function(x) {
  x <- stats::na.omit(x)
  m <- mean(x)
  s <- stats::sd(x)
  if (length(x) < 4 || is.na(s) || s == 0) return(NA_real_)
  mean(((x - m) / s)^4)
}
