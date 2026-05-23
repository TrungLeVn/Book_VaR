bookvar_base_family <- "Arial"

bookvar_palette <- function() {
  c(
    primary = "#1F4E79",
    secondary = "#9A3D2E",
    accent = "#3C6E71",
    neutral = "#6C757D",
    light = "#E9ECEF"
  )
}

theme_bookvar <- function(base_size = 11, base_family = bookvar_base_family) {
  if (!requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'ggplot2' is required for theme_bookvar().", call. = FALSE)
  }

  palette <- bookvar_palette()

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", colour = palette[["primary"]]),
      plot.subtitle = ggplot2::element_text(colour = palette[["neutral"]]),
      axis.title = ggplot2::element_text(face = "bold"),
      panel.grid.minor = ggplot2::element_blank(),
      panel.grid.major.x = ggplot2::element_blank(),
      legend.position = "bottom",
      legend.title = ggplot2::element_text(face = "bold")
    )
}

bookvar_scale_y_percent <- function(...) {
  if (!requireNamespace("scales", quietly = TRUE)) {
    stop("Package 'scales' is required for bookvar_scale_y_percent().", call. = FALSE)
  }

  ggplot2::scale_y_continuous(labels = scales::label_percent(accuracy = 0.1), ...)
}
