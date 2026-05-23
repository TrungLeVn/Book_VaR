bookvar_round_numeric_df <- function(data, digits = 3) {
  numeric_cols <- vapply(data, is.numeric, logical(1))
  data[numeric_cols] <- lapply(data[numeric_cols], round, digits = digits)
  data
}

bookvar_table_column_order <- function(data, columns) {
  keep <- intersect(columns, names(data))
  data[keep]
}

bookvar_kable <- function(data, caption = NULL, digits = NULL, align = NULL, col.names = NULL, ...) {
  if (!requireNamespace("knitr", quietly = TRUE)) {
    stop("Package 'knitr' is required for bookvar_kable().", call. = FALSE)
  }

  knitr::kable(
    data,
    caption = caption,
    digits = digits,
    align = align,
    col.names = col.names,
    booktabs = TRUE,
    longtable = FALSE,
    ...
  )
}
