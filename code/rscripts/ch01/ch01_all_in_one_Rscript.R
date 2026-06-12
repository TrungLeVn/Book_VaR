# ============================================================
# ch01_all_in_one_Rscript.R
# Standalone Rscript for Chapter 1 tables, figures, estimates
# Run: Rscript ch01_all_in_one_Rscript.R
# ============================================================
ROOT_DIR <- getwd()
# ============================================================
# 00_setup.R
# Chapter 1 - shared configuration and helper functions
# ============================================================

if (!exists("ROOT_DIR")) ROOT_DIR <- getwd()

# ---- User configuration -------------------------------------
INSTALL_MISSING <- TRUE
USE_DEMO_IF_NO_DATA <- TRUE

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
# ============================================================
# 02_tables.R
# Tables for Chapter 1
# ============================================================

# ---- Table 1.1 ------------------------------------------------
tbl_1_1 <- tibble::tribble(
  ~`Tài sản`, ~`Giá đầu kỳ`, ~`Giá cuối kỳ`,
  "A", 50, 55,
  "B", 200, 206
) |>
  dplyr::mutate(
    `Thay đổi giá` = `Giá cuối kỳ` - `Giá đầu kỳ`,
    `Tỷ lệ sinh lời` = (`Giá cuối kỳ` - `Giá đầu kỳ`) / `Giá đầu kỳ`,
    `Nhận xét` = dplyr::case_when(
      `Tài sản` == "A" ~ "Tăng giá tuyệt đối thấp hơn, nhưng tỷ lệ sinh lời cao hơn",
      `Tài sản` == "B" ~ "Tăng giá tuyệt đối cao hơn, nhưng tỷ lệ sinh lời thấp hơn"
    )
  )

ft_1_1 <- tbl_1_1 |>
  dplyr::mutate(`Tỷ lệ sinh lời` = scales::percent(`Tỷ lệ sinh lời`, accuracy = 0.1, decimal.mark = ",")) |>
  flextable::flextable() |>
  format_ft()

save_ft_docx(ft_1_1, "Bảng 1.1. Vì sao cần dùng tỷ lệ sinh lời thay vì thay đổi giá tuyệt đối?", "tbl_1_1_price_return.docx")
readr::write_csv(tbl_1_1, file.path(TAB_DIR, "tbl_1_1_price_return.csv"))

# ---- Table 1.2 ------------------------------------------------
tbl_1_2 <- tibble::tribble(
  ~`Vấn đề dữ liệu`, ~`Lựa chọn khuyến nghị`, ~`Lý do`, ~`Hệ quả nếu xử lý sai`,

  "Giá đóng cửa hay giá điều chỉnh",
  "Ưu tiên giá điều chỉnh khi phân tích cổ phiếu riêng lẻ",
  "Phản ánh tốt hơn cổ tức, chia tách, cổ phiếu thưởng và quyền mua",
  "Return có thể xuất hiện cú nhảy kỹ thuật không phản ánh rủi ro thị trường thực chất",

  "Cổ tức tiền mặt",
  "Tính vào return hoặc dùng giá điều chỉnh",
  "Cổ tức là một phần lợi ích kinh tế của nhà đầu tư",
  "Có thể đánh giá thấp return thực tế và phóng đại biến động quanh ngày không hưởng quyền",

  "Chia tách/cổ phiếu thưởng",
  "Điều chỉnh lại chuỗi giá trước khi tính return",
  "Giá sau sự kiện có thể giảm mạnh về mặt kỹ thuật nhưng giá trị kinh tế không giảm tương ứng",
  "Tạo return âm giả tạo, làm sai lệch volatility và VaR",

  "Phát hành quyền mua",
  "Điều chỉnh giá hoặc xử lý riêng các quan sát bị ảnh hưởng",
  "Quyền mua làm thay đổi giá tham chiếu và lợi ích kinh tế của cổ đông",
  "Tạo outlier kỹ thuật trong chuỗi return",

  "Ngày không giao dịch",
  "Sắp xếp theo ngày giao dịch thực tế; không nội suy giá nếu không có cơ sở",
  "Dữ liệu thị trường không có quan sát vào ngày nghỉ",
  "Có thể tạo return bằng 0 hoặc return giả nếu xử lý máy móc",

  "Dữ liệu thiếu",
  "Kiểm tra nguyên nhân thiếu; loại bỏ hoặc xử lý theo quy tắc rõ ràng",
  "Dữ liệu thiếu có thể do lỗi dữ liệu, ngừng giao dịch hoặc thanh khoản thấp",
  "Làm sai lệch thống kê mô tả, kiểm định và mô hình volatility",

  "Cổ phiếu thanh khoản thấp",
  "Cân nhắc loại khỏi mẫu hoặc phân tích riêng",
  "Giao dịch thưa có thể làm chuỗi giá không phản ánh liên tục thông tin thị trường",
  "Return có nhiều giá trị bằng 0, tự tương quan giả và volatility bị bóp méo",

  "Simple return hay log return",
  "Dùng log return cho mô hình chuỗi thời gian; dùng simple return cho P&L và danh mục",
  "Log return cộng được theo thời gian; simple return trực quan và cộng được theo tỷ trọng danh mục",
  "Diễn giải sai kết quả hoặc không nhất quán giữa phần mô hình và phần lãi/lỗ",

  "Giả định tái cân bằng danh mục",
  "Nêu rõ danh mục giữ nguyên số lượng tài sản hay tái cân bằng định kỳ",
  "Tỷ trọng danh mục thay đổi theo biến động giá nếu không tái cân bằng",
  "Return và VaR danh mục không thể so sánh giữa các phương án"
)

ft_1_2 <- tbl_1_2 |>
  flextable::flextable() |>
  flextable::width(j = 1, width = 1.55) |>
  flextable::width(j = 2, width = 2.00) |>
  flextable::width(j = 3, width = 2.10) |>
  flextable::width(j = 4, width = 2.15) |>
  format_ft(font_size = 9)

save_ft_docx(ft_1_2, "Bảng 1.2. Các quyết định dữ liệu khi tính tỷ lệ sinh lời trong thực nghiệm", "tbl_1_2_data_decisions.docx")
readr::write_csv(tbl_1_2, file.path(TAB_DIR, "tbl_1_2_data_decisions.csv"))

# ---- Table 1.3 ------------------------------------------------
tbl_1_3 <- tibble::tribble(
  ~`Tiêu chí`, ~`Tỷ lệ sinh lời giản đơn`, ~`Tỷ lệ sinh lời logarit`,

  "Công thức cơ bản",
  "R_t = (P_t - P_{t-1}) / P_{t-1}",
  "r_t = ln(P_t / P_{t-1})",

  "Diễn giải kinh tế",
  "Trực quan, phản ánh lãi/lỗ tương đối trong một kỳ",
  "Ít trực quan hơn, nhưng thuận tiện về mặt toán học",

  "Tổng hợp theo thời gian",
  "Tổng hợp bằng phép nhân lãi kép",
  "Có thể cộng trực tiếp qua thời gian",

  "Tổng hợp theo danh mục",
  "Danh mục là trung bình gia quyền của return thành phần",
  "Không có tính chất trung bình gia quyền chính xác",

  "Phù hợp nhất khi",
  "Phân tích hiệu quả đầu tư, P&L, return danh mục, phân bổ tài sản",
  "Mô hình hóa chuỗi thời gian, volatility, GARCH, VaR động",

  "Cách dùng trong cuốn sách",
  "Dùng khi diễn giải lãi/lỗ và danh mục",
  "Dùng chủ yếu trong các mô hình volatility và VaR/ES"
)

ft_1_3 <- tbl_1_3 |>
  flextable::flextable() |>
  flextable::width(j = 1, width = 1.60) |>
  flextable::width(j = 2, width = 2.45) |>
  flextable::width(j = 3, width = 2.45) |>
  format_ft()

save_ft_docx(ft_1_3, "Bảng 1.3. So sánh tỷ lệ sinh lời giản đơn và tỷ lệ sinh lời logarit", "tbl_1_3_simple_log_return.docx")
readr::write_csv(tbl_1_3, file.path(TAB_DIR, "tbl_1_3_simple_log_return.csv"))

# ---- Core-language table ------------------------------------
tbl_risk_language <- tibble::tribble(
  ~`Khái niệm`, ~`Ký hiệu gợi ý`, ~`Cách hiểu ngắn`, ~`Vai trò trong cuốn sách`,
  "Tỷ lệ sinh lời", "r_t hoặc R_t", "Mức thay đổi tương đối của giá trị đầu tư qua một kỳ", "Dữ liệu đầu vào cơ sở cho toàn bộ phân tích",
  "Lãi/lỗ vị thế", "P&L_t", "Giá trị lãi hoặc lỗ bằng tiền của một vị thế đầu tư", "Cầu nối giữa return và quản trị danh mục",
  "Tổn thất", "L_t = -P&L_t", "Cách viết lại P&L để giá trị dương phản ánh mức lỗ", "Nền tảng để định nghĩa phân phối tổn thất, VaR và ES",
  "Volatility", "sigma_t", "Thước đo quy mô dao động của tỷ lệ sinh lời", "Cầu nối từ phân phối return sang mô hình rủi ro động",
  "Value-at-Risk", "VaR_alpha,t", "Ngưỡng tổn thất tại một mức xác suất đuôi cho trước", "Thước đo phân vị của rủi ro đuôi",
  "Expected Shortfall", "ES_alpha,t", "Tổn thất trung bình khi đã vượt qua ngưỡng VaR", "Thước đo độ nghiêm trọng của rủi ro đuôi"
)

ft_risk_language <- tbl_risk_language |>
  flextable::flextable() |>
  flextable::width(j = 1, width = 1.45) |>
  flextable::width(j = 2, width = 1.25) |>
  flextable::width(j = 3, width = 2.35) |>
  flextable::width(j = 4, width = 2.35) |>
  format_ft()

save_ft_docx(ft_risk_language, "Bảng 1.x. Ngôn ngữ cốt lõi của Chương 1", "tbl_1_x_risk_language.docx")
readr::write_csv(tbl_risk_language, file.path(TAB_DIR, "tbl_1_x_risk_language.csv"))
# ============================================================
# 03_figures.R
# Figures for Chapter 1
# ============================================================

# ---- Figure 1.1: price and log return -----------------------
p_price <- ggplot2::ggplot(price_data, ggplot2::aes(x = Date, y = Price)) +
  ggplot2::geom_line(linewidth = 0.35) +
  ggplot2::labs(
    title = "Panel A. Chuỗi giá",
    x = NULL,
    y = "Giá/chỉ số"
  ) +
  theme_ch01()

p_return <- ggplot2::ggplot(price_data, ggplot2::aes(x = Date, y = log_return)) +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_line(linewidth = 0.30) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::labs(
    title = "Panel B. Tỷ lệ sinh lời logarit",
    x = NULL,
    y = "Log return"
  ) +
  theme_ch01()

fig_1_1 <- p_price / p_return +
  patchwork::plot_annotation(
    title = "Hình 1.1. Chuỗi giá và chuỗi tỷ lệ sinh lời logarit",
    caption = data_note
  )

save_plot_png(fig_1_1, "fig_1_1_price_logreturn.png", width = 7.5, height = 5.2)

# ---- Figure 1.2: simple vs log return -----------------------
return_relation <- tibble::tibble(
  simple_return = seq(-0.30, 0.30, by = 0.001),
  log_return = log1p(simple_return)
)

fig_1_2 <- ggplot2::ggplot(return_relation, ggplot2::aes(x = simple_return, y = log_return)) +
  ggplot2::geom_abline(intercept = 0, slope = 1, linetype = "dashed", linewidth = 0.5) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::labs(
    title = "Hình 1.2. Quan hệ giữa tỷ lệ sinh lời giản đơn và logarit",
    subtitle = "Đường đứt nét là đường 45 độ: log return xấp xỉ simple return khi mức sinh lời nhỏ",
    x = "Tỷ lệ sinh lời giản đơn",
    y = "Tỷ lệ sinh lời logarit",
    caption = "Ghi chú: Hình minh họa r_t = ln(1 + R_t). Khi |R_t| lớn, chênh lệch giữa hai thước đo tăng lên."
  ) +
  theme_ch01()

save_plot_png(fig_1_2, "fig_1_2_simple_vs_log_return.png", width = 7.2, height = 4.8)

# ---- Figure 1.3: price to loss distribution -----------------
flow_nodes <- tibble::tibble(
  id = 1:7,
  label = c(
    "Giá tài sản",
    "Giá điều chỉnh",
    "Tỷ lệ sinh lời",
    "P&L vị thế",
    "Biến tổn thất",
    "Phân phối tổn thất",
    "Volatility,\nVaR, ES"
  ),
  x = 1:7,
  y = 1
)

flow_edges <- tibble::tibble(
  x = flow_nodes$x[-nrow(flow_nodes)] + 0.36,
  xend = flow_nodes$x[-1] - 0.36,
  y = 1,
  yend = 1
)

fig_1_3 <- ggplot2::ggplot() +
  ggplot2::geom_segment(
    data = flow_edges,
    ggplot2::aes(x = x, xend = xend, y = y, yend = yend),
    arrow = grid::arrow(length = grid::unit(0.16, "inches")),
    linewidth = 0.45
  ) +
  ggplot2::geom_rect(
    data = flow_nodes,
    ggplot2::aes(xmin = x - 0.36, xmax = x + 0.36, ymin = y - 0.20, ymax = y + 0.20),
    fill = "white",
    color = "black",
    linewidth = 0.45
  ) +
  ggplot2::geom_text(
    data = flow_nodes,
    ggplot2::aes(x = x, y = y, label = stringr::str_wrap(label, width = 12)),
    size = 3.3,
    lineheight = 0.9
  ) +
  ggplot2::annotate(
    "text", x = 2, y = 0.55,
    label = "Xử lý cổ tức,\nchia tách, quyền mua",
    size = 3,
    lineheight = 0.9
  ) +
  ggplot2::annotate(
    "segment", x = 2, xend = 2, y = 0.70, yend = 0.82,
    arrow = grid::arrow(length = grid::unit(0.12, "inches")),
    linewidth = 0.35
  ) +
  ggplot2::annotate(
    "text", x = 4.5, y = 0.55,
    label = "Quy mô vị thế,\ndấu vị thế, kỳ nắm giữ",
    size = 3,
    lineheight = 0.9
  ) +
  ggplot2::annotate(
    "segment", x = 4.5, xend = 4.5, y = 0.70, yend = 0.82,
    arrow = grid::arrow(length = grid::unit(0.12, "inches")),
    linewidth = 0.35
  ) +
  ggplot2::labs(
    title = "Hình 1.3. Từ giá tài sản đến phân phối tổn thất",
    caption = "Ghi chú: Sơ đồ mô tả quy trình nền tảng trước khi ước lượng volatility, VaR và ES."
  ) +
  ggplot2::coord_cartesian(xlim = c(0.55, 7.45), ylim = c(0.35, 1.35), expand = FALSE) +
  ggplot2::theme_void(base_size = 12, base_family = "Arial") +
  ggplot2::theme(
    plot.title = ggplot2::element_text(face = "bold", hjust = 0.5),
    plot.caption = ggplot2::element_text(hjust = 0.5)
  )

save_plot_png(fig_1_3, "fig_1_3_price_to_loss_distribution.png", width = 9.5, height = 2.8)

# ---- Figure 1.4: original return-language figure ------------
p_price_overview <- ggplot2::ggplot(price_data, ggplot2::aes(x = Date, y = Price)) +
  ggplot2::geom_line(linewidth = 0.40) +
  ggplot2::labs(title = "Chuỗi giá", x = NULL, y = "Giá/chỉ số") +
  theme_ch01()

p_return_hist <- ggplot2::ggplot(price_data, ggplot2::aes(x = log_return)) +
  ggplot2::geom_histogram(bins = 32, fill = "grey75", color = "white", linewidth = 0.25) +
  ggplot2::geom_vline(xintercept = 0, linetype = "dashed", linewidth = 0.45) +
  ggplot2::labs(title = "Phân phối tỷ lệ sinh lời", x = "Log return", y = "Tần suất") +
  theme_ch01()

fig_1_4 <- p_price_overview + p_return_hist +
  patchwork::plot_layout(ncol = 2) +
  patchwork::plot_annotation(
    title = "Hình 1.4. Từ chuỗi giá sang tỷ lệ sinh lời và vùng đuôi trái",
    caption = data_note
  )

save_plot_png(fig_1_4, "fig_1_4_return_language_left_tail.png", width = 8.0, height = 5.2)

# ---- Figure 1.5: rolling volatility -------------------------
rolling_data <- price_data |>
  dplyr::mutate(
    rolling_vol = zoo::rollapply(
      log_return,
      width = ROLLING_WINDOW,
      FUN = stats::sd,
      align = "right",
      fill = NA_real_
    )
  )

fig_1_5 <- ggplot2::ggplot(rolling_data, ggplot2::aes(x = Date, y = rolling_vol)) +
  ggplot2::geom_line(linewidth = 0.35) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 0.1)) +
  ggplot2::labs(
    title = paste0("Hình 1.5. Biến động trượt ", ROLLING_WINDOW, " ngày của tỷ lệ sinh lời logarit"),
    x = NULL,
    y = "Rolling volatility",
    caption = data_note
  ) +
  theme_ch01()

save_plot_png(fig_1_5, "fig_1_5_rolling_volatility.png", width = 7.5, height = 4.5)

# ---- Figure 1.6: histogram and QQ plot ----------------------
p_hist <- ggplot2::ggplot(price_data, ggplot2::aes(x = log_return)) +
  ggplot2::geom_histogram(ggplot2::aes(y = after_stat(density)), bins = 45, fill = "grey80", color = "white") +
  ggplot2::geom_density(linewidth = 0.55) +
  ggplot2::labs(title = "Panel A. Histogram và mật độ thực nghiệm", x = "Log return", y = "Mật độ") +
  theme_ch01()

p_qq <- ggplot2::ggplot(price_data, ggplot2::aes(sample = log_return)) +
  ggplot2::stat_qq(size = 1.1) +
  ggplot2::stat_qq_line(linewidth = 0.45) +
  ggplot2::labs(title = "Panel B. Q-Q plot so với phân phối chuẩn", x = "Phân vị chuẩn lý thuyết", y = "Phân vị mẫu") +
  theme_ch01()

fig_1_6 <- p_hist + p_qq +
  patchwork::plot_layout(ncol = 2) +
  patchwork::plot_annotation(
    title = "Hình 1.6. Hình dạng phân phối tỷ lệ sinh lời",
    caption = data_note
  )

save_plot_png(fig_1_6, "fig_1_6_histogram_qqplot.png", width = 8.0, height = 4.8)
# ============================================================
# 04_estimates.R
# Descriptive statistics, diagnostics, VaR/ES estimates
# ============================================================

x <- price_data$log_return
loss <- -x

# ---- Descriptive statistics ---------------------------------
desc_stats <- tibble::tibble(
  n = length(stats::na.omit(x)),
  mean = mean(x, na.rm = TRUE),
  sd = stats::sd(x, na.rm = TRUE),
  min = min(x, na.rm = TRUE),
  q01 = as.numeric(stats::quantile(x, 0.01, na.rm = TRUE)),
  q05 = as.numeric(stats::quantile(x, 0.05, na.rm = TRUE)),
  median = stats::median(x, na.rm = TRUE),
  q95 = as.numeric(stats::quantile(x, 0.95, na.rm = TRUE)),
  q99 = as.numeric(stats::quantile(x, 0.99, na.rm = TRUE)),
  max = max(x, na.rm = TRUE),
  skewness = skewness_manual(x),
  kurtosis = kurtosis_manual(x),
  excess_kurtosis = kurtosis_manual(x) - 3
)

readr::write_csv(desc_stats, file.path(EST_DIR, "desc_stats_log_return.csv"))

ft_desc <- desc_stats |>
  dplyr::mutate(dplyr::across(where(is.numeric), ~ round(.x, 6))) |>
  flextable::flextable() |>
  format_ft(font_size = 8.5)

save_ft_docx(ft_desc, "Bảng 1.x. Thống kê mô tả tỷ lệ sinh lời logarit", "tbl_desc_stats_log_return.docx")

# ---- Diagnostic tests ---------------------------------------
normality_jb <- function(x) {
  x <- stats::na.omit(x)
  n <- length(x)
  s <- skewness_manual(x)
  k <- kurtosis_manual(x)
  jb <- n / 6 * (s^2 + (k - 3)^2 / 4)
  p <- stats::pchisq(jb, df = 2, lower.tail = FALSE)
  tibble::tibble(test = "Jarque-Bera", statistic = jb, p_value = p, null = "Normality")
}

extract_test <- function(obj, test_name, null_name) {
  if (length(obj) == 1 && is.na(obj)) {
    return(tibble::tibble(test = test_name, statistic = NA_real_, p_value = NA_real_, null = null_name))
  }
  tibble::tibble(
    test = test_name,
    statistic = as.numeric(obj$statistic[1]),
    p_value = as.numeric(obj$p.value),
    null = null_name
  )
}

lag_lb <- min(20, floor(length(x) / 5))
lag_arch <- min(12, floor(length(x) / 10))

diagnostic_tests <- dplyr::bind_rows(
  normality_jb(x),
  extract_test(stats::Box.test(x, lag = lag_lb, type = "Ljung-Box"), paste0("Ljung-Box return, lag ", lag_lb), "No autocorrelation"),
  extract_test(stats::Box.test(x^2, lag = lag_lb, type = "Ljung-Box"), paste0("Ljung-Box squared return, lag ", lag_lb), "No autocorrelation"),
  extract_test(safe_test(tseries::adf.test(x)), "ADF", "Unit root"),
  extract_test(safe_test(tseries::pp.test(x)), "Phillips-Perron", "Unit root"),
  extract_test(safe_test(tseries::kpss.test(x)), "KPSS", "Stationarity"),
  extract_test(safe_test(FinTS::ArchTest(x, lags = lag_arch)), paste0("ARCH-LM, lag ", lag_arch), "No ARCH effect")
) |>
  dplyr::mutate(
    statistic = round(statistic, 4),
    p_value = round(p_value, 4)
  )

readr::write_csv(diagnostic_tests, file.path(EST_DIR, "diagnostic_tests_log_return.csv"))

ft_tests <- diagnostic_tests |>
  flextable::flextable() |>
  format_ft(font_size = 9)

save_ft_docx(ft_tests, "Bảng 1.x. Kiểm định chẩn đoán sơ bộ chuỗi tỷ lệ sinh lời", "tbl_diagnostic_tests.docx")

# ---- Simple VaR and ES estimates ----------------------------
var_es_estimates <- purrr::map_dfr(VAR_LEVELS, function(cl) {
  alpha <- 1 - cl
  q_return <- as.numeric(stats::quantile(x, probs = alpha, na.rm = TRUE, type = 7))
  var_rate <- -q_return
  es_rate <- -mean(x[x <= q_return], na.rm = TRUE)

  tibble::tibble(
    confidence_level = cl,
    tail_probability = alpha,
    return_quantile = q_return,
    VaR_rate = var_rate,
    ES_rate = es_rate,
    VaR_money = POSITION_VALUE * var_rate,
    ES_money = POSITION_VALUE * es_rate
  )
})

readr::write_csv(var_es_estimates, file.path(EST_DIR, "historical_var_es.csv"))

ft_var_es <- var_es_estimates |>
  dplyr::mutate(
    confidence_level = scales::percent(confidence_level, accuracy = 1),
    tail_probability = scales::percent(tail_probability, accuracy = 1),
    return_quantile = scales::percent(return_quantile, accuracy = 0.01),
    VaR_rate = scales::percent(VaR_rate, accuracy = 0.01),
    ES_rate = scales::percent(ES_rate, accuracy = 0.01),
    VaR_money = scales::comma(round(VaR_money, 0), big.mark = ".", decimal.mark = ","),
    ES_money = scales::comma(round(ES_money, 0), big.mark = ".", decimal.mark = ",")
  ) |>
  flextable::flextable() |>
  format_ft(font_size = 8.8)

save_ft_docx(ft_var_es, "Bảng 1.x. Ước lượng VaR và ES lịch sử", "tbl_historical_var_es.docx")

# ---- VaR exceedance plot ------------------------------------
var_99_rate <- var_es_estimates |>
  dplyr::filter(confidence_level == max(VAR_LEVELS)) |>
  dplyr::pull(VaR_rate)

var_plot_data <- price_data |>
  dplyr::mutate(
    loss_rate = -log_return,
    VaR_rate = var_99_rate,
    exceedance = loss_rate > VaR_rate
  )

fig_var_exceedance <- ggplot2::ggplot(var_plot_data, ggplot2::aes(x = Date)) +
  ggplot2::geom_line(ggplot2::aes(y = loss_rate), linewidth = 0.30) +
  ggplot2::geom_hline(yintercept = var_99_rate, linetype = "dashed", linewidth = 0.45) +
  ggplot2::geom_point(
    data = dplyr::filter(var_plot_data, exceedance),
    ggplot2::aes(y = loss_rate),
    size = 1.2
  ) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::labs(
    title = "Hình 1.x. Minh họa các ngày lỗ vượt ngưỡng VaR lịch sử",
    x = NULL,
    y = "Tỷ lệ lỗ",
    caption = paste0(data_note, " Đường đứt nét là VaR lịch sử ở mức tin cậy ", scales::percent(max(VAR_LEVELS), accuracy = 1), ".")
  ) +
  theme_ch01()

save_plot_png(fig_var_exceedance, "fig_1_x_var_exceedance.png", width = 7.5, height = 4.5)
# ============================================================
# 05_export_report.R
# Optional Word report collecting all Chapter 1 outputs
# ============================================================

add_plot_if_exists <- function(doc, title, img_file, width = 6.5, height = 4.2) {
  path <- file.path(FIG_DIR, img_file)
  if (file.exists(path)) {
    doc <- officer::body_add_par(doc, title, style = "heading 2")
    doc <- officer::body_add_img(doc, src = path, width = width, height = height)
  }
  doc
}

doc <- officer::read_docx()
doc <- officer::body_add_par(doc, "Outputs for Chapter 1", style = "heading 1")
doc <- officer::body_add_par(doc, paste("Series:", SERIES_NAME), style = "Normal")
doc <- officer::body_add_par(doc, data_note, style = "Normal")

# Tables
doc <- officer::body_add_par(doc, "Tables", style = "heading 1")
doc <- officer::body_add_par(doc, "Bảng 1.1. Vì sao cần dùng tỷ lệ sinh lời thay vì thay đổi giá tuyệt đối?", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_1_1)
doc <- officer::body_add_par(doc, "Bảng 1.2. Các quyết định dữ liệu khi tính tỷ lệ sinh lời trong thực nghiệm", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_1_2)
doc <- officer::body_add_par(doc, "Bảng 1.3. So sánh tỷ lệ sinh lời giản đơn và tỷ lệ sinh lời logarit", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_1_3)
doc <- officer::body_add_par(doc, "Bảng 1.x. Ngôn ngữ cốt lõi của Chương 1", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_risk_language)
doc <- officer::body_add_par(doc, "Bảng 1.x. Thống kê mô tả tỷ lệ sinh lời logarit", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_desc)
doc <- officer::body_add_par(doc, "Bảng 1.x. Kiểm định chẩn đoán sơ bộ chuỗi tỷ lệ sinh lời", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_tests)
doc <- officer::body_add_par(doc, "Bảng 1.x. Ước lượng VaR và ES lịch sử", style = "heading 2")
doc <- flextable::body_add_flextable(doc, ft_var_es)

# Figures
doc <- officer::body_add_par(doc, "Figures", style = "heading 1")
doc <- add_plot_if_exists(doc, "Hình 1.1. Chuỗi giá và chuỗi tỷ lệ sinh lời logarit", "fig_1_1_price_logreturn.png", 6.5, 4.5)
doc <- add_plot_if_exists(doc, "Hình 1.2. Quan hệ giữa tỷ lệ sinh lời giản đơn và logarit", "fig_1_2_simple_vs_log_return.png", 6.4, 4.2)
doc <- add_plot_if_exists(doc, "Hình 1.3. Từ giá tài sản đến phân phối tổn thất", "fig_1_3_price_to_loss_distribution.png", 6.8, 2.1)
doc <- add_plot_if_exists(doc, "Hình 1.4. Từ chuỗi giá sang tỷ lệ sinh lời và vùng đuôi trái", "fig_1_4_return_language_left_tail.png", 6.6, 4.3)
doc <- add_plot_if_exists(doc, "Hình 1.5. Biến động trượt của tỷ lệ sinh lời logarit", "fig_1_5_rolling_volatility.png", 6.6, 4.0)
doc <- add_plot_if_exists(doc, "Hình 1.6. Hình dạng phân phối tỷ lệ sinh lời", "fig_1_6_histogram_qqplot.png", 6.8, 4.1)
doc <- add_plot_if_exists(doc, "Hình 1.x. Minh họa các ngày lỗ vượt ngưỡng VaR lịch sử", "fig_1_x_var_exceedance.png", 6.6, 4.0)

out_docx <- file.path(DOC_DIR, "ch01_tables_figures_estimates.docx")
print(doc, target = out_docx)
message("Saved Word report: ", out_docx)
