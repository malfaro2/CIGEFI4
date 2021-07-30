###################################
####  PRECIPITATION yearLY  ######
###################################

## Data and packages
rm(list=ls())
source(file="code/packages.R")
source(file="code/functions_year/get_maps_all.R")
load("data_proc/tab_local_year_prec.Rdata")
load(file="data_proc/data_prec_year.Rdata")
rm(datos)
load(file="data_proc/tab_trends_year_prec.Rdata")
load(file="maps/plot_list_year_prec.Rdata")


allin <- function(i){
  datos <- data.frame(tab_local_year_prec[[i]], locations) 
  names(datos) <- c("S", "P_025","P_975", "lat", "lon")
  datos <- data.frame(datos %>% mutate(signo = case_when(S >= 0 ~ "POSITIVE", 
                                                         S < 0 ~ "NEGATIVE")))
  names(datos) <- c("S", "P_025","P_975", "lat", "lon", "signo")
  datos <- tibble(datos)
  get_maps(datos,i)
  
}

map_list <- lapply(1:length(tab_local_year_prec),allin)

## Number of maps
length(map_list)

for(i in seq(1,10)){
  tiff(paste0("maps/prec_year_index",i,"_",all[i],".tif"), 
       width = 2500, height = 1500,res = 300) 
  layout <- (map_list[[i]]) 
  print(layout)
  dev.off()
}

###################################
####  TEMPERATURE YEARLY  ######
###################################
rm(list=ls())
## Data and packages
source(file="code/packages.R")
source(file="code/functions_year/get_maps_all.R")
load(file="data_proc/tab_local_year_temp.Rdata")
load(file="data_proc/data_temp_year.Rdata")
rm(datos)
load(file="data_proc/tab_trends_year_temp.Rdata")
load(file="maps/plot_list_year_temp.Rdata")

allin <- function(i){
  datos <- data.frame(tab_local_year_temp[[i]], locations) 
  names(datos) <- c("S", "P_025","P_975", "lat", "lon")
  datos <- data.frame(datos %>% mutate(signo = case_when(S  >=0 ~ "POSITIVE",
                                                         S < 0 ~ "NEGATIVE")))
  names(datos) <- c("S", "P_025","P_975", "lat", "lon", "signo")
  datos <- tibble(datos)
  datos$lon <- -datos$lon
  get_maps(datos,i)
}

map_list <- lapply(1:length(tab_local_year_temp),allin)

## Number of maps
length(map_list)
all

## CSDI, WSDI ARE ALL ZEROES.
## Erase 1, 11

for(i in 2:10){
  tiff(paste0("maps/temp_year_index",i,"_",all[i-1],".tif"), 
       width = 2500, height = 1500,res =300)
  j<-i-1
  layout <- (map_list[[j]])
  print(layout) 
dev.off()
}
