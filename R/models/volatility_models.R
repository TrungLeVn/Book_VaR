if (!exists("bookvar_sample_excess_kurtosis", mode = "function")) {
  stop("Source R/data/prepare_vnindex.R before sourcing R/models/volatility_models.R.", call. = FALSE)
}

bookvar_rolling_sd <- function(x, window = 20, scale = 1) {
  n <- length(x)
  out <- rep(NA_real_, n)

  if (window <= 1L || window > n) {
    return(out)
  }

  for (i in seq.int(window, n)) {
    out[i] <- stats::sd(x[(i - window + 1L):i], na.rm = TRUE) * scale
  }

  out
}

bookvar_rolling_variance <- function(x, window = 20) {
  n <- length(x)
  out <- rep(NA_real_, n)

  if (window <= 1L || window > n) {
    return(out)
  }

  for (i in seq.int(window, n)) {
    out[i] <- stats::var(x[(i - window + 1L):i], na.rm = TRUE)
  }

  out
}

bookvar_ewma_variance <- function(x, lambda = 0.94, initial_variance = NULL) {
  n <- length(x)
  sigma2 <- rep(NA_real_, n)

  if (is.null(initial_variance)) {
    initial_variance <- stats::var(x, na.rm = TRUE)
  }

  sigma2[1] <- initial_variance

  for (i in 2:n) {
    sigma2[i] <- lambda * sigma2[i - 1L] + (1 - lambda) * x[i - 1L]^2
  }

  sigma2
}

bookvar_ewma_vol <- function(x, lambda = 0.94, scale = 1) {
  sqrt(bookvar_ewma_variance(x, lambda = lambda)) * scale
}

bookvar_half_life <- function(lambda) {
  log(0.5) / log(lambda)
}

bookvar_qlike_loss <- function(actual_var, forecast_var) {
  eps <- 1e-10
  actual_var <- pmax(actual_var, eps)
  forecast_var <- pmax(forecast_var, eps)
  mean(log(forecast_var) + actual_var / forecast_var, na.rm = TRUE)
}

bookvar_build_historical_vol_table <- function(returns) {
  daily_vol <- stats::sd(returns, na.rm = TRUE)
  annual_vol <- daily_vol * sqrt(252)

  data.frame(
    `Chỉ tiêu` = c("Trung bình ngày", "Volatility ngày", "Volatility năm hóa", "Số ngày giao dịch"),
    `Giá trị` = c(
      mean(returns, na.rm = TRUE),
      daily_vol,
      annual_vol,
      length(returns)
    ),
    check.names = FALSE
  )
}

bookvar_build_rolling_volatility_panel <- function(returns, dates, windows = c(20, 60, 120, 252)) {
  pieces <- lapply(windows, function(window) {
    data.frame(
      date = dates,
      window = paste0("Cửa sổ ", window, " ngày"),
      volatility = bookvar_rolling_sd(returns, window = window),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, pieces)
}

bookvar_build_rolling_volatility_summary <- function(rolling_panel) {
  split_panel <- split(rolling_panel$volatility, rolling_panel$window)

  out <- lapply(names(split_panel), function(window_name) {
    values <- split_panel[[window_name]]
    values <- values[is.finite(values)]

    data.frame(
      window = window_name,
      mean = mean(values),
      median = stats::median(values),
      q95 = stats::quantile(values, 0.95),
      max = max(values),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, out)
}

bookvar_build_ewma_panel <- function(returns, dates, lambda_values = c(0.90, 0.94, 0.97)) {
  pieces <- lapply(lambda_values, function(lambda) {
    data.frame(
      date = dates,
      lambda = paste0("lambda = ", lambda),
      volatility = bookvar_ewma_vol(returns, lambda = lambda),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, pieces)
}

bookvar_build_ewma_summary <- function(ewma_panel) {
  split_panel <- split(ewma_panel$volatility, ewma_panel$lambda)

  out <- lapply(names(split_panel), function(lambda_name) {
    values <- split_panel[[lambda_name]]
    values <- values[is.finite(values)]

    data.frame(
      lambda = lambda_name,
      mean = mean(values),
      median = stats::median(values),
      q95 = stats::quantile(values, 0.95),
      max = max(values),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, out)
}

bookvar_build_rolling_ewma_comparison <- function(returns, dates) {
  data.frame(
    date = rep(dates, 2),
    method = rep(c("Rolling 60 ngày", "EWMA lambda = 0.94"), each = length(dates)),
    volatility = c(
      bookvar_rolling_sd(returns, window = 60),
      bookvar_ewma_vol(returns, lambda = 0.94)
    ),
    stringsAsFactors = FALSE
  )
}

bookvar_make_garch_spec <- function(variance_model = "sGARCH", distribution_model = "std", arma_order = c(0, 0)) {
  rugarch::ugarchspec(
    variance.model = list(model = variance_model, garchOrder = c(1, 1)),
    mean.model = list(armaOrder = arma_order, include.mean = TRUE),
    distribution.model = distribution_model
  )
}

bookvar_fit_garch_safe <- function(x, model = "sGARCH", dist = "std") {
  spec <- bookvar_make_garch_spec(variance_model = model, distribution_model = dist)
  tryCatch(
    rugarch::ugarchfit(spec = spec, data = x, solver = "hybrid"),
    error = function(...) NULL
  )
}

bookvar_model_short_name <- function(x) {
  dplyr::recode(
    x,
    `GARCH-normal` = "GARCH-N",
    `GARCH-Student-t` = "GARCH-t",
    `GJR-GARCH-Student-t` = "GJR-t",
    `EGARCH-Student-t` = "EGARCH-t",
    .default = x
  )
}

bookvar_parameter_label <- function(x) {
  dplyr::recode(
    x,
    mu = "Mean: mu",
    ar1 = "Mean: ar1",
    ma1 = "Mean: ma1",
    omega = "Variance: omega",
    alpha1 = "ARCH: alpha1",
    beta1 = "GARCH: beta1",
    gamma1 = "Asymmetry: gamma1",
    eta1 = "Asymmetry: eta1",
    delta = "Power: delta",
    shape = "Distribution: shape",
    skew = "Distribution: skew",
    .default = x
  )
}

bookvar_sig_stars <- function(p) {
  ifelse(
    is.na(p), "",
    ifelse(p < 0.01, "***", ifelse(p < 0.05, "**", ifelse(p < 0.10, "*", "")))
  )
}

bookvar_format_coef_cell <- function(fit, param) {
  if (is.null(fit)) {
    return("")
  }

  mat <- fit@fit$matcoef
  if (!(param %in% rownames(mat))) {
    return("")
  }

  estimate <- mat[param, 1]
  se <- mat[param, 2]
  p_value <- mat[param, 4]

  paste0(
    formatC(estimate, digits = 6, format = "f"),
    bookvar_sig_stars(p_value),
    " (", formatC(se, digits = 6, format = "f"), ")"
  )
}

bookvar_garch_journal_table <- function(model_fits) {
  preferred_order <- c(
    "mu", "ar1", "ma1", "omega", "alpha1", "beta1",
    "gamma1", "eta1", "delta", "shape", "skew"
  )

  available_params <- unique(unlist(lapply(model_fits, function(fit) {
    if (is.null(fit)) {
      return(character(0))
    }
    rownames(fit@fit$matcoef)
  })))

  params <- c(
    preferred_order[preferred_order %in% available_params],
    setdiff(available_params, preferred_order)
  )

  out <- data.frame(`Tham số` = bookvar_parameter_label(params), check.names = FALSE)

  for (model_name in names(model_fits)) {
    out[[bookvar_model_short_name(model_name)]] <- vapply(
      params,
      function(param) bookvar_format_coef_cell(model_fits[[model_name]], param),
      character(1)
    )
  }

  out
}

bookvar_ic_table <- function(fit, model_name = "Mô hình") {
  if (is.null(fit)) {
    return(data.frame(`Mô hình` = model_name, AIC = NA_real_, BIC = NA_real_, `Hannan-Quinn` = NA_real_, check.names = FALSE))
  }

  ic <- rugarch::infocriteria(fit)

  data.frame(
    `Mô hình` = model_name,
    AIC = round(as.numeric(ic["Akaike"]), 5),
    BIC = round(as.numeric(ic["Bayes"]), 5),
    `Hannan-Quinn` = round(as.numeric(ic["Hannan-Quinn"]), 5),
    check.names = FALSE
  )
}

bookvar_build_garch_ic_comparison <- function(model_fits) {
  do.call(
    rbind,
    lapply(names(model_fits), function(model_name) bookvar_ic_table(model_fits[[model_name]], model_name))
  )
}

bookvar_garch_persistence_row <- function(fit, model_name) {
  if (is.null(fit)) {
    return(data.frame(`Mô hình` = model_name, Persistence = NA_real_, `Half-life` = NA_real_, check.names = FALSE))
  }

  co <- stats::coef(fit)

  if ("alpha1" %in% names(co) && "beta1" %in% names(co)) {
    if ("gamma1" %in% names(co) && grepl("GJR", model_name)) {
      persistence <- as.numeric(co["alpha1"] + 0.5 * co["gamma1"] + co["beta1"])
    } else {
      persistence <- as.numeric(co["alpha1"] + co["beta1"])
    }
  } else {
    persistence <- NA_real_
  }

  half_life <- ifelse(
    is.finite(persistence) && persistence > 0 && persistence < 1,
    log(0.5) / log(persistence),
    NA_real_
  )

  data.frame(
    `Mô hình` = model_name,
    Persistence = round(persistence, 4),
    `Half-life` = round(half_life, 2),
    check.names = FALSE
  )
}

bookvar_build_garch_persistence_table <- function(model_fits) {
  do.call(
    rbind,
    lapply(names(model_fits), function(model_name) bookvar_garch_persistence_row(model_fits[[model_name]], model_name))
  )
}

bookvar_build_conditional_volatility_panel <- function(model_fits, dates) {
  pieces <- lapply(names(model_fits), function(model_name) {
    fit <- model_fits[[model_name]]
    if (is.null(fit)) {
      return(NULL)
    }

    data.frame(
      date = dates,
      model = model_name,
      volatility = as.numeric(rugarch::sigma(fit)),
      stringsAsFactors = FALSE
    )
  })

  pieces <- Filter(Negate(is.null), pieces)
  if (!length(pieces)) {
    return(data.frame())
  }

  do.call(rbind, pieces)
}

bookvar_build_news_impact_data <- function(fit_gjr_std, returns) {
  if (is.null(fit_gjr_std)) {
    return(NULL)
  }

  co_gjr <- stats::coef(fit_gjr_std)
  shock_grid <- seq(
    stats::quantile(returns, 0.01, na.rm = TRUE),
    stats::quantile(returns, 0.99, na.rm = TRUE),
    length.out = 300
  )

  sigma2_bar <- mean(rugarch::sigma(fit_gjr_std)^2, na.rm = TRUE)

  news_impact <- co_gjr["omega"] +
    co_gjr["alpha1"] * shock_grid^2 +
    co_gjr["gamma1"] * shock_grid^2 * (shock_grid < 0) +
    co_gjr["beta1"] * sigma2_bar

  data.frame(
    shock = shock_grid,
    next_variance = as.numeric(news_impact),
    next_volatility = sqrt(pmax(as.numeric(news_impact), 0)),
    stringsAsFactors = FALSE
  )
}

bookvar_make_garch_diagnostics_table <- function(fit, model_name) {
  if (is.null(fit)) {
    return(data.frame(`Mô hình` = model_name, `Kiểm định` = NA_character_, `Thống kê` = NA_real_, `p-value` = NA_real_, check.names = FALSE))
  }

  z <- as.numeric(stats::residuals(fit, standardize = TRUE))
  z <- z[is.finite(z)]

  tests <- list(
    "Ljung-Box trên z" = stats::Box.test(z, lag = 12, type = "Ljung-Box"),
    "Ljung-Box trên z^2" = stats::Box.test(z^2, lag = 12, type = "Ljung-Box"),
    "ARCH-LM trên z" = FinTS::ArchTest(z, lags = 12)
  )

  data.frame(
    `Mô hình` = model_name,
    `Kiểm định` = names(tests),
    `Thống kê` = round(vapply(tests, function(x) unname(x$statistic), numeric(1)), 3),
    `p-value` = signif(vapply(tests, function(x) x$p.value, numeric(1)), 4),
    check.names = FALSE
  )
}

bookvar_build_garch_diagnostics <- function(model_fits) {
  do.call(
    rbind,
    lapply(names(model_fits), function(model_name) bookvar_make_garch_diagnostics_table(model_fits[[model_name]], model_name))
  )
}

bookvar_compute_range_based_volatility <- function(vn_daily) {
  within(vn_daily, {
    log_hl <- log(high / low)
    log_co <- log(close / open)
    cc_var <- ret^2
    parkinson_var <- pmax((log_hl^2) / (4 * log(2)), 0)
    gk_var <- pmax(0.5 * log_hl^2 - (2 * log(2) - 1) * log_co^2, 0)
  })
}

bookvar_build_range_based_plot_data <- function(range_data, window = 20) {
  data.frame(
    date = rep(range_data$date, 3),
    method = rep(c("Close-to-close", "Parkinson", "Garman-Klass"), each = nrow(range_data)),
    volatility = c(
      sqrt(zoo::rollapplyr(range_data$cc_var, window, mean, fill = NA)),
      sqrt(zoo::rollapplyr(range_data$parkinson_var, window, mean, fill = NA)),
      sqrt(zoo::rollapplyr(range_data$gk_var, window, mean, fill = NA))
    ),
    stringsAsFactors = FALSE
  )
}

bookvar_build_volatility_measure_comparison <- function() {
  data.frame(
    `Nhóm thước đo` = c("Historical", "Rolling", "EWMA", "GARCH-type", "Range-based"),
    `Dữ liệu cần` = c("Close", "Close", "Close", "Close", "OHLC"),
    `Vai trò trong chương` = c("Benchmark", "Dynamic benchmark", "RiskMetrics benchmark", "Mô hình chính", "Proxy bổ sung"),
    check.names = FALSE
  )
}

bookvar_prepare_forecast_exercise <- function(returns, horizons = c(1, 5, 10, 20), forecast_step = 20, max_forecast_origins = 50, estimation_window = NULL) {
  estimation_window <- estimation_window %||% min(1250, max(750, floor(length(returns) * 0.55)))
  n_obs <- length(returns)
  max_h <- max(horizons)

  start_origin <- estimation_window
  end_origin <- n_obs - max_h
  forecast_origins <- seq(start_origin, end_origin, by = forecast_step)

  if (length(forecast_origins) > max_forecast_origins) {
    forecast_origins <- tail(forecast_origins, max_forecast_origins)
  }

  list(
    estimation_window = estimation_window,
    horizons = horizons,
    forecast_step = forecast_step,
    max_forecast_origins = max_forecast_origins,
    forecast_origins = forecast_origins
  )
}

bookvar_build_forecast_exercise_design <- function(spec) {
  data.frame(
    `Thành phần` = c(
      "Estimation window",
      "Forecast horizons",
      "Refit frequency",
      "Số forecast origins tối đa",
      "Proxy volatility thực tế",
      "Loss functions"
    ),
    `Thiết lập` = c(
      paste0(spec$estimation_window, " ngày giao dịch"),
      paste(spec$horizons, collapse = ", "),
      paste0("Mỗi ", spec$forecast_step, " ngày"),
      as.character(spec$max_forecast_origins),
      "Tổng bình phương return tương lai",
      "RMSE, MAE, QLIKE"
    ),
    check.names = FALSE
  )
}

bookvar_run_volatility_forecast_exercise <- function(returns, dates, spec) {
  horizons <- spec$horizons
  estimation_window <- spec$estimation_window
  forecast_origins <- spec$forecast_origins

  forecast_rows <- list()
  row_id <- 1L

  for (origin in forecast_origins) {
    train_index <- (origin - estimation_window + 1L):origin
    x_train <- returns[train_index]
    current_date <- dates[origin]

    var_roll_60 <- stats::var(utils::tail(x_train, 60), na.rm = TRUE)
    var_roll_120 <- stats::var(utils::tail(x_train, 120), na.rm = TRUE)
    var_ewma <- utils::tail(bookvar_ewma_vol(x_train, lambda = 0.94)^2, 1)

    for (h in horizons) {
      actual_var <- sum(returns[(origin + 1L):(origin + h)]^2, na.rm = TRUE)

      forecast_rows[[row_id]] <- data.frame(date = current_date, horizon = h, model = "Rolling 60", actual_var = actual_var, forecast_var = h * var_roll_60, stringsAsFactors = FALSE)
      row_id <- row_id + 1L
      forecast_rows[[row_id]] <- data.frame(date = current_date, horizon = h, model = "Rolling 120", actual_var = actual_var, forecast_var = h * var_roll_120, stringsAsFactors = FALSE)
      row_id <- row_id + 1L
      forecast_rows[[row_id]] <- data.frame(date = current_date, horizon = h, model = "EWMA 0.94", actual_var = actual_var, forecast_var = h * var_ewma, stringsAsFactors = FALSE)
      row_id <- row_id + 1L
    }

    fit_o_garch <- bookvar_fit_garch_safe(x_train, model = "sGARCH", dist = "std")
    fit_o_gjr <- bookvar_fit_garch_safe(x_train, model = "gjrGARCH", dist = "std")
    fit_o_egarch <- bookvar_fit_garch_safe(x_train, model = "eGARCH", dist = "std")

    forecast_model_list <- list(
      "GARCH-Student-t" = fit_o_garch,
      "GJR-GARCH-Student-t" = fit_o_gjr,
      "EGARCH-Student-t" = fit_o_egarch
    )

    for (model_name in names(forecast_model_list)) {
      fit_obj <- forecast_model_list[[model_name]]
      if (is.null(fit_obj)) {
        next
      }

      fc <- tryCatch(
        rugarch::ugarchforecast(fit_obj, n.ahead = max(horizons)),
        error = function(...) NULL
      )

      if (is.null(fc)) {
        next
      }

      sigma2_path <- as.numeric(rugarch::sigma(fc))^2

      for (h in horizons) {
        actual_var <- sum(returns[(origin + 1L):(origin + h)]^2, na.rm = TRUE)

        forecast_rows[[row_id]] <- data.frame(
          date = current_date,
          horizon = h,
          model = model_name,
          actual_var = actual_var,
          forecast_var = sum(sigma2_path[1:h], na.rm = TRUE),
          stringsAsFactors = FALSE
        )
        row_id <- row_id + 1L
      }
    }
  }

  if (!length(forecast_rows)) {
    return(data.frame())
  }

  out <- do.call(rbind, forecast_rows)
  out[is.finite(out$actual_var) & is.finite(out$forecast_var) & out$forecast_var > 0, , drop = FALSE]
}

bookvar_summarise_forecast_losses <- function(df_forecast_eval) {
  if (!nrow(df_forecast_eval)) {
    return(data.frame())
  }

  aggregate_df <- split(df_forecast_eval, list(df_forecast_eval$horizon, df_forecast_eval$model), drop = TRUE)

  rows <- lapply(aggregate_df, function(df_piece) {
    data.frame(
      horizon = df_piece$horizon[1],
      model = df_piece$model[1],
      RMSE = sqrt(mean((df_piece$forecast_var - df_piece$actual_var)^2, na.rm = TRUE)),
      MAE = mean(abs(df_piece$forecast_var - df_piece$actual_var), na.rm = TRUE),
      QLIKE = bookvar_qlike_loss(df_piece$actual_var, df_piece$forecast_var),
      stringsAsFactors = FALSE
    )
  })

  out <- do.call(rbind, rows)
  out[order(out$horizon, out$QLIKE), , drop = FALSE]
}

bookvar_make_metric_panel <- function(forecast_loss_raw, metric_name) {
  panel_data <- forecast_loss_raw[, c("model", "horizon", metric_name), drop = FALSE]
  names(panel_data)[3] <- "value"
  panel_data$horizon <- paste0("h = ", panel_data$horizon)
  panel_data$value <- ifelse(is.na(panel_data$value), "", formatC(panel_data$value, format = "e", digits = 3))
  tidyr::pivot_wider(panel_data, names_from = horizon, values_from = value)
}

bookvar_best_model_by_horizon <- function(forecast_loss_raw) {
  long_df <- tidyr::pivot_longer(
    forecast_loss_raw,
    cols = c("RMSE", "MAE", "QLIKE"),
    names_to = "metric",
    values_to = "value"
  )

  best_rows <- do.call(
    rbind,
    lapply(split(long_df, list(long_df$horizon, long_df$metric), drop = TRUE), function(df_piece) {
      df_piece[which.min(df_piece$value), , drop = FALSE]
    })
  )

  best_rows$horizon <- paste0("h = ", best_rows$horizon)
  tidyr::pivot_wider(best_rows[, c("horizon", "metric", "model")], names_from = metric, values_from = model)
}

bookvar_build_forecast_plot_data <- function(df_forecast_eval, plot_horizon = 1, selected_models = c("Rolling 60", "EWMA 0.94", "GARCH-Student-t", "GJR-GARCH-Student-t")) {
  forecast_plot_data <- subset(df_forecast_eval, horizon == plot_horizon & model %in% selected_models)

  actual_plot <- unique(data.frame(
    date = forecast_plot_data$date,
    model = "Proxy thực tế",
    volatility = sqrt(forecast_plot_data$actual_var),
    stringsAsFactors = FALSE
  ))

  forecast_plot <- data.frame(
    date = forecast_plot_data$date,
    model = forecast_plot_data$model,
    volatility = sqrt(forecast_plot_data$forecast_var),
    stringsAsFactors = FALSE
  )

  rbind(actual_plot, forecast_plot)
}

bookvar_build_multistep_forecast_data <- function(returns, estimation_window) {
  last_window <- utils::tail(returns, estimation_window)
  last_fit <- bookvar_fit_garch_safe(last_window, model = "sGARCH", dist = "std")

  if (is.null(last_fit)) {
    return(NULL)
  }

  last_fc <- rugarch::ugarchforecast(last_fit, n.ahead = 20)

  data.frame(
    horizon = 1:20,
    forecast_volatility = as.numeric(rugarch::sigma(last_fc)),
    stringsAsFactors = FALSE
  )
}
