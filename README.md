# Any way the wind blows: exploring the physical wind dispersal of insects #

Here we explore the potential for the wind dispersal of insects (biting midges in particular) with applications in disease ecology. This includes 1) describing the climatology of [wind dispersal](#wind-dispersal-climatology-from-sampled-vector-locations) events in locations where we have collected different biting midge species and 2) describing the [backwards wind trajectories](#backwards-wind-trajectories) leading up to an anomalous expansion of Vesicular Stomatitis to Kansas in 2020. We leverage the HYSPLIT model through the [splitr](https://rdocumentation.org/packages/SplitR/versions/0.4) package for these analyses, which defaults to the NCEP/NCAR reanalysis product. I also brought in the ERA5 reanalysis product.

## Wind dispersal climatology from sampled biting midge locations ##

*Culicoides sonorensis* are a known vector of VS and other livestock diseases such as Epizootic Hemorrhagic Disease and Blue Tongue. Some sampling sites have multiple *Culicoides* species present at different abundances. *Culicoides sonorensis* has a pretty wide distribution as environmental generalists in the United States, and their genetic makeup is similar enough to suggest that these populations travel large distances frequently (Shults et al. 2022 *Scientific Reports*). 

We begin by taking cross-continental sampling locations of *Culicoides sonorensis* and modeling potential forward trajectories of air parcels in summer months (when insects are most active and abundant) at different heights in the atmosphere and different time window aggregates, to explore whether wind could be assisting interactions between geographically diverse populations at these known locations. For the summer months (June-September) in 2018 we explored trajectories where the midges would be in flight at 6am and 9pm, in the air for 3, 6, 12, and 24 hours, and at heights of 10m, 50m, 100m, and 200m. *These are starting heights- the parcels can travel much higher, so may need to constrain.* Temperature is likely the main height constraint and what drives the large variability we see in the observational record of finding midges in the air- there is no temperature output in the splitr package, but I could potentially convert the known height and pressure of the air parcel to temperature, or bring in a temperature data product.

### September 2018 trajectories, where midges fly up to 200m and their location up to 24hrs later ###
![](/figures/midges_wind_24h_200m_September.png)

The wind distributions generally match with a novel, MaxEnt-derived spacies distribution model of *C. sonorensis* developed by Melanie and Brian, which we can add here as a baselayer, with observed locations plotted.

All of these runs are now stored in trajectory_total.csv file which we can use for visualizing (need to go beyond default package plot). I've also included a new column 'eucdistm' which measures the euclidean distance in meters from each start point to the progressive movement of the parcel. We can see how maximum distance varies e.g. from month to month. The longer distances usually correspond to time stamps furthest from the initial point (24h) and heighest in the atmosphere (200m).

```{r include = T}
aggregate(trajectory_total$eucdistm, 
          by = as.data.frame(trajectory_total$month), 
          FUN = max)
```
| Month | Euclidean Distance (m) |
| ----- | ------------------ |
| June | 813,595 |
| July | 644,141 |
| August | 835,745 |
| September | 707,243 |

*Are there times of year where wind could help move midges west to east, or east to west?
How do the times of day influence those wind assists?*

Using another reanalysis product (ERA-5, 1979-present, global) we examined  the climatology of zonal wind (U component, east/west movement) over the period of 2010-2019 for -124.50E to -92.75E and 35.50N to 45.50N. I’ve averaged across years and then zonally averaged the windspeed across latitude grids to show how, as we move across longitudes at different points in the atmosphere, this is what zonal wind looks like. Y axis is atmosphere levels, surface (1000hPa) to ~2500 meters above sea level (750hPa). Rows are months and columns are times of day from 4am to 9pm.
The Rockies are around 4,000m at peaks (at around -110E) but Saunders et al. 1990 mention midges being found at max of 3,500m, after which it would likely be too cold. Air parcels could flow around these mountain peaks. 
Blues indicate wind moving from east to west, reds indicate wind moving west to east, and magnitude is windspeed (m/s).
Midges could potentially be mixing west and east with seasonal winds flowing west (blue shades) at the surface (e.g. in late spring, early summer), and then easily moving east if getting high enough up in atmosphere in nearly every month. 

![](/figures/era5uwndclimatology.png)


*How would variability influence spread?*
The white coloring in the above figure may indicate that there is high variability in wind direction over the 10 year time period here. For example, September 2018 had a lot more wind moving west than other years. That variability may promote cross-continental dispersal.
![](/figures/10m_uwnd_201809.jpg)
 

**References and notes:**

Observations of *Culicoides* at different atmospheric heights:
* [Sanders et al., 2011 *Veterinary Record*](https://bvajournals.onlinelibrary.wiley.com/doi/epdf/10.1136/vr.d4245) (170-200m observed from a blimp in the UK; multiple *Culicoides* species; highest density at dusk 21:00-22:00)
  * [Glick 1939 *USDA technical report*](https://naldc.nal.usda.gov/download/CAT86200667/PDF) The distribution of insects, spiders, and mites in the air. (airplane)
  * Hardy and Cheng 1986 *Ecological Entomology* Studies in the distribution of insects by aerial currents: 3. Insect drift over the sea. 
  * Johansen et al. 2003 *Medical and Veterinary Entomology* Collection of wind-borne haematophagous insects in the Torres Strait, Australia.
  
Studies examining wind dispersed *Culicoides* and other insects:
* [Sellers and Maarouf, 1990 *Epidemiology and Infection*](https://pubmed.ncbi.nlm.nih.gov/2157606/) (*Culicoides* warm enough temperatures recorded at 2,500-3,500m of 10C; they examined 100-2,500m trajectories for Vesicular stomatitis spread)
* Hendrickx et al. 2008 *Preventive Veterinary Medicine* (850mb (1,170m - 1,590m)- 6hrs)
* [Lander et al. 2014 *Ecology and Evolution*](https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.1206) (50m; 15hrs; 6am and 9pm (diurnal pattern)- wasps)
* Sellers and Maarouf, 1991 *Canadian journal of veterinary research* (Examined wind driven midge trajectories towards modeling Blue tongue spread);
* Eagles et al., 2014 *BMC Veterinary Research* (Blue tongue Culicoides dispersal + trajectories HYSPLIT)
* Burgin et al., 2012 *Transboundary and Emerging Diseases* (Blue tongue Culicoides dispersal + trajectories)
* Bishop et al., 2000 *Preventive Veterinary Medicine* (Blue tongue Culicoides dispersal + trajectories other models)
* Review by Lee W. Cohnstaedt and Mark G. Ruder 2013- check refs. Biting midge movement and implications for EHD transmission: How far can a midge travel?

*Where and when are these observational studies conducted? Is there a pattern of warmer temperatures (e.g. near the equator/ summer) corresponding with higher abundance of midges higher in the atmosphere? Are there thresholds to those heights that may also incorporate a change in midge behavior?*

*Most projected species distribution models of insects only focus on habitat suitability... could we also incorporate projected changes in dispersal that correspond with atmospheric warming throughout the column and wind patterns? Do we know enough about how midges would respond behaviorally to these changes?*

## Backwards wind trajectories ##

VS infection was reported on June 1 in Kansas. We examined the backwards wind trajectories (from the NCEP reanalysis product) for 6-20 days before the reported VS occurance to account for both a delay in reporting as well as time for an infected vector to bite the animal and the animal to show symptoms. 05/12 (light trajectories) to 05/26 (dark) where every node is the air parcel location every 2 hours up to 120 hours (5 days). We also subset the temperature ≥ 10 °C. We explored at different heights in the atmosphere as identified by previous literature (some based on finding insects at that height).

We found it was most likely that the Kansas expansion, if dispersed by wind, was from the Texas or New Mexico regions based on the prevailing winds and locations where there may have been enough infected insect vectors. We could also examine lower heights- in 2019 there was a case in eastern Kansas and could have potentially spread via wind at lower altitudes, or black fly flight along water channels.

![](/figures/vs_wind_2020.png)

Future Directions:
It would potentially be valuable to see the infected premises as a layer on this map? Or, more accurately, large enough populations of viable insect vectors. It would also be good to take surface climate into consideration and masking out paths- we know cold fronts can indicate the riding and dropping of these air parcels.


### Other Notes ###
* Active flight is paired with passive dispersal; flight behavior of C. species may promote dispersal events on top of habitat availability. 
* Handrick et al. 2008 found that there was no long range spread over distances of 300-400km at 850mb. Elevation and terrain roughness can cause air turbulence and drop down of Culicoides and restrict spread. This may be a relevant point considering how we're considering midges mixing on both sides of the Rockies.
* Monsoonal winds can promote insect dispersal- implying a seasonality to dispersal events (Baker et al. 1990 Simulium spp)
* Braverman and Chechik, 1996
* C sonorensis have a 30 day life cycle, with potentially 5-12 generations per year depending on temperature thresholds
* Used [grip](https://github.com/joeyespo/grip) to print this readme.md to pdf- cd to repo, grip, open on chrome, and print as pdf
