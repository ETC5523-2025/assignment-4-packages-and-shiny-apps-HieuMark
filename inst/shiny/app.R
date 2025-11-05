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
library(plotly)

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
            tabPanel("Plots", plotlyOutput("distPlot", height = "600px"), downloadButton("download_plot", "Download Plot")),
            tabPanel("Data", tabsetPanel(
              tabPanel("Panel A", DTOutput("table_A"), downloadButton("download_csv_A", "Download CSV")),
              tabPanel("Panel B", DTOutput("table_B"), downloadButton("download_csv_B", "Download CSV")),
              tabPanel("Panel C", DTOutput("table_C"), downloadButton("download_csv_C", "Download CSV")),
              tabPanel("Panel D", DTOutput("table_D"), downloadButton("download_csv_D", "Download CSV"))
            ))
          )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlotly({
        if (input$plot_geom == "histogram") { # draws histograms with the specified number of bins
          eventBreachesCovid19::draw_histograms(input$people, bins = input$bins) |>
            ggplotly() |> layout(margin = list(b = 50))
        } else { # draw density plots
          eventBreachesCovid19::draw_density_plots(input$people) |>
            ggplotly() |> layout(margin = list(b = 50))
        }
    })

    output$download_plot = downloadHandler(
      function() paste0(input$plot_geom, "_", input$people, "_", Sys.Date(), ".png"),
      function(f) ggplot2::ggsave(f, device = "png")
    )

    lapply(c("A", "B", "C", "D"), function(p) {
      panel_df = eventBreachesCovid19::breach_events |> dplyr::filter(panel == p)

      output[[paste0("table_", p)]] = renderDT({panel_df})

      output[[paste0("download_csv_", p)]] = downloadHandler(
        function() paste0("panel_", p, "_", Sys.Date(), ".csv"),
        function(f) readr::write_csv(panel_df, f)
      )
    })
}

# Run the application
shinyApp(ui = ui, server = server)
