# 1000 hPa is the pressure at sea level; 750hPa is ~2500m above sea level
# The Rockies are ~4,400m peaks

# # read in era5
# downloaded from https://cds.climate.copernicus.eu/cdsapp#!/yourrequests?tab=form
# 3/2/2022
library(sf)
library(ncdf4)
library(tidyverse)

#open the connection with the ncdf file
#nc <- nc_open("data/adaptor.mars.internal-1646256800.0525954-7935-9-37dc997a-7031-4f3b-99fa-5f76da152b49.nc")
nc <- nc_open("data/adaptor.mars.internal-1694639513.6101391-15122-20-f8076b88-2d3b-4092-87d4-217cd8aca5a4.nc")


#extract lon and lat
lat <- ncvar_get(nc,'latitude')
lon <- ncvar_get(nc,'longitude')
lev1 <- ncvar_get(nc,'level')
dim(lat);dim(lon)

#extract the time
t <- ncvar_get(nc, "time")

#time unit: hours since 1900-01-01
ncatt_get(nc,'time')

#convert the hours into date + hour
#as_datetime() function of the lubridate package needs seconds
timestamp <- as_datetime(c(t*60*60),origin="1900-01-01")

#import the data
data <- ncvar_get(nc,"u")

#close the conection with the ncdf file
nc_close(nc)


###############
# crop bounding box further
# 6am July
# average across years and then across latitudes
# subset by 
# plot: y-axis: atmosphere level, x-axis: longitudes, color: u-wind speed 

#utod <- c(4,5,6,7,17,18,19,20,21)
utod <- c(7)



#tod <- rep(c(4,5,6,7,17,18,19,20,21),12*10)
tod <- rep(c(7),12*10)

#mo <- rep(rep(1:12,each = 9),10)
#yr <- rep(2010:2019, each = 12*9)
mo <- rep(rep(1:12,each = 1),10)
yr <- rep(2010:2019, each = 12*1)

pd_total = data.frame()


for (k in 1:12){
  #for (j in 1:9){
  for (j in 1){
    
d1 <- data[which(lon >= -124.50 & lon <= -92.75),
           which(lat >= 35.50 & lat <= 45.50),
           ,
           which(mo == k & tod == utod[j])]

lon <- lon[which(lon >= -124.50 & lon <= -92.75)]
lat <- lat[which(lat >= 35.50 & lat <= 45.50)]

weights <- cos(lat*pi/180)
#rw <- d1*weights #need to permute and change dimensions 41*everything
#s <- stack(weights,)
#zonal(d1,)

# average across 10 years
d2 <- rowMeans(d1, dims = length(dim(d1))-1)

# zonally average wind speed across latitudes
d3 <- aperm(d2,c(3,1,2)) #now level, longitude, latitude
library(matrixStats)
d6 <- aperm(d2,c(2,3,1))
dim(d6)<- c(41,16*128)
#d7 <- as.matrix(as.data.frame(matrix(d6,nrow = 41, ncol = 16*128)))
#class(d7)
# this requires a matrix input but I could only feed it a class of "matrix" "array"
#d7 <- colWeightedMeans(d7,w = weights) 
#inherits(d7, "matrix")

#weighted.mean(d7[,1], weights)
#apply(data = d7,
#      FUN= weighted.mean(x, w = weights), 
#      MARGIN = 2)

d8 <- matrix(NA,nrow = 1,ncol = 16*128)
for (i in 1:(16*128)){
  d8[,i] <- weighted.mean(d6[,i], weights)
}
dim(d8)<- c(16,128)

#d4 <- rowMeans(d3, dims = length(dim(d3))-1)
d5 <- as.data.frame(d8)
colnames(d5) <- lon
d5$lev <- lev1
pd <- pivot_longer(d5,cols = 1:128,values_to = "uwndSpeed", names_to = "lon")
pd$lon <- as.numeric(pd$lon)
pd$facet <- rep(month.abb[k],dim(pd)[1]) #rep(paste(month.name[k],utod[j]),dim(pd)[1])

pd_total <- rbind(pd_total,pd)


  }
}


#double check dimension changes
#widen bins
# remove x axis/ Longitude binned
# 7 AM u windspeed zonal average (blue means blowing )
# California migration of insects at end of summer?

library(ggplot2)
library(hrbrthemes)
pd_total <- pd_total %>%
  mutate(facet = as.factor(facet),
         lev = as.factor(lev)) #, levels = as.character(rev(lev1))


#png("figures/era5uwndclimatology.png",
#    width = 8, height = 11, units = "in", 
#    pointsize = 10, res = 600)

ggplot(pd_total, aes(lon, lev, fill= uwndSpeed)) + 
  geom_tile() +
  #ylim(750, 1000) +
  scale_y_discrete(limits=rev, name = "hPa")+
  #scale_y_reverse(expand = c(0, 0), name = "hPa"#,sec.axis = sec_axis(name="m")
  #)+
  scale_fill_distiller(palette = "RdBu", limit = c(-4,4), oob = scales::oob_squish,
                       guide = my_triangle_colourbar()) +
  #scale_x_continuous(guide = guide_axis(angle = 90),expand = c(0, 0))+
  #ggtitle(paste(month.name[k],utod[j]))+
  theme_classic()+
  labs(fill='Average\nU-wind\nSpeed\n(m/s)') +
  facet_wrap(~ factor(facet, levels=month.abb))

ggsave('figures/era5uwndclimatology7am.pdf',
       width = 6,
       height = 6,
       units = "in")

#dev.off()
###############
## add triangle legend?
library(ggplot2)
library(gtable)
library(grid)

my_triangle_colourbar <- function(...) {
  guide <- guide_colourbar(...)
  class(guide) <- c("my_triangle_colourbar", class(guide))
  guide
}

guide_gengrob.my_triangle_colourbar <- function(...) {
  # First draw normal colourbar
  guide <- NextMethod()
  # Extract bar / colours
  is_bar <- grep("^bar$", guide$layout$name)
  bar <- guide$grobs[[is_bar]]
  extremes <- c(bar$raster[1], bar$raster[length(bar$raster)])
  # Extract size
  width  <- guide$widths[guide$layout$l[is_bar]]
  height <- guide$heights[guide$layout$t[is_bar]]
  short  <- min(convertUnit(width, "cm",  valueOnly = TRUE),
                convertUnit(height, "cm", valueOnly = TRUE))
  # Make space for triangles
  guide <- gtable_add_rows(guide, unit(short, "cm"),
                           guide$layout$t[is_bar] - 1)
  guide <- gtable_add_rows(guide, unit(short, "cm"),
                           guide$layout$t[is_bar])
  
  # Draw triangles
  top <- polygonGrob(
    x = unit(c(0, 0.5, 1), "npc"),
    y = unit(c(0, 1, 0), "npc"),
    gp = gpar(fill = extremes[1], col = NA)
  )
  bottom <- polygonGrob(
    x = unit(c(0, 0.5, 1), "npc"),
    y = unit(c(1, 0, 1), "npc"),
    gp = gpar(fill = extremes[2], col = NA)
  )
  # Add triangles to guide
  guide <- gtable_add_grob(
    guide, top, 
    t = guide$layout$t[is_bar] - 1,
    l = guide$layout$l[is_bar]
  )
  guide <- gtable_add_grob(
    guide, bottom,
    t = guide$layout$t[is_bar] + 1,
    l = guide$layout$l[is_bar]
  )
  
  return(guide)
}


###############
# API script I should try sometime...


# import cdsapi
# 
# c = cdsapi.Client()
# 
# c.retrieve(
#   'reanalysis-era5-pressure-levels-monthly-means',
#   {
#     'format': 'netcdf',
#     'product_type': 'monthly_averaged_reanalysis_by_hour_of_day',
#     'variable': 'u_component_of_wind',
#     'pressure_level': [
#       '750', '775', '800',
#       '825', '850', '875',
#       '900', '925', '950',
#       '975', '1000',
#     ],
#     'year': [
#       '2010', '2011', '2012',
#       '2013', '2014', '2015',
#       '2016', '2017', '2018',
#       '2019',
#     ],
#     'month': [
#       '01', '02', '03',
#       '04', '05', '06',
#       '07', '08', '09',
#       '10', '11', '12',
#     ],
#     'time': [
#       '05:00', '06:00', '07:00',
#       '17:00', '18:00', '19:00',
#       '20:00', '21:00',
#     ],
#     'area': [
#       60, -130, 20,
#       -60,
#     ],
#   },
#   'download.nc')