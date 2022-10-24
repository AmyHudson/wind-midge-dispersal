# have trajectories; working on whether dispersal modeling would be better

#devtools::install_github("rich-iannone/splitr")

library(splitr)
library(lubridate)
library(here)
#################
# Create the `dispersion_model` object, add
# a grid of starting locations, add run
# parameters, and then execute the model run
dispersion_model <-
  create_dispersion_model() %>%
  add_source(
    name = "particle",
    lat = 49.0, lon = -123.0, height = 50,
    rate = 5, pdiam = 1000, density = 1.5, shape_factor = 0.8,
    release_start = lubridate::ymd_hm("2018-07-01 00:00"),
    release_end = lubridate::ymd_hm("2018-07-01 00:00") + lubridate::hours(2)
  ) %>%
  add_dispersion_params(
    start_time = lubridate::ymd_hm("2018-07-01 00:00"),
    end_time = lubridate::ymd_hm("2018-07-01 00:00") + lubridate::hours(6),
    direction = "forward", 
    met_type = "reanalysis"#,
    #met_dir = here::here("met"),
    #exec_dir = here::here("out")
  ) %>%
  run_model()

# Get a tibble containing the model results
dispersion_tbl <- dispersion_model %>% get_output_tbl()

# Plot particle data onto a map
dispersion_model %>% dispersion_plot()

#################
# doesn't work yet
dispersion <-
  hysplit_dispersion(
    lat = 49.263,
    lon = -123.25,
    height = 5,
    duration = 24,
    direction = "forward", met_type = "reanalysis", vert_motion = 0, #species =
    model_height = 20000, particle_num = 2500, particle_max = 10000, clean_up = TRUE)

hysplit_dispersion_define("species")

# Create the `dispersion_model` object, add
# a grid of starting locations, add run
# parameters, and then execute the model run
dispersion_model <-
  create_disp_model() %>%
  add_emissions(
    rate = 5,
    duration = 6,
    start_day = "2015-07-01",
    start_hour = 0) %>%
  add_species(
    pdiam = 1,
    density = 1,
    shape_factor = 1) %>%
  add_grid(
    range = c(0.5, 0.5),
    division = c(0.1, 0.1)) %>%
  add_params(
    lat = 49.0,
    lon = -123.0,
    height = 50,
    duration = 24,
    start_day = "2015-07-01",
    start_hour = 0,
    direction = "forward",
    met_type = "reanalysis") %>%
  run_model()

# dispersion_model()

# dispersion_model %>% dispersion_plot()