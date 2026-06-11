suppressPackageStartupMessages({
  library(readxl)
  library(readr)
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(purrr)
  library(lubridate)
  library(rugarch)
  library(quantreg)
  library(tseries)
  library(FinTS)
})

script_arg <- grep("^--file=", commandArgs(), value = TRUE)
script_path <- normalizePath(sub("^--file=", "", script_arg[1]))
project_root <- normalizePath(file.path(dirname(script_path), "..", ".."))
data_dir <- file.path(project_root, "data")
derived_dir <- file.path(data_dir, "derived")
dir.create(derived_dir, recursive = TRUE, showWarnings = FALSE)

data_path <- file.path(data_dir, "vni_data.xlsx")
if (!file.exists(data_path)) {
  stop("Missing data file: data/vni_data.xlsx")
}

parse_date_safe <- function(x) {
  if (inherits(x, "Date")) return(as.Date(x))
  if (inherits(x, "POSIXt")) return(as.Date(x))
  if (is.numeric(x)) return(as.Date(x, origin = "1899-12-30"))

  x_chr <- trimws(as.character(x))
  out <- suppressWarnings(as.Date(x_chr))
  if (all(is.na(out))) out <- suppressWarnings(ymd(x_chr))
  if (all(is.na(out))) out <- suppressWarnings(dmy(x_chr))
  if (all(is.na(out))) out <- suppressWarnings(mdy(x_chr))
  as.Date(out)
}

as_numeric_safe <- function(x) {
  if (is.numeric(x)) return(as.numeric(x))
  as.numeric(gsub(",", "", trimws(as.character(x))))
}

sample_skewness <- function(x) {
  x <- x[is.finite(x)]
  n <- length(x)
  if (n < 3) return(NA_real_)
  m <- mean(x)
  s <- stats::sd(x)
  if (!is.finite(s) || s == 0) return(NA_real_)
  (n / ((n - 1) * (n - 2))) * sum(((x - m) / s)^3)
}

sample_excess_kurtosis <- function(x) {
  x <- x[is.finite(x)]
  n <- length(x)
  if (n < 4) return(NA_real_)
  m <- mean(x)
  s <- stats::sd(x)
  if (!is.finite(s) || s == 0) return(NA_real_)
  num <- n * (n + 1) * sum(((x - m) / s)^4)
  den <- (n - 1) * (n - 2) * (n - 3)
  adj <- 3 * (n - 1)^2 / ((n - 2) * (n - 3))
  num / den - adj
}

infer_t_df <- function(x) {
  ex_kurt <- sample_excess_kurtosis(x)
  if (!is.finite(ex_kurt) || ex_kurt <= 0) return(30)
  df <- 4 + 6 / ex_kurt
  pmin(pmax(df, 5), 60)
}

std_t_q <- function(alpha, df) {
  stats::qt(alpha, df = df) * sqrt((df - 2) / df)
}

std_t_left_mean <- function(alpha, df) {
  q_raw <- stats::qt(alpha, df = df)
  scale_adj <- sqrt((df - 2) / df)
  scale_adj * (-(stats::dt(q_raw, df = df) * (df + q_raw^2)) / ((df - 1) * alpha))
}

ewma_vol <- function(x, lambda = 0.94, init_window = 60) {
  x <- as.numeric(x)
  n <- length(x)
  out <- rep(NA_real_, n)
  start_n <- min(init_window, max(10, floor(n / 5)))
  sigma2 <- stats::var(x[seq_len(start_n)], na.rm = TRUE)
  if (!is.finite(sigma2)) sigma2 <- mean(x^2, na.rm = TRUE)
  for (i in 2:n) {
    sigma2 <- lambda * sigma2 + (1 - lambda) * x[i - 1]^2
    out[i] <- sqrt(sigma2)
  }
  out
}

qlike_loss <- function(actual_var, forecast_var) {
  idx <- is.finite(actual_var) & is.finite(forecast_var) & actual_var > 0 & forecast_var > 0
  if (!any(idx)) return(NA_real_)
  mean(actual_var[idx] / forecast_var[idx] - log(actual_var[idx] / forecast_var[idx]) - 1)
}

fit_garch_safe <- function(x, model = "sGARCH", dist = "std") {
  spec <- rugarch::ugarchspec(
    variance.model = list(model = model, garchOrder = c(1, 1)),
    mean.model = list(armaOrder = c(1, 0), include.mean = TRUE),
    distribution.model = dist
  )

  tryCatch(
    rugarch::ugarchfit(spec = spec, data = x, solver = "hybrid"),
    error = function(e) NULL
  )
}

make_garch_spec <- function(garch_model = "sGARCH", dist = "std") {
  rugarch::ugarchspec(
    variance.model = list(model = garch_model, garchOrder = c(1, 1)),
    mean.model = list(armaOrder = c(1, 0), include.mean = TRUE),
    distribution.model = dist
  )
}

find_var_column <- function(nms, alpha) {
  alpha_pct <- alpha * 100
  patterns <- c(paste0(alpha_pct, "%"), paste0(format(alpha_pct, trim = TRUE, scientific = FALSE), "%"))
  var_cols <- grep("VaR", nms, value = TRUE)
  for (pat in patterns) {
    hit <- var_cols[grepl(pat, var_cols, fixed = TRUE)]
    if (length(hit) > 0) return(hit[1])
  }
  if (length(var_cols) > 0) return(var_cols[1])
  NA_character_
}

fit_gpd_mle <- function(excess) {
  excess <- excess[is.finite(excess) & excess > 0]
  if (length(excess) < 30) return(NULL)

  neg_ll <- function(par) {
    beta <- exp(par[1])
    xi <- par[2]
    if (!is.finite(beta) || beta <= 0 || !is.finite(xi) || xi <= -0.49 || xi >= 0.95) {
      return(1e12)
    }
    z <- 1 + xi * excess / beta
    if (any(z <= 0)) return(1e12)
    if (abs(xi) < 1e-6) {
      ll <- -length(excess) * log(beta) - sum(excess) / beta
    } else {
      ll <- -length(excess) * log(beta) - (1 / xi + 1) * sum(log(z))
    }
    -ll
  }

  fit <- tryCatch(
    optim(
      par = c(log(mean(excess)), 0.1),
      fn = neg_ll,
      method = "L-BFGS-B",
      lower = c(log(1e-6), -0.49),
      upper = c(log(max(excess) * 100), 0.95)
    ),
    error = function(e) NULL
  )

  if (is.null(fit) || fit$convergence != 0) return(NULL)
  list(beta = exp(fit$par[1]), xi = fit$par[2])
}

gpd_var_es <- function(loss_window, alpha, threshold_prob = 0.90) {
  loss_window <- loss_window[is.finite(loss_window)]
  n <- length(loss_window)
  if (n < 100) return(c(VaR = NA_real_, ES = NA_real_))

  u <- as.numeric(stats::quantile(loss_window, probs = threshold_prob, na.rm = TRUE, type = 7))
  excess <- loss_window[loss_window > u] - u
  nu <- length(excess)
  if (nu < 30) return(c(VaR = NA_real_, ES = NA_real_))

  fit <- fit_gpd_mle(excess)
  if (is.null(fit)) return(c(VaR = NA_real_, ES = NA_real_))

  beta <- fit$beta
  xi <- fit$xi
  tail_prob <- nu / n
  if (alpha >= tail_prob) return(c(VaR = NA_real_, ES = NA_real_))

  if (abs(xi) < 1e-6) {
    var_val <- u + beta * log(tail_prob / alpha)
  } else {
    var_val <- u + (beta / xi) * ((tail_prob / alpha)^xi - 1)
  }

  es_val <- if (xi < 1) {
    var_val + (beta + xi * (var_val - u)) / (1 - xi)
  } else {
    NA_real_
  }

  c(VaR = var_val, ES = es_val)
}

kupiec_test <- function(exceed, alpha) {
  exceed <- as.integer(exceed)
  exceed <- exceed[is.finite(exceed)]
  n <- length(exceed)
  x <- sum(exceed)
  if (n == 0) return(c(LR_uc = NA_real_, p_value = NA_real_, phat = NA_real_))

  phat <- x / n
  eps <- 1e-10
  phat_adj <- min(max(phat, eps), 1 - eps)
  alpha_adj <- min(max(alpha, eps), 1 - eps)

  ll_null <- x * log(alpha_adj) + (n - x) * log(1 - alpha_adj)
  ll_alt <- x * log(phat_adj) + (n - x) * log(1 - phat_adj)
  lr <- -2 * (ll_null - ll_alt)

  c(LR_uc = lr, p_value = 1 - stats::pchisq(lr, df = 1), phat = phat)
}

christoffersen_test <- function(exceed, alpha) {
  exceed <- as.integer(exceed)
  exceed <- exceed[is.finite(exceed)]
  n <- length(exceed)
  if (n < 5) return(c(LR_ind = NA_real_, p_ind = NA_real_, LR_cc = NA_real_, p_cc = NA_real_))

  y0 <- exceed[-n]
  y1 <- exceed[-1]
  n00 <- sum(y0 == 0 & y1 == 0)
  n01 <- sum(y0 == 0 & y1 == 1)
  n10 <- sum(y0 == 1 & y1 == 0)
  n11 <- sum(y0 == 1 & y1 == 1)

  eps <- 1e-10
  p01 <- min(max(n01 / max(n00 + n01, 1), eps), 1 - eps)
  p11 <- min(max(n11 / max(n10 + n11, 1), eps), 1 - eps)
  p <- min(max((n01 + n11) / max(n00 + n01 + n10 + n11, 1), eps), 1 - eps)

  ll_ind <- n00 * log(1 - p01) + n01 * log(p01) + n10 * log(1 - p11) + n11 * log(p11)
  ll_null <- (n00 + n10) * log(1 - p) + (n01 + n11) * log(p)
  lr_ind <- -2 * (ll_null - ll_ind)

  kup <- kupiec_test(exceed, alpha)
  lr_cc <- as.numeric(kup["LR_uc"]) + lr_ind
  c(
    LR_ind = lr_ind,
    p_ind = 1 - stats::pchisq(lr_ind, df = 1),
    LR_cc = lr_cc,
    p_cc = 1 - stats::pchisq(lr_cc, df = 2)
  )
}

dq_test <- function(exceed, var, alpha, lags = 4) {
  exceed <- as.integer(exceed)
  dat <- tibble(hit = exceed - alpha, var = as.numeric(scale(var)))
  for (j in seq_len(lags)) {
    dat[[paste0("hit_lag", j)]] <- dplyr::lag(dat$hit, j)
  }
  dat <- dat |> filter(if_all(everything(), is.finite))
  if (nrow(dat) < 50) return(c(DQ = NA_real_, p_value = NA_real_))

  rhs <- paste(c(paste0("hit_lag", seq_len(lags)), "var"), collapse = " + ")
  fit <- tryCatch(stats::lm(stats::as.formula(paste("hit ~", rhs)), data = dat), error = function(e) NULL)
  if (is.null(fit)) return(c(DQ = NA_real_, p_value = NA_real_))

  stat <- nrow(dat) * summary(fit)$r.squared
  df <- length(stats::coef(fit)) - 1
  c(DQ = stat, p_value = 1 - stats::pchisq(stat, df = df))
}

quantile_loss_return <- function(ret, var_loss, alpha) {
  q <- -var_loss
  hit <- as.integer(ret < q)
  (alpha - hit) * (ret - q)
}

traffic_decision <- function(p_uc, p_cc, exceed_rate, alpha) {
  if (is.na(p_uc) || is.na(p_cc)) return("Insufficient")
  if (p_uc >= 0.05 && p_cc >= 0.05) return("Pass")
  if (exceed_rate > alpha) return("Underestimates risk")
  "Too conservative or clustered"
}

raw_data <- readxl::read_excel(data_path)
names(raw_data) <- trimws(names(raw_data))
daily <- raw_data |>
  transmute(
    date = parse_date_safe(.data[["Date"]]),
    close = as_numeric_safe(.data[["Price"]]),
    open = as_numeric_safe(.data[["Open"]]),
    high = as_numeric_safe(.data[["High"]]),
    low = as_numeric_safe(.data[["Low"]])
  ) |>
  filter(!is.na(date), is.finite(close), close > 0) |>
  arrange(date) |>
  distinct(date, .keep_all = TRUE) |>
  mutate(
    log_price = log(close),
    ret = 100 * (log_price - dplyr::lag(log_price)),
    loss = -ret,
    abs_ret = abs(ret),
    ret_lag1 = dplyr::lag(ret),
    abs_ret_lag1 = dplyr::lag(abs_ret),
    loss_lag1 = dplyr::lag(loss),
    gk_var = ifelse(
      is.finite(open) & is.finite(high) & is.finite(low) & is.finite(close) &
        open > 0 & high > 0 & low > 0 & close > 0,
      0.5 * (log(high / low))^2 - (2 * log(2) - 1) * (log(close / open))^2,
      NA_real_
    )
  ) |>
  filter(is.finite(ret))

returns <- daily$ret
n_obs <- nrow(daily)
sample_start <- min(daily$date)
sample_end <- max(daily$date)

desc_stats <- tibble(
  n_obs = n_obs,
  sample_start = sample_start,
  sample_end = sample_end,
  mean_ret = mean(daily$ret, na.rm = TRUE),
  sd_ret = stats::sd(daily$ret, na.rm = TRUE),
  min_ret = min(daily$ret, na.rm = TRUE),
  max_ret = max(daily$ret, na.rm = TRUE),
  skewness = sample_skewness(daily$ret),
  excess_kurtosis = sample_excess_kurtosis(daily$ret),
  jb_p = tryCatch(tseries::jarque.bera.test(daily$ret)$p.value, error = function(e) NA_real_),
  lb_ret_p = tryCatch(stats::Box.test(daily$ret, lag = 20, type = "Ljung-Box")$p.value, error = function(e) NA_real_),
  lb_sq_p = tryCatch(stats::Box.test(daily$ret^2, lag = 20, type = "Ljung-Box")$p.value, error = function(e) NA_real_),
  arch_lm_p = tryCatch(FinTS::ArchTest(daily$ret, lags = 12)$p.value, error = function(e) NA_real_),
  adf_ret_p = tryCatch(tseries::adf.test(daily$ret)$p.value, error = function(e) NA_real_)
)

stylized_facts <- tibble(
  feature = c(
    "Log-return mean is small relative to volatility",
    "Distribution departs from Gaussian symmetry and thin tails",
    "Return levels show limited linear dependence",
    "Squared returns retain serial dependence",
    "ARCH effect is present"
  ),
  empirical_indicator = c(
    "Mean and standard deviation of daily returns",
    "Skewness, excess kurtosis, Jarque-Bera p-value",
    "Ljung-Box p-value on returns",
    "Ljung-Box p-value on squared returns",
    "ARCH-LM p-value"
  ),
  implication_for_book = c(
    "Focus shifts from average return to risk scale and tail behaviour",
    "Normal-only VaR/ES is unlikely to be sufficient",
    "Mean dynamics are secondary to volatility and tail dynamics",
    "Conditional-volatility models are empirically motivated",
    "ARCH/GARCH-type inputs are justified for later chapters"
  )
)

vol_window <- min(1250L, max(750L, floor(n_obs * 0.55)))
horizons <- c(1L, 5L, 10L, 20L)
forecast_step <- 20L
max_forecast_origins <- 50L
start_origin <- vol_window
end_origin <- n_obs - max(horizons)
forecast_origins <- seq(start_origin, end_origin, by = forecast_step)
if (length(forecast_origins) > max_forecast_origins) {
  forecast_origins <- tail(forecast_origins, max_forecast_origins)
}

vol_rows <- list()
row_id <- 1L
for (origin in forecast_origins) {
  train_idx <- (origin - vol_window + 1L):origin
  x_train <- returns[train_idx]
  current_date <- daily$date[origin]

  roll60_var <- stats::var(tail(x_train, 60), na.rm = TRUE)
  roll120_var <- stats::var(tail(x_train, 120), na.rm = TRUE)
  ewma_var <- tail(ewma_vol(x_train, lambda = 0.94)^2, 1)

  garch_fit <- fit_garch_safe(x_train, model = "sGARCH", dist = "std")
  gjr_fit <- fit_garch_safe(x_train, model = "gjrGARCH", dist = "std")

  garch_paths <- list(
    "GARCH-Student-t" = garch_fit,
    "GJR-GARCH-Student-t" = gjr_fit
  )

  for (h in horizons) {
    actual_var <- sum(returns[(origin + 1L):(origin + h)]^2, na.rm = TRUE)
    proxy_var <- if (h == 1L && is.finite(daily$gk_var[origin + 1L])) daily$gk_var[origin + 1L] else actual_var

    vol_rows[[row_id]] <- tibble(
      date = current_date,
      horizon = h,
      model = "Rolling 60",
      actual_var = actual_var,
      proxy_var = proxy_var,
      forecast_var = h * roll60_var
    )
    row_id <- row_id + 1L

    vol_rows[[row_id]] <- tibble(
      date = current_date,
      horizon = h,
      model = "Rolling 120",
      actual_var = actual_var,
      proxy_var = proxy_var,
      forecast_var = h * roll120_var
    )
    row_id <- row_id + 1L

    vol_rows[[row_id]] <- tibble(
      date = current_date,
      horizon = h,
      model = "EWMA 0.94",
      actual_var = actual_var,
      proxy_var = proxy_var,
      forecast_var = h * ewma_var
    )
    row_id <- row_id + 1L
  }

  for (model_name in names(garch_paths)) {
    fit_obj <- garch_paths[[model_name]]
    if (is.null(fit_obj)) next
    fc <- tryCatch(rugarch::ugarchforecast(fit_obj, n.ahead = max(horizons)), error = function(e) NULL)
    if (is.null(fc)) next
    sigma2_path <- as.numeric(rugarch::sigma(fc))^2
    for (h in horizons) {
      actual_var <- sum(returns[(origin + 1L):(origin + h)]^2, na.rm = TRUE)
      proxy_var <- if (h == 1L && is.finite(daily$gk_var[origin + 1L])) daily$gk_var[origin + 1L] else actual_var
      vol_rows[[row_id]] <- tibble(
        date = current_date,
        horizon = h,
        model = model_name,
        actual_var = actual_var,
        proxy_var = proxy_var,
        forecast_var = sum(sigma2_path[1:h], na.rm = TRUE)
      )
      row_id <- row_id + 1L
    }
  }
}

vol_eval <- bind_rows(vol_rows) |>
  filter(is.finite(actual_var), is.finite(forecast_var), forecast_var > 0)

vol_metrics <- vol_eval |>
  group_by(horizon, model) |>
  summarise(
    RMSE = sqrt(mean((forecast_var - actual_var)^2, na.rm = TRUE)),
    MAE = mean(abs(forecast_var - actual_var), na.rm = TRUE),
    QLIKE = qlike_loss(actual_var, forecast_var),
    .groups = "drop"
  )

vol_ranks <- vol_metrics |>
  pivot_longer(cols = c(RMSE, MAE, QLIKE), names_to = "metric", values_to = "value") |>
  group_by(metric, horizon) |>
  mutate(rank = rank(value, ties.method = "first")) |>
  ungroup() |>
  group_by(model) |>
  summarise(avg_rank = mean(rank, na.rm = TRUE), .groups = "drop")

vol_candidates <- tibble(
  model = c("Rolling 60", "Rolling 120", "EWMA 0.94", "GARCH-Student-t", "GJR-GARCH-Student-t"),
  family = c("Historical/rolling benchmark", "Historical/rolling benchmark", "Volatility dynamics", "Volatility dynamics", "Asymmetric volatility dynamics"),
  main_value = c(
    "Fast-moving benchmark for short-memory variance",
    "Smoother benchmark with longer memory",
    "Simple dynamic benchmark that reacts to new shocks",
    "Conditional-volatility input with heavy-tail innovations",
    "Conditional-volatility input that also allows asymmetric shock effects"
  ),
  carry_to_ch07 = c("No", "No", "Yes", "Yes", "Yes")
) |>
  left_join(vol_ranks, by = "model")

var_window <- 500L
alpha_levels <- c(0.05, 0.01)
alpha_labels <- c("0.05" = "95%", "0.01" = "99%")
refit_every <- 25L
pot_threshold_prob <- 0.90
backtest_start <- daily$date[var_window + 1L]

rolling_historical_var_es <- function(ret, dates, alpha, width) {
  n <- length(ret)
  var_out <- rep(NA_real_, n)
  es_out <- rep(NA_real_, n)
  for (i in (width + 1L):n) {
    w <- ret[(i - width): (i - 1L)]
    q <- as.numeric(stats::quantile(w, probs = alpha, na.rm = TRUE, type = 7))
    var_out[i] <- -q
    es_out[i] <- -mean(w[w <= q], na.rm = TRUE)
  }
  tibble(date = dates, model = "Historical simulation", alpha = alpha, VaR = var_out, ES = es_out)
}

rolling_parametric_var_es <- function(ret, dates, alpha, width, dist = c("normal", "student")) {
  dist <- match.arg(dist)
  n <- length(ret)
  var_out <- rep(NA_real_, n)
  es_out <- rep(NA_real_, n)
  for (i in (width + 1L):n) {
    w <- ret[(i - width):(i - 1L)]
    mu <- mean(w, na.rm = TRUE)
    sig <- stats::sd(w, na.rm = TRUE)
    if (!is.finite(sig) || sig <= 0) next
    if (dist == "normal") {
      z <- stats::qnorm(alpha)
      var_out[i] <- -(mu + sig * z)
      es_out[i] <- -(mu - sig * stats::dnorm(z) / alpha)
    } else {
      df <- infer_t_df(w)
      q_std <- std_t_q(alpha, df)
      lm_std <- std_t_left_mean(alpha, df)
      var_out[i] <- -(mu + sig * q_std)
      es_out[i] <- -(mu + sig * lm_std)
    }
  }
  tibble(
    date = dates,
    model = ifelse(dist == "normal", "Normal rolling", "Student-t rolling"),
    alpha = alpha,
    VaR = var_out,
    ES = es_out
  )
}

rolling_ewma_var_es <- function(ret, dates, alpha, width, lambda = 0.94) {
  sigma <- ewma_vol(ret, lambda = lambda)
  mu <- zoo::rollapplyr(ret, width = width, FUN = mean, fill = NA)
  mu <- dplyr::lag(mu)
  z <- stats::qnorm(alpha)
  tibble(
    date = dates,
    model = "EWMA-normal",
    alpha = alpha,
    VaR = -(mu + sigma * z),
    ES = -(mu - sigma * stats::dnorm(z) / alpha)
  )
}

run_ugarchroll_var <- function(ret, dates, spec, model_label, width, refit_every, alpha_levels) {
  roll_obj <- tryCatch(
    rugarch::ugarchroll(
      spec = spec,
      data = ret,
      n.ahead = 1,
      forecast.length = length(ret) - width,
      refit.every = refit_every,
      refit.window = "moving",
      window.size = width,
      solver = "hybrid",
      calculate.VaR = TRUE,
      VaR.alpha = alpha_levels,
      keep.coef = TRUE
    ),
    error = function(e) NULL
  )
  if (is.null(roll_obj)) {
    return(bind_rows(lapply(alpha_levels, function(a) {
      tibble(date = dates, model = model_label, alpha = a, VaR = NA_real_, ES = NA_real_)
    })))
  }
  roll_df <- as.data.frame(roll_obj)
  out_dates <- tail(dates, nrow(roll_df))
  bind_rows(lapply(alpha_levels, function(a) {
    var_col <- find_var_column(names(roll_df), a)
    if (is.na(var_col)) {
      var_value <- rep(NA_real_, nrow(roll_df))
    } else {
      var_value <- -as.numeric(roll_df[[var_col]])
    }
    tibble(date = out_dates, model = model_label, alpha = a, VaR = var_value, ES = NA_real_)
  }))
}

rolling_quantile_regression_var <- function(df, alpha, width) {
  n <- nrow(df)
  var_out <- rep(NA_real_, n)
  for (i in (width + 1L):n) {
    w <- df[(i - width):(i - 1L), ] |>
      filter(is.finite(ret), is.finite(abs_ret_lag1), is.finite(loss_lag1), is.finite(ret_lag1))
    newx <- df[i, ]
    if (nrow(w) < width * 0.8) next
    if (any(!is.finite(c(newx$abs_ret_lag1, newx$loss_lag1, newx$ret_lag1)))) next
    fit <- tryCatch(quantreg::rq(ret ~ abs_ret_lag1 + loss_lag1 + ret_lag1, tau = alpha, data = w), error = function(e) NULL)
    if (is.null(fit)) next
    q_pred <- tryCatch(as.numeric(stats::predict(fit, newdata = newx)), error = function(e) NA_real_)
    var_out[i] <- -q_pred
  }
  tibble(date = df$date, model = "Quantile regression", alpha = alpha, VaR = var_out, ES = NA_real_)
}

rolling_evt_pot_var_es <- function(loss, dates, alpha, width, threshold_prob = 0.90) {
  n <- length(loss)
  var_out <- rep(NA_real_, n)
  es_out <- rep(NA_real_, n)
  for (i in (width + 1L):n) {
    w <- loss[(i - width):(i - 1L)]
    out <- gpd_var_es(w, alpha, threshold_prob)
    var_out[i] <- out["VaR"]
    es_out[i] <- out["ES"]
  }
  tibble(date = dates, model = "EVT-POT", alpha = alpha, VaR = var_out, ES = es_out)
}

hs_forecasts <- bind_rows(lapply(alpha_levels, function(a) {
  rolling_historical_var_es(daily$ret, daily$date, a, var_window)
}))
normal_forecasts <- bind_rows(lapply(alpha_levels, function(a) {
  rolling_parametric_var_es(daily$ret, daily$date, a, var_window, "normal")
}))
student_forecasts <- bind_rows(lapply(alpha_levels, function(a) {
  rolling_parametric_var_es(daily$ret, daily$date, a, var_window, "student")
}))
ewma_forecasts <- bind_rows(lapply(alpha_levels, function(a) {
  rolling_ewma_var_es(daily$ret, daily$date, a, var_window, lambda = 0.94)
}))

garch_spec_t <- make_garch_spec("sGARCH", "std")
gjr_spec_t <- make_garch_spec("gjrGARCH", "std")
garch_forecasts <- run_ugarchroll_var(daily$ret, daily$date, garch_spec_t, "GARCH-t", var_window, refit_every, alpha_levels)
gjr_forecasts <- run_ugarchroll_var(daily$ret, daily$date, gjr_spec_t, "GJR-GARCH-t", var_window, refit_every, alpha_levels)
qr_forecasts <- bind_rows(lapply(alpha_levels, function(a) {
  rolling_quantile_regression_var(daily, a, var_window)
}))
evt_forecasts <- bind_rows(lapply(alpha_levels, function(a) {
  rolling_evt_pot_var_es(daily$loss, daily$date, a, var_window, pot_threshold_prob)
}))

all_forecasts <- bind_rows(
  hs_forecasts,
  normal_forecasts,
  student_forecasts,
  ewma_forecasts,
  garch_forecasts,
  gjr_forecasts,
  qr_forecasts,
  evt_forecasts
) |>
  mutate(alpha_label = dplyr::recode(as.character(alpha), "0.05" = "95%", "0.01" = "99%"))

eval_data <- all_forecasts |>
  left_join(daily |> select(date, ret, loss), by = "date") |>
  filter(date >= backtest_start, is.finite(VaR), is.finite(loss)) |>
  mutate(
    exceed = loss > VaR,
    qloss = quantile_loss_return(ret, VaR, alpha)
  )

backtest_summary <- eval_data |>
  group_by(model, alpha, alpha_label) |>
  summarise(
    n = n(),
    exceedances = sum(exceed, na.rm = TRUE),
    exceed_rate = mean(exceed, na.rm = TRUE),
    expected = dplyr::first(alpha) * dplyr::n(),
    avg_qloss = mean(qloss, na.rm = TRUE),
    kupiec_p = kupiec_test(exceed, dplyr::first(alpha))["p_value"],
    christoffersen_p = christoffersen_test(exceed, dplyr::first(alpha))["p_cc"],
    dq_p = dq_test(exceed, VaR, dplyr::first(alpha))["p_value"],
    .groups = "drop"
  ) |>
  mutate(
    decision = mapply(traffic_decision, kupiec_p, christoffersen_p, exceed_rate, alpha)
  )

tail_severity <- eval_data |>
  filter(exceed) |>
  group_by(model, alpha, alpha_label) |>
  summarise(
    exceedances = n(),
    mean_loss_when_exceed = mean(loss, na.rm = TRUE),
    mean_var_when_exceed = mean(VaR, na.rm = TRUE),
    mean_excess_loss = mean(loss - VaR, na.rm = TRUE),
    tail_loss_ratio = mean(loss / VaR, na.rm = TRUE),
    mean_es_when_available = if (all(is.na(ES))) NA_real_ else mean(ES, na.rm = TRUE),
    .groups = "drop"
  )

var_plot_models <- c("Historical simulation", "EWMA-normal", "GJR-GARCH-t", "EVT-POT")
var_paths <- eval_data |>
  filter(alpha == 0.01, model %in% var_plot_models) |>
  select(date, model, VaR, loss)

model_summary <- tibble(
  model = c(
    "Historical simulation",
    "Normal rolling",
    "Student-t rolling",
    "EWMA-normal",
    "GARCH-t",
    "GJR-GARCH-t",
    "Quantile regression",
    "EVT-POT"
  ),
  family = c(
    "Nonparametric",
    "Static parametric",
    "Static parametric heavy-tail",
    "Volatility-based",
    "Volatility-based",
    "Volatility-based asymmetric",
    "Semi-parametric",
    "Tail model"
  ),
  main_strength = c(
    "Transparent benchmark from empirical quantiles",
    "Fast baseline under Gaussian assumption",
    "Allows heavier tails without full volatility model",
    "Responds quickly to volatility changes",
    "Links conditional variance and heavy-tail innovations",
    "Adds asymmetric volatility response to bad news",
    "Targets the conditional quantile directly",
    "Focuses explicitly on the extreme tail"
  ),
  main_risk = c(
    "Slow adaptation when market regime shifts",
    "Thin-tail assumption can understate left-tail risk",
    "Window choice and df inference remain sensitive",
    "Normal innovation may still miss tail thickness",
    "ES is not directly reported in the cached pipeline",
    "Greater model complexity and possible estimation instability",
    "Sensitive to predictor choice and local sample structure",
    "Threshold choice can make results unstable"
  ),
  es_available = c("Yes", "Yes", "Yes", "Yes", "No", "No", "No", "Yes")
)

pipeline <- list(
  metadata = list(
    source_file = "data/vni_data.xlsx",
    source_status = "Local workbook in repository; original external provider still unverified",
    price_field = "Price used as close",
    fields_available = c("Date", "Price", "Open", "High", "Low"),
    frequency = "Daily trading data",
    sample_start = sample_start,
    sample_end = sample_end,
    n_obs = n_obs,
    missing_treatment = "Drop rows with invalid date/price and keep distinct dates",
    return_definition = "ret = 100 * [log(P_t) - log(P_{t-1})]",
    loss_definition = "loss = -ret",
    ch05_ch06_horizons = horizons,
    ch06_estimation_window = vol_window,
    ch06_refit_step = forecast_step,
    ch06_max_origins = max_forecast_origins,
    ch07_estimation_window = var_window,
    ch07_refit_every = refit_every,
    ch07_alpha_levels = alpha_levels,
    pot_threshold_prob = pot_threshold_prob,
    generated_at = Sys.time()
  ),
  daily = daily,
  desc_stats = desc_stats,
  stylized_facts = stylized_facts,
  vol_eval = vol_eval,
  vol_metrics = vol_metrics,
  vol_candidates = vol_candidates,
  all_forecasts = all_forecasts,
  eval_data = eval_data,
  backtest_summary = backtest_summary,
  tail_severity = tail_severity,
  var_paths = var_paths,
  model_summary = model_summary
)

saveRDS(pipeline, file.path(derived_dir, "ch05_ch07_pipeline.rds"))
readr::write_csv(daily, file.path(derived_dir, "vnindex_daily.csv"))
readr::write_csv(desc_stats, file.path(derived_dir, "ch05_descriptive_stats.csv"))
readr::write_csv(vol_metrics, file.path(derived_dir, "ch06_volatility_metrics.csv"))
readr::write_csv(vol_candidates, file.path(derived_dir, "ch06_volatility_candidates.csv"))
readr::write_csv(backtest_summary, file.path(derived_dir, "ch07_backtesting_summary.csv"))
readr::write_csv(tail_severity, file.path(derived_dir, "ch07_tail_severity.csv"))
readr::write_csv(var_paths, file.path(derived_dir, "ch07_var_paths.csv"))

cat("Derived pipeline written to data/derived/ch05_ch07_pipeline.rds\n")
