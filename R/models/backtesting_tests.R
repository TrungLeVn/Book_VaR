bookvar_kupiec_test <- function(losses, var_series, alpha = 0.01) {
  exceed <- losses > var_series
  exceed <- exceed[is.finite(exceed)]
  n <- length(exceed)
  x <- sum(exceed)

  if (n == 0L || x == 0L || x == n) {
    return(list(lr = NA_real_, p_value = NA_real_, exceedances = x, observations = n))
  }

  pi_hat <- x / n
  lr <- -2 * (
    (n - x) * log((1 - alpha) / (1 - pi_hat)) +
      x * log(alpha / pi_hat)
  )

  list(
    lr = lr,
    p_value = 1 - stats::pchisq(lr, df = 1),
    exceedances = x,
    observations = n
  )
}

bookvar_christoffersen_test <- function(losses, var_series) {
  exceed <- as.integer(losses > var_series)
  exceed <- exceed[is.finite(exceed)]

  if (length(exceed) < 2L) {
    return(list(lr = NA_real_, p_value = NA_real_))
  }

  lagged <- exceed[-length(exceed)]
  current <- exceed[-1L]

  n00 <- sum(lagged == 0 & current == 0)
  n01 <- sum(lagged == 0 & current == 1)
  n10 <- sum(lagged == 1 & current == 0)
  n11 <- sum(lagged == 1 & current == 1)

  pi0 <- if ((n00 + n01) > 0) n01 / (n00 + n01) else 0
  pi1 <- if ((n10 + n11) > 0) n11 / (n10 + n11) else 0
  pi_hat <- (n01 + n11) / (n00 + n01 + n10 + n11)

  eps <- 1e-10
  lr <- -2 * (
    n00 * log((1 - pi_hat + eps) / (1 - pi0 + eps)) +
      n01 * log((pi_hat + eps) / (pi0 + eps)) +
      n10 * log((1 - pi_hat + eps) / (1 - pi1 + eps)) +
      n11 * log((pi_hat + eps) / (pi1 + eps))
  )

  list(
    lr = lr,
    p_value = 1 - stats::pchisq(lr, df = 1),
    transition_counts = c(n00 = n00, n01 = n01, n10 = n10, n11 = n11)
  )
}

bookvar_dq_test <- function(losses, var_series, alpha = 0.01, lags = 4L) {
  hit <- as.numeric(losses > var_series) - alpha
  valid <- is.finite(hit) & is.finite(var_series)
  hit <- hit[valid]
  var_series <- var_series[valid]

  if (length(hit) <= lags + 1L) {
    return(list(statistic = NA_real_, p_value = NA_real_))
  }

  y <- hit[(lags + 1L):length(hit)]
  x <- cbind(1, var_series[(lags + 1L):length(var_series)])

  for (lag in seq_len(lags)) {
    x <- cbind(x, hit[(lags + 1L - lag):(length(hit) - lag)])
  }

  fit <- stats::lm.fit(x = x, y = y)
  fitted <- as.vector(x %*% fit$coefficients)
  residuals <- y - fitted
  r_squared <- 1 - sum(residuals^2) / sum((y - mean(y))^2)
  statistic <- length(y) * r_squared

  list(
    statistic = statistic,
    p_value = 1 - stats::pchisq(statistic, df = ncol(x))
  )
}

bookvar_quantile_loss <- function(losses, var_series, alpha = 0.01) {
  (alpha - as.numeric(losses < var_series)) * (losses - var_series)
}

bookvar_tail_severity_summary <- function(losses, var_series, es_series = NULL) {
  exceed <- losses > var_series
  exceed_losses <- losses[exceed]
  exceed_var <- var_series[exceed]

  out <- list(
    exceedance_count = sum(exceed, na.rm = TRUE),
    mean_exceedance = if (length(exceed_losses)) mean(exceed_losses - exceed_var, na.rm = TRUE) else NA_real_,
    max_exceedance = if (length(exceed_losses)) max(exceed_losses - exceed_var, na.rm = TRUE) else NA_real_
  )

  if (!is.null(es_series)) {
    exceed_es <- es_series[exceed]
    out$mean_es_gap <- if (length(exceed_losses)) mean(exceed_losses - exceed_es, na.rm = TRUE) else NA_real_
  }

  out
}
