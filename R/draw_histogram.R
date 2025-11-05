ggplot = ggplot2:::ggplot
aes = ggplot2:::aes
geom_histogram = ggplot2:::geom_histogram
facet_wrap = ggplot2:::facet_wrap
labs = ggplot2:::labs
theme_bw = ggplot2:::theme_bw

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

draw_histograms = function(col, bins = 30) {
  data("breach_events", package = "eventBreachesCovid19", envir = environment())

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
