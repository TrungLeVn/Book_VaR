if (!exists("bookvar_data_path", mode = "function")) {
  stop("Source R/helpers/path_helpers.R before sourcing R/data/prepare_vnindex.R.", call. = FALSE)
}

bookvar_guess_vnindex_file <- function() {
  candidates <- c(
    bookvar_data_path("vni_data.xlsx"),
    bookvar_data_path("VNI.csv"),
    bookvar_data_path("vnindex.csv"),
    bookvar_data_path("VNINDEX.csv")
  )

  found <- candidates[file.exists(candidates)]
  if (!length(found)) {
    stop(
      "No local VN-Index data file was found under data/. Expected a local Excel or CSV file such as 'data/vni_data.xlsx' or 'data/VNI.csv'.",
      call. = FALSE
    )
  }

  found[[1]]
}

bookvar_parse_date_safe <- function(x) {
  if (inherits(x, "Date")) {
    return(x)
  }

  if (inherits(x, c("POSIXct", "POSIXt"))) {
    return(as.Date(x))
  }

  if (is.numeric(x)) {
    return(as.Date(x, origin = "1899-12-30"))
  }

  x_chr <- trimws(as.character(x))

  parsed <- suppressWarnings(as.Date(x_chr))

  if (all(is.na(parsed)) && requireNamespace("lubridate", quietly = TRUE)) {
    parsed <- suppressWarnings(lubridate::ymd(x_chr))
  }
  if (all(is.na(parsed)) && requireNamespace("lubridate", quietly = TRUE)) {
    parsed <- suppressWarnings(lubridate::dmy(x_chr))
  }
  if (all(is.na(parsed)) && requireNamespace("lubridate", quietly = TRUE)) {
    parsed <- suppressWarnings(lubridate::mdy(x_chr))
  }

  as.Date(parsed)
}

bookvar_numeric_safe <- function(x) {
  if (is.numeric(x)) {
    return(as.numeric(x))
  }

  cleaned <- trimws(as.character(x))
  cleaned <- gsub("%", "", cleaned, fixed = TRUE)
  cleaned <- gsub(",", "", cleaned, fixed = TRUE)
  suppressWarnings(as.numeric(cleaned))
}

bookvar_sample_skewness <- function(x) {
  x <- x[is.finite(x)]
  if (length(x) < 3L) {
    return(NA_real_)
  }

  if (requireNamespace("moments", quietly = TRUE)) {
    return(moments::skewness(x))
  }

  centered <- x - mean(x)
  s <- stats::sd(x)
  if (is.na(s) || s == 0) {
    return(NA_real_)
  }
  mean((centered / s)^3)
}

bookvar_sample_excess_kurtosis <- function(x) {
  x <- x[is.finite(x)]
  if (length(x) < 4L) {
    return(NA_real_)
  }

  if (requireNamespace("moments", quietly = TRUE)) {
    return(moments::kurtosis(x) - 3)
  }

  centered <- x - mean(x)
  s <- stats::sd(x)
  if (is.na(s) || s == 0) {
    return(NA_real_)
  }
  mean((centered / s)^4) - 3
}

bookvar_safe_test <- function(expr) {
  tryCatch(expr, error = function(...) NULL, warning = function(...) suppressWarnings(expr))
}

bookvar_safe_stat <- function(test_obj) {
  if (is.null(test_obj)) {
    return(NA_real_)
  }
  round(unname(test_obj$statistic[1]), 3)
}

bookvar_safe_pvalue <- function(test_obj) {
  if (is.null(test_obj)) {
    return(NA_real_)
  }
  signif(test_obj$p.value, 4)
}

bookvar_make_acf_df <- function(x, label, lag_max = 30) {
  ac <- stats::acf(x, lag.max = lag_max, plot = FALSE, na.action = na.pass)

  data.frame(
    lag = as.numeric(ac$lag),
    acf = as.numeric(ac$acf),
    series = label,
    stringsAsFactors = FALSE
  ) |>
    subset(lag > 0)
}

bookvar_standardize_vnindex <- function(df) {
  names(df) <- tolower(names(df))
  names(df) <- gsub("\\.", "_", names(df))
  names(df) <- gsub(" ", "_", names(df))

  date_candidates <- c("date", "ngay", "ngày", "trading_date", "tradingdate", "time")
  open_candidates <- c("open", "open_price", "gia_mo_cua", "mo_cua")
  high_candidates <- c("high", "high_price", "gia_cao_nhat", "cao_nhat")
  low_candidates <- c("low", "low_price", "gia_thap_nhat", "thap_nhat")
  close_candidates <- c(
    "adjusted", "adjusted_close", "adj_close", "close",
    "close_price", "gia_dong_cua", "dong_cua", "price"
  )

  pick_col <- function(candidates) {
    hit <- intersect(candidates, names(df))
    if (length(hit) == 0L) {
      return(NA_character_)
    }
    hit[1]
  }

  date_col <- pick_col(date_candidates)
  close_col <- pick_col(close_candidates)
  open_col <- pick_col(open_candidates)
  high_col <- pick_col(high_candidates)
  low_col <- pick_col(low_candidates)

  if (is.na(date_col) || is.na(close_col)) {
    stop(
      "VN-Index input must include at least a date column and a close/adjusted close column after standardization.",
      call. = FALSE
    )
  }

  out <- data.frame(
    date = bookvar_parse_date_safe(df[[date_col]]),
    open = if (!is.na(open_col)) bookvar_numeric_safe(df[[open_col]]) else NA_real_,
    high = if (!is.na(high_col)) bookvar_numeric_safe(df[[high_col]]) else NA_real_,
    low = if (!is.na(low_col)) bookvar_numeric_safe(df[[low_col]]) else NA_real_,
    close = bookvar_numeric_safe(df[[close_col]]),
    stringsAsFactors = FALSE
  )

  out <- out[!is.na(out$date) & is.finite(out$close) & out$close > 0, , drop = FALSE]
  out <- out[order(out$date), , drop = FALSE]
  out <- out[!duplicated(out$date), , drop = FALSE]

  if (all(is.finite(out$high)) && all(is.finite(out$low)) && any(out$high < out$low, na.rm = TRUE)) {
    stop("Invalid OHLC input: at least one observation has High lower than Low.", call. = FALSE)
  }

  rownames(out) <- NULL
  out
}

bookvar_load_vnindex <- function(data_path = NULL, sheet = 1) {
  data_path <- data_path %||% bookvar_guess_vnindex_file()
  extension <- tolower(tools::file_ext(data_path))

  raw_data <- switch(
    extension,
    "xlsx" = {
      if (!requireNamespace("readxl", quietly = TRUE)) {
        stop("Package 'readxl' is required to read local Excel VN-Index sources.", call. = FALSE)
      }
      readxl::read_excel(data_path, sheet = sheet)
    },
    "xls" = {
      if (!requireNamespace("readxl", quietly = TRUE)) {
        stop("Package 'readxl' is required to read local Excel VN-Index sources.", call. = FALSE)
      }
      readxl::read_excel(data_path, sheet = sheet)
    },
    "csv" = utils::read.csv(data_path, stringsAsFactors = FALSE, check.names = FALSE, fileEncoding = "UTF-8-BOM"),
    stop("Unsupported VN-Index file format: ", extension, call. = FALSE)
  )

  standardized <- bookvar_standardize_vnindex(as.data.frame(raw_data))
  attr(standardized, "source_file") <- normalizePath(data_path, winslash = "/", mustWork = TRUE)
  standardized
}

bookvar_source_note <- function(data_path) {
  paste0("Dữ liệu được đọc từ file nội bộ ", bookvar_rel_path(data_path), ".")
}

bookvar_build_returns <- function(data, scale = 100) {
  close <- data$close
  log_price <- log(close)
  ret <- scale * (log_price - dplyr::lag(log_price))

  out <- data.frame(
    date = data$date,
    open = data$open,
    high = data$high,
    low = data$low,
    close = close,
    log_price = log_price,
    ret = ret,
    log_return = ret,
    loss = -ret,
    abs_ret = abs(ret),
    neg_ret = ifelse(ret < 0, abs(ret), 0),
    ret_lag1 = dplyr::lag(ret),
    abs_ret_lag1 = dplyr::lag(abs(ret)),
    loss_lag1 = dplyr::lag(-ret),
    neg_ret_lag1 = dplyr::lag(ifelse(ret < 0, abs(ret), 0)),
    sq_return = ret^2,
    stringsAsFactors = FALSE
  )

  out <- out[is.finite(out$ret), , drop = FALSE]
  rownames(out) <- NULL
  out
}

bookvar_prepare_vnindex_daily <- function(data_path = NULL, scale = 100) {
  vnindex_raw <- bookvar_load_vnindex(data_path = data_path)
  daily <- bookvar_build_returns(vnindex_raw, scale = scale)
  attr(daily, "source_file") <- attr(vnindex_raw, "source_file")
  attr(daily, "return_scale") <- scale
  daily
}

bookvar_build_ch05_metadata <- function(vn_raw, vn_daily, estimation_window = 500, holding_period = 1, alpha_levels = c(0.05, 0.01), refit_every = 25, pot_threshold_prob = 0.90, backtest_buffer = 100) {
  if (nrow(vn_daily) <= estimation_window + backtest_buffer) {
    stop(
      "The current daily series is too short for the requested rolling design. Add more historical data or reduce the estimation window.",
      call. = FALSE
    )
  }

  source_file <- attr(vn_raw, "source_file")
  sample_start <- min(vn_daily$date)
  sample_end <- max(vn_daily$date)
  backtest_start <- vn_daily$date[estimation_window + 1L]

  list(
    source_file = source_file,
    source_note = bookvar_source_note(source_file),
    sample_start = sample_start,
    sample_end = sample_end,
    backtest_start = backtest_start,
    estimation_window = estimation_window,
    holding_period = holding_period,
    alpha_levels = alpha_levels,
    alpha_labels = c("0.05" = "95%", "0.01" = "99%"),
    refit_every = refit_every,
    pot_threshold_prob = pot_threshold_prob
  )
}

bookvar_build_ch05_research_design <- function(vn_daily, metadata) {
  data.frame(
    `Thành phần` = c(
      "Tài sản đại diện",
      "Nguồn dữ liệu",
      "Tần suất",
      "Tỷ lệ sinh lời",
      "Đại lượng lỗ",
      "Kỳ nắm giữ",
      "Mức tin cậy",
      "Cửa sổ ước lượng",
      "Giai đoạn kiểm định ngoài mẫu",
      "Ngưỡng POT cho EVT"
    ),
    `Lựa chọn trong chương` = c(
      "VN-Index",
      metadata$source_note,
      "Ngày giao dịch",
      "$r_t = 100[\\ln(P_t)-\\ln(P_{t-1})]$",
      "$L_t=-r_t$",
      paste0(metadata$holding_period, " ngày"),
      "95% và 99%",
      paste0(metadata$estimation_window, " quan sát giao dịch"),
      paste0(format(metadata$backtest_start), " đến ", format(metadata$sample_end)),
      paste0(scales::percent(metadata$pot_threshold_prob, accuracy = 0.1, decimal.mark = ","), " của phân phối lỗ trong cửa sổ rolling")
    ),
    stringsAsFactors = FALSE
  )
}

bookvar_build_ch05_data_summary <- function(vn_daily, metadata) {
  data.frame(
    `Số quan sát` = nrow(vn_daily),
    `Ngày bắt đầu` = as.character(metadata$sample_start),
    `Ngày kết thúc` = as.character(metadata$sample_end),
    `Trung bình (%)` = mean(vn_daily$ret, na.rm = TRUE),
    `Độ lệch chuẩn (%)` = stats::sd(vn_daily$ret, na.rm = TRUE),
    `Nhỏ nhất (%)` = min(vn_daily$ret, na.rm = TRUE),
    `Lớn nhất (%)` = max(vn_daily$ret, na.rm = TRUE),
    `Skewness` = bookvar_sample_skewness(vn_daily$ret),
    `Excess kurtosis` = bookvar_sample_excess_kurtosis(vn_daily$ret),
    check.names = FALSE
  )
}

bookvar_build_ch05_price_return_data <- function(vn_raw, vn_daily) {
  list(
    price = vn_raw[, c("date", "close"), drop = FALSE],
    returns = vn_daily[, c("date", "ret", "loss"), drop = FALSE]
  )
}

bookvar_build_ch05_hist_qq_data <- function(vn_daily) {
  mu_ret <- mean(vn_daily$ret, na.rm = TRUE)
  sd_ret <- stats::sd(vn_daily$ret, na.rm = TRUE)

  hist_data <- within(vn_daily, {
    z <- (ret - mu_ret) / sd_ret
  })

  qq_data <- data.frame(
    sample = sort(hist_data$z),
    theoretical = stats::qnorm(stats::ppoints(length(hist_data$z)))
  )

  list(
    histogram = hist_data,
    qq = qq_data,
    mean_ret = mu_ret,
    sd_ret = sd_ret
  )
}

bookvar_build_ch05_stationarity_tests <- function(vn_daily) {
  log_price <- vn_daily$log_price
  r_vnindex <- vn_daily$ret

  adf_price <- bookvar_safe_test(tseries::adf.test(log_price))
  adf_return <- bookvar_safe_test(tseries::adf.test(r_vnindex))
  pp_price <- bookvar_safe_test(tseries::pp.test(log_price))
  pp_return <- bookvar_safe_test(tseries::pp.test(r_vnindex))
  kpss_price <- bookvar_safe_test(tseries::kpss.test(log_price))
  kpss_return <- bookvar_safe_test(tseries::kpss.test(r_vnindex))

  data.frame(
    `Kiểm định` = c("ADF", "ADF", "PP", "PP", "KPSS", "KPSS"),
    `Biến` = c("log price", "log return", "log price", "log return", "log price", "log return"),
    `Thống kê` = c(
      bookvar_safe_stat(adf_price), bookvar_safe_stat(adf_return),
      bookvar_safe_stat(pp_price), bookvar_safe_stat(pp_return),
      bookvar_safe_stat(kpss_price), bookvar_safe_stat(kpss_return)
    ),
    `p-value` = c(
      bookvar_safe_pvalue(adf_price), bookvar_safe_pvalue(adf_return),
      bookvar_safe_pvalue(pp_price), bookvar_safe_pvalue(pp_return),
      bookvar_safe_pvalue(kpss_price), bookvar_safe_pvalue(kpss_return)
    ),
    check.names = FALSE
  )
}

bookvar_build_ch05_acf_data <- function(vn_daily, lag_max = 30) {
  r_vnindex <- vn_daily$ret
  rbind(
    bookvar_make_acf_df(r_vnindex, "Return", lag_max = lag_max),
    bookvar_make_acf_df(r_vnindex^2, "Squared return", lag_max = lag_max)
  )
}

bookvar_build_ch05_dependence_tests <- function(vn_daily, lag = 12) {
  r_vnindex <- vn_daily$ret
  lb_return <- stats::Box.test(r_vnindex, lag = lag, type = "Ljung-Box")
  lb_sq_return <- stats::Box.test(r_vnindex^2, lag = lag, type = "Ljung-Box")
  arch_lm <- FinTS::ArchTest(r_vnindex, lags = lag)

  data.frame(
    `Kiểm định` = c("Ljung-Box trên return", "Ljung-Box trên return^2", "ARCH-LM"),
    `Độ trễ` = c(lag, lag, lag),
    `Thống kê` = c(
      round(unname(lb_return$statistic), 3),
      round(unname(lb_sq_return$statistic), 3),
      round(unname(arch_lm$statistic), 3)
    ),
    `p-value` = c(
      signif(lb_return$p.value, 4),
      signif(lb_sq_return$p.value, 4),
      signif(arch_lm$p.value, 4)
    ),
    check.names = FALSE
  )
}

# TODO: Yahoo fallback existed in legacy-ch05.qmd but is intentionally postponed here
# because local RStudio testing should stay deterministic and file-based.
