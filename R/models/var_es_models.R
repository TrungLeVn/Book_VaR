bookvar_sample_skewness <- function(x) {
  x <- stats::na.omit(x)
  if (length(x) < 3L) {
    return(NA_real_)
  }
  centered <- x - mean(x)
  mean(centered^3) / stats::sd(x)^3
}

bookvar_sample_excess_kurtosis <- function(x) {
  x <- stats::na.omit(x)
  if (length(x) < 4L) {
    return(NA_real_)
  }
  centered <- x - mean(x)
  mean(centered^4) / stats::sd(x)^4 - 3
}

bookvar_infer_t_df <- function(x, min_df = 5, max_df = 200) {
  excess_kurtosis <- bookvar_sample_excess_kurtosis(x)
  if (is.na(excess_kurtosis) || excess_kurtosis <= 0) {
    return(Inf)
  }

  df <- 6 / excess_kurtosis + 4
  max(min_df, min(max_df, df))
}

bookvar_std_t_q <- function(p, df) {
  stats::qt(p, df = df) * sqrt((df - 2) / df)
}

bookvar_std_t_left_mean <- function(alpha, df) {
  q_alpha <- stats::qt(alpha, df = df)
  scaling <- sqrt((df - 2) / df)
  -scaling * ((df + q_alpha^2) / ((df - 1) * alpha)) * stats::dt(q_alpha, df = df)
}

bookvar_historical_var_es <- function(losses, alpha = 0.01) {
  losses <- stats::na.omit(losses)
  if (!length(losses)) {
    return(list(var = NA_real_, es = NA_real_))
  }

  threshold <- as.numeric(stats::quantile(losses, probs = 1 - alpha, na.rm = TRUE, type = 7))
  tail_losses <- losses[losses >= threshold]

  list(
    var = threshold,
    es = mean(tail_losses, na.rm = TRUE)
  )
}

bookvar_parametric_var_es <- function(mu, sigma, alpha = 0.01, distribution = c("norm", "std"), df = NULL) {
  distribution <- match.arg(distribution)

  if (distribution == "norm") {
    z_alpha <- stats::qnorm(alpha)
    var_value <- -(mu + sigma * z_alpha)
    es_value <- -(mu - sigma * stats::dnorm(z_alpha) / alpha)
    return(list(var = var_value, es = es_value))
  }

  df <- df %||% 8
  q_alpha <- bookvar_std_t_q(alpha, df = df)
  var_value <- -(mu + sigma * q_alpha)
  es_value <- -(mu - sigma * bookvar_std_t_left_mean(alpha, df = df))
  list(var = var_value, es = es_value)
}

bookvar_rolling_historical_var_es <- function(losses, window = 500, alpha = 0.01) {
  n <- length(losses)
  output <- data.frame(index = seq_len(n), var = NA_real_, es = NA_real_)

  for (i in seq.int(window, n)) {
    estimates <- bookvar_historical_var_es(losses[(i - window + 1L):i], alpha = alpha)
    output$var[i] <- estimates$var
    output$es[i] <- estimates$es
  }

  output
}

bookvar_rolling_parametric_var_es <- function(returns, sigma, window = 500, alpha = 0.01, distribution = "norm") {
  n <- length(returns)
  output <- data.frame(index = seq_len(n), var = NA_real_, es = NA_real_)

  for (i in seq.int(window, n)) {
    mu_hat <- mean(returns[(i - window + 1L):i], na.rm = TRUE)
    sigma_hat <- sigma[i]
    if (is.na(sigma_hat)) {
      next
    }
    estimates <- bookvar_parametric_var_es(mu = mu_hat, sigma = sigma_hat, alpha = alpha, distribution = distribution)
    output$var[i] <- estimates$var
    output$es[i] <- estimates$es
  }

  output
}
