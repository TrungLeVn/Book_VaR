bookvar_project_root <- function(start = getwd()) {
  start_path <- normalizePath(start, winslash = "/", mustWork = TRUE)

  if (file.exists(start_path) && !dir.exists(start_path)) {
    start_path <- dirname(start_path)
  }

  current <- start_path

  repeat {
    sentinel <- file.path(current, "_quarto.yml")
    if (file.exists(sentinel)) {
      return(current)
    }

    parent <- dirname(current)
    if (identical(parent, current)) {
      stop("Could not locate project root containing '_quarto.yml'.", call. = FALSE)
    }
    current <- parent
  }
}

bookvar_path <- function(...) {
  file.path(bookvar_project_root(), ...)
}

bookvar_data_path <- function(...) {
  bookvar_path("data", ...)
}

bookvar_derived_path <- function(...) {
  bookvar_path("data", "derived", ...)
}

bookvar_r_path <- function(...) {
  bookvar_path("R", ...)
}

bookvar_scripts_path <- function(...) {
  bookvar_path("scripts", ...)
}

bookvar_ensure_dir <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  invisible(normalizePath(path, winslash = "/", mustWork = TRUE))
}

bookvar_ensure_parent_dir <- function(path) {
  parent <- dirname(path)
  bookvar_ensure_dir(parent)
  invisible(parent)
}

bookvar_rel_path <- function(path) {
  root <- bookvar_project_root()
  normalized <- normalizePath(path, winslash = "/", mustWork = FALSE)
  sub(paste0("^", root, "/?"), "", normalized)
}

`%||%` <- function(x, y) {
  if (is.null(x) || (length(x) == 1L && is.na(x))) {
    y
  } else {
    x
  }
}
