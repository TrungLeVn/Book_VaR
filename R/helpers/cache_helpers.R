bookvar_env_flag <- function(name, default = FALSE) {
  value <- Sys.getenv(name, unset = "")
  if (!nzchar(value)) {
    return(default)
  }
  tolower(value) %in% c("1", "true", "yes", "y", "on")
}

bookvar_should_recompute <- function(force = NULL) {
  if (!is.null(force)) {
    return(isTRUE(force))
  }
  bookvar_env_flag("BOOKVAR_RECOMPUTE", default = FALSE)
}

bookvar_file_hash <- function(path) {
  if (!file.exists(path)) {
    stop(sprintf("Cannot hash missing file: %s", path), call. = FALSE)
  }
  unname(tools::md5sum(path))
}

bookvar_hash_object <- function(x) {
  tmp <- tempfile(fileext = ".rds")
  on.exit(unlink(tmp), add = TRUE)
  saveRDS(x, tmp, version = 2)
  unname(tools::md5sum(tmp))
}

bookvar_input_hash <- function(input_files = character()) {
  normalized <- unique(normalizePath(input_files, winslash = "/", mustWork = TRUE))
  hash_payload <- lapply(normalized, function(path) {
    list(path = path, md5 = bookvar_file_hash(path))
  })
  bookvar_hash_object(hash_payload)
}

bookvar_parameter_hash <- function(params = list()) {
  bookvar_hash_object(params)
}

bookvar_code_version <- function(default = "unversioned") {
  code_version <- Sys.getenv("BOOKVAR_CODE_VERSION", unset = "")
  if (nzchar(code_version)) {
    return(code_version)
  }

  git_sha <- tryCatch(
    system2("git", c("rev-parse", "--short", "HEAD"), stdout = TRUE, stderr = FALSE),
    error = function(...) character()
  )

  if (length(git_sha) == 1L && nzchar(git_sha)) {
    return(git_sha)
  }

  default
}

bookvar_cache_meta_path <- function(output_path) {
  sub("\\.rds$", ".meta.yml", output_path)
}

bookvar_yaml_scalar <- function(value) {
  if (length(value) == 0L || is.null(value)) {
    return("null")
  }

  if (is.logical(value)) {
    return(ifelse(is.na(value), "null", ifelse(value, "true", "false")))
  }

  if (inherits(value, "Date")) {
    return(format(value, "%Y-%m-%d"))
  }

  if (inherits(value, c("POSIXct", "POSIXt"))) {
    return(format(value, "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"))
  }

  if (is.numeric(value)) {
    return(ifelse(is.na(value), "null", format(value, scientific = FALSE, trim = TRUE)))
  }

  escaped <- gsub("\"", "\\\\\"", as.character(value), fixed = TRUE)
  sprintf("\"%s\"", escaped)
}

bookvar_yaml_lines <- function(x, indent = 0L) {
  prefix <- paste(rep(" ", indent), collapse = "")

  if (is.list(x) && !is.null(names(x))) {
    lines <- character()
    for (name in names(x)) {
      value <- x[[name]]

      if (is.list(value) && length(value) > 0L) {
        lines <- c(lines, sprintf("%s%s:", prefix, name), bookvar_yaml_lines(value, indent + 2L))
      } else if (length(value) > 1L) {
        lines <- c(lines, sprintf("%s%s:", prefix, name))
        for (item in value) {
          lines <- c(lines, sprintf("%s  - %s", prefix, bookvar_yaml_scalar(item)))
        }
      } else {
        lines <- c(lines, sprintf("%s%s: %s", prefix, name, bookvar_yaml_scalar(value)))
      }
    }
    return(lines)
  }

  if (length(x) > 1L) {
    return(sprintf("%s- %s", prefix, vapply(x, bookvar_yaml_scalar, character(1))))
  }

  sprintf("%s%s", prefix, bookvar_yaml_scalar(x))
}

bookvar_write_yaml <- function(x, path) {
  if (exists("bookvar_ensure_parent_dir", mode = "function")) {
    bookvar_ensure_parent_dir(path)
  } else {
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  }
  writeLines(bookvar_yaml_lines(x), con = path, useBytes = TRUE)
  invisible(path)
}

bookvar_read_yaml <- function(path) {
  if (!file.exists(path)) {
    stop(sprintf("Missing metadata file: %s", path), call. = FALSE)
  }

  lines <- readLines(path, warn = FALSE)
  lines <- lines[nzchar(trimws(lines))]

  result <- list()
  current_key <- NULL

  for (line in lines) {
    if (grepl("^\\s+-\\s+", line)) {
      if (is.null(current_key)) {
        next
      }
      value <- sub("^\\s+-\\s+", "", line)
      value <- gsub('^"|"$', "", value)
      result[[current_key]] <- c(result[[current_key]], value)
      next
    }

    if (!grepl(":", line, fixed = TRUE)) {
      next
    }

    parts <- strsplit(line, ":", fixed = TRUE)[[1]]
    key <- trimws(parts[1])
    value <- trimws(paste(parts[-1], collapse = ":"))

    if (!nzchar(value)) {
      current_key <- key
      result[[key]] <- character()
      next
    }

    current_key <- NULL
    value <- gsub('^"|"$', "", value)
    if (identical(value, "null")) {
      result[[key]] <- NULL
    } else {
      result[[key]] <- value
    }
  }

  result
}

bookvar_cache_metadata <- function(output_path, input_files = character(), params = list(), extra_meta = list()) {
  input_files <- unique(normalizePath(input_files, winslash = "/", mustWork = TRUE))

  metadata <- c(
    list(
      output_file = normalizePath(output_path, winslash = "/", mustWork = FALSE),
      input_files = input_files,
      input_hash = if (length(input_files)) bookvar_input_hash(input_files) else NA_character_,
      parameter_hash = bookvar_parameter_hash(params),
      code_version = bookvar_code_version(),
      created_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
      r_version = as.character(getRversion())
    ),
    extra_meta
  )

  metadata$file_hash <- if (file.exists(output_path)) bookvar_file_hash(output_path) else NA_character_
  metadata
}

bookvar_save_cached <- function(result, output_path, input_files = character(), params = list(), extra_meta = list()) {
  if (exists("bookvar_ensure_parent_dir", mode = "function")) {
    bookvar_ensure_parent_dir(output_path)
  } else {
    dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
  }

  saveRDS(result, output_path, version = 2)

  metadata <- bookvar_cache_metadata(
    output_path = output_path,
    input_files = input_files,
    params = params,
    extra_meta = extra_meta
  )

  bookvar_write_yaml(metadata, bookvar_cache_meta_path(output_path))
  invisible(output_path)
}

bookvar_result_fresh <- function(output_path, input_files = character(), params = list(), code_version = NULL) {
  meta_path <- bookvar_cache_meta_path(output_path)
  if (!file.exists(output_path) || !file.exists(meta_path)) {
    return(FALSE)
  }

  metadata <- bookvar_read_yaml(meta_path)
  current_file_hash <- bookvar_file_hash(output_path)

  if (!identical(unname(metadata$file_hash), current_file_hash)) {
    return(FALSE)
  }

  if (length(input_files)) {
    current_input_hash <- bookvar_input_hash(input_files)
    if (!identical(unname(metadata$input_hash), current_input_hash)) {
      return(FALSE)
    }
  }

  current_parameter_hash <- bookvar_parameter_hash(params)
  if (!identical(unname(metadata$parameter_hash), current_parameter_hash)) {
    return(FALSE)
  }

  code_version <- code_version %||% bookvar_code_version()
  if (!identical(unname(metadata$code_version), code_version)) {
    return(FALSE)
  }

  TRUE
}

bookvar_fail_if_missing <- function(output_path, instruction = NULL) {
  if (file.exists(output_path)) {
    return(invisible(output_path))
  }

  message_text <- c(
    sprintf("Required cached output is missing: %s", output_path),
    instruction %||% sprintf(
      "Run the corresponding pipeline script or set BOOKVAR_RECOMPUTE=1 before rendering."
    )
  )

  stop(paste(message_text, collapse = "\n"), call. = FALSE)
}

bookvar_load_cached <- function(output_path, input_files = character(), params = list(), force = NULL, fail_missing = TRUE) {
  if (bookvar_should_recompute(force = force)) {
    return(NULL)
  }

  if (!file.exists(output_path)) {
    if (isTRUE(fail_missing)) {
      bookvar_fail_if_missing(output_path)
    }
    return(NULL)
  }

  if (!bookvar_result_fresh(output_path, input_files = input_files, params = params)) {
    return(NULL)
  }

  readRDS(output_path)
}
