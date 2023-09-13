# create a map showing where the zonal wind was calculated

# load in US/ or NA map with states
library(tidyverse)
library(sf)
library(USAboundaries)
library(ggthemes)
library(cowplot)

USAboundaries::us_states()
# Geodetic CRS:  WGS 84

# zonal averaging region box


usmap <- us_states() %>%
  st_transform(st_crs("WGS84"))

# sampling points to map
source("scripts/readin_midgelocations.R")

samploc <- pts %>%
  st_as_sf(coords = c("Long","Lat"),
           crs = st_crs("WGS84")) 

zonalpoly <- st_as_sfc()

lat <- c(35.50, 45.50)
lon <- c(-124.50,-92.75)
poly <- data.frame(lon,lat)

poly <-  poly %>% 
  st_as_sf(coords = c("lon", "lat"), 
           crs = "WGS84") %>% 
  st_bbox() %>% 
  st_as_sfc()

## map CONUS and zonal averaging region
ggplot() +
  geom_sf(size = 0.1,
          data=usmap %>%
            filter(!(state_abbr %in% c('AK',"HI","PR")))) +
  geom_sf(fill = 'orange',
          color = NA,
          size = 0.25,
          alpha = 0.4,
          lwd = 0,
          data = poly) +
  geom_sf(data = samploc)+
  theme_nothing() +
  theme(#panel.background = element_rect(fill='transparent', size = 0.1), #transparent panel bg
        plot.background = element_rect(fill='transparent', color=NA) #transparent plot bg
  )

ggsave('figures/mapinsert.pdf',
       bg='transparent',
       units = c("in"),
       width = 4,
       height = 4,
       dpi = 300)


