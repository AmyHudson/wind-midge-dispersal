# Anywhere the wind blows: exploring the physical wind dispersal of insects #

Here we explore the potential for the wind dispersal of insects (biting midges in particular) with applications in disease ecology. This includes 1) describing the [backwards wind trajectories](#backwards-wind-trajectories) leading up to an anomalous expansion of Vesicular Stomatitis to Kansas in 2020, and 2) describing the climatology of [wind dispersal](#wind-dispersal-climatology-from-sampled-vector-locations) events in locations where we have collected different biting midge species. We leverage the HYSPLIT model through the [splitr](https://rdocumentation.org/packages/SplitR/versions/0.4) package for these analyses.

## Backwards wind trajectories ##

VS infection was reported on June 1 in Kansas. We examined the backwards wind trajectories (from the NCEP reanalysis product) for 6-20 days before the reported VS occurance to account for both a delay in reporting as well as time for an infected vector to bite the animal and the animal to show symptoms. 05/12 (light trajectories) to 05/26 (dark) where every node is the air parcel location every 2 hours up to 120 hours (5 days). We also subset the temperature ≥ 10 °C. We explored at different heights in the atmosphere as identified by previous literature (some based on finding insects at that height).

Sellers and Maarouf, 1990 *Epidemiology and Infection* (100-2500m)
Sanders et al., 2011 *Veterinary Record* (170-200m)
Hendrickx et al. 2008 *Preventive Veterinary Medicine* (850mb- 6hrs)

We found it was most likely that the Kansas expansion, if dispersed by wind, was from the Texas or New Mexico regions based on the prevailing winds and locations where there may have been enough infected insect vectors. 

![](/figures/vs_wind_2020.png)

Future Directions:
Would be valuable to see the infected premises as a layer on this map? Or, more accurately, large enough populations of viable insect vectors? It would also be good to take surface climate into consideration and masking out paths- we know cold fronts can indicate the riding and dropping of these air parcels with 

References:
Sellers and Maarouf, 1990 *Epidemiology and Infection* (VSV);
Sellers and Maarouf, 1991 *Canadian journal of veterinary research* (Blue tongue);
Eagles et al., 2014 *BMC Veterinary Research* (Blue tongue Culicoides dispersal + trajectories HYSPLIT)
Burgin et al., 2012 *Transboundary and Emerging Diseases* (Blue tongue Culicoides dispersal + trajectories)
Bishop et al., 2000 *Preventive Veterinary Medicine* (Blue tongue Culicoides dispersal + trajectories other models)

## Wind dispersal climatology from sampled vector locations ##

Biting midges are a known vector of VS and some sampling sites have multiple *Culicoides* species present at different abundances. *Culicoides sonorensis* has a pretty wide distribution as environmental generalists in the United States, and their genetic makeup is similar enough to suggest that these populations travel large distances frequently. 

We begin by taking the sampling locations and modeling potential dispersal in summer months (when insects are most active and abundant) over the sampling date period (1980-2020?) at different heights in the atmosphere and different time window aggregates, to generate wind dispersal climatology and determine through which pathways these populations interact. 

### Other Notes ###
Active flight paired with passive dispersal; 
Handrick et al. 2008 found that there was no long range spread over distances of 300-400km at 850mb.Elevation and terrain roughness can cause air turbulence and drop down of Culicoides and restrict spread. 
Monsoonal winds (Baker et al. 1990 Simulium spp)
Braverman and Chechik, 1996
