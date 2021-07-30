###################################
####  PRECIPITATION yearLY  ######
###################################
######bimonth1:DJF, bimonth2:MA####
######bimonth3:MJ, bimonth4:JA#####

## Data and packages
rm(list=ls())
source(file="code/packages.R")
source(file="code/functions_year/get_maps_all.R")
load(file="data_proc/data_prec_bimonth.Rdata")
rm(datos_prec)

allin <- function(i){
  datos <- data.frame(tab_local_bimonth_prec[[i]], latlonprec) 
  names(datos) <- c("S", "P_025","P_975", "lat", "lon")
  datos <- data.frame(datos %>% mutate(signo = case_when(S >= 0 ~ "POSITIVE", 
                                                         S < 0 ~ "NEGATIVE")))
  names(datos) <- c("S", "P_025","P_975", "lat", "lon", "signo")
  datos <- tibble(datos)
  get_maps(datos,i)
}

map_list <- list(list())

for(m in 1:4){
  load(file=paste0("data_proc/tab_local_bimonth",m,"_prec.Rdata"))
  map_list[[m]] <- lapply(1:length(tab_local_bimonth_prec),allin)
}

#Number of maps per month
unlist(lapply(map_list,length))
bim <- c("DJF","MA","MJ", "JA")
all

for(i in 1:8){
  for(m in 1:4){
  tiff(paste0("maps/prec_bimonth_index",i,"_",bim[m],"_",all[i],".tif"), 
       width = 2500, height = 1500,res = 300)
  layout <- (map_list[[m]][[i]])
  print(layout)
  dev.off()
}}


###################################
####  TEMPERATURE YEARLY  ######
###################################
######bimonth1:DJF, bimonth2:MA####
######bimonth3:MJ, bimonth4:JA#####

rm(list=ls())
## Data and packages
source(file="code/packages.R")
source(file="code/functions_year/get_maps_all.R")
load(file="data_proc/data_temp_bimonth.Rdata")
rm(datos_temp)

allin <- function(i){
  datos <- data.frame(tab_local_bimonth_temp[i], latlontemp) 
  names(datos) <- c("S", "P_025","P_975", "lat", "lon")
  datos <- data.frame(datos %>% mutate(signo = case_when(S >= 0 ~ "POSITIVE", 
                                                         S < 0 ~ "NEGATIVE")))
  names(datos) <- c("S", "P_025","P_975", "lat", "lon", "signo")
  datos <- tibble(datos)
  datos$lon <- -datos$lon
  get_maps(datos,i)
}

map_list <- list(list())

for(m in 1:4){
  load(file=paste0("data_proc/tab_local_bimonth",m,"_temp.Rdata"))
  map_list[[m]] <- lapply(1:length(tab_local_bimonth_temp),allin)
}


#Number of maps per month
unlist(lapply(map_list,length))
bim <- c("DJF","MA","MJ", "JA")
all

for(i in 1:9){
  for(m in 1:4){
    tiff(paste0("maps/temp_bimonth_index",i,"_",bim[m],"_",all[i],".tif"), 
         width = 2500, height = 1500,res = 300)
    layout <- (map_list[[m]][[i]])
    print(layout)
    dev.off()
  }}
