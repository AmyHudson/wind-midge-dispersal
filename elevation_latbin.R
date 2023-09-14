# elevation of continent- for latitudinal binning
#install.packages("elevatr")
library(elevatr)

# install.packages("remotes")
remotes::install_github("wmgeolab/rgeoboundaries")


library(rgeoboundaries)
library(sf)
library(raster)
library(ggplot2)
library(viridis)

bbox <- sf::st_bbox(c(xmin = -124.50, ymin = 35.50, xmax = -92.75, ymax = 45.50),
                           crs = "+proj=longlat +datum=WGS84 +no_defs") #%>%
elevation_data <- elevatr::get_elev_raster(x = c(-124.5,-92.75), y = c(35.5,45.5))


elevation_data <- as.data.frame(elevation_data, xy = TRUE)
colnames(elevation_data)[3] <- "elevation"
# remove rows of data frame with one or more NA's,using complete.cases
elevation_data <- elevation_data[complete.cases(elevation_data), ]

ggplot() +
  geom_raster(data = elevation_data, aes(x = x, y = y, fill = elevation)) +
  geom_sf(data = swiss_bound, color = "white", fill = NA) +
  coord_sf() +
  scale_fill_viridis_c() +
  labs(title = "Elevation in Switzerland", x = "Longitude", y = "Latitude", fill = "Elevation (meters)")