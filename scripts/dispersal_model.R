#NOT RUNNING DEFAULT SCRIPT 3/23- try another default script??

# Dispersal modeling at California site based on derived parameter distributions

# Default model parameters and explanations: This run has been set to be modeled for 6 h. The starting location of 49.0ºN and 123.0ºW is set using lat = 49.0 and lon = -123.0; the starting height of 50 m above ground level is set by height = 50. The meteorological options include the type of met data to use (global NCEP Reanalysis data is used here with met_type = "reanalysis).

# A single emissions species is set to be emitted (using add_source()) for 2 hours at an emission rate of 5 mass units per hour (rate = 5). 
# Emissions begin at the same time as the start of the model (release_start = lubridate::ymd_hm("2015-07-01 00:00")). 
# particle diameter (in micrometers), 
# density (in grams per cubic centimeter) 
# shape factor (value from 0 to 1)

#From Phillip
#Attached is the collection data and GPS coordinates for the 3-year population study in California.
#Also the sonorensis paper lists the mean weight of an unfed midge to be 0.2501 + 0.058 (range: 0.14 - 0.37)
    #which sonorensis paper?


#devtools::install_github("rich-iannone/splitr")

library(splitr)
library(lubridate)
library(here)
library(magrittr)
library(mapview)
#################
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
    #met_dir = here::here("met"),
    #exec_dir = here::here("out")
  ) %>%
  run_model()

#################
# rate of XX mass units per hour

# density (in grams per cubic centimeter) 

# shape factor (value from 0 to 1)
# Female sonorensis are ~3mm long x 0.5 mm wide x 0.5 mm tall.
# A shape factor is designed to prevent the creation of irregularly shaped lots by providing a measurement to evaluate the compactness and degree of regularity of the shape of a lot. 
# Shape factor (SF) is the non-dimensional ratio of the lot perimeter (P) squared, divided by the lot area (A), where P and A are derived from the same unit of measurement. 
# SF = (P^2/A)
# 3mm x 0.5mm x 0.5mm 

# ddep_mw molecular weight in units of g/mol
# unfed females: 0.00025 g 
# blood fed: 0.00057 g
# 50% water (18.01528 g/mol) + 50%(15% chitin (203.1925 g/mol)+ protein + fat)





dispersion_model <-
  create_dispersion_model() %>%
  add_source(
    name = "particle",
    lat = 34.0, lon = -117.5, height = 10,
    #rate = 5, pdiam = 15, density = 1.5, shape_factor = 0.8,
    release_start = lubridate::ymd_hm("2018-09-10 17:00"),
    release_end = lubridate::ymd_hm("2018-09-10 17:00") + lubridate::hours(1)
  ) %>%
  add_dispersion_params(
    start_time = lubridate::ymd_hm("2018-09-10 17:00"),
    end_time = lubridate::ymd_hm("2018-09-10 17:00") + lubridate::hours(2),
    direction = "forward", 
    met_type = "nam12",
  ) %>%
  run_model()

# Get a tibble containing the model results
dispersion_tbl <- dispersion_model %>% get_output_tbl()

# Plot particle data onto a map
p <- dispersion_model %>% dispersion_plot()

#remotes::install_github("r-spatial/mapview")
mapviewOptions(fgb = FALSE)
remotes::install_github('rstudio/rmarkdown')
library(mapview)
mapshot(p, 
        file = "figures/dispersion.png")

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