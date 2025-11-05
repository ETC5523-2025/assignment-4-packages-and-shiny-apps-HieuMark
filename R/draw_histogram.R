#' Draw 4 histogram of a numeric column from a data frame by 4 different scenarios
#'
#' @param col either "travelers" or "workers"; will draw histograms for either travelers breach or workers breach
#' @param bins Number of bins for the histogram (default value is 30)
#'
#' @return a ggplot2 object with geom histogram
#' @examples
#' draw_histograms("travelers")
#'
#' @export
#' @importFrom ggplot2 ggplot aes geom_histogram theme_bw labs facet_wrap

draw_histograms = function(col, bins = 30) {
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
    geom_histogram(bins = bins, fill = "steelblue", color = "skyblue") +
    facet_wrap(~ panel, scales = "free") +
    theme_bw()
}
