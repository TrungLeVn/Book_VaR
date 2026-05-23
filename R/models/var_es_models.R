if (!exists("bookvar_sample_excess_kurtosis", mode = "function")) {
  stop("Source R/data/prepare_vnindex.R before sourcing R/models/var_es_models.R.", call. = FALSE)
}

bookvar_infer_t_df <- function(x) {
  ex_kurt <- bookvar_sample_excess_kurtosis(x)
  if (is.na(ex_kurt) || ex_kurt <= 0) {
    return(30)
  }

  df <- 4 + 6 / ex_kurt
  pmin(pmax(df, 5), 60)
}

bookvar_std_t_q <- function(alpha, df) {
  stats::qt(alpha, df = df) / sqrt(df / (df - 2))
}

bookvar_std_t_left_mean <- function(alpha, df) {
  q_raw <- stats::qt(alpha, df = df)
  scale_std <- sqrt(df / (df - 2))
  -((df + q_raw^2) / (df - 1)) * stats::dt(q_raw, df = df) / alpha / scale_std
}

bookvar_rolling_historical_var_es <- function(ret, dates, alpha, width) {
  n <- length(ret)
  var_out <- rep(NA_real_, n)
  es_out <- rep(NA_real_, n)

  for (i in (width + 1L):n) {
    window_returns <- ret[(i - width):(i - 1L)]
    q <- as.numeric(stats::quantile(window_returns, probs = alpha, na.rm = TRUE, type = 7))
    var_out[i] <- -q
    es_out[i] <- -mean(window_returns[window_returns <= q], na.rm = TRUE)
  }

  data.frame(
    date = dates,
    model = "Historical simulation",
    alpha = alpha,
    VaR = var_out,
    ES = es_out,
    stringsAsFactors = FALSE
  )
}

bookvar_rolling_parametric_var_es <- function(ret, dates, alpha, width, dist = c("normal", "student")) {
  dist <- match.arg(dist)
  n <- length(ret)
  var_out <- rep(NA_real_, n)
  es_out <- rep(NA_real_, n)
  df_out <- rep(NA_real_, n)

  for (i in (width + 1L):n) {
    window_returns <- ret[(i - width):(i - 1L)]
    mu <- mean(window_returns, na.rm = TRUE)
    sig <- stats::sd(window_returns, na.rm = TRUE)

    if (dist == "normal") {
      z <- stats::qnorm(alpha)
      var_out[i] <- -(mu + sig * z)
      es_out[i] <- -(mu - sig * stats::dnorm(z) / alpha)
      df_out[i] <- NA_real_
    } else {
      df <- bookvar_infer_t_df(window_returns)
      q_std <- bookvar_std_t_q(alpha, df)
      lm_std <- bookvar_std_t_left_mean(alpha, df)
      var_out[i] <- -(mu + sig * q_std)
      es_out[i] <- -(mu + sig * lm_std)
      df_out[i] <- df
    }
  }

  data.frame(
    date = dates,
    model = ifelse(dist == "normal", "Normal rolling", "Student-t rolling"),
    alpha = alpha,
    VaR = var_out,
    ES = es_out,
    df = df_out,
    stringsAsFactors = FALSE
  )
}

bookvar_ewma_sigma_forecast <- function(ret, width, lambda = 0.94) {
  n <- length(ret)
  sigma <- rep(NA_real_, n)
  sigma2 <- stats::var(ret[1:width], na.rm = TRUE)

  for (i in (width + 1L):n) {
    sigma2 <- lambda * sigma2 + (1 - lambda) * ret[i - 1L]^2
    sigma[i] <- sqrt(sigma2)
  }

  sigma
}

bookvar_rolling_ewma_var_es <- function(ret, dates, alpha, width, lambda = 0.94) {
  sigma <- bookvar_ewma_sigma_forecast(ret, width = width, lambda = lambda)
  mu <- zoo::rollapplyr(ret, width = width, FUN = mean, fill = NA)
  mu <- dplyr::lag(mu)
  z <- stats::qnorm(alpha)

  data.frame(
    date = dates,
    model = "EWMA-normal",
    alpha = alpha,
    VaR = -(mu + sigma * z),
    ES = -(mu - sigma * stats::dnorm(z) / alpha),
    stringsAsFactors = FALSE
  )
}

bookvar_make_var_garch_spec <- function(garch_model = "sGARCH", dist = "std") {
  rugarch::ugarchspec(
    variance.model = list(model = garch_model, garchOrder = c(1, 1)),
    mean.model = list(armaOrder = c(1, 0), include.mean = TRUE),
    distribution.model = dist
  )
}

bookvar_find_var_column <- function(column_names, alpha) {
  alpha_pct <- alpha * 100
  alpha_string_1 <- paste0(alpha_pct, "%")
  alpha_string_2 <- paste0(format(alpha_pct, trim = TRUE, scientific = FALSE), "%")
  var_cols <- grep("VaR", column_names, value = TRUE)

  if (length(var_cols) == 0L) {
    return(NA_character_)
  }

  hit <- var_cols[grepl(alpha_string_1, var_cols, fixed = TRUE)]
  if (length(hit)) {
    return(hit[1])
  }

  hit <- var_cols[grepl(alpha_string_2, var_cols, fixed = TRUE)]
  if (length(hit)) {
    return(hit[1])
  }

  var_cols[1]
}

bookvar_run_ugarchroll_var <- function(ret, dates, spec, model_label, width, refit_every, alpha_levels, run_garch_models = TRUE) {
  if (!isTRUE(run_garch_models)) {
    return(do.call(
      rbind,
      lapply(alpha_levels, function(alpha) {
        data.frame(date = dates, model = model_label, alpha = alpha, VaR = NA_real_, ES = NA_real_, stringsAsFactors = FALSE)
      })
    ))
  }

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
    error = function(e) {
      warning(paste("Không ước lượng được", model_label, ":", e$message))
      NULL
    }
  )

  if (is.null(roll_obj)) {
    return(do.call(
      rbind,
      lapply(alpha_levels, function(alpha) {
        data.frame(date = dates, model = model_label, alpha = alpha, VaR = NA_real_, ES = NA_real_, stringsAsFactors = FALSE)
      })
    ))
  }

  roll_df <- as.data.frame(roll_obj)
  out_dates <- utils::tail(dates, nrow(roll_df))

  do.call(
    rbind,
    lapply(alpha_levels, function(alpha) {
      var_col <- bookvar_find_var_column(names(roll_df), alpha)
      var_value <- if (is.na(var_col)) rep(NA_real_, nrow(roll_df)) else -as.numeric(roll_df[[var_col]])

      data.frame(
        date = out_dates,
        model = model_label,
        alpha = alpha,
        VaR = var_value,
        ES = NA_real_,
        stringsAsFactors = FALSE
      )
    })
  )
}

bookvar_rolling_quantile_regression_var <- function(vn_daily, alpha, width) {
  n <- nrow(vn_daily)
  var_out <- rep(NA_real_, n)

  for (i in (width + 1L):n) {
    window_df <- vn_daily[(i - width):(i - 1L), , drop = FALSE]
    window_df <- window_df[
      is.finite(window_df$ret) &
        is.finite(window_df$abs_ret_lag1) &
        is.finite(window_df$loss_lag1) &
        is.finite(window_df$ret_lag1),
      ,
      drop = FALSE
    ]

    newx <- vn_daily[i, , drop = FALSE]

    if (nrow(window_df) < width * 0.8 || any(!is.finite(c(newx$abs_ret_lag1, newx$loss_lag1, newx$ret_lag1)))) {
      next
    }

    fit <- tryCatch(
      quantreg::rq(ret ~ abs_ret_lag1 + loss_lag1 + ret_lag1, tau = alpha, data = window_df),
      error = function(...) NULL
    )

    if (!is.null(fit)) {
      q_pred <- tryCatch(as.numeric(stats::predict(fit, newdata = newx)), error = function(...) NA_real_)
      var_out[i] <- -q_pred
    }
  }

  data.frame(
    date = vn_daily$date,
    model = "Quantile regression",
    alpha = alpha,
    VaR = var_out,
    ES = NA_real_,
    stringsAsFactors = FALSE
  )
}

bookvar_fit_gpd_mle <- function(excess) {
  excess <- excess[is.finite(excess) & excess > 0]
  if (length(excess) < 30L) {
    return(NULL)
  }

  neg_ll <- function(par) {
    beta <- exp(par[1])
    xi <- par[2]

    if (!is.finite(beta) || beta <= 0 || !is.finite(xi) || xi <= -0.5 || xi >= 1) {
      return(1e12)
    }

    z <- 1 + xi * excess / beta
    if (any(z <= 0)) {
      return(1e12)
    }

    if (abs(xi) < 1e-6) {
      ll <- -length(excess) * log(beta) - sum(excess) / beta
    } else {
      ll <- -length(excess) * log(beta) - (1 / xi + 1) * sum(log(z))
    }

    -ll
  }

  fit <- tryCatch(
    stats::optim(
      par = c(log(mean(excess)), 0.1),
      fn = neg_ll,
      method = "L-BFGS-B",
      lower = c(log(1e-6), -0.49),
      upper = c(log(max(excess) * 100), 0.95)
    ),
    error = function(...) NULL
  )

  if (is.null(fit) || fit$convergence != 0) {
    return(NULL)
  }

  list(beta = exp(fit$par[1]), xi = fit$par[2])
}

bookvar_gpd_var_es <- function(loss_window, alpha, threshold_prob = 0.90) {
  loss_window <- loss_window[is.finite(loss_window)]
  n <- length(loss_window)
  if (n < 100L) {
    return(c(VaR = NA_real_, ES = NA_real_))
  }

  u <- as.numeric(stats::quantile(loss_window, probs = threshold_prob, na.rm = TRUE, type = 7))
  exceed <- loss_window[loss_window > u] - u
  nu <- length(exceed)

  if (nu < 30L) {
    return(c(VaR = NA_real_, ES = NA_real_))
  }

  fit <- bookvar_fit_gpd_mle(exceed)
  if (is.null(fit)) {
    return(c(VaR = NA_real_, ES = NA_real_))
  }

  beta <- fit$beta
  xi <- fit$xi
  tail_prob <- nu / n

  if (alpha >= tail_prob) {
    return(c(VaR = NA_real_, ES = NA_real_))
  }

  if (abs(xi) < 1e-6) {
    var_value <- u + beta * log(tail_prob / alpha)
  } else {
    var_value <- u + (beta / xi) * ((tail_prob / alpha)^xi - 1)
  }

  if (xi < 1) {
    es_value <- var_value + (beta + xi * (var_value - u)) / (1 - xi)
  } else {
    es_value <- NA_real_
  }

  c(VaR = var_value, ES = es_value)
}

bookvar_rolling_evt_pot_var_es <- function(loss, dates, alpha, width, threshold_prob = 0.90) {
  n <- length(loss)
  var_out <- rep(NA_real_, n)
  es_out <- rep(NA_real_, n)

  for (i in (width + 1L):n) {
    window_loss <- loss[(i - width):(i - 1L)]
    out <- bookvar_gpd_var_es(window_loss, alpha = alpha, threshold_prob = threshold_prob)
    var_out[i] <- out["VaR"]
    es_out[i] <- out["ES"]
  }

  data.frame(
    date = dates,
    model = "EVT-POT",
    alpha = alpha,
    VaR = var_out,
    ES = es_out,
    stringsAsFactors = FALSE
  )
}
