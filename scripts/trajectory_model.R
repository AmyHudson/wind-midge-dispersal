# add scale bar to maps
# https://stackoverflow.com/questions/63459419/add-a-scale-bar-to-a-ggplot-map-that-has-been-scaled-using-coord-sf

source("scripts/readin_midgelocations.R")

# forward trajectory modeling using splitr
# should consider using GDAS1 or  


#devtools::install_github("rich-iannone/splitr")

library(splitr)
library(magrittr)
library(lubridate)
library(here)
library(mapview)


hgt <- c(10,50,100,200) #m above ground level

trajectory_total <- data.frame()

for (i in 6:9){ #month
  for (j in 1:4){ #height
    
    trajectory <-
      hysplit_trajectory(
        lat = pts$Lat,
        lon = pts$Long,
        height = hgt[j],#j
        duration = 24,
        days = seq(
          lubridate::ymd(paste("2018-",i,"-01", sep = "")),
          lubridate::ymd(paste("2018-",i,"-30", sep = "")),
          by = "2 day"
        ),
        daily_hours = c(6,21), #play with this C(4,5,6,7,19,20,21,22)
        direction = "backward", #forward
        met_type = "reanalysis",
        extended_met = TRUE
      )
    
    trajectory$month <- month.name[i]#i
    trajectory$maxhgt <- hgt[j]#j
    
    mapshot(trajectory_plot(trajectory), 
            file = paste("figures/trajectory_backward_24h_2018", hgt[j],"m_",month.name[i],".pdf", sep = ""))
    #orange to blue to pink advance in time
    
    trajectory_total <- rbind(trajectory_total,trajectory)
    
  }
}

# color by hour along- gradient fill continuous axis


library(mapview)

#https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.1206
#Particle release height was 50 m to simulate high-altitude insect dispersal, although the release height does not restrict the altitude to which particles may travel, either up or down, along their dispersal trajectories. Particles were allowed to travel for 15 h from a release time of 6:00 (approximate sunrise) until 21:00 (approximate sunset) to mimic the diurnal flying activity of adult wasps. Each trajectory was re-estimated every hour (Figure S1). Trajectories were modeled for departure from each of the study sites for each day in May every year beginning with the year colonization was detected at each site (total of 6014 days modeled at 23 sites; Table S4). 

#U-component wind zonal velocity horizontal wind from west
#V-component wind meridional velocity vertical wind from south


# calculate euclidean distance of furthest air parcels
# by month? by height? for each run, what is the maximum lat lon distance from lat_i lon_i 
library(raster)

trajectory_total$eucdistm <- NA

for(i in 1:dim(trajectory_total)[1]){
  trajectory_total$eucdistm[i] <- pointDistance(
    c(trajectory_total$lon[i], trajectory_total$lat[i]),
    c(trajectory_total$lon_i[i], trajectory_total$lat_i[i]),
    lonlat = T)
}

trajectory_total$month <- factor(trajectory_total$month, levels = c("June", "July", "August", "September"))
#trajectory_total$month <- as.numeric(format(as.Date(trajectory_total$traj_dt), "%m"))
aggregate(trajectory_total$eucdistm, 
          by = as.data.frame(trajectory_total$month), 
          FUN = max)

# add temperature of parcel
# add wind speed?
# what is the height measured at?

#write.csv(trajectory_total, "data/trajectory_total.csv", row.names = F)
write.csv(trajectory_total, "data/trajectory_total_backward.csv", row.names = F)

trajectory_total <- read.csv("data/trajectory_total_backward.csv") %>%
  group_by(run, receptor) %>%
  mutate(lonend = lag(lon),
         latend = lag(lat))

trajectory_plot(trajectory_total[which(trajectory_total$month == "June" &
                                         trajectory_total$maxhgt == 10),])

library(ggplot2)
trajectory_total %>%
  group_by(run, receptor) %>%
  ggplot()+
  geom_segment(aes(x = lon, y = lat))

library(maps)
ggplot(trajectory_total, aes(lon, lat)) +
  geom_segment(aes(xend = lonend, yend = latend),
               arrow = arrow(length = unit(0.1,"cm"))) +
  borders("state")

library(cowplot)
plot_grid(p1)
