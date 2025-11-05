#' Launch ashiny app that allows users to interact with histograms, density plots, and data tables
#'
#' @export
#' @importFrom shiny runApp
run_shiny_app <- function() {
  appDir <- system.file("shiny", package = "eventBreachesCovid19")
  shiny::runApp(appDir)
}
