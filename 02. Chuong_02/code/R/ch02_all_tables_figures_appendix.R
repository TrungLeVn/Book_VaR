# ============================================================
# Chapter 2 combined R script: setup + figures + appendix tables + export
# Book: Volatility, VaR and ES for Vietnamese financial returns
# Chapter 2: Forecasting volatility and conditional variance models
#
# This is a production helper script, not main-text content.
# It intentionally keeps all R code outside the printed chapter.
# ============================================================

# ============================================================
# 0. Packages and output folders
# ============================================================

required_packages <- c(
  "dplyr", "tidyr", "tibble", "ggplot2", "scales", "patchwork",
  "zoo", "readr", "flextable", "officer", "sgt"
)

install_missing_packages <- function(pkgs) {
  missing <- pkgs[!pkgs %in% rownames(utils::installed.packages())]
  if (length(missing) > 0) {
    utils::install.packages(missing)
  }
  invisible(TRUE)
}

install_missing_packages(required_packages)
suppressPackageStartupMessages(invisible(lapply(required_packages, library, character.only = TRUE)))

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
      return(normalizePath(start_dir, winslash = "/", mustWork = TRUE))
    }
    current <- parent
  }
}

SCRIPT_DIR <- resolve_script_dir()
REPO_ROOT <- find_repo_root(SCRIPT_DIR)
CHAPTER_DIR <- file.path(REPO_ROOT, "02. Chuong_02")
OUT_DIR  <- file.path(CHAPTER_DIR, "output")
FIG_DIR  <- file.path(OUT_DIR, "figures")
TAB_DIR  <- file.path(OUT_DIR, "tables")
DOCX_DIR <- file.path(OUT_DIR, "tables")

for (d in c(OUT_DIR, FIG_DIR, TAB_DIR, DOCX_DIR)) {
  if (!dir.exists(d)) dir.create(d, recursive = TRUE)
}

BOOK_DPI <- 300
BOOK_FIG_WIDTH <- 8
BOOK_FIG_HEIGHT <- 5

# ============================================================
# 1. Common theme and helpers
# ============================================================

theme_ch02 <- function(base_size = 12) {
  ggplot2::theme_minimal(base_size = base_size) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = base_size + 3),
      plot.subtitle = ggplot2::element_text(size = base_size),
      plot.caption = ggplot2::element_text(size = base_size - 3, hjust = 0),
      axis.title = ggplot2::element_text(face = "bold"),
      legend.position = "bottom",
      panel.grid.minor = ggplot2::element_blank()
    )
}

percent_vn <- scales::label_percent(accuracy = 0.1, decimal.mark = ",")

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
    flextable::valign(valign = "top", part = "all") |>
    flextable::fontsize(size = 10, part = "all") |>
    flextable::padding(padding = 4, part = "all") |>
    flextable::border_outer(border = officer::fp_border(color = "gray70", width = 0.75)) |>
    flextable::border_inner_h(border = officer::fp_border(color = "gray80", width = 0.5)) |>
    flextable::border_inner_v(border = officer::fp_border(color = "gray80", width = 0.5)) |>
    flextable::autofit()
}

save_table_outputs <- function(data, file_stem, title, source = "Nguồn: Tổng hợp của tác giả.") {
  readr::write_csv(data, file.path(TAB_DIR, paste0(file_stem, ".csv")))

  doc <- officer::read_docx()
  doc <- officer::body_add_par(doc, title, style = "Normal")
  doc <- flextable::body_add_flextable(doc, format_table_docx(data))
  doc <- officer::body_add_par(doc, source, style = "Normal")
  print(doc, target = file.path(TAB_DIR, paste0(file_stem, ".docx")))
}

# ============================================================
# 2. Simulation and distribution functions
# ============================================================

set.seed(20260708)

make_ewma_weights <- function(lambda, max_lag = 80) {
  tibble::tibble(
    lag = 0:max_lag,
    lambda = lambda,
    weight = (1 - lambda) * lambda^(0:max_lag)
  )
}

compute_ewma_variance <- function(r, lambda, init_window = 30) {
  n <- length(r)
  ewma_var <- rep(NA_real_, n)

  if (n < init_window) {
    stop("The return series is shorter than init_window.", call. = FALSE)
  }

  ewma_var[1] <- stats::var(r[1:init_window], na.rm = TRUE)

  for (t in 2:n) {
    ewma_var[t] <- lambda * ewma_var[t - 1] + (1 - lambda) * r[t - 1]^2
  }

  ewma_var
}

simulate_returns_with_regimes <- function(n1 = 120, n2 = 70, n3 = 110) {
  r <- c(
    stats::rnorm(n1, mean = 0.0002, sd = 0.006),
    stats::rnorm(n2, mean = -0.0001, sd = 0.022),
    stats::rnorm(n3, mean = 0.0002, sd = 0.010)
  )

  tibble::tibble(
    time = seq_along(r),
    return = r,
    regime = dplyr::case_when(
      time <= n1 ~ "Giai đoạn biến động thấp",
      time <= n1 + n2 ~ "Giai đoạn biến động cao",
      TRUE ~ "Giai đoạn biến động vừa"
    )
  )
}

simulate_returns_with_single_shock <- function(n = 250, shock_time = 120, shock_value = -0.08) {
  r <- stats::rnorm(n, mean = 0, sd = 0.01)
  r[shock_time] <- shock_value

  tibble::tibble(
    time = seq_len(n),
    return = r,
    shock = time == shock_time
  )
}

simulate_garch_returns <- function(n = 700, omega = 0.000004, alpha = 0.08, beta = 0.90) {
  if (alpha + beta >= 1) {
    stop("alpha + beta must be below 1 for this simulation.", call. = FALSE)
  }

  z <- stats::rnorm(n)
  sigma2 <- rep(NA_real_, n)
  eps <- rep(NA_real_, n)

  sigma2[1] <- omega / (1 - alpha - beta)
  eps[1] <- sqrt(sigma2[1]) * z[1]

  for (t in 2:n) {
    sigma2[t] <- omega + alpha * eps[t - 1]^2 + beta * sigma2[t - 1]
    eps[t] <- sqrt(sigma2[t]) * z[t]
  }

  tibble::tibble(
    time = seq_len(n),
    return = eps,
    sigma = sqrt(sigma2),
    sigma2 = sigma2,
    z = z
  )
}

standardized_t_density <- function(x, df) {
  scale_factor <- sqrt((df - 2) / df)
  stats::dt(x / scale_factor, df = df) / scale_factor
}

standardized_t_quantile <- function(prob, df) {
  stats::qt(prob, df = df) * sqrt((df - 2) / df)
}

acf_data <- function(x, max_lag = 25, series_name = "series") {
  acf_obj <- stats::acf(x, plot = FALSE, lag.max = max_lag, na.action = stats::na.pass)
  tibble::tibble(
    lag = as.numeric(acf_obj$lag[-1]),
    acf = as.numeric(acf_obj$acf[-1]),
    series = series_name,
    n = sum(stats::complete.cases(x)),
    threshold = 1.96 / sqrt(n)
  )
}

# ============================================================
# 3. Figures already used in Section 2.1, renumbered to match the Word draft
# ============================================================

# Figure 2.1. Simulated returns and rolling volatility
fig_2_1_return_data <- simulate_returns_with_regimes()

fig_2_1_vol_data <- fig_2_1_return_data |>
  dplyr::mutate(
    rolling_vol_20 = zoo::rollapplyr(return, width = 20, FUN = stats::sd, fill = NA),
    rolling_vol_60 = zoo::rollapplyr(return, width = 60, FUN = stats::sd, fill = NA),
    rolling_vol_120 = zoo::rollapplyr(return, width = 120, FUN = stats::sd, fill = NA)
  ) |>
  dplyr::select(time, rolling_vol_20, rolling_vol_60, rolling_vol_120) |>
  tidyr::pivot_longer(
    cols = dplyr::starts_with("rolling_vol_"),
    names_to = "window",
    values_to = "rolling_vol"
  ) |>
  dplyr::mutate(
    window = dplyr::case_when(
      window == "rolling_vol_20" ~ "Cửa sổ 20 phiên",
      window == "rolling_vol_60" ~ "Cửa sổ 60 phiên",
      window == "rolling_vol_120" ~ "Cửa sổ 120 phiên",
      TRUE ~ window
    )
  )

fig_2_1_returns <- ggplot2::ggplot(fig_2_1_return_data, ggplot2::aes(x = time, y = return)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.4) +
  ggplot2::geom_line(linewidth = 0.7) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  ggplot2::labs(title = "Chuỗi tỷ suất sinh lời mô phỏng", x = NULL, y = "Tỷ suất sinh lời") +
  theme_ch02()

fig_2_1_rolling <- ggplot2::ggplot(fig_2_1_vol_data, ggplot2::aes(x = time, y = rolling_vol, linetype = window)) +
  ggplot2::geom_line(linewidth = 0.85, na.rm = TRUE) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 0.1)) +
  ggplot2::labs(title = "Biến động theo cửa sổ trượt", x = "Thời gian", y = "Biến động trượt", linetype = "Độ dài cửa sổ") +
  theme_ch02()

fig_2_1 <- fig_2_1_returns / fig_2_1_rolling +
  patchwork::plot_annotation(
    title = "Hình 2.1. Mô phỏng biến động tỷ lệ sinh lời theo các cửa sổ ước lượng với độ dài khác nhau",
    subtitle = "Cửa sổ ngắn phản ứng nhanh hơn, trong khi cửa sổ dài tạo đường biến động mượt hơn",
    caption = "Nguồn: Minh họa của tác giả. Chuỗi tỷ suất sinh lời được mô phỏng, không phải dữ liệu VN-Index."
  )

# Figure 2.2. EWMA weights
fig_2_2_data <- dplyr::bind_rows(
  make_ewma_weights(lambda = 0.90, max_lag = 80),
  make_ewma_weights(lambda = 0.94, max_lag = 80),
  make_ewma_weights(lambda = 0.97, max_lag = 80)
) |>
  dplyr::mutate(lambda_label = paste0("lambda = ", lambda))

fig_2_2 <- ggplot2::ggplot(fig_2_2_data, ggplot2::aes(x = lag, y = weight, linetype = lambda_label)) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 0.1)) +
  ggplot2::labs(
    title = "Hình 2.2. Trọng số suy giảm trong trung bình trượt hàm mũ",
    subtitle = "Hệ số suy giảm càng lớn thì trọng số của quan sát quá khứ giảm càng chậm",
    x = "Độ trễ của quan sát",
    y = "Trọng số",
    linetype = "Hệ số suy giảm",
    caption = "Nguồn: Minh họa của tác giả."
  ) +
  theme_ch02()

# Figure 2.3. EWMA response to a single shock
fig_2_3_return_data <- simulate_returns_with_single_shock(n = 250, shock_time = 120, shock_value = -0.08)

fig_2_3_ewma_data <- fig_2_3_return_data |>
  dplyr::mutate(
    ewma_vol_090 = sqrt(compute_ewma_variance(return, lambda = 0.90, init_window = 30)),
    ewma_vol_094 = sqrt(compute_ewma_variance(return, lambda = 0.94, init_window = 30)),
    ewma_vol_097 = sqrt(compute_ewma_variance(return, lambda = 0.97, init_window = 30))
  ) |>
  dplyr::select(time, ewma_vol_090, ewma_vol_094, ewma_vol_097) |>
  tidyr::pivot_longer(cols = dplyr::starts_with("ewma_vol_"), names_to = "lambda_label", values_to = "ewma_vol") |>
  dplyr::mutate(
    lambda_label = dplyr::case_when(
      lambda_label == "ewma_vol_090" ~ "lambda = 0.90",
      lambda_label == "ewma_vol_094" ~ "lambda = 0.94",
      lambda_label == "ewma_vol_097" ~ "lambda = 0.97",
      TRUE ~ lambda_label
    )
  )

shock_time_2_3 <- fig_2_3_return_data$time[fig_2_3_return_data$shock][1]
max_ewma_2_3 <- max(fig_2_3_ewma_data$ewma_vol, na.rm = TRUE)

fig_2_3 <- ggplot2::ggplot(fig_2_3_ewma_data, ggplot2::aes(x = time, y = ewma_vol, linetype = lambda_label)) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::geom_vline(xintercept = shock_time_2_3, linewidth = 0.5, linetype = "dashed") +
  ggplot2::annotate("text", x = shock_time_2_3 + 3, y = max_ewma_2_3, label = "Cú sốc mô phỏng", hjust = 0, vjust = 1, size = 3.5) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 0.1)) +
  ggplot2::labs(
    title = "Hình 2.3. Phản ứng của trung bình trượt hàm mũ trước một cú sốc biến động",
    subtitle = "Hệ số suy giảm thấp phản ứng nhanh hơn; hệ số suy giảm cao làm biến động giảm chậm hơn sau cú sốc",
    x = "Thời gian",
    y = "Biến động ước lượng",
    linetype = "Hệ số suy giảm",
    caption = "Nguồn: Minh họa của tác giả. Chuỗi tỷ suất sinh lời được mô phỏng với một cú sốc lớn tại thời điểm 120."
  ) +
  theme_ch02()

# Figure 2.4. Historical, rolling and EWMA volatility comparison
fig_2_4_return_data <- fig_2_1_return_data
historical_vol_2_4 <- stats::sd(fig_2_4_return_data$return, na.rm = TRUE)

fig_2_4_data <- fig_2_4_return_data |>
  dplyr::mutate(
    historical_vol = historical_vol_2_4,
    rolling_vol_60 = zoo::rollapplyr(return, width = 60, FUN = stats::sd, fill = NA),
    ewma_vol_094 = sqrt(compute_ewma_variance(return, lambda = 0.94, init_window = 30))
  ) |>
  dplyr::select(time, historical_vol, rolling_vol_60, ewma_vol_094) |>
  tidyr::pivot_longer(cols = c(historical_vol, rolling_vol_60, ewma_vol_094), names_to = "method", values_to = "volatility") |>
  dplyr::mutate(
    method = dplyr::case_when(
      method == "historical_vol" ~ "Biến động lịch sử toàn mẫu",
      method == "rolling_vol_60" ~ "Biến động cửa sổ trượt 60 phiên",
      method == "ewma_vol_094" ~ "Trung bình trượt hàm mũ, lambda = 0.94",
      TRUE ~ method
    )
  )

fig_2_4 <- ggplot2::ggplot(fig_2_4_data, ggplot2::aes(x = time, y = volatility, linetype = method)) +
  ggplot2::geom_line(linewidth = 0.85, na.rm = TRUE) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 0.1)) +
  ggplot2::labs(
    title = "Hình 2.4. So sánh biến động lịch sử, cửa sổ trượt và trung bình trượt hàm mũ",
    subtitle = "Ba phương pháp tạo ra các đường biến động khác nhau từ cùng một chuỗi tỷ suất sinh lời mô phỏng",
    x = "Thời gian",
    y = "Biến động ước lượng",
    linetype = "Phương pháp",
    caption = "Nguồn: Minh họa của tác giả. Chuỗi tỷ suất sinh lời được mô phỏng, không phải dữ liệu VN-Index."
  ) +
  theme_ch02()

# ============================================================
# 4. Section 2.2 figures: conditional variance models
# ============================================================

# Figure 2.5. Volatility clustering in simulated GARCH returns
fig_2_5_data <- simulate_garch_returns(n = 700, omega = 0.000004, alpha = 0.08, beta = 0.90)

fig_2_5_returns <- ggplot2::ggplot(fig_2_5_data, ggplot2::aes(x = time, y = return)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.35) +
  ggplot2::geom_line(linewidth = 0.65) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
  ggplot2::labs(title = "Tỷ suất sinh lời mô phỏng", x = NULL, y = "Tỷ suất sinh lời") +
  theme_ch02()

fig_2_5_squared <- ggplot2::ggplot(fig_2_5_data, ggplot2::aes(x = time, y = return^2)) +
  ggplot2::geom_line(linewidth = 0.65) +
  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 0.1)) +
  ggplot2::labs(title = "Bình phương tỷ suất sinh lời", x = "Thời gian", y = "Bình phương tỷ suất sinh lời") +
  theme_ch02()

fig_2_5 <- fig_2_5_returns / fig_2_5_squared +
  patchwork::plot_annotation(
    title = "Hình 2.5. Cụm biến động trong chuỗi tỷ suất sinh lời mô phỏng",
    subtitle = "Các giai đoạn dao động mạnh thường xuất hiện thành cụm khi phương sai có điều kiện thay đổi theo thời gian",
    caption = "Nguồn: Minh họa của tác giả. Chuỗi tỷ suất sinh lời được mô phỏng từ một quá trình GARCH(1,1), không phải dữ liệu VN-Index."
  )

# Figure 2.6. News impact curves for GARCH, GJR-GARCH and EGARCH
z_grid <- seq(-4, 4, length.out = 801)
E_abs_z <- sqrt(2 / pi)

fig_2_6_data <- tibble::tibble(z = z_grid) |>
  dplyr::mutate(
    `GARCH đối xứng` = sqrt(0.02 + 0.08 * z^2 + 0.88 * 1),
    `GJR-GARCH bất đối xứng` = sqrt(0.02 + 0.06 * z^2 + 0.12 * (z < 0) * z^2 + 0.88 * 1),
    `EGARCH bất đối xứng` = sqrt(exp(0 + 0.18 * (abs(z) - E_abs_z) - 0.14 * z))
  ) |>
  tidyr::pivot_longer(cols = -z, names_to = "model", values_to = "next_vol")

fig_2_6 <- ggplot2::ggplot(fig_2_6_data, ggplot2::aes(x = z, y = next_vol, linetype = model)) +
  ggplot2::geom_vline(xintercept = 0, linewidth = 0.35) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::labs(
    title = "Hình 2.6. Đường phản ứng tin tức của GARCH, GJR-GARCH và EGARCH",
    subtitle = "Mô hình đối xứng phản ứng như nhau với cú sốc âm và dương; mô hình bất đối xứng cho phép cú sốc âm làm biến động tăng mạnh hơn",
    x = "Cú sốc chuẩn hóa kỳ trước",
    y = "Biến động kỳ sau, theo thang minh họa",
    linetype = "Mô hình",
    caption = "Nguồn: Minh họa của tác giả. Tham số được chọn để minh họa trực giác, không phải kết quả ước lượng thực nghiệm."
  ) +
  theme_ch02()

# Appendix Figure A2.2. Volatility persistence when alpha + beta changes
make_persistence_path <- function(persistence, alpha = 0.08, n = 90, shock_time = 15, shock_size = 16) {
  beta <- persistence - alpha
  omega <- 1 - persistence
  sigma2 <- rep(1, n)
  eps2 <- rep(0, n)
  eps2[shock_time] <- shock_size

  for (t in 2:n) {
    sigma2[t] <- omega + alpha * eps2[t - 1] + beta * sigma2[t - 1]
  }

  tibble::tibble(
    time = seq_len(n),
    sigma2 = sigma2,
    persistence = paste0("alpha + beta = ", persistence)
  )
}

fig_A2_2_data <- dplyr::bind_rows(
  make_persistence_path(0.80),
  make_persistence_path(0.94),
  make_persistence_path(0.98)
)

fig_A2_2 <- ggplot2::ggplot(fig_A2_2_data, ggplot2::aes(x = time, y = sigma2, linetype = persistence)) +
  ggplot2::geom_hline(yintercept = 1, linewidth = 0.35) +
  ggplot2::geom_vline(xintercept = 15, linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::labs(
    title = "Hình A2.2. Độ dai dẳng biến động khi alpha + beta thay đổi",
    subtitle = "Tổng alpha + beta càng gần 1 thì tác động của cú sốc lên phương sai có điều kiện suy giảm càng chậm",
    x = "Thời gian",
    y = "Phương sai có điều kiện, theo thang minh họa",
    linetype = "Mức dai dẳng",
    caption = "Nguồn: Minh họa của tác giả. Tham số được chọn để minh họa trực giác, không phải kết quả ước lượng thực nghiệm."
  ) +
  theme_ch02()

# ============================================================
# 5. Section 2.3 figures: standardized error distributions
# ============================================================

x_grid <- seq(-5, 5, length.out = 1201)

# Figure 2.7. Normal and standardized Student-t densities
fig_2_7_data <- tibble::tibble(x = x_grid) |>
  dplyr::mutate(
    `Chuẩn N(0,1)` = stats::dnorm(x),
    `Student-t chuẩn hóa, nu = 5` = standardized_t_density(x, df = 5),
    `Student-t chuẩn hóa, nu = 8` = standardized_t_density(x, df = 8)
  ) |>
  tidyr::pivot_longer(cols = -x, names_to = "distribution", values_to = "density")

fig_2_7 <- ggplot2::ggplot(fig_2_7_data, ggplot2::aes(x = x, y = density, linetype = distribution)) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::coord_cartesian(xlim = c(-5, 5)) +
  ggplot2::labs(
    title = "Hình 2.7. So sánh phân phối chuẩn và Student-t chuẩn hóa",
    subtitle = "Student-t có đuôi dày hơn phân phối chuẩn; bậc tự do thấp hơn hàm ý xác suất lớn hơn ở vùng xa trung tâm",
    x = "Sai số chuẩn hóa",
    y = "Mật độ xác suất",
    linetype = "Phân phối",
    caption = "Nguồn: Minh họa của tác giả. Phân phối Student-t được chuẩn hóa để có phương sai bằng 1."
  ) +
  theme_ch02()

# Figure 2.8. Left-tail quantiles under alternative distributions
prob_tail <- 0.01
q_norm_01 <- stats::qnorm(prob_tail)
q_t5_01 <- standardized_t_quantile(prob_tail, df = 5)

fig_2_8_data <- tibble::tibble(x = x_grid) |>
  dplyr::mutate(
    `Chuẩn N(0,1)` = stats::dnorm(x),
    `Student-t chuẩn hóa, nu = 5` = standardized_t_density(x, df = 5)
  ) |>
  tidyr::pivot_longer(cols = -x, names_to = "distribution", values_to = "density") |>
  dplyr::mutate(
    q01 = dplyr::case_when(
      distribution == "Chuẩn N(0,1)" ~ q_norm_01,
      distribution == "Student-t chuẩn hóa, nu = 5" ~ q_t5_01,
      TRUE ~ NA_real_
    ),
    tail_region = x <= q01
  )

fig_2_8 <- ggplot2::ggplot(fig_2_8_data, ggplot2::aes(x = x, y = density)) +
  ggplot2::geom_area(data = dplyr::filter(fig_2_8_data, tail_region), alpha = 0.35) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::geom_vline(ggplot2::aes(xintercept = q01), linetype = "dashed", linewidth = 0.45) +
  ggplot2::facet_wrap(~ distribution, ncol = 1, scales = "free_y") +
  ggplot2::coord_cartesian(xlim = c(-5, 2.5)) +
  ggplot2::labs(
    title = "Hình 2.8. Phân vị đuôi trái dưới các giả định phân phối khác nhau",
    subtitle = "Với cùng trung bình và phương sai, giả định phân phối khác nhau tạo ra phân vị đuôi trái khác nhau",
    x = "Sai số chuẩn hóa",
    y = "Mật độ xác suất",
    caption = "Nguồn: Minh họa của tác giả. Vùng tô đậm là vùng đuôi trái 1%."
  ) +
  theme_ch02()

# Appendix Figure A2.3. Effect of degrees of freedom in Student-t
fig_A2_3_data <- tibble::tibble(x = x_grid) |>
  dplyr::mutate(
    `nu = 4` = standardized_t_density(x, df = 4),
    `nu = 6` = standardized_t_density(x, df = 6),
    `nu = 10` = standardized_t_density(x, df = 10),
    `nu = 30` = standardized_t_density(x, df = 30),
    `Chuẩn N(0,1)` = stats::dnorm(x)
  ) |>
  tidyr::pivot_longer(cols = -x, names_to = "df_label", values_to = "density")

fig_A2_3 <- ggplot2::ggplot(fig_A2_3_data, ggplot2::aes(x = x, y = density, linetype = df_label)) +
  ggplot2::geom_line(linewidth = 0.85) +
  ggplot2::coord_cartesian(xlim = c(-5, 5), ylim = c(0, 0.45)) +
  ggplot2::labs(
    title = "Hình A2.3. Ảnh hưởng của bậc tự do đến độ dày đuôi Student-t",
    subtitle = "Khi bậc tự do tăng, Student-t chuẩn hóa tiến gần hơn đến phân phối chuẩn",
    x = "Sai số chuẩn hóa",
    y = "Mật độ xác suất",
    linetype = "Phân phối",
    caption = "Nguồn: Minh họa của tác giả."
  ) +
  theme_ch02()

# Appendix Figure A2.4. Left-skewed, symmetric and right-skewed distributions
fig_A2_4_data <- tibble::tibble(x = x_grid) |>
  dplyr::mutate(
    `Lệch trái, lambda = -0.35` = sgt::dsgt(x, mu = 0, sigma = 1, lambda = -0.35, p = 2, q = 6, mean.cent = TRUE, var.adj = TRUE),
    `Đối xứng, lambda = 0` = sgt::dsgt(x, mu = 0, sigma = 1, lambda = 0, p = 2, q = 6, mean.cent = TRUE, var.adj = TRUE),
    `Lệch phải, lambda = 0.35` = sgt::dsgt(x, mu = 0, sigma = 1, lambda = 0.35, p = 2, q = 6, mean.cent = TRUE, var.adj = TRUE)
  ) |>
  tidyr::pivot_longer(cols = -x, names_to = "skewness", values_to = "density")

fig_A2_4 <- ggplot2::ggplot(fig_A2_4_data, ggplot2::aes(x = x, y = density, linetype = skewness)) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::coord_cartesian(xlim = c(-5, 5)) +
  ggplot2::labs(
    title = "Hình A2.4. Minh họa phân phối lệch trái, đối xứng và lệch phải",
    subtitle = "Tham số lambda trong họ SGT điều chỉnh hướng lệch của phân phối",
    x = "Sai số chuẩn hóa",
    y = "Mật độ xác suất",
    linetype = "Hình dạng",
    caption = "Nguồn: Minh họa của tác giả bằng package sgt. Tham số được chọn để minh họa hình dạng phân phối."
  ) +
  theme_ch02()

# Appendix Figure A2.4A. SGT parameter effects
make_sgt_density <- function(effect, label, lambda, p, q) {
  tibble::tibble(
    x = x_grid,
    density = sgt::dsgt(x_grid, mu = 0, sigma = 1, lambda = lambda, p = p, q = q, mean.cent = TRUE, var.adj = TRUE),
    effect = effect,
    label = label
  )
}

fig_A2_4A_data <- dplyr::bind_rows(
  make_sgt_density("Thay đổi lambda", "lambda = -0.35", lambda = -0.35, p = 2, q = 6),
  make_sgt_density("Thay đổi lambda", "lambda = 0", lambda = 0, p = 2, q = 6),
  make_sgt_density("Thay đổi lambda", "lambda = 0.35", lambda = 0.35, p = 2, q = 6),
  make_sgt_density("Thay đổi p", "p = 1.4", lambda = 0, p = 1.4, q = 8),
  make_sgt_density("Thay đổi p", "p = 2", lambda = 0, p = 2, q = 8),
  make_sgt_density("Thay đổi p", "p = 3.5", lambda = 0, p = 3.5, q = 8),
  make_sgt_density("Thay đổi q", "q = 3", lambda = 0, p = 2, q = 3),
  make_sgt_density("Thay đổi q", "q = 8", lambda = 0, p = 2, q = 8),
  make_sgt_density("Thay đổi q", "q = Inf", lambda = 0, p = 2, q = Inf)
)

fig_A2_4A <- ggplot2::ggplot(fig_A2_4A_data, ggplot2::aes(x = x, y = density, linetype = label)) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::facet_wrap(~ effect, ncol = 1, scales = "free_y") +
  ggplot2::coord_cartesian(xlim = c(-5, 5)) +
  ggplot2::labs(
    title = "Hình A2.4A. Minh họa phân phối SGT khi thay đổi các tham số",
    subtitle = "lambda điều chỉnh độ lệch; p và q điều chỉnh hình dạng trung tâm và độ dày đuôi trong họ SGT",
    x = "Sai số chuẩn hóa",
    y = "Mật độ xác suất",
    linetype = "Tham số",
    caption = "Nguồn: Minh họa của tác giả bằng package sgt::dsgt. Các tham số dùng cho minh họa, không phải kết quả ước lượng thực nghiệm."
  ) +
  theme_ch02()

# Appendix Figure A2.4B. SGED parameter effects using SGT with q = Inf
make_sged_density <- function(effect, label, lambda, p) {
  tibble::tibble(
    x = x_grid,
    density = sgt::dsgt(x_grid, mu = 0, sigma = 1, lambda = lambda, p = p, q = Inf, mean.cent = TRUE, var.adj = TRUE),
    effect = effect,
    label = label
  )
}

fig_A2_4B_data <- dplyr::bind_rows(
  make_sged_density("Thay đổi lambda", "lambda = -0.35", lambda = -0.35, p = 2),
  make_sged_density("Thay đổi lambda", "lambda = 0", lambda = 0, p = 2),
  make_sged_density("Thay đổi lambda", "lambda = 0.35", lambda = 0.35, p = 2),
  make_sged_density("Thay đổi p", "p = 1.3", lambda = 0, p = 1.3),
  make_sged_density("Thay đổi p", "p = 2", lambda = 0, p = 2),
  make_sged_density("Thay đổi p", "p = 4", lambda = 0, p = 4)
)

fig_A2_4B <- ggplot2::ggplot(fig_A2_4B_data, ggplot2::aes(x = x, y = density, linetype = label)) +
  ggplot2::geom_line(linewidth = 0.85) +
  ggplot2::facet_wrap(~ effect, ncol = 1, scales = "free_y") +
  ggplot2::coord_cartesian(xlim = c(-5, 5)) +
  ggplot2::labs(
    title = "Hình A2.4B. Minh họa phân phối SGED khi thay đổi các tham số",
    subtitle = "SGED được minh họa như trường hợp q = Inf trong package sgt; lambda điều chỉnh độ lệch và p điều chỉnh hình dạng",
    x = "Sai số chuẩn hóa",
    y = "Mật độ xác suất",
    linetype = "Tham số",
    caption = "Nguồn: Minh họa của tác giả bằng package sgt::dsgt với q = Inf. Các tham số dùng cho minh họa, không phải kết quả ước lượng thực nghiệm."
  ) +
  theme_ch02()

# ============================================================
# 6. Section 2.4 figures: estimation, diagnostics and forecasting design
# ============================================================

# Appendix Figure A2.5. Standardized residual diagnostics
fig_A2_5_sim <- fig_2_5_data |>
  dplyr::mutate(
    z_true = return / sigma,
    z2_true = z_true^2
  )

fig_A2_5_z <- ggplot2::ggplot(fig_A2_5_sim, ggplot2::aes(x = time, y = z_true)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.35) +
  ggplot2::geom_line(linewidth = 0.55) +
  ggplot2::labs(title = "Sai số chuẩn hóa", x = NULL, y = "z") +
  theme_ch02(base_size = 10)

fig_A2_5_z2 <- ggplot2::ggplot(fig_A2_5_sim, ggplot2::aes(x = time, y = z2_true)) +
  ggplot2::geom_line(linewidth = 0.55) +
  ggplot2::labs(title = "Bình phương sai số chuẩn hóa", x = "Thời gian", y = "z^2") +
  theme_ch02(base_size = 10)

fig_A2_5_acf_z_data <- acf_data(fig_A2_5_sim$z_true, max_lag = 25, series_name = "z")
fig_A2_5_acf_z2_data <- acf_data(fig_A2_5_sim$z2_true, max_lag = 25, series_name = "z^2")

fig_A2_5_acf_z <- ggplot2::ggplot(fig_A2_5_acf_z_data, ggplot2::aes(x = lag, y = acf)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.35) +
  ggplot2::geom_hline(ggplot2::aes(yintercept = threshold), linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_hline(ggplot2::aes(yintercept = -threshold), linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_col(width = 0.6) +
  ggplot2::labs(title = "ACF của z", x = "Độ trễ", y = "ACF") +
  theme_ch02(base_size = 10)

fig_A2_5_acf_z2 <- ggplot2::ggplot(fig_A2_5_acf_z2_data, ggplot2::aes(x = lag, y = acf)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.35) +
  ggplot2::geom_hline(ggplot2::aes(yintercept = threshold), linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_hline(ggplot2::aes(yintercept = -threshold), linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_col(width = 0.6) +
  ggplot2::labs(title = "ACF của z^2", x = "Độ trễ", y = "ACF") +
  theme_ch02(base_size = 10)

fig_A2_5 <- (fig_A2_5_z | fig_A2_5_z2) / (fig_A2_5_acf_z | fig_A2_5_acf_z2) +
  patchwork::plot_annotation(
    title = "Hình A2.5. Minh họa chẩn đoán sai số chuẩn hóa sau khi lọc biến động",
    subtitle = "Nếu mô hình phương sai có điều kiện phù hợp, z và z^2 không nên còn cấu trúc tự tương quan rõ rệt",
    caption = "Nguồn: Minh họa của tác giả. Chuỗi được mô phỏng từ GARCH(1,1); z là sai số chuẩn hóa theo phương sai mô phỏng."
  )

# Appendix Figure A2.6. Correctly filtered versus constant-volatility misspecification
acf_true_z2 <- acf_data((fig_A2_5_sim$return / fig_A2_5_sim$sigma)^2, max_lag = 25, series_name = "Lọc bằng sigma_t đúng")
constant_sigma <- stats::sd(fig_A2_5_sim$return, na.rm = TRUE)
acf_const_z2 <- acf_data((fig_A2_5_sim$return / constant_sigma)^2, max_lag = 25, series_name = "Giả định biến động hằng số")
fig_A2_6_data <- dplyr::bind_rows(acf_true_z2, acf_const_z2)

fig_A2_6 <- ggplot2::ggplot(fig_A2_6_data, ggplot2::aes(x = lag, y = acf)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.35) +
  ggplot2::geom_hline(ggplot2::aes(yintercept = threshold), linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_hline(ggplot2::aes(yintercept = -threshold), linetype = "dashed", linewidth = 0.35) +
  ggplot2::geom_col(width = 0.6) +
  ggplot2::facet_wrap(~ series, ncol = 1) +
  ggplot2::labs(
    title = "Hình A2.6. Minh họa mô hình phù hợp và mô hình sai đặc tả qua ACF của z^2",
    subtitle = "Giả định biến động hằng số có thể để lại tự tương quan trong bình phương phần dư chuẩn hóa",
    x = "Độ trễ",
    y = "ACF",
    caption = "Nguồn: Minh họa của tác giả. Chuỗi được mô phỏng từ GARCH(1,1)."
  ) +
  theme_ch02()

# Appendix Figure A2.7. Rolling and recursive forecasting windows
make_window_df <- function(design = c("Cửa sổ trượt", "Cửa sổ mở rộng"), steps = 1:4, initial_width = 80, step_size = 25) {
  design <- match.arg(design)
  dplyr::bind_rows(lapply(steps, function(s) {
    forecast_point <- initial_width + s * step_size
    if (design == "Cửa sổ trượt") {
      xmin <- forecast_point - initial_width
      xmax <- forecast_point - 1
    } else {
      xmin <- 1
      xmax <- forecast_point - 1
    }
    tibble::tibble(
      design = design,
      step = paste0("Bước ", s),
      xmin = xmin,
      xmax = xmax,
      forecast = forecast_point
    )
  }))
}

fig_A2_7_data <- dplyr::bind_rows(
  make_window_df("Cửa sổ trượt"),
  make_window_df("Cửa sổ mở rộng")
) |>
  dplyr::mutate(
    step_id = as.integer(gsub("Bước ", "", step)),
    ymin = step_id - 0.35,
    ymax = step_id + 0.35
  )

fig_A2_7 <- ggplot2::ggplot(fig_A2_7_data) +
  ggplot2::geom_rect(ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), alpha = 0.45) +
  ggplot2::geom_vline(ggplot2::aes(xintercept = forecast), linetype = "dashed", linewidth = 0.4) +
  ggplot2::facet_wrap(~ design, ncol = 1) +
  ggplot2::scale_y_continuous(breaks = 1:4, labels = paste0("Bước ", 1:4)) +
  ggplot2::labs(
    title = "Hình A2.7. Thiết kế dự báo cửa sổ trượt và cửa sổ mở rộng",
    subtitle = "Cửa sổ trượt giữ độ dài mẫu ước lượng cố định; cửa sổ mở rộng giữ điểm bắt đầu và tăng dần số quan sát",
    x = "Chỉ số thời gian mô phỏng",
    y = NULL,
    caption = "Nguồn: Minh họa của tác giả. Vùng tô đậm là mẫu dùng để ước lượng; đường nét đứt là thời điểm tạo dự báo một bước tiếp theo."
  ) +
  theme_ch02()

# ============================================================
# 7. Tables for main text and appendix
# ============================================================

# Table 2.1. Model map for ARCH/GARCH family
table_2_1 <- tibble::tribble(
  ~`Mô hình`, ~`Câu hỏi thực nghiệm`, ~`Thành phần chính`, ~`Mô tả được`, ~`Hạn chế chính`,
  "ARCH", "Cú sốc quá khứ có làm biến động hiện tại tăng không?", "Bình phương cú sốc trễ", "Hiệu ứng ARCH và cụm biến động", "Có thể cần nhiều độ trễ khi biến động dai dẳng",
  "GARCH", "Biến động có ghi nhớ quá khứ không?", "Bình phương cú sốc và phương sai trễ", "Cụm biến động và độ dai dẳng", "Đối xứng với cú sốc âm và dương cùng độ lớn",
  "GJR-GARCH", "Tin xấu có làm biến động tăng mạnh hơn tin tốt không?", "Biến chỉ báo cú sốc âm", "Bất đối xứng trong phản ứng biến động", "Diễn giải phụ thuộc quy ước biến chỉ báo",
  "EGARCH", "Có thể mô hình hóa bất đối xứng trên thang log phương sai không?", "Log phương sai và sai số chuẩn hóa", "Phương sai dương tự nhiên và phản ứng bất đối xứng", "Khó diễn giải trực tiếp hơn GARCH chuẩn",
  "APARCH", "Dữ liệu ủng hộ bậc lũy thừa nào của biến động?", "Tham số lũy thừa delta và tham số bất đối xứng", "Linh hoạt về dạng phản ứng biến động", "Nhiều tham số hơn, có thể khó ước lượng ổn định",
  "GARCH-M", "Biến động có ảnh hưởng đến tỷ suất sinh lời kỳ vọng không?", "Phương sai hoặc độ lệch chuẩn trong phương trình trung bình", "Quan hệ rủi ro - tỷ suất sinh lời kỳ vọng có điều kiện", "Không nên diễn giải như khuyến nghị đầu tư; cần kiểm định trong mẫu cụ thể"
)

# Table 2.2. Distribution map for standardized innovations
table_2_2 <- tibble::tribble(
  ~`Phân phối`, ~`Tham số chính`, ~`Đuôi dày`, ~`Bất đối xứng`, ~`Vai trò trong VaR/ES`, ~`Lưu ý`,
  "Chuẩn", "Không có tham số hình dạng ngoài chuẩn hóa", "Không", "Không", "Mô hình nền và chuẩn so sánh", "Có thể đánh giá thấp xác suất cú sốc cực đoan nếu dữ liệu có đuôi dày",
  "Student-t", "Bậc tự do nu", "Có", "Không", "Tạo phân vị đuôi xa hơn khi nu thấp", "Cần chuẩn hóa phương sai khi dùng làm sai số z_t",
  "Student-t chệch", "nu và tham số chệch", "Có", "Có", "Mô tả đồng thời đuôi dày và lệch đuôi", "Cách diễn giải tham số chệch phụ thuộc tham số hóa/package",
  "SGED", "Tham số hình dạng p và tham số chệch lambda", "Có thể có", "Có", "Linh hoạt về độ nhọn và độ lệch", "Cần kiểm tra tham số hóa trước khi đưa công thức mật độ vào sách",
  "SGT", "lambda, p, q", "Có", "Có", "Khung rất linh hoạt cho phân phối có điều kiện", "Nhiều tham số hơn; quá trình ước lượng có thể nhạy với giá trị khởi tạo"
)

# Table 2.3. Model selection and diagnostic checklist
table_2_3 <- tibble::tribble(
  ~`Bước`, ~`Câu hỏi`, ~`Công cụ`, ~`Dấu hiệu đạt`, ~`Xử lý nếu chưa đạt`,
  "1. Phương trình trung bình", "Phần trung bình có còn phụ thuộc tuyến tính không?", "Đồ thị, ACF/PACF, Ljung-Box trên phần dư", "Phần dư không còn tự tương quan rõ rệt", "Cân nhắc trung bình hằng số, ARMA bậc thấp hoặc biến giải thích phù hợp",
  "2. Phương trình phương sai", "Bình phương phần dư còn cụm biến động không?", "ACF của phần dư bình phương, ARCH LM", "Không còn hiệu ứng ARCH đáng kể", "Cân nhắc ARCH/GARCH bậc khác hoặc mô hình bất đối xứng",
  "3. Phân phối sai số", "Sai số chuẩn hóa có đuôi dày hoặc lệch không?", "Histogram, QQ plot, log-likelihood, AIC/BIC", "Phân phối mô tả tốt hình dạng phần dư chuẩn hóa", "Thử Student-t, skewed-t, SGED hoặc đặc tả đơn giản hơn nếu không ổn định",
  "4. So sánh trong mẫu", "Mô hình có cải thiện đủ để bù cho số tham số không?", "Log-likelihood, AIC, BIC", "AIC/BIC thấp hơn và tham số có diễn giải hợp lý", "Không chọn chỉ vì mô hình phức tạp hơn",
  "5. Chẩn đoán sau ước lượng", "Phần dư chuẩn hóa còn cấu trúc động không?", "Ljung-Box trên z_t và z_t^2, ARCH LM", "Không bác bỏ mạnh giả thuyết không còn cấu trúc động", "Quay lại đặc tả trung bình, phương sai hoặc phân phối",
  "6. Chuẩn bị dự báo", "Mô hình có thể dùng cho dự báo biến động kỳ tiếp theo không?", "Kiểm tra hội tụ, tham số, chẩn đoán", "Mô hình ổn định và có diễn giải phù hợp", "Chưa chuyển sang VaR/ES nếu chẩn đoán còn lỗi nghiêm trọng"
)

# Appendix Table A2.1. Notation and parameters
table_A2_1 <- tibble::tribble(
  ~`Ký hiệu`, ~`Xuất hiện trong`, ~`Ý nghĩa`, ~`Diễn giải khi tăng`, ~`Lưu ý`,
  "r_t", "Toàn chương", "Tỷ suất/tỷ lệ sinh lời tại thời điểm t", "Không áp dụng", "Cần thống nhất một thuật ngữ trong toàn sách",
  "mu_t", "Phương trình trung bình", "Kỳ vọng có điều kiện", "Phân phối có điều kiện dịch sang phải nếu mu_t tăng", "Với dữ liệu ngày, thường nhỏ so với biến động",
  "epsilon_t", "Phương trình sai số", "Cú sốc chưa chuẩn hóa", "Độ lớn cú sốc tăng", "Không quan sát trực tiếp, thường ước lượng từ phần dư",
  "sigma_t", "Phương trình phương sai", "Độ lệch chuẩn có điều kiện", "Phân phối có điều kiện rộng hơn", "sigma_t^2 là phương sai có điều kiện",
  "z_t", "Sai số chuẩn hóa", "Cú sốc sau khi chuẩn hóa theo sigma_t", "Không áp dụng", "Thường giả định E(z_t)=0 và Var(z_t)=1",
  "omega", "ARCH/GARCH", "Hằng số trong phương trình phương sai", "Mức nền phương sai tăng", "Cần ràng buộc để phương sai dương",
  "alpha", "ARCH/GARCH", "Tác động của bình phương cú sốc quá khứ", "Biến động phản ứng mạnh hơn với cú sốc mới", "Trong GARCH(1,1), alpha + beta thường đo độ dai dẳng",
  "beta", "GARCH", "Tác động của phương sai có điều kiện quá khứ", "Biến động dai dẳng hơn", "alpha + beta gần 1 hàm ý cú sốc suy giảm chậm",
  "gamma", "GJR/EGARCH/APARCH", "Tham số bất đối xứng", "Tác động phụ thuộc quy ước mô hình", "Cần giải thích theo đúng phương trình đang dùng",
  "delta", "APARCH", "Bậc lũy thừa của biến động", "Dạng phản ứng biến động linh hoạt hơn", "Không phải lúc nào cũng dễ diễn giải kinh tế",
  "nu", "Student-t", "Bậc tự do", "nu cao làm Student-t gần phân phối chuẩn hơn", "nu thấp hàm ý đuôi dày hơn",
  "lambda", "SGT/SGED/EWMA", "Có thể là hệ số suy giảm hoặc tham số chệch", "Ý nghĩa phụ thuộc ngữ cảnh", "Tránh dùng cùng lambda cho EWMA và skewness nếu gây nhầm; có thể đổi skewness thành xi"
)

# Appendix Table A2.2. Tail quantiles of standardized distributions
prob_levels <- c(0.05, 0.01, 0.005)
quantile_table <- tibble::tibble(
  `Mức phân vị` = prob_levels,
  `Chuẩn N(0,1)` = stats::qnorm(prob_levels),
  `Student-t nu=5 chuẩn hóa` = standardized_t_quantile(prob_levels, df = 5),
  `Student-t nu=8 chuẩn hóa` = standardized_t_quantile(prob_levels, df = 8),
  `SGT lệch trái minh họa` = sgt::qsgt(prob_levels, mu = 0, sigma = 1, lambda = -0.30, p = 2, q = 6, mean.cent = TRUE, var.adj = TRUE),
  `SGED lệch trái minh họa` = sgt::qsgt(prob_levels, mu = 0, sigma = 1, lambda = -0.30, p = 1.5, q = Inf, mean.cent = TRUE, var.adj = TRUE)
)

table_A2_2 <- quantile_table |>
  dplyr::mutate(`Mức phân vị` = scales::label_percent(accuracy = 0.1)(`Mức phân vị`)) |>
  dplyr::mutate(dplyr::across(-`Mức phân vị`, ~ round(.x, 4)))

# Appendix Table A2.3. Model comparison template
table_A2_3 <- tibble::tribble(
  ~`Mô hình ứng viên`, ~`Phân phối z_t`, ~`Số tham số k`, ~`Log-likelihood`, ~`AIC`, ~`BIC`, ~`Ghi chú diễn giải`,
  "GARCH(1,1)", "Normal", "[điền sau khi ước lượng]", "[điền]", "[điền]", "[điền]", "Mô hình nền",
  "GARCH(1,1)", "Student-t", "[điền sau khi ước lượng]", "[điền]", "[điền]", "[điền]", "Kiểm tra vai trò đuôi dày",
  "GJR-GARCH(1,1)", "Student-t hoặc skewed-t", "[điền sau khi ước lượng]", "[điền]", "[điền]", "[điền]", "Kiểm tra bất đối xứng biến động",
  "EGARCH(1,1)", "Student-t hoặc SGED", "[điền sau khi ước lượng]", "[điền]", "[điền]", "[điền]", "Kiểm tra bất đối xứng trên log phương sai",
  "APARCH(1,1)", "SGED hoặc SGT", "[điền sau khi ước lượng]", "[điền]", "[điền]", "[điền]", "Kiểm tra tham số lũy thừa delta"
)

# Appendix Table A2.4. Diagnostic tests
table_A2_4 <- tibble::tribble(
  ~`Kiểm định/đồ thị`, ~`Áp dụng cho`, ~`Giả thuyết gốc hoặc mục tiêu`, ~`Diễn giải nếu không đạt`, ~`Gợi ý xử lý`,
  "Đồ thị z_t", "Sai số chuẩn hóa", "Không còn cụm dao động rõ rệt", "Mô hình có thể chưa lọc hết biến động", "Xem lại phương trình phương sai hoặc phân phối",
  "ACF của z_t", "Sai số chuẩn hóa", "Không có tự tương quan tuyến tính", "Phương trình trung bình có thể thiếu cấu trúc", "Xem lại mean equation hoặc ARMA bậc thấp",
  "ACF của z_t^2", "Bình phương sai số chuẩn hóa", "Không còn phụ thuộc động trong phương sai", "Còn hiệu ứng ARCH/GARCH", "Xem lại bậc GARCH hoặc mô hình bất đối xứng",
  "Ljung-Box trên z_t", "Sai số chuẩn hóa", "Không có tự tương quan đến độ trễ m", "Còn thông tin tuyến tính chưa khai thác", "Điều chỉnh phương trình trung bình",
  "Ljung-Box trên z_t^2", "Bình phương sai số chuẩn hóa", "Không có tự tương quan đến độ trễ m", "Còn cụm biến động sau chuẩn hóa", "Điều chỉnh phương trình phương sai",
  "ARCH LM", "Bình phương phần dư chuẩn hóa", "Không còn hiệu ứng ARCH đến bậc kiểm định", "Mô hình phương sai chưa hấp thụ hết ARCH effect", "Thử GARCH bậc khác, GJR-GARCH, EGARCH hoặc phân phối khác",
  "QQ plot", "Sai số chuẩn hóa", "Phân phối giả định phù hợp tương đối với phần dư", "Sai lệch rõ ở đuôi hoặc lệch phân phối", "Xem xét Student-t, skewed-t, SGED hoặc SGT"
)

# Appendix Table A2.5. Forecast evaluation criteria
table_A2_5 <- tibble::tribble(
  ~`Tiêu chí`, ~`Công thức minh họa`, ~`Dùng cho thang đo`, ~`Ưu điểm`, ~`Hạn chế`,
  "MSE", "mean((v_t - vhat_t)^2)", "Variance hoặc volatility, nhưng phải nhất quán", "Phạt mạnh sai số lớn", "Nhạy với ngoại lai và giai đoạn biến động cực đoan",
  "MAE", "mean(abs(v_t - vhat_t))", "Variance hoặc volatility, nhưng phải nhất quán", "Dễ diễn giải hơn MSE", "Ít nhấn mạnh lỗi lớn hơn MSE",
  "QLIKE", "mean(log(vhat_t) + v_t / vhat_t)", "Variance dương", "Phù hợp khi đánh giá dự báo phương sai", "Không dùng trực tiếp nếu v_t và vhat_t là độ lệch chuẩn",
  "VaR backtest", "So sánh số vi phạm VaR với mức kỳ vọng", "Dự báo phân vị/loss tail", "Đánh giá trực tiếp mô hình rủi ro đuôi", "Thuộc chương VaR/backtesting, không thay thế đánh giá volatility"
)

# ============================================================
# 8. Export all outputs
# ============================================================

# Figures for Section 2.1
save_plot(fig_2_1, "fig_2_1_simulated_returns_rolling_volatility.png", width = 8, height = 7)
save_plot(fig_2_2, "fig_2_2_ewma_weights.png", width = 8, height = 5)
save_plot(fig_2_3, "fig_2_3_ewma_shock_response.png", width = 8, height = 5)
save_plot(fig_2_4, "fig_2_4_historical_rolling_ewma_comparison.png", width = 8.8, height = 5.6)

# Figures for Section 2.2
save_plot(fig_2_5, "fig_2_5_volatility_clustering_simulation.png", width = 8, height = 7)
save_plot(fig_2_6, "fig_2_6_news_impact_curves.png", width = 8.5, height = 5.2)
save_plot(fig_A2_2, "fig_A2_2_garch_persistence_alpha_beta.png", width = 8, height = 5)

# Figures for Section 2.3
save_plot(fig_2_7, "fig_2_7_normal_student_t_density.png", width = 8, height = 5)
save_plot(fig_2_8, "fig_2_8_left_tail_quantiles.png", width = 8, height = 6.5)
save_plot(fig_A2_3, "fig_A2_3_student_t_degrees_of_freedom.png", width = 8, height = 5)
save_plot(fig_A2_4, "fig_A2_4_left_right_skewed_distributions.png", width = 8, height = 5)
save_plot(fig_A2_4A, "fig_A2_4A_sgt_parameter_effects.png", width = 8.5, height = 8)
save_plot(fig_A2_4B, "fig_A2_4B_sged_parameter_effects.png", width = 8.5, height = 7)

# Figures for Section 2.4
save_plot(fig_A2_5, "fig_A2_5_standardized_residual_diagnostics.png", width = 9, height = 7)
save_plot(fig_A2_6, "fig_A2_6_misspecification_acf_squared_residuals.png", width = 8, height = 6.5)
save_plot(fig_A2_7, "fig_A2_7_rolling_recursive_forecast_windows.png", width = 8.5, height = 6)

# Tables
save_table_outputs(table_2_1, "table_2_1_arch_garch_model_map", "Bảng 2.1. Bản đồ trực giác các mô hình ARCH/GARCH")
save_table_outputs(table_2_2, "table_2_2_standardized_error_distributions", "Bảng 2.2. So sánh các giả định phân phối của sai số chuẩn hóa z_t")
save_table_outputs(table_2_3, "table_2_3_model_selection_diagnostic_checklist", "Bảng 2.3. Checklist lựa chọn mô hình và chẩn đoán")
save_table_outputs(table_A2_1, "table_A2_1_notation_parameter_register", "Bảng A2.1. Ký hiệu và tham số trong họ mô hình ARCH/GARCH")
save_table_outputs(table_A2_2, "table_A2_2_tail_quantiles", "Bảng A2.2. Phân vị đuôi trái của một số phân phối chuẩn hóa", "Nguồn: Tính toán mô phỏng của tác giả bằng R.")
save_table_outputs(table_A2_3, "table_A2_3_model_comparison_template", "Bảng A2.3. Mẫu bảng so sánh log-likelihood, AIC và BIC")
save_table_outputs(table_A2_4, "table_A2_4_diagnostic_tests", "Bảng A2.4. Diễn giải các kiểm định chẩn đoán mô hình GARCH")
save_table_outputs(table_A2_5, "table_A2_5_forecast_evaluation_criteria", "Bảng A2.5. Tiêu chí đánh giá dự báo biến động")

# Output register
ch02_register <- tibble::tribble(
  ~type, ~number, ~title, ~section, ~placement, ~file, ~data_type, ~note,
  "figure", "Hình 2.1", "Mô phỏng biến động tỷ lệ sinh lời theo các cửa sổ ước lượng với độ dài khác nhau", "2.1", "main text", "fig_2_1_simulated_returns_rolling_volatility.png", "simulation", "Đã chỉnh lại numbering để khớp bản Word",
  "figure", "Hình 2.2", "Trọng số suy giảm trong trung bình trượt hàm mũ", "2.1", "main text", "fig_2_2_ewma_weights.png", "simulation", "EWMA weights",
  "figure", "Hình 2.3", "Phản ứng của trung bình trượt hàm mũ trước một cú sốc biến động", "2.1", "main text", "fig_2_3_ewma_shock_response.png", "simulation", "Single shock",
  "figure", "Hình 2.4", "So sánh biến động lịch sử, cửa sổ trượt và trung bình trượt hàm mũ", "2.1", "main text", "fig_2_4_historical_rolling_ewma_comparison.png", "simulation", "Comparison",
  "figure", "Hình 2.5", "Cụm biến động trong chuỗi tỷ suất sinh lời mô phỏng", "2.2", "main text", "fig_2_5_volatility_clustering_simulation.png", "simulation", "GARCH simulated returns",
  "figure", "Hình 2.6", "Đường phản ứng tin tức của GARCH, GJR-GARCH và EGARCH", "2.2", "main text", "fig_2_6_news_impact_curves.png", "simulation", "Parameters for illustration only",
  "figure", "Hình A2.2", "Độ dai dẳng biến động khi alpha + beta thay đổi", "2.2", "appendix", "fig_A2_2_garch_persistence_alpha_beta.png", "simulation", "Persistence illustration",
  "figure", "Hình 2.7", "So sánh phân phối chuẩn và Student-t chuẩn hóa", "2.3", "main text", "fig_2_7_normal_student_t_density.png", "simulation", "Standardized t density",
  "figure", "Hình 2.8", "Phân vị đuôi trái dưới các giả định phân phối khác nhau", "2.3", "main text", "fig_2_8_left_tail_quantiles.png", "simulation", "1 percent left tail",
  "figure", "Hình A2.3", "Ảnh hưởng của bậc tự do đến độ dày đuôi Student-t", "2.3", "appendix", "fig_A2_3_student_t_degrees_of_freedom.png", "simulation", "Degrees of freedom",
  "figure", "Hình A2.4", "Minh họa phân phối lệch trái, đối xứng và lệch phải", "2.3", "appendix", "fig_A2_4_left_right_skewed_distributions.png", "simulation", "Uses sgt package",
  "figure", "Hình A2.4A", "Minh họa phân phối SGT khi thay đổi các tham số", "2.3", "appendix", "fig_A2_4A_sgt_parameter_effects.png", "simulation", "Uses sgt::dsgt",
  "figure", "Hình A2.4B", "Minh họa phân phối SGED khi thay đổi các tham số", "2.3", "appendix", "fig_A2_4B_sged_parameter_effects.png", "simulation", "Uses sgt::dsgt with q = Inf",
  "figure", "Hình A2.5", "Minh họa chẩn đoán sai số chuẩn hóa sau khi lọc biến động", "2.4", "appendix", "fig_A2_5_standardized_residual_diagnostics.png", "simulation", "ACF of z and z squared",
  "figure", "Hình A2.6", "Minh họa mô hình phù hợp và mô hình sai đặc tả qua ACF của z^2", "2.4", "appendix", "fig_A2_6_misspecification_acf_squared_residuals.png", "simulation", "Correct filtering vs constant volatility",
  "figure", "Hình A2.7", "Thiết kế dự báo cửa sổ trượt và cửa sổ mở rộng", "2.4", "appendix", "fig_A2_7_rolling_recursive_forecast_windows.png", "simulation", "Forecast window schematic",
  "table", "Bảng 2.1", "Bản đồ trực giác các mô hình ARCH/GARCH", "2.2", "main text", "table_2_1_arch_garch_model_map.docx", "author synthesis", "Also exported as CSV",
  "table", "Bảng 2.2", "So sánh các giả định phân phối của sai số chuẩn hóa z_t", "2.3", "main text", "table_2_2_standardized_error_distributions.docx", "author synthesis", "Also exported as CSV",
  "table", "Bảng 2.3", "Checklist lựa chọn mô hình và chẩn đoán", "2.4", "main text", "table_2_3_model_selection_diagnostic_checklist.docx", "author synthesis", "Also exported as CSV",
  "table", "Bảng A2.1", "Ký hiệu và tham số trong họ mô hình ARCH/GARCH", "2.2", "appendix", "table_A2_1_notation_parameter_register.docx", "author synthesis", "Also exported as CSV",
  "table", "Bảng A2.2", "Phân vị đuôi trái của một số phân phối chuẩn hóa", "2.3", "appendix", "table_A2_2_tail_quantiles.docx", "simulation", "Also exported as CSV",
  "table", "Bảng A2.3", "Mẫu bảng so sánh log-likelihood, AIC và BIC", "2.4", "appendix", "table_A2_3_model_comparison_template.docx", "template", "No empirical results inserted",
  "table", "Bảng A2.4", "Diễn giải các kiểm định chẩn đoán mô hình GARCH", "2.4", "appendix", "table_A2_4_diagnostic_tests.docx", "author synthesis", "Also exported as CSV",
  "table", "Bảng A2.5", "Tiêu chí đánh giá dự báo biến động", "2.4", "appendix", "table_A2_5_forecast_evaluation_criteria.docx", "author synthesis", "Use in Chapter 2 appendix or move to Chapter 3"
)

readr::write_csv(ch02_register, file.path(OUT_DIR, "ch02_output_register.csv"))

message("Chapter 2 outputs exported to: ", normalizePath(OUT_DIR, mustWork = FALSE))
message("Figures: ", normalizePath(FIG_DIR, mustWork = FALSE))
message("Tables: ", normalizePath(TAB_DIR, mustWork = FALSE))
