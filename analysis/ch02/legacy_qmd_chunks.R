# ============================================================
# Verbatim R chunks from the legacy Quarto chapter (read-only provenance copy)
# Source: git commit 5b648173c77a092aec43830d63d4bba2d960a051,
#   path archive_pre_word_workflow/chapters/legacy-ch02.qmd (blob ad394fa663797a7c6b33e95f2a563dc33a1188fb);
#   the file was deleted in commit 5c085fb ("Remove legacy layout").
# Copied by C02-M3 (L2), 22/10/2026. Do not edit: lines are byte-for-byte copies.
# Chunk fences and '#|' chunk options are kept as comments.
# ============================================================

# ---- qmd lines 38-127 of chunk setup-ch02 (lines 12-37: package checks and knitr options, omitted; caller loads packages) ----
base_family <- "Arial"
base_size <- 13

book_cols <- c(
  "return" = "#2B2B2B",
  "true_sigma" = "#0072B2",
  "historical" = "#999999",
  "rolling_20" = "#D55E00",
  "rolling_60" = "#0072B2",
  "rolling_120" = "#009E73",
  "ewma_090" = "#CC79A7",
  "ewma_094" = "#E69F00",
  "ewma_097" = "#56B4E9",
  "garch" = "#D55E00",
  "gjr" = "#009E73"
)

book_ltys <- c(
  "Volatility thật trong mô phỏng" = "solid",
  "Historical volatility" = "dashed",
  "Rolling 20 kỳ" = "solid",
  "Rolling 60 kỳ" = "longdash",
  "Rolling 120 kỳ" = "dotdash",
  "EWMA, lambda = 0.90" = "solid",
  "EWMA, lambda = 0.94" = "longdash",
  "EWMA, lambda = 0.97" = "dotdash",
  "GARCH chuẩn" = "solid",
  "GJR-GARCH" = "longdash"
)

theme_book <- function() {
  theme_minimal(base_family = base_family, base_size = base_size) +
    theme(
      plot.title = element_text(face = "bold", size = 15, margin = margin(b = 4)),
      plot.subtitle = element_text(size = 12, margin = margin(b = 10)),
      axis.title = element_text(size = 12),
      axis.text = element_text(size = 11),
      legend.position = "bottom",
      legend.title = element_text(size = 11),
      legend.text = element_text(size = 10),
      panel.grid.minor = element_blank()
    )
}

label_pct <- function(accuracy = 0.01) {
  scales::label_percent(accuracy = accuracy, decimal.mark = ",")
}

fmt_pct <- function(x, accuracy = 0.01) {
  scales::percent(x, accuracy = accuracy, decimal.mark = ",")
}

roll_sd <- function(x, width) {
  zoo::rollapplyr(x, width = width, FUN = sd, fill = NA)
}

ewma_vol <- function(x, lambda = 0.94) {
  sigma2 <- numeric(length(x))
  sigma2[1] <- var(x, na.rm = TRUE)

  for (i in 2:length(x)) {
    sigma2[i] <- lambda * sigma2[i - 1] + (1 - lambda) * x[i - 1]^2
  }

  sqrt(sigma2)
}

fit_garch_model <- function(x, model = "sGARCH", dist = "std") {
  spec <- rugarch::ugarchspec(
    variance.model = list(model = model, garchOrder = c(1, 1)),
    mean.model = list(armaOrder = c(0, 0), include.mean = TRUE),
    distribution.model = dist
  )

  tryCatch(
    rugarch::ugarchfit(spec = spec, data = x, solver = "hybrid"),
    error = function(e) NULL
  )
}

coef_table_simple <- function(fit) {
  if (is.null(fit)) {
    return(tibble(`Tham số` = "Không ước lượng được", `Ước lượng` = NA_real_))
  }

  tibble(
    `Tham số` = names(coef(fit)),
    `Ước lượng` = round(as.numeric(coef(fit)), 6)
  )
}

# ---- qmd lines 131-165: chunk simulate-return-series ----
#| label: simulate-return-series
#| include: false

set.seed(2026)

n_obs <- 1500

true_sigma <- c(
  rep(0.008, 350),
  rep(0.022, 300),
  rep(0.011, 450),
  rep(0.017, 400)
)

true_sigma <- true_sigma[seq_len(n_obs)]

# Sai số Student-t được chuẩn hóa để có phương sai xấp xỉ bằng 1.
df_t <- 6
z_t <- rt(n_obs, df = df_t) / sqrt(df_t / (df_t - 2))

r_demo <- true_sigma * z_t

df_return <- tibble(
  time = 1:n_obs,
  return = r_demo,
  abs_return = abs(r_demo),
  squared_return = r_demo^2,
  true_sigma = true_sigma,
  regime = case_when(
    time <= 350 ~ "Biến động thấp",
    time <= 650 ~ "Biến động cao",
    time <= 1100 ~ "Biến động trung bình",
    TRUE ~ "Biến động tăng trở lại"
  )
)

# ---- qmd lines 534-579: chunk fig-ewma-vs-rolling-demo ----
legacy_fig_ewma_vs_rolling <- {
#| label: fig-ewma-vs-rolling-demo
#| fig-cap: "So sánh rolling volatility và EWMA volatility"
#| fig-width: 8
#| fig-height: 4.8

df_ewma_compare <- df_return |>
  mutate(
    `Rolling 60 kỳ` = roll_sd(return, 60),
    `EWMA, lambda = 0.90` = ewma_vol(return, 0.90),
    `EWMA, lambda = 0.94` = ewma_vol(return, 0.94),
    `EWMA, lambda = 0.97` = ewma_vol(return, 0.97),
    `Volatility thật trong mô phỏng` = true_sigma
  ) |>
  select(time, `Rolling 60 kỳ`, starts_with("EWMA"), `Volatility thật trong mô phỏng`) |>
  pivot_longer(
    cols = -time,
    names_to = "method",
    values_to = "volatility"
  )

ggplot(df_ewma_compare, aes(x = time, y = volatility, color = method, linetype = method)) +
  geom_line(linewidth = 0.7, na.rm = TRUE) +
  scale_y_continuous(labels = label_pct(0.5)) +
  scale_color_manual(values = c(
    "Rolling 60 kỳ" = book_cols["rolling_60"],
    "EWMA, lambda = 0.90" = book_cols["ewma_090"],
    "EWMA, lambda = 0.94" = book_cols["ewma_094"],
    "EWMA, lambda = 0.97" = book_cols["ewma_097"],
    "Volatility thật trong mô phỏng" = book_cols["true_sigma"]
  )) +
  scale_linetype_manual(values = c(
    "Rolling 60 kỳ" = "solid",
    "EWMA, lambda = 0.90" = "solid",
    "EWMA, lambda = 0.94" = "longdash",
    "EWMA, lambda = 0.97" = "dotdash",
    "Volatility thật trong mô phỏng" = "dashed"
  )) +
  labs(
    title = "EWMA cập nhật volatility liên tục hơn rolling volatility",
    subtitle = "Lambda nhỏ phản ứng nhanh hơn; lambda lớn duy trì ảnh hưởng của cú sốc lâu hơn",
    x = "Thời gian",
    y = "Volatility ước lượng",
    color = NULL,
    linetype = NULL
  ) +
  theme_book()
}

# ---- qmd lines 893-936: chunk fig-news-impact-curve ----
legacy_fig_news_impact <- {
#| label: fig-news-impact-curve
#| fig-cap: "News impact curve của GARCH chuẩn và GJR-GARCH"
#| fig-width: 8
#| fig-height: 4.8

eps_grid <- seq(-0.06, 0.06, length.out = 300)
omega_demo <- 0.000005
alpha_demo <- 0.08
beta_sigma_demo <- 0.0001
gamma_demo <- 0.12

news_df <- tibble(
  shock = eps_grid,
  `GARCH chuẩn` = omega_demo + alpha_demo * shock^2 + beta_sigma_demo,
  `GJR-GARCH` = omega_demo + alpha_demo * shock^2 + gamma_demo * shock^2 * (shock < 0) + beta_sigma_demo
) |>
  pivot_longer(
    cols = c(`GARCH chuẩn`, `GJR-GARCH`),
    names_to = "model",
    values_to = "variance"
  )

ggplot(news_df, aes(x = shock, y = sqrt(variance), color = model, linetype = model)) +
  geom_line(linewidth = 0.9) +
  geom_vline(xintercept = 0, color = "grey55", linetype = "dashed") +
  scale_x_continuous(labels = label_pct(1)) +
  scale_y_continuous(labels = label_pct(0.5)) +
  scale_color_manual(values = c(
    "GARCH chuẩn" = book_cols["garch"],
    "GJR-GARCH" = book_cols["gjr"]
  )) +
  scale_linetype_manual(values = c(
    "GARCH chuẩn" = "solid",
    "GJR-GARCH" = "longdash"
  )) +
  labs(
    title = "Mô hình bất đối xứng cho phép shock âm làm volatility tăng mạnh hơn",
    subtitle = "Với GARCH chuẩn, shock dương và âm cùng độ lớn có tác động như nhau; với GJR-GARCH, shock âm có thể tạo volatility cao hơn",
    x = "Cú sốc quá khứ",
    y = "Volatility hàm ý từ news impact curve",
    color = NULL,
    linetype = NULL
  ) +
  theme_book()
}
