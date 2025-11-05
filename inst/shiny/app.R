#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Simulated breach events distributions"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
          radioButtons("plot_geom", "Plot type",
                       choices = c("Histogram" = "histogram", "Density" = "density"),
                       selected = "histogram"),

          conditionalPanel(
            "input.plot_geom === 'histogram'",
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
          ),

          radioButtons("people", "Travelers or Workers?",
                       choices = c("Travelers" = "travelers", "Workers" = "workers"),
                       selected = "travelers")
        ),

        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(
            tabPanel("Plots", plotOutput("distPlot", height = "600px"), downloadButton("download_plot", "Download Plot")),
            tabPanel("Data", tabsetPanel(
              tabPanel("Panel A", DTOutput("table_A")),
              tabPanel("Panel B", DTOutput("table_B")),
              tabPanel("Panel C", DTOutput("table_C")),
              tabPanel("Panel D", DTOutput("table_D"))
            ))
          )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        if (input$plot_geom == "histogram") { # draws histograms with the specified number of bins
          eventBreachesCovid19::draw_histograms(input$people, bins = input$bins)
        } else { # draw density plots
          eventBreachesCovid19::draw_density_plots(input$people)
        }
    })

    output$download_plot = downloadHandler(
      function() paste0(input$plot_geom, "_", input$people, "_", Sys.Date(), ".png"),
      function(f) ggplot2::ggsave(f, device = "png")
    )

    lapply(c("A", "B", "C", "D"), function(p) {
      output[[paste0("table_", p)]] = renderDT({
        eventBreachesCovid19::breach_events |>
          dplyr::filter(panel == p)
      })
    })
}

# Run the application
shinyApp(ui = ui, server = server)
