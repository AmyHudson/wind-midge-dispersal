# read in locations of biting midge sampling
library(dplyr)

pts <- read.csv("data/midge_sampling_locations.csv")
pts <- pts[which(pts$Sonorensis_present == "Yes"),]

ratesCA <- read.csv("data/California_sonorensis_population.csv") %>%
  mutate(Start_Date = as.Date(Start_Date, format = "%m/%d/%Y"),
         massperhour = num.of.mides.collected/(24*.05)) %>% #5% of total emissions; daily converted to hourly;mass unit of 1midge = 0.00025 to 0.00057g 
  select(c(Start_Date,massperhour)) 

#but how big is the grid cell for reanalysis product and how does this point scale across space
#assume even distribution across space
