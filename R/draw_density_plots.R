#' Draw 4 density plots of a numeric column from a data frame by 4 different scenarios
#'
#' @param col either "travelers" or "workers"; will draw density plots for either travelers breach or workers breach
#'
#' @return a ggplot2 object with geom density
#' @examples
#' draw_density_plots("travelers")
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_density theme_bw labs facet_wrap

draw_density_plots = function(col) {
  utils::data("breach_events", package = "eventBreachesCovid19", envir = environment())

  if (col == "travelers") {
    p = ggplot(breach_events, aes(traveler_counts_pois)) +
      labs(
        title = "Histograms of traveler breaches",
        x = "Traveler counts (Poisson-simulated)"
      )
  } else if (col == "workers") {
    p = ggplot(breach_events, aes(worker_counts_pois)) +
      labs(
        title = "Histograms of worker breaches",
        x = "Worker counts (Poisson-simulated)"
      )
  } else {
    stop("Invalid input.")
  }

  p +
    geom_density(fill = "skyblue", alpha = 0.5, color = "steelblue") +
    facet_wrap(~ panel, scales = "free") +
    theme_bw()
}
