bookvar_guess_vnindex_file <- function() {
  candidates <- c(
    bookvar_data_path("VNI.csv"),
    bookvar_data_path("vni_data.xlsx"),
    bookvar_data_path("VNINDEX.csv"),
    bookvar_data_path("raw", "VNI.csv"),
    bookvar_data_path("raw", "vni_data.xlsx")
  )

  found <- candidates[file.exists(candidates)]
  if (!length(found)) {
    stop(
      "No VN-Index data file was found under data/. Expected a CSV or Excel source such as 'data/VNI.csv' or 'data/vni_data.xlsx'.",
      call. = FALSE
    )
  }

  found[[1]]
}

bookvar_parse_date_safe <- function(x) {
  if (inherits(x, "Date")) {
    return(x)
  }

  if (is.numeric(x)) {
    return(as.Date(x, origin = "1899-12-30"))
  }

  parsed <- suppressWarnings(as.Date(x))
  if (all(is.na(parsed))) {
    parsed <- suppressWarnings(as.Date(x, format = "%d/%m/%Y"))
  }
  if (all(is.na(parsed))) {
    parsed <- suppressWarnings(as.Date(x, format = "%m/%d/%Y"))
  }

  parsed
}

bookvar_numeric_safe <- function(x) {
  if (is.numeric(x)) {
    return(x)
  }

  cleaned <- gsub(",", "", as.character(x), fixed = TRUE)
  suppressWarnings(as.numeric(cleaned))
}

bookvar_standardize_vnindex <- function(raw_data) {
  names(raw_data) <- trimws(names(raw_data))
  names(raw_data) <- tolower(gsub("[^A-Za-z0-9]+", "_", names(raw_data)))

  rename_map <- c(
    date = "date",
    ngay = "date",
    trading_date = "date",
    close = "close",
    close_price = "close",
    dong_cua = "close",
    price = "close",
    open = "open",
    mo_cua = "open",
    high = "high",
    cao_nhat = "high",
    low = "low",
    thap_nhat = "low",
    volume = "volume",
    khoi_luong = "volume"
  )

  mapped <- rename_map[names(raw_data)]
  valid <- !is.na(mapped)
  names(raw_data)[valid] <- unname(mapped[valid])

  required <- c("date", "close")
  if (!all(required %in% names(raw_data))) {
    stop("VN-Index input must include at least 'date' and 'close' columns after standardization.", call. = FALSE)
  }

  raw_data$date <- bookvar_parse_date_safe(raw_data$date)
  raw_data$close <- bookvar_numeric_safe(raw_data$close)

  optional <- intersect(c("open", "high", "low", "volume"), names(raw_data))
  for (col in optional) {
    raw_data[[col]] <- bookvar_numeric_safe(raw_data[[col]])
  }

  raw_data <- raw_data[!is.na(raw_data$date) & !is.na(raw_data$close), , drop = FALSE]
  raw_data <- raw_data[order(raw_data$date), , drop = FALSE]
  raw_data <- raw_data[!duplicated(raw_data$date), , drop = FALSE]
  rownames(raw_data) <- NULL

  raw_data
}

bookvar_load_vnindex <- function(data_path = NULL, sheet = 1) {
  data_path <- data_path %||% bookvar_guess_vnindex_file()
  extension <- tolower(tools::file_ext(data_path))

  if (extension %in% c("xlsx", "xls")) {
    if (!requireNamespace("readxl", quietly = TRUE)) {
      stop("Package 'readxl' is required to read Excel VN-Index sources.", call. = FALSE)
    }
    raw_data <- readxl::read_excel(data_path, sheet = sheet)
  } else {
    raw_data <- utils::read.csv(data_path, stringsAsFactors = FALSE, check.names = FALSE)
  }

  standardized <- bookvar_standardize_vnindex(as.data.frame(raw_data))
  attr(standardized, "source_file") <- normalizePath(data_path, winslash = "/", mustWork = TRUE)
  standardized
}

bookvar_build_returns <- function(data, scale = 100) {
  close <- data$close
  log_price <- log(close)
  log_return <- c(NA_real_, diff(log_price)) * scale

  out <- data.frame(
    date = data$date,
    open = if ("open" %in% names(data)) data$open else NA_real_,
    high = if ("high" %in% names(data)) data$high else NA_real_,
    low = if ("low" %in% names(data)) data$low else NA_real_,
    close = close,
    volume = if ("volume" %in% names(data)) data$volume else NA_real_,
    log_price = log_price,
    log_return = log_return,
    loss = -log_return,
    abs_return = abs(log_return),
    sq_return = log_return^2
  )

  out <- out[!is.na(out$log_return), , drop = FALSE]
  rownames(out) <- NULL
  out
}

bookvar_prepare_vnindex_daily <- function(data_path = NULL, scale = 100) {
  vnindex <- bookvar_load_vnindex(data_path = data_path)
  daily <- bookvar_build_returns(vnindex, scale = scale)
  attr(daily, "source_file") <- attr(vnindex, "source_file")
  attr(daily, "return_scale") <- scale
  daily
}
