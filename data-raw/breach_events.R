## code to prepare `breach_events` dataset
set.seed(1)

breach_events = lapply(
  list.files("data-raw/synth_data/", ".csv", full.names = TRUE),
  function(f_path) {
    readr::read_csv(f_path) |>
      dplyr::mutate(
        panel = substr(f_path, 21, 21),
        traveler_counts_pois = rpois(dplyr::n(), mean(traveler_counts, na.rm = TRUE)),
        worker_counts_pois = rpois(dplyr::n(), mean(worker_counts, na.rm = TRUE))
      ) |>
      dplyr::select(-c(traveler_counts, worker_counts))
  }
) |>
  dplyr::bind_rows()

usethis::use_data(breach_events, overwrite = TRUE)
