#' Launch my shiny app
#'
#' @export
#' @importFrom shiny runApp
run_my_app <- function() {
  appDir <- system.file("shiny", package = "eventBreachesCovid19")
  shiny::runApp(appDir)
}
