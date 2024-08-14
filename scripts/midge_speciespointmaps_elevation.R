#default zoom is 5; 7 looks better


library(dplyr)
library(readxl)
df <- read_excel("data/Final_gps_Lexi_is_great.xlsx") %>%
  select(!Comma)

#################
## Elevation 
#################
library(elevatr)

# find elevation (m), longterm ppt (cm/y)
df_elev_aws <- get_elev_point(df[,c(5,4)], prj = 4326, src = "aws", 
                              z = 7, #7 ~1km resolution https://github.com/tilezen/joerd/blob/master/docs/data-sources.md#what-is-the-ground-resolution
                              override_size_check = TRUE)
df_elev_aws$elevation

#ground_resolution = (cos(latitude * pi/180) * 2 * pi * 6378137 meters) / (256 * 2^zoom_level pixels)
ground_resolution <- (cos(df$Lat * pi/180) * 2 * pi * 6378137) / (256 * 2^7)

df <- cbind(df,df_elev_aws$elevation, ground_resolution)
colnames(df) <- c("Species","Source_a","Source_b","Lat","Long","Elevation_m", "GroundResolution_m")

write.csv(df, "data/Final_gps_elevation.csv")

library(ggplot2)

ggplot(data = df, aes(x = Elevation_m, fill = Species)) + 
  geom_histogram(colour = 'white') +
  theme_bw()

#################
## Maps
#################

#OpenStreetMap standard; google terrain ggmap
# drop Source_b
# each species has own map
# color as Source_a
# make new column for shape

# unique(Species)

species <- unique(df$Species)
i <- 1

for (i in 1:length(species)){
  df1 <- df %>%
    mutate(shape = case_when(Source_a == "Literature" ~ "notype",
                             Source_a == "Museum" ~ "notype",
                             Source_a == "Type" ~ "type")) %>%
    select(!Source_b) %>%
    filter(Species == species[i])
  # "literature" or "museum" can be circles, but different colors. 
  # The "type" will need to be a different shape.
  
  bbbox <- make_bbox(lon = c( min(df1$Long)-2, max(df1$Long)+2), 
                     lat = c(min(df1$Lat)-2, max(df1$Lat)+2))
  
  library(ggmap) 
  library(ggsn)
  library(ggrepel)
  
  register_stadiamaps("8b77a48c-66a3-4f4c-8f34-07a1c44b3c6d") 
  # helpful instruction tutorial https://www.youtube.com/watch?v=ewYGC2JjKuE
  #register_google("AIzaSyAEbdLjUuRcWXpAkmCXiFOzPpoOU2lScPE")
  
  
  bmap <- get_map(location = bbbox, source = "stadia", maptype = "stamen_terrain_background", zoom = 7)
  
  #bmap <- get_map(location = bbbox, source = "google", maptype = "terrain")#, color = "bw")
  
  #ggmap(bmap,zoom = 10)
  #ggmap(bmap, darken = c(0.5, "white"))
  
  #qmplot(x = Long, y = Lat, data = df1, source = "stadia", maptype = "stamen_terrain_background", 
  #       geom = "point", color = Source_a, shape = shape, zoom = 7)
  
  ggmap(bmap) +
    geom_point(df1, mapping = aes(x = Long, y = Lat,
                                  color = Source_a,
                                  #fill = Source_a,
                                  shape = shape),
               size = 2) +
    scale_color_manual(name = '', values = c(
      'Literature' = "navy",
      'Museum' = "firebrick2",
      'Type' = "black")) +
    scale_shape_manual(name = '', values = c(
      'notype' = 16,
      'type' = 17)) +
    # scale_fill_manual(name = '', values = c(
    #   'Literature' = "goldenrod",
    #   'Museum' = "cadetblue",
    #   'Type' = "navy")) +
    # scale_shape_manual(name = '', values = c(
    #   'notype' = 21,
    #   'type' = 24)) +
    labs(size=NULL)+
    ggtitle(species[i]) +
    #guides(fill=guide_legend(override.aes=list(colour=c(
    #  'Literature' = "goldenrod",
    #  'Museum' = "cadetblue",
    #  'Type' = "navy")))) +
    theme_bw() +
    theme(axis.title.x = element_blank(),
          axis.title.y = element_blank(),
          legend.title=element_blank()
    ) 
  
  ggsave(paste("figures/species/", species[i],".pdf", sep = ""),
         dpi = 600,
         width = 7,
         height = 8,
         units = c("in"))
}

