ggplot = ggplot2::ggplot
aes = ggplot2::aes
geom_density = ggplot2::geom_density
facet_wrap = ggplot2::facet_wrap
labs = ggplot2::labs
glue = glue::glue
theme_bw = ggplot2::theme_bw

#' Draw 4 density plots of a numeric column from a data frame by 4 different scenarios
#'
#' @param col either "travelers" or "workers"; will draw density plots for either travelers breach or workers breach
#'
#' @return a ggplot2 object with geom density
#' @examples
#' draw_density_plots("travelers")
#'
#' @export

draw_density_plots = function(col) {
  if (col == "travelers") {
    p = ggplot(breach_events, aes(traveler_counts_pois))
  } else if (col == "workers") {
    p = ggplot(breach_events, aes(worker_counts_pois))
  } else {
    stop("Invalid input.")
  }

  p +
    geom_density(fill = "skyblue", alpha = 0.5, color = "steelblue") +
    facet_wrap(~ panel, scale = "free") +
    labs(title = glue("Histograms of {col} breach")) +
    theme_bw()
}
