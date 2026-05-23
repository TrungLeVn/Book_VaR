bookvar_rolling_sd <- function(x, window = 20, scale = sqrt(252)) {
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

bookvar_ewma_variance <- function(x, lambda = 0.94, initial_variance = NULL) {
  n <- length(x)
  variance <- rep(NA_real_, n)

  if (is.null(initial_variance)) {
    initial_variance <- stats::var(x, na.rm = TRUE)
  }

  variance[1] <- initial_variance

  for (i in 2:n) {
    variance[i] <- lambda * variance[i - 1L] + (1 - lambda) * x[i - 1L]^2
  }

  variance
}

bookvar_ewma_sd <- function(x, lambda = 0.94, scale = sqrt(252)) {
  sqrt(bookvar_ewma_variance(x, lambda = lambda)) * scale
}

bookvar_half_life <- function(lambda) {
  log(0.5) / log(lambda)
}

bookvar_qlike_loss <- function(realized, forecast_variance) {
  realized / forecast_variance - log(realized / forecast_variance) - 1
}

bookvar_make_garch_spec <- function(variance_model = "sGARCH", distribution_model = "std", arma_order = c(0, 0)) {
  if (!requireNamespace("rugarch", quietly = TRUE)) {
    stop("Package 'rugarch' is required for GARCH specifications.", call. = FALSE)
  }

  rugarch::ugarchspec(
    variance.model = list(model = variance_model, garchOrder = c(1, 1)),
    mean.model = list(armaOrder = arma_order, include.mean = TRUE),
    distribution.model = distribution_model
  )
}

bookvar_fit_garch_safe <- function(x, spec = bookvar_make_garch_spec(), solver = "hybrid") {
  tryCatch(
    rugarch::ugarchfit(spec = spec, data = x, solver = solver),
    error = function(e) structure(list(error = conditionMessage(e)), class = "bookvar_garch_error")
  )
}

bookvar_is_garch_fit <- function(x) {
  inherits(x, "uGARCHfit")
}

bookvar_garch_persistence <- function(fit) {
  if (!bookvar_is_garch_fit(fit)) {
    return(NA_real_)
  }

  coef_names <- names(stats::coef(fit))
  alpha_names <- grep("^alpha", coef_names, value = TRUE)
  beta_names <- grep("^beta", coef_names, value = TRUE)

  sum(stats::coef(fit)[c(alpha_names, beta_names)], na.rm = TRUE)
}

bookvar_garch_half_life <- function(fit) {
  persistence <- bookvar_garch_persistence(fit)
  if (is.na(persistence) || persistence <= 0 || persistence >= 1) {
    return(NA_real_)
  }
  log(0.5) / log(persistence)
}

bookvar_forecast_garch_safe <- function(fit, n_ahead = 1) {
  if (!bookvar_is_garch_fit(fit)) {
    return(NULL)
  }

  tryCatch(
    rugarch::ugarchforecast(fit, n.ahead = n_ahead),
    error = function(...) NULL
  )
}
