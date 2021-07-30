# Load our packages in the usual way.

list.of.packages <- c("boot","broom","cowplot","distances","dplyr","drake",
                    "fda","fda.usc","fs","ggalt","gganimate","ggplot2",
                    "ggridges","ggspatial","gridExtra","gstat","hrbrthemes",
                    "Kendall","knitr","lattice","lubridate","magick","metR",
                    "modelr","patchwork","R.matlab","rgeos","rnaturalearth",
                    "scales","sf","sp","spBayes","tidyr","tidyverse",
                    "viridis","zoo")

new.packages <- list.of.packages[!(list.of.packages %in% 
                      installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

#devtools::install_github("ropensci/rnaturalearth")
#devtools::install_github("ropensci/rnaturalearthdata")
#devtools::install_github("ropensci/rnaturalearthhires")
# install.packages("rnaturalearthhires",
#                 repos = "http://packages.ropensci.org",
#                 type = "source")

lapply(list.of.packages, require, character.only = TRUE)
