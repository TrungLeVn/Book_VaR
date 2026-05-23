bookvar_format_number <- function(x, digits = 3, big_mark = ",") {
  ifelse(
    is.na(x),
    NA_character_,
    formatC(x, digits = digits, format = "f", big.mark = big_mark)
  )
}

bookvar_format_percent <- function(x, digits = 2) {
  paste0(bookvar_format_number(100 * x, digits = digits), "%")
}

bookvar_format_p_value <- function(x, digits = 3, threshold = 0.001) {
  ifelse(
    is.na(x),
    NA_character_,
    ifelse(x < threshold, paste0("< ", format(threshold, nsmall = digits)), format(round(x, digits), nsmall = digits))
  )
}

bookvar_format_date_vi <- function(x, format = "%d/%m/%Y") {
  if (inherits(x, "character")) {
    x <- as.Date(x)
  }
  ifelse(is.na(x), NA_character_, format(x, format))
}

bookvar_label_confidence <- function(level) {
  paste0("Muc tin cay ", bookvar_format_percent(level, digits = 0))
}

bookvar_label_horizon <- function(h) {
  ifelse(h == 1, "1 ngay", paste(h, "ngay"))
}
