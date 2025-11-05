
# eventBreachesCovid19

<!-- badges: start -->
<!-- badges: end -->

eventBreachesCovid19 helps simulate breach events scenarios from "COVID-19 in low-tolerance border quarantine systems: Impact of the Delta variant of SARS-CoV-2" with Poisson distribution and visualize them using histograms and density plots.

## Installation

You can install the development version of eventBreachesCovid19 from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("ETC5523-2025/assignment-4-packages-and-shiny-apps-HieuMark")
```

or

``` r
remotes::install_github("https://github.com/ETC5523-2025/assignment-4-packages-and-shiny-apps-HieuMark.git")
```

## Example

``` r
library(eventBreachesCovid19)

breach_events

draw_histograms("travelers")
draw_histograms("workers")
draw_density_plots("travelers")
draw_density_plots("workers")

run_shiny_app()
```

