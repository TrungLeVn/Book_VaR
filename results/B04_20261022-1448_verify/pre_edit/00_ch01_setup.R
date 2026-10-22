# ============================================================
# Chapter 1 setup (not for printed appendix)
# Book: Volatility, VaR and ES for Vietnamese financial returns
# ============================================================

required_packages <- c(
  "dplyr", "tibble", "ggplot2", "scales", "patchwork",
  "zoo", "readr", "quantmod", "flextable", "officer"
)

install_missing_packages <- function(pkgs) {
  missing <- pkgs[!pkgs %in% rownames(installed.packages())]
  if (length(missing) > 0) install.packages(missing)
  invisible(TRUE)
}

install_missing_packages(required_packages)
invisible(lapply(required_packages, library, character.only = TRUE))

resolve_script_dir <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", args, value = TRUE)
  if (length(file_arg) > 0) {
    return(dirname(normalizePath(sub("^--file=", "", file_arg[1]), winslash = "/", mustWork = TRUE)))
  }
  normalizePath(getwd(), winslash = "/", mustWork = TRUE)
}

find_repo_root <- function(start_dir) {
  current <- normalizePath(start_dir, winslash = "/", mustWork = TRUE)
  repeat {
    if (file.exists(file.path(current, "Volatility-VaR.Rproj")) || dir.exists(file.path(current, ".git"))) {
      return(current)
    }
    parent <- dirname(current)
    if (identical(parent, current)) {
      stop("Cannot locate repository root from script directory: ", start_dir, call. = FALSE)
    }
    current <- parent
  }
}

# ---- Output folders ----------------------------------------
SCRIPT_DIR <- resolve_script_dir()
REPO_ROOT <- find_repo_root(SCRIPT_DIR)
CHAPTER_DIR <- file.path(REPO_ROOT, "01. Chuong_01")
CODE_DIR <- file.path(CHAPTER_DIR, "code")
DATA_DIR <- file.path(CHAPTER_DIR, "data", "raw")
OUT_DIR  <- file.path(CHAPTER_DIR, "output")
FIG_DIR  <- file.path(OUT_DIR, "figures")
TAB_DIR  <- file.path(OUT_DIR, "tables")
EST_DIR  <- file.path(OUT_DIR, "estimates")
DOCX_DIR <- file.path(OUT_DIR, "tables")

for (d in c(OUT_DIR, FIG_DIR, TAB_DIR, EST_DIR, DOCX_DIR)) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

# ---- Common settings ---------------------------------------
BOOK_DPI <- 300
BOOK_FIG_WIDTH <- 8
BOOK_FIG_HEIGHT <- 5

# ---- Theme -------------------------------------------------
theme_ch01 <- function(base_size = 12) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = base_size + 4),
      plot.subtitle = ggplot2::element_text(size = base_size),
      plot.caption = ggplot2::element_text(size = base_size - 3, hjust = 0),
      axis.title = ggplot2::element_text(face = "bold"),
      legend.position = "bottom",
      panel.grid.minor = ggplot2::element_blank()
    )
}

# ---- Small helpers -----------------------------------------
percent_vn <- scales::label_percent(accuracy = 1, decimal.mark = ",")

save_plot <- function(plot, file, width = BOOK_FIG_WIDTH, height = BOOK_FIG_HEIGHT) {
  ggplot2::ggsave(
    filename = file.path(FIG_DIR, file),
    plot = plot,
    width = width,
    height = height,
    dpi = BOOK_DPI
  )
}

format_table_docx <- function(data) {
  flextable::flextable(data) |>
    flextable::bold(part = "header") |>
    flextable::align(align = "center", part = "header") |>
    flextable::fontsize(size = 10, part = "all") |>
    flextable::padding(padding = 4, part = "all") |>
    flextable::border_outer(border = officer::fp_border(color = "gray70", width = 0.75)) |>
    flextable::border_inner_h(border = officer::fp_border(color = "gray80", width = 0.5)) |>
    flextable::border_inner_v(border = officer::fp_border(color = "gray80", width = 0.5)) |>
    flextable::autofit()
}

save_table_docx <- function(data, title, source, file) {
  doc <- officer::read_docx()
  doc <- officer::body_add_par(doc, title, style = "Normal")
  doc <- officer::body_add_flextable(doc, format_table_docx(data))
  doc <- officer::body_add_par(doc, source, style = "Normal")
  print(doc, target = file.path(TAB_DIR, file))
}
