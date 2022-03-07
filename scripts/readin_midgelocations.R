# read in locations of biting midge sampling

pts <- read.csv("data/midge_sampling_locations.csv")
pts <- pts[which(pts$Sonorensis_present == "Yes"),]

# forward trajectory modeling using splitr
# create a dataframe with June July August September, 6am 9pm, 

#devtools::install_github("rich-iannone/splitr")

library(splitr)
library(magrittr)
library(lubridate)
library(here)

hgt <- c(10,50,100,200)

trajectory_total <- data.frame()

for (i in 6:9){
  for (j in 1:4){

trajectory <-
  hysplit_trajectory(
    lat = pts$Lat,
    lon = pts$Long,
    height = j,
    duration = 24,
    days = seq(
      lubridate::ymd(paste("2018-",i,"-01", sep = "")),
      lubridate::ymd(paste("2018-",i,"-30", sep = "")),
      by = "2 day"
    ),
    daily_hours = c(6,21)
  )

trajectory$month <- month.name[i]
trajectory$maxhgt <- hgt[j]

trajectory_total <- rbind(trajectory_total,trajectory)

  }
}
# color by hour along- gradient fill continuous axis
write.csv(trajectory_total, "trajectory_total.csv", row.names = F)
#trajectory_color$hgt_color <- 

# calculate euclidean distance of furthest air parcels


library(mapview)
mapshot(trajectory_plot(trajectory), 
        file = "figures/midges_wind_24h_200m_September.png")
#orange to blue to pink advance in time

#https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.1206
#Particle release height was 50 m to simulate high-altitude insect dispersal, although the release height does not restrict the altitude to which particles may travel, either up or down, along their dispersal trajectories. Particles were allowed to travel for 15 h from a release time of 6:00 (approximate sunrise) until 21:00 (approximate sunset) to mimic the diurnal flying activity of adult wasps. Each trajectory was re-estimated every hour (Figure S1). Trajectories were modeled for departure from each of the study sites for each day in May every year beginning with the year colonization was detected at each site (total of 6014 days modeled at 23 sites; Table S4). 

#U-component wind zonal velocity horizontal wind from west
#V-component wind meridional velocity vertical wind from south

##################
# # doesn't work yet
# dispersion <- 
#   hysplit_dispersion(
#     lat = 49.263, 
#     lon = -123.25, 
#     height = 5,
#     duration = 24,
#     direction = "forward", met_type = "reanalysis", vert_motion = 0, species = 
#     model_height = 20000, particle_num = 2500, particle_max = 10000, clean_up = TRUE)
# 
# # trajectory <- 
# #   hysplit_trajectory(
# #     lat = 42.83752,
# #     lon = -80.30364,
# #     height = 50,
# #     duration = 24,
# #     run_period = "2012-03-12",
# #     daily_hours = c(0, 6, 12, 18),
# #     direction = "forward",
# #     met_type = "gdas1",
# #     extended_met = TRUE)  
# 
# trajectory_model <-
#   create_traj_model() %>%
#   add_grid(
#     lat = 49.0,
#     lon = -123.0,
#     range = c(0.8, 0.8),
#     division = c(0.2, 0.2)) %>%
#   add_params(
#     height = 50,
#     duration = 6,
#     run_period = "2015-07-01",
#     daily_hours = c(0, 12),
#     direction = "backward",
#     met_type = "reanalysis") %>%
#   run_model()
# 
# # Create the `dispersion_model` object, add
# # a grid of starting locations, add run
# # parameters, and then execute the model run
# dispersion_model <-
#   create_disp_model() %>%
#   add_emissions(
#     rate = 5,
#     duration = 6,
#     start_day = "2015-07-01",
#     start_hour = 0) %>%
#   add_species(
#     pdiam = 1,
#     density = 1,
#     shape_factor = 1) %>%
#   add_grid(
#     range = c(0.5, 0.5),
#     division = c(0.1, 0.1)) %>%
#   add_params(
#     lat = 49.0,
#     lon = -123.0,
#     height = 50,
#     duration = 24,
#     start_day = "2015-07-01",
#     start_hour = 0,
#     direction = "forward",
#     met_type = "reanalysis") %>%
#   run_model()
# 
# # dispersion_model()
# 
# # dispersion_model %>% dispersion_plot()