# read in locations of biting midge sampling

pts <- read.csv("data/midge_sampling_locations.csv")

# plot on a map and add date of collection

# two approaches- dispersal modeling and backwards trajectory modeling

devtools::install_github("rich-iannone/splitr", force = TRUE)

library(splitr)
library(lubridate)
library(here)

trajectory <- 
  hysplit_trajectory(
    lat = 42.83752,
    lon = -80.30364,
    height = 50,
    duration = 24,
    days = "2012-03-12",
    daily_hours = c(0, 6, 12, 18),
    direction = "forward",
    met_type = "gdas1",
    extended_met = TRUE,
    met_dir = here::here("met"),
    exec_dir = here::here("out")
  ) 

# Create the `dispersion_model` object, add
# a grid of starting locations, add run
# parameters, and then execute the model run
dispersion_model <-
  create_dispersion_model() %>%
  add_source(
    name = "particle",
    lat = 49.0, lon = -123.0, height = 50,
    rate = 5, pdiam = 15, density = 1.5, shape_factor = 0.8,
    release_start = lubridate::ymd_hm("2015-07-01 00:00"),
    release_end = lubridate::ymd_hm("2015-07-01 00:00") + lubridate::hours(2)
  ) %>%
  add_dispersion_params(
    start_time = lubridate::ymd_hm("2015-07-01 00:00"),
    end_time = lubridate::ymd_hm("2015-07-01 00:00") + lubridate::hours(6),
    direction = "forward", 
    met_type = "reanalysis",
    met_dir = here::here("met"),
    exec_dir = here::here("out")
  ) %>%
  run_model()

# dispersion_model()

# dispersion_model %>% dispersion_plot()