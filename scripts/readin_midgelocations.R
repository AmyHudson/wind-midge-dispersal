# read in locations of biting midge sampling
 
pts <- read.csv("data/midge_sampling_locations.csv")
pts <- pts[which(pts$Sonorensis_present == "Yes"),]
