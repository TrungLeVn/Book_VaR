bookvar_resolve_exceed <- function(losses = NULL, var_series = NULL, exceed = NULL) {
  if (!is.null(exceed)) {
    exceed <- as.integer(exceed)
    exceed <- exceed[is.finite(exceed)]
    return(exceed)
  }

  if (is.null(losses) || is.null(var_series)) {
    stop("Provide either exceed or both losses and var_series.", call. = FALSE)
  }

  exceed <- as.integer(losses > var_series)
  exceed[is.finite(exceed)]
}

bookvar_kupiec_test <- function(losses = NULL, var_series = NULL, alpha = 0.01, exceed = NULL) {
  exceed <- bookvar_resolve_exceed(losses = losses, var_series = var_series, exceed = exceed)
  n <- length(exceed)
  x <- sum(exceed)

  if (n == 0L) {
    return(c(LRuc = NA_real_, p_value = NA_real_, phat = NA_real_))
  }

  phat <- x / n
  eps <- 1e-10
  phat_adj <- min(max(phat, eps), 1 - eps)
  alpha_adj <- min(max(alpha, eps), 1 - eps)

  ll_null <- x * log(alpha_adj) + (n - x) * log(1 - alpha_adj)
  ll_alt <- x * log(phat_adj) + (n - x) * log(1 - phat_adj)
  lr <- -2 * (ll_null - ll_alt)

  c(
    LRuc = lr,
    p_value = 1 - stats::pchisq(lr, df = 1),
    phat = phat
  )
}

bookvar_christoffersen_test <- function(losses = NULL, var_series = NULL, alpha = 0.01, exceed = NULL) {
  exceed <- bookvar_resolve_exceed(losses = losses, var_series = var_series, exceed = exceed)
  n <- length(exceed)

  if (n < 5L) {
    return(c(LRind = NA_real_, p_ind = NA_real_, LRcc = NA_real_, p_cc = NA_real_))
  }

  lagged <- exceed[-n]
  current <- exceed[-1L]

  n00 <- sum(lagged == 0 & current == 0)
  n01 <- sum(lagged == 0 & current == 1)
  n10 <- sum(lagged == 1 & current == 0)
  n11 <- sum(lagged == 1 & current == 1)

  eps <- 1e-10
  p01 <- n01 / max(n00 + n01, 1)
  p11 <- n11 / max(n10 + n11, 1)
  p <- (n01 + n11) / max(n00 + n01 + n10 + n11, 1)

  p01 <- min(max(p01, eps), 1 - eps)
  p11 <- min(max(p11, eps), 1 - eps)
  p <- min(max(p, eps), 1 - eps)

  ll_ind <- n00 * log(1 - p01) + n01 * log(p01) +
    n10 * log(1 - p11) + n11 * log(p11)
  ll_null <- (n00 + n10) * log(1 - p) + (n01 + n11) * log(p)
  lr_ind <- -2 * (ll_null - ll_ind)

  kup <- bookvar_kupiec_test(alpha = alpha, exceed = exceed)
  lr_cc <- kup["LRuc"] + lr_ind

  c(
    LRind = lr_ind,
    p_ind = 1 - stats::pchisq(lr_ind, df = 1),
    LRcc = lr_cc,
    p_cc = 1 - stats::pchisq(lr_cc, df = 2)
  )
}

bookvar_dq_test <- function(exceed, var_series, alpha, lags = 4) {
  exceed <- as.integer(exceed)
  dat <- data.frame(
    hit = exceed - alpha,
    var = as.numeric(scale(var_series))
  )

  for (j in seq_len(lags)) {
    dat[[paste0("hit_lag", j)]] <- dplyr::lag(dat$hit, j)
  }

  dat <- dat[stats::complete.cases(dat), , drop = FALSE]

  if (nrow(dat) < 50) {
    return(c(DQ = NA_real_, p_value = NA_real_))
  }

  rhs <- paste(c(paste0("hit_lag", seq_len(lags)), "var"), collapse = " + ")
  fml <- stats::as.formula(paste("hit ~", rhs))

  fit <- tryCatch(stats::lm(fml, data = dat), error = function(...) NULL)
  if (is.null(fit)) {
    return(c(DQ = NA_real_, p_value = NA_real_))
  }

  stat <- nrow(dat) * summary(fit)$r.squared
  df <- length(stats::coef(fit)) - 1

  c(
    DQ = stat,
    p_value = 1 - stats::pchisq(stat, df = df)
  )
}

bookvar_quantile_loss_return <- function(ret, var_loss, alpha) {
  q <- -var_loss
  hit <- as.integer(ret < q)
  (alpha - hit) * (ret - q)
}

bookvar_traffic_decision <- function(p_uc, p_cc, exceed_rate, alpha) {
  if (is.na(p_uc) || is.na(p_cc)) {
    return("Không đủ dữ liệu")
  }
  if (p_uc >= 0.05 && p_cc >= 0.05) {
    return("Không bác bỏ")
  }
  if (exceed_rate > alpha) {
    return("Bác bỏ: đánh giá thấp rủi ro")
  }
  "Bác bỏ: quá bảo thủ hoặc vi phạm phụ thuộc"
}

bookvar_build_eval_data <- function(all_forecasts, vn_daily, backtest_start) {
  merged <- merge(
    all_forecasts,
    vn_daily[, c("date", "ret", "loss"), drop = FALSE],
    by = "date",
    all.x = TRUE
  )

  merged <- merged[merged$date >= backtest_start & is.finite(merged$VaR) & is.finite(merged$loss), , drop = FALSE]
  merged$exceed <- merged$loss > merged$VaR
  merged$qloss <- bookvar_quantile_loss_return(merged$ret, merged$VaR, merged$alpha)
  merged
}

bookvar_build_backtesting_summary <- function(eval_data) {
  if (!nrow(eval_data)) {
    return(data.frame())
  }

  split_df <- split(eval_data, list(eval_data$model, eval_data$alpha, eval_data$alpha_label), drop = TRUE)

  rows <- lapply(split_df, function(df_piece) {
    exceed <- df_piece$exceed
    alpha <- df_piece$alpha[1]

    kupiec <- bookvar_kupiec_test(alpha = alpha, exceed = exceed)
    christoffersen <- bookvar_christoffersen_test(alpha = alpha, exceed = exceed)
    dq <- bookvar_dq_test(exceed = exceed, var_series = df_piece$VaR, alpha = alpha)
    exceed_rate <- mean(exceed, na.rm = TRUE)

    data.frame(
      model = df_piece$model[1],
      alpha = alpha,
      alpha_label = df_piece$alpha_label[1],
      n = nrow(df_piece),
      exceedances = sum(exceed, na.rm = TRUE),
      exceed_rate = exceed_rate,
      expected = alpha * nrow(df_piece),
      avg_qloss = mean(df_piece$qloss, na.rm = TRUE),
      kupiec_LR = kupiec["LRuc"],
      kupiec_p = kupiec["p_value"],
      christoffersen_LRcc = christoffersen["LRcc"],
      christoffersen_p = christoffersen["p_cc"],
      dq_stat = dq["DQ"],
      dq_p = dq["p_value"],
      decision = bookvar_traffic_decision(kupiec["p_value"], christoffersen["p_cc"], exceed_rate, alpha),
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}

bookvar_build_tail_severity_summary <- function(eval_data) {
  exceed_df <- eval_data[eval_data$exceed, , drop = FALSE]
  if (!nrow(exceed_df)) {
    return(data.frame())
  }

  split_df <- split(exceed_df, list(exceed_df$model, exceed_df$alpha, exceed_df$alpha_label), drop = TRUE)

  rows <- lapply(split_df, function(df_piece) {
    mean_es <- if (all(is.na(df_piece$ES))) NA_real_ else mean(df_piece$ES, na.rm = TRUE)

    data.frame(
      model = df_piece$model[1],
      alpha = df_piece$alpha[1],
      alpha_label = df_piece$alpha_label[1],
      exceedances = nrow(df_piece),
      mean_loss_when_exceed = mean(df_piece$loss, na.rm = TRUE),
      mean_var_when_exceed = mean(df_piece$VaR, na.rm = TRUE),
      mean_excess_loss = mean(df_piece$loss - df_piece$VaR, na.rm = TRUE),
      tail_loss_ratio = mean(df_piece$loss / df_piece$VaR, na.rm = TRUE),
      mean_es_when_available = mean_es,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, rows)
}
