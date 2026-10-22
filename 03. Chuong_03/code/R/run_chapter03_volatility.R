#!/usr/bin/env Rscript

# Chapter 3: reproducible VN-Index volatility measurement and forecasting.
# Run from any working directory: Rscript code/R/run_chapter03_volatility.R

suppressPackageStartupMessages({
  library(dplyr); library(readr); library(ggplot2); library(zoo)
  library(rugarch); library(tseries); library(FinTS); library(jsonlite)
  library(forecast); library(MCS)
})

args <- commandArgs(trailingOnly = TRUE)
refresh <- "--refresh" %in% args
options(timeout = 15)
script_file <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE)[1])
chapter_dir <- normalizePath(file.path(dirname(script_file), "..", ".."))
book_root <- normalizePath(file.path(chapter_dir, ".."))
legacy_file <- file.path(book_root, "..", "99. Archive", "2026-08-15_pre-restructure",
                         "legacy_numbering_pending_review", "vnindex_daily.csv")
raw_dir <- file.path(chapter_dir, "data", "raw")
derived_dir <- file.path(chapter_dir, "data", "derived")
figure_dir <- file.path(chapter_dir, "output", "figures")
table_dir <- file.path(chapter_dir, "output", "tables")
estimate_dir <- file.path(chapter_dir, "output", "estimates")
for (d in c(raw_dir, derived_dir, figure_dir, table_dir, estimate_dir)) dir.create(d, recursive = TRUE, showWarnings = FALSE)

write_csv_utf8 <- function(x, path) readr::write_csv(x, path, na = "")
safe_num <- function(x) suppressWarnings(as.numeric(gsub(",", "", as.character(x))))
stars <- function(p) ifelse(is.na(p), "", ifelse(p < .01, "***", ifelse(p < .05, "**", ifelse(p < .1, "*", ""))))
q_like <- function(actual, forecast) {
  ok <- is.finite(actual) & is.finite(forecast) & actual > 0 & forecast > 0
  mean(actual[ok] / forecast[ok] - log(actual[ok] / forecast[ok]) - 1)
}
ewma_var <- function(x, lambda = .94, initial = 60L) {
  out <- rep(NA_real_, length(x)); s2 <- var(x[seq_len(initial)])
  for (i in 2:length(x)) { s2 <- lambda * s2 + (1 - lambda) * x[i - 1]^2; out[i] <- s2 }
  out
}

# Attempt the documented VNDIRECT-compatible endpoint. It is optional because the
# provider can be unavailable; the run then remains reproducible from the archived input.
download_vndirect <- function() {
  endpoint <- paste0("https://finfo-api.vndirect.com.vn/v4/stock_prices?",
                     "q=code:VNINDEX~date:gte:2010-01-01&size=10000&sort=date")
  ans <- tryCatch(jsonlite::fromJSON(endpoint, simplifyDataFrame = TRUE), error = function(e) NULL)
  if (is.null(ans) || is.null(ans$data) || nrow(ans$data) < 100) return(NULL)
  d <- as.data.frame(ans$data)
  pick <- function(candidates) { hit <- intersect(candidates, names(d)); if (!length(hit)) rep(NA, nrow(d)) else d[[hit[1]]] }
  tibble(date = as.Date(pick(c("date", "tradingDate"))),
         open = safe_num(pick(c("open", "openPrice"))), high = safe_num(pick(c("high", "highPrice"))),
         low = safe_num(pick(c("low", "lowPrice"))), close = safe_num(pick(c("close", "adClose", "closePrice")))) |>
    filter(is.finite(close), close > 0) |>
    arrange(date) |>
    distinct(date, .keep_all = TRUE)
}

source_note <- "archive fallback"
raw <- if (refresh) download_vndirect() else NULL
if (!is.null(raw) && nrow(raw) > 100) source_note <- "VNDIRECT endpoint"
if (is.null(raw) || nrow(raw) < 100) {
  if (!file.exists(legacy_file)) stop("No downloadable data and archive fallback is missing: ", legacy_file)
  old <- readr::read_csv(legacy_file, show_col_types = FALSE)
  raw <- old |>
    transmute(date = as.Date(date), open = safe_num(open), high = safe_num(high),
              low = safe_num(low), close = safe_num(close)) |>
    filter(is.finite(close), close > 0) |>
    arrange(date) |>
    distinct(date, .keep_all = TRUE)
}
write_csv_utf8(raw, file.path(raw_dir, "vnindex_daily.csv"))

daily <- raw |>
  mutate(log_price = log(close), ret = 100 * (log_price - lag(log_price)),
         gk_var = .5 * log(high / low)^2 - (2 * log(2) - 1) * log(close / open)^2) |>
  filter(is.finite(ret))
write_csv_utf8(daily, file.path(derived_dir, "vnindex_daily_clean.csv"))

desc <- tibble(
  n_obs = nrow(daily), sample_start = min(daily$date), sample_end = max(daily$date),
  mean_return_pct = mean(daily$ret), sd_return_pct = sd(daily$ret), min_return_pct = min(daily$ret),
  max_return_pct = max(daily$ret), skewness = moments::skewness(daily$ret),
  kurtosis = moments::kurtosis(daily$ret), jb_p = jarque.bera.test(daily$ret)$p.value,
  lb_return_p = Box.test(daily$ret, lag = 12, type = "Ljung-Box")$p.value,
  lb_squared_return_p = Box.test(daily$ret^2, lag = 12, type = "Ljung-Box")$p.value,
  arch_lm_p = FinTS::ArchTest(daily$ret, lags = 12)$p.value,
  adf_return_p = adf.test(daily$ret)$p.value,
  kpss_return_p = kpss.test(daily$ret)$p.value
)
write_csv_utf8(desc, file.path(table_dir, "table_03_descriptive_statistics.csv"))
stationarity <- bind_rows(
  tibble(test = "ADF", series = "log_price", statistic = adf.test(daily$log_price)$statistic, p_value = adf.test(daily$log_price)$p.value),
  tibble(test = "ADF", series = "log_return", statistic = adf.test(daily$ret)$statistic, p_value = adf.test(daily$ret)$p.value),
  tibble(test = "KPSS", series = "log_price", statistic = kpss.test(daily$log_price)$statistic, p_value = kpss.test(daily$log_price)$p.value),
  tibble(test = "KPSS", series = "log_return", statistic = kpss.test(daily$ret)$statistic, p_value = kpss.test(daily$ret)$p.value)
)
write_csv_utf8(stationarity, file.path(table_dir, "table_04_stationarity.csv"))
arch_tests <- bind_rows(
  tibble(test = "Ljung-Box return", lag = 12, statistic = Box.test(daily$ret, lag = 12, type = "Ljung-Box")$statistic, p_value = Box.test(daily$ret, lag = 12, type = "Ljung-Box")$p.value),
  tibble(test = "Ljung-Box squared return", lag = 12, statistic = Box.test(daily$ret^2, lag = 12, type = "Ljung-Box")$statistic, p_value = Box.test(daily$ret^2, lag = 12, type = "Ljung-Box")$p.value),
  tibble(test = "ARCH-LM", lag = 12, statistic = FinTS::ArchTest(daily$ret, lags = 12)$statistic, p_value = FinTS::ArchTest(daily$ret, lags = 12)$p.value)
)
write_csv_utf8(arch_tests, file.path(table_dir, "table_05_arch_diagnostics.csv"))

roll_windows <- c(20L, 60L, 120L, 252L)
for (w in roll_windows) daily[[paste0("roll", w, "_var")]] <- zoo::rollapply(daily$ret^2, w, mean, fill = NA, align = "right")
for (lam in c(.90, .94, .97)) daily[[paste0("ewma", gsub("\\.", "", as.character(lam)), "_var")]] <- ewma_var(daily$ret, lam)
roll_summary <- bind_rows(lapply(roll_windows, function(w) {
  x <- sqrt(daily[[paste0("roll", w, "_var")]])
  tibble(window = w, mean_daily_pct = mean(x, na.rm = TRUE), median_daily_pct = median(x, na.rm = TRUE), p95_daily_pct = quantile(x, .95, na.rm = TRUE), max_daily_pct = max(x, na.rm = TRUE))
}))
ewma_summary <- bind_rows(lapply(c(.90, .94, .97), function(lam) {
  x <- sqrt(daily[[paste0("ewma", gsub("\\.", "", as.character(lam)), "_var")]])
  tibble(lambda = lam, mean_daily_pct = mean(x, na.rm = TRUE), median_daily_pct = median(x, na.rm = TRUE), p95_daily_pct = quantile(x, .95, na.rm = TRUE), max_daily_pct = max(x, na.rm = TRUE))
}))
write_csv_utf8(tibble(mean_daily_pct = mean(daily$ret), daily_volatility_pct = sd(daily$ret), annualized_volatility_pct = sd(daily$ret) * sqrt(252), n_obs = nrow(daily)), file.path(table_dir, "table_06_historical_volatility.csv"))
write_csv_utf8(roll_summary, file.path(table_dir, "table_07_rolling_volatility.csv")); write_csv_utf8(ewma_summary, file.path(table_dir, "table_08_ewma_volatility.csv"))

mean_candidates <- tidyr::expand_grid(arma_p = 0:3, arma_q = 0:3)
mean_model_selection <- bind_rows(lapply(seq_len(nrow(mean_candidates)), function(i) {
  pq <- unlist(mean_candidates[i, ])
  s <- ugarchspec(variance.model = list(model = "sGARCH", garchOrder = c(1, 1)),
                  mean.model = list(armaOrder = pq, include.mean = TRUE), distribution.model = "std")
  f <- tryCatch(ugarchfit(s, daily$ret, solver = "hybrid"), error = function(e) NULL)
  if (is.null(f)) return(tibble(arma_p = pq[1], arma_q = pq[2], AIC = NA_real_, BIC = NA_real_, Hannan_Quinn = NA_real_, residual_lb_p = NA_real_, converged = FALSE))
  ic <- infocriteria(f)
  z <- residuals(f, standardize = TRUE)
  tibble(arma_p = pq[1], arma_q = pq[2], AIC = ic[1], BIC = ic[2], Hannan_Quinn = ic[3], residual_lb_p = Box.test(z, lag = 12, type = "Ljung-Box")$p.value, converged = f@fit$convergence == 0)
}))
write_csv_utf8(mean_model_selection, file.path(table_dir, "table_08b_mean_model_selection.csv"))
eligible_mean <- mean_model_selection |> filter(converged, is.finite(BIC), residual_lb_p >= .05)
chosen_mean <- if (nrow(eligible_mean)) eligible_mean |> slice_min(BIC, n = 1, with_ties = FALSE) else mean_model_selection |> filter(converged, is.finite(BIC)) |> slice_min(BIC, n = 1, with_ties = FALSE)
if (!nrow(chosen_mean)) stop("No converged ARMA mean specification")
arma_order <- c(chosen_mean$arma_p, chosen_mean$arma_q)
make_spec <- function(variance_model, distribution) ugarchspec(
  variance.model = list(model = variance_model, garchOrder = c(1, 1)),
  mean.model = list(armaOrder = arma_order, include.mean = TRUE), distribution.model = distribution
)
model_catalog <- tibble(
  model = c("GARCH-normal", "GARCH-Student-t", "GJR-GARCH-Student-t", "GJR-GARCH-skewed-t",
            "EGARCH-Student-t", "EGARCH-skewed-t", "APARCH-Student-t", "APARCH-skewed-t"),
  variance_model = c("sGARCH", "sGARCH", "gjrGARCH", "gjrGARCH", "eGARCH", "eGARCH", "apARCH", "apARCH"),
  distribution = c("norm", "std", "std", "sstd", "std", "sstd", "std", "sstd")
)
specs <- setNames(lapply(seq_len(nrow(model_catalog)), function(i) make_spec(model_catalog$variance_model[i], model_catalog$distribution[i])), model_catalog$model)
fits <- lapply(specs, function(s) ugarchfit(s, daily$ret, solver = "hybrid"))
fit_info <- bind_rows(lapply(names(fits), function(nm) {
  ic <- infocriteria(fits[[nm]])
  tibble(model = nm, AIC = ic[1], BIC = ic[2], Hannan_Quinn = ic[3])
}))
coefficients <- bind_rows(lapply(names(fits), function(nm) {
  m <- fits[[nm]]@fit$matcoef
  tibble(model = nm, parameter = rownames(m), estimate = m[,1], std_error = m[,2], p_value = m[,4], significance = stars(m[,4]))
}))
persistence <- bind_rows(lapply(names(fits), function(nm) {
  cf <- coef(fits[[nm]]); kind <- model_catalog$variance_model[match(nm, model_catalog$model)]
  p <- if (kind %in% c("gjrGARCH", "apARCH")) cf["alpha1"] + cf["beta1"] + .5 * cf["gamma1"] else if (kind == "eGARCH") cf["beta1"] else cf["alpha1"] + cf["beta1"]
  tibble(model = nm, persistence = as.numeric(p), persistence_note = ifelse(kind == "apARCH", "persistence proxy in power-volatility model", "model persistence"), half_life_days = ifelse(p > 0 && p < 1, log(.5) / log(p), NA_real_))
}))
diagnostics <- bind_rows(lapply(names(fits), function(nm) {
  z <- residuals(fits[[nm]], standardize = TRUE)
  bind_rows(
    tibble(model = nm, test = "Ljung-Box z", statistic = Box.test(z, lag = 12, type = "Ljung-Box")$statistic, p_value = Box.test(z, lag = 12, type = "Ljung-Box")$p.value),
    tibble(model = nm, test = "Ljung-Box z_squared", statistic = Box.test(z^2, lag = 12, type = "Ljung-Box")$statistic, p_value = Box.test(z^2, lag = 12, type = "Ljung-Box")$p.value),
    tibble(model = nm, test = "ARCH-LM z", statistic = FinTS::ArchTest(z, lags = 12)$statistic, p_value = FinTS::ArchTest(z, lags = 12)$p.value)
  )
}))
write_csv_utf8(fit_info, file.path(table_dir, "table_09_garch_information_criteria.csv")); write_csv_utf8(coefficients, file.path(estimate_dir, "garch_coefficients.csv")); write_csv_utf8(persistence, file.path(table_dir, "table_11_garch_persistence.csv")); write_csv_utf8(diagnostics, file.path(table_dir, "table_12_garch_diagnostics.csv"))
coefficient_table <- coefficients |>
  mutate(value = sprintf("%.5f%s (%.5f)", estimate, significance, std_error)) |>
  select(parameter, model, value) |>
  tidyr::pivot_wider(names_from = model, values_from = value)
write_csv_utf8(coefficient_table, file.path(table_dir, "table_10_garch_coefficients.csv"))
write_csv_utf8(tibble(
  measure = c("Historical", "Rolling", "EWMA", "GARCH-type", "Garman-Klass"),
  data_required = c("Close", "Close", "Close", "Close", "OHLC"),
  chapter_role = c("Benchmark", "Dynamic benchmark", "RiskMetrics benchmark", "Main models", "Supplementary proxy")
), file.path(table_dir, "table_13_volatility_measure_map.csv"))

horizons <- c(1L, 5L, 10L, 20L); window <- 1250L; step <- 20L; max_origins <- 50L
origins <- tail(seq(window, nrow(daily) - max(horizons), by = step), max_origins)
forecast_one <- function(origin) {
  x <- daily$ret[(origin - window + 1):origin]; date <- daily$date[origin]
  actual <- sapply(horizons, function(h) sum(daily$ret[(origin + 1):(origin + h)]^2))
  base <- bind_rows(lapply(horizons, function(h) bind_rows(
    tibble(origin_date = date, model = "Rolling 60", horizon = h, actual_var = actual[which(horizons == h)], forecast_var = h * mean(tail(x^2, 60))),
    tibble(origin_date = date, model = "Rolling 120", horizon = h, actual_var = actual[which(horizons == h)], forecast_var = h * mean(tail(x^2, 120))),
    tibble(origin_date = date, model = "EWMA 0.94", horizon = h, actual_var = actual[which(horizons == h)], forecast_var = h * tail(ewma_var(x, .94), 1))
  )))
  garch_rows <- bind_rows(lapply(names(specs), function(nm) {
    f <- tryCatch(ugarchfit(specs[[nm]], x, solver = "hybrid"), error = function(e) NULL)
    if (is.null(f)) return(tibble())
    fc <- ugarchforecast(f, n.ahead = max(horizons)); s2 <- as.numeric(sigma(fc)^2)
    rows <- lapply(horizons, function(h) {
      tibble(origin_date = date, model = nm, horizon = h,
             actual_var = actual[which(horizons == h)],
             forecast_var = sum(s2[seq_len(h)]))
    })
    bind_rows(rows)
  }))
  bind_rows(base, garch_rows)
}
forecast_long <- bind_rows(lapply(origins, forecast_one))
if (!nrow(forecast_long)) stop("Forecast exercise produced no valid rows")
metrics <- forecast_long |>
  group_by(model, horizon) |>
  summarise(n_origins = n(), RMSE = sqrt(mean((forecast_var - actual_var)^2)), MAE = mean(abs(forecast_var - actual_var)), QLIKE = q_like(actual_var, forecast_var), .groups = "drop")
write_csv_utf8(forecast_long, file.path(estimate_dir, "forecast_paths.csv")); write_csv_utf8(metrics, file.path(estimate_dir, "forecast_metrics_long.csv"))
for (metric in c("RMSE", "MAE", "QLIKE")) {
  wide <- metrics |> select(model, horizon, all_of(metric)) |> tidyr::pivot_wider(names_from = horizon, values_from = all_of(metric), names_prefix = "h_")
  write_csv_utf8(wide, file.path(table_dir, paste0("table_", ifelse(metric == "RMSE", "15", ifelse(metric == "MAE", "16", "17")), "_forecast_", tolower(metric), ".csv")))
}
best <- metrics |> tidyr::pivot_longer(c(RMSE, MAE, QLIKE), names_to = "metric", values_to = "value") |> group_by(horizon, metric) |> slice_min(value, n = 1, with_ties = FALSE) |> ungroup()
write_csv_utf8(best, file.path(table_dir, "table_18_best_forecast_models.csv"))

# Mincer-Zarnowitz regression: actual_var_t = a + b * forecast_var_t, per model x horizon
mz <- bind_rows(lapply(split(forecast_long, list(forecast_long$model, forecast_long$horizon), drop = TRUE), function(d) {
  fit <- lm(actual_var ~ forecast_var, data = d)
  wald <- car::linearHypothesis(fit, c("(Intercept) = 0", "forecast_var = 1"), test = "F")
  tibble(model = d$model[1], horizon = d$horizon[1], n_origins = nrow(d),
         intercept = coef(fit)[1], slope = coef(fit)[2], r_squared = summary(fit)$r.squared,
         joint_F = wald$F[2], joint_p = wald$`Pr(>F)`[2])
}))
write_csv_utf8(mz, file.path(table_dir, "table_19_mincer_zarnowitz.csv"))

# Diebold-Mariano test: each model's squared-error loss vs the best RMSE model, per horizon
dm <- bind_rows(lapply(horizons, function(h) {
  d_h <- forecast_long |> filter(horizon == h)
  ref_model <- metrics |> filter(horizon == h) |> slice_min(RMSE, n = 1, with_ties = FALSE) |> pull(model)
  ref <- d_h |> filter(model == ref_model) |> arrange(origin_date)
  bind_rows(lapply(setdiff(unique(d_h$model), ref_model), function(nm) {
    cand <- d_h |> filter(model == nm) |> arrange(origin_date)
    common <- intersect(ref$origin_date, cand$origin_date)
    e_ref <- ref$actual_var[match(common, ref$origin_date)] - ref$forecast_var[match(common, ref$origin_date)]
    e_cand <- cand$actual_var[match(common, cand$origin_date)] - cand$forecast_var[match(common, cand$origin_date)]
    dm_res <- tryCatch(forecast::dm.test(e_cand, e_ref, alternative = "two.sided", h = h, power = 2), error = function(e) NULL)
    if (is.null(dm_res)) return(tibble())
    tibble(horizon = h, reference_model = ref_model, model = nm, n_common_origins = length(common),
           DM_statistic = as.numeric(dm_res$statistic), DM_p_value = dm_res$p.value)
  }))
}))
write_csv_utf8(dm, file.path(table_dir, "table_20_diebold_mariano.csv"))

# Model Confidence Set on squared-error loss, per horizon
mcs_summary <- bind_rows(lapply(horizons, function(h) {
  d_h <- forecast_long |> filter(horizon == h)
  loss_wide <- d_h |> mutate(se = (actual_var - forecast_var)^2) |>
    select(origin_date, model, se) |> tidyr::pivot_wider(names_from = model, values_from = se) |>
    tidyr::drop_na()
  loss_mat <- as.matrix(select(loss_wide, -origin_date))
  set.seed(20260816)
  m <- tryCatch(MCS::MCSprocedure(Loss = loss_mat, alpha = .1, B = 2000, statistic = "TR"), error = function(e) NULL)
  if (is.null(m)) return(tibble(horizon = h, model = colnames(loss_mat), in_mcs_90 = NA))
  included <- m@Info$included
  tibble(horizon = h, model = colnames(loss_mat), in_mcs_90 = colnames(loss_mat) %in% included)
}))
write_csv_utf8(mcs_summary, file.path(table_dir, "table_21_model_confidence_set.csv"))
write_csv_utf8(tibble(
  setting = c("Estimation window", "Forecast horizons", "Refit frequency", "Maximum forecast origins", "Actual-volatility proxy", "Loss functions"),
  value = c("1250 trading days", "1, 5, 10, 20 trading days", "Every 20 trading days", "50", "Sum of future squared returns", "RMSE, MAE, QLIKE")
), file.path(table_dir, "table_14_forecast_design.csv"))

theme_book <- theme_minimal(base_size = 11) + theme(legend.position = "bottom", plot.title = element_text(face = "bold"))
ggsave(file.path(figure_dir, "fig_01_price_returns.png"), ggplot(daily, aes(date, close)) + geom_line(colour = "#0b5394") + labs(x = NULL, y = "VN-Index", title = "VN-Index: giá đóng cửa") + theme_book, width = 8, height = 4, dpi = 180)
ggsave(file.path(figure_dir, "fig_03_return_histogram.png"), ggplot(daily, aes(ret)) + geom_histogram(aes(y = after_stat(density)), bins = 55, fill = "#6fa8dc", colour = "white") + stat_function(fun = dnorm, args = list(mean = mean(daily$ret), sd = sd(daily$ret)), colour = "#cc0000", linewidth = .8) + labs(x = "Log return (%)", y = "Mật độ", title = "Phân phối log return VN-Index") + theme_book, width = 8, height = 4, dpi = 180)
qq <- qqnorm(daily$ret, plot.it = FALSE)
qq_df <- tibble(theoretical = qq$x, observed = qq$y)
ggsave(file.path(figure_dir, "fig_04_return_qq.png"), ggplot(qq_df, aes(theoretical, observed)) + geom_point(size = .6, colour = "#0b5394") + geom_abline(slope = sd(daily$ret), intercept = mean(daily$ret), colour = "#cc0000") + labs(x = "Phân vị chuẩn lý thuyết", y = "Phân vị return", title = "Q-Q plot của log return VN-Index") + theme_book, width = 8, height = 4, dpi = 180)
acf_ret <- acf(daily$ret, lag.max = 30, plot = FALSE); acf_sq <- acf(daily$ret^2, lag.max = 30, plot = FALSE)
acf_df <- bind_rows(tibble(lag = as.numeric(acf_ret$lag), acf = as.numeric(acf_ret$acf), series = "Return"), tibble(lag = as.numeric(acf_sq$lag), acf = as.numeric(acf_sq$acf), series = "Squared return")) |> filter(lag > 0)
ggsave(file.path(figure_dir, "fig_05_acf_return_squared.png"), ggplot(acf_df, aes(lag, acf)) + geom_hline(yintercept = 0, colour = "grey50") + geom_segment(aes(xend = lag, yend = 0), colour = "#0b5394") + geom_point(colour = "#0b5394") + facet_wrap(~series, ncol = 1) + labs(x = "Độ trễ", y = "ACF", title = "Tự tương quan return và squared return") + theme_book, width = 8, height = 5, dpi = 180)
roll_long <- daily |> select(date, starts_with("roll")) |> tidyr::pivot_longer(-date, names_to = "window", values_to = "variance") |> mutate(window = gsub("_var", "", window), volatility = sqrt(variance))
ggsave(file.path(figure_dir, "fig_06_rolling_volatility.png"), ggplot(roll_long, aes(date, volatility, colour = window)) + geom_line(linewidth = .35) + labs(x = NULL, y = "Volatility ngày (%)", colour = "Cửa sổ", title = "Rolling volatility của VN-Index") + theme_book, width = 8, height = 4, dpi = 180)
ewma_long <- daily |> select(date, starts_with("ewma")) |> tidyr::pivot_longer(-date, names_to = "lambda", values_to = "variance") |> mutate(lambda = sub("ewma", "", sub("_var", "", lambda)), volatility = sqrt(variance))
ggsave(file.path(figure_dir, "fig_07_ewma_lambda.png"), ggplot(ewma_long, aes(date, volatility, colour = lambda)) + geom_line(linewidth = .35) + labs(x = NULL, y = "Volatility ngày (%)", colour = "Lambda", title = "EWMA volatility theo hệ số suy giảm") + theme_book, width = 8, height = 4, dpi = 180)
compare <- daily |> transmute(date, `Rolling 60` = sqrt(roll60_var), `EWMA 0.94` = sqrt(ewma094_var)) |> tidyr::pivot_longer(-date, names_to = "model", values_to = "volatility")
ggsave(file.path(figure_dir, "fig_08_ewma_rolling_comparison.png"), ggplot(compare, aes(date, volatility, colour = model)) + geom_line(linewidth = .35) + labs(x = NULL, y = "Volatility ngày (%)", colour = NULL, title = "So sánh EWMA và rolling volatility") + theme_book, width = 8, height = 4, dpi = 180)
fit_long <- bind_rows(lapply(names(fits), function(nm) tibble(date = daily$date, model = nm, volatility = as.numeric(sigma(fits[[nm]])))))
ggsave(file.path(figure_dir, "fig_09_garch_conditional_volatility.png"), ggplot(fit_long, aes(date, volatility, colour = model)) + geom_line(linewidth = .35) + labs(x = NULL, y = "Volatility ngày (%)", colour = NULL, title = "Volatility có điều kiện từ mô hình GARCH-type") + theme_book, width = 8, height = 4, dpi = 180)
gjr <- coef(fits[["GJR-GARCH-Student-t"]]); shocks <- seq(-4, 4, length.out = 300); baseline <- var(daily$ret)
news <- tibble(shock = shocks, next_variance = gjr["omega"] + gjr["alpha1"] * shocks^2 + gjr["gamma1"] * shocks^2 * (shocks < 0) + gjr["beta1"] * baseline)
ggsave(file.path(figure_dir, "fig_10_news_impact_gjr.png"), ggplot(news, aes(shock, sqrt(pmax(next_variance, 0)))) + geom_line(colour = "#cc0000", linewidth = .7) + labs(x = "Cú sốc chuẩn hóa", y = "Volatility kỳ sau (%)", title = "News impact curve: GJR-GARCH") + theme_book, width = 8, height = 4, dpi = 180)
gk_roll <- zoo::rollapply(pmax(daily$gk_var, 0), 20, mean, fill = NA, align = "right")
gk_df <- tibble(date = daily$date, `Garman-Klass (20 ngày)` = sqrt(gk_roll), `Close-to-close (20 ngày)` = sqrt(daily$roll20_var)) |> tidyr::pivot_longer(-date, names_to = "measure", values_to = "volatility")
ggsave(file.path(figure_dir, "fig_11_range_based_volatility.png"), ggplot(gk_df, aes(date, volatility, colour = measure)) + geom_line(linewidth = .35) + labs(x = NULL, y = "Volatility ngày (%)", colour = NULL, title = "Range-based volatility từ dữ liệu OHLC") + theme_book, width = 8, height = 4, dpi = 180)
plot_fc <- forecast_long |> filter(horizon == 1)
ggsave(file.path(figure_dir, "fig_12_oos_forecast_h1.png"), ggplot(plot_fc, aes(origin_date)) + geom_line(aes(y = actual_var, colour = "Proxy thực tế"), linewidth = .55) + geom_line(aes(y = forecast_var, colour = model), linewidth = .35) + labs(x = NULL, y = "Phương sai 1 ngày", colour = NULL, title = "Dự báo OOS và proxy volatility: horizon 1 ngày") + theme_book, width = 8, height = 4, dpi = 180)
fc20 <- ugarchforecast(fits[["GARCH-Student-t"]], n.ahead = 20)
multi <- tibble(horizon = 1:20, forecast_volatility = as.numeric(sigma(fc20)))
ggsave(file.path(figure_dir, "fig_13_garch_multistep_forecast.png"), ggplot(multi, aes(horizon, forecast_volatility)) + geom_line(colour = "#0b5394", linewidth = .7) + geom_point(colour = "#0b5394") + labs(x = "Horizon (ngày)", y = "Volatility dự báo (%)", title = "Dự báo nhiều bước từ GARCH-Student-t") + theme_book, width = 8, height = 4, dpi = 180)

manifest <- tibble(source_used = source_note, generated_at_utc = format(Sys.time(), tz = "UTC", usetz = TRUE), sample_start = min(daily$date), sample_end = max(daily$date), price_observations = nrow(raw), return_observations = nrow(daily), forecast_origins = length(origins), mean_specification = paste0("ARMA(", arma_order[1], ",", arma_order[2], ") selected by lowest BIC among candidates with Ljung-Box p >= 0.05"), garch_specifications = paste(names(specs), collapse = "; "), qlike_definition = "mean(actual/forecast - log(actual/forecast) - 1)")
write_csv_utf8(manifest, file.path(derived_dir, "data_manifest.csv"))
report <- c("# Run report — Chương 3", "", paste0("- Source used: ", source_note), paste0("- Sample: ", min(daily$date), " to ", max(daily$date), "; ", nrow(daily), " log returns."), paste0("- Mean equation: ARMA(", arma_order[1], ",", arma_order[2], ") selected by lowest BIC among ARMA(0:3,0:3) candidates with Ljung-Box p >= 0.05."), paste0("- Volatility models: ", paste(names(specs), collapse = "; "), "."), paste0("- Forecast origins: ", length(origins), "; window = ", window, "; refit step = ", step, "."), "- QLIKE is the non-negative variance loss `actual/forecast - log(actual/forecast) - 1`.", "", "## Best models by horizon and loss", "", paste(capture.output(print(best, n = Inf)), collapse = "\n"))
writeLines(report, file.path(chapter_dir, "output", "RUN_REPORT.md"))
message("Chapter 3 completed. See output/RUN_REPORT.md")
