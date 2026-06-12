# ============================================================
# 01_data.R
# Read and prepare price/return data for Chapter 1
# ============================================================

clean_names_basic <- function(x) {
  x |>
    stringr::str_replace_all("\\s+", "") |>
    stringr::str_replace_all("\\.", "") |>
    stringr::str_replace_all("_", "")
}

parse_date_safe <- function(x) {
  if (inherits(x, "Date")) return(x)
  out <- suppressWarnings(as.Date(x))
  if (all(is.na(out))) out <- suppressWarnings(lubridate::ymd(x))
  if (all(is.na(out))) out <- suppressWarnings(lubridate::dmy(x))
  if (all(is.na(out))) out <- suppressWarnings(lubridate::mdy(x))
  out
}

read_price_data <- function(file_path) {
  raw <- readr::read_csv(
    file_path,
    locale = readr::locale(encoding = "UTF-8"),
    show_col_types = FALSE
  )

  original_names <- names(raw)
  names(raw) <- clean_names_basic(names(raw))

  date_candidates <- clean_names_basic(c("Date", "TradingDate", "Ngay", "Ngày", "date"))
  price_candidates <- clean_names_basic(c(
    "Adjusted", "AdjClose", "AdjClosePrice", "CloseAdjusted",
    "Close", "Price", "Index", "Value"
  ))

  date_col <- intersect(date_candidates, names(raw))[1]
  price_col <- intersect(price_candidates, names(raw))[1]

  if (is.na(date_col)) {
    stop("Không tìm thấy cột ngày. Hãy dùng tên cột Date, TradingDate hoặc Ngay.", call. = FALSE)
  }
  if (is.na(price_col)) {
    stop("Không tìm thấy cột giá. Hãy dùng tên cột Adjusted, AdjClose, Close, Price hoặc Index.", call. = FALSE)
  }

  raw |>
    dplyr::transmute(
      Date = parse_date_safe(.data[[date_col]]),
      Price = as.numeric(.data[[price_col]])
    ) |>
    dplyr::filter(!is.na(Date), !is.na(Price), Price > 0) |>
    dplyr::arrange(Date) |>
    dplyr::mutate(
      simple_return = Price / dplyr::lag(Price) - 1,
      log_return = log(Price / dplyr::lag(Price)),
      loss_return = -log_return
    ) |>
    dplyr::filter(!is.na(log_return))
}

make_demo_price_data <- function(seed = 20260612, n = 2200) {
  set.seed(seed)

  tibble::tibble(
    Date = seq.Date(as.Date("2015-01-01"), by = "day", length.out = ceiling(n * 1.6))
  ) |>
    dplyr::filter(lubridate::wday(Date) %in% 2:6) |>
    dplyr::slice_head(n = n) |>
    dplyr::mutate(
      shock = dplyr::case_when(
        dplyr::row_number() %in% 650:780 ~ stats::rnorm(dplyr::n(), -0.00020, 0.024),
        dplyr::row_number() %in% 1450:1580 ~ stats::rnorm(dplyr::n(), -0.00010, 0.021),
        TRUE ~ stats::rnorm(dplyr::n(), 0.00035, 0.011)
      ),
      Price = 600 * exp(cumsum(shock)),
      simple_return = Price / dplyr::lag(Price) - 1,
      log_return = log(Price / dplyr::lag(Price)),
      loss_return = -log_return
    ) |>
    dplyr::filter(!is.na(log_return))
}

load_ch01_data <- function() {
  if (file.exists(DATA_FILE)) {
    data <- read_price_data(DATA_FILE)
    note <- paste0("Nguồn: Dữ liệu ", SERIES_NAME, " do tác giả cung cấp.")
  } else if (isTRUE(USE_DEMO_IF_NO_DATA)) {
    data <- make_demo_price_data()
    note <- paste0(
      "Ghi chú: Hình sử dụng dữ liệu mô phỏng để minh họa; ",
      "khi hoàn thiện bản thảo cần thay bằng dữ liệu ", SERIES_NAME, " thực tế."
    )
  } else {
    stop("Không tìm thấy DATA_FILE: ", DATA_FILE, call. = FALSE)
  }

  attr(data, "data_note") <- note
  data
}

price_data <- load_ch01_data()
data_note <- attr(price_data, "data_note")

readr::write_csv(price_data, file.path(EST_DIR, "ch01_prepared_returns.csv"))
message("Prepared observations: ", nrow(price_data))
