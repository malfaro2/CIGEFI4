## Data, functions and packages
source(file="code/packages.R")
source(file="code/functions_bimonth/BPfunc_bimonth.R")
source(file="code/functions_bimonth/get_plots_bimonth.R")
source(file="code/functions_bimonth/heatmaps_bimonth.R")
load(file="data_proc/data_temp_bimonth.Rdata")

# Draw plots and calculate descriptive stats

N <- 38 # number of stations.
estaciones <- tibble("lat" = latlontemp[[1]][,1],
                        "lon" = latlontemp[[1]][,2],
                        "station" = c(1:N))
map1 <- rnaturalearth::ne_states(
  country = c("guatemala", "honduras", 
              "el salvador", "panama", 
              "nicaragua", "costa rica", 
              "belize", "mexico", 
              "colombia"), returnclass = "sf")

names(datos_temp)

dat <- datos_temp %>% 
  group_by(year,bimonth,station) %>% 
  left_join(estaciones, by=c("station")) %>% 
  group_by(station, bimonth) %>% 
  mutate(CSDI.m = mean(CSDI,na.rm=TRUE),
         DTR.m = mean(DTR,na.rm=TRUE),
         TN10p.m = mean(TN10p,na.rm=TRUE),
         TN90p.m = mean(TN90p,na.rm=TRUE),
         TNn.m = mean(TNn,na.rm=TRUE),
         TNx.m = mean(TNx,na.rm=TRUE),
         TX10p.m = mean(TX10p,na.rm=TRUE),
         TX90p.m = mean(TX90p,na.rm=TRUE),
         TXn.m = mean(TXn,na.rm=TRUE),
         TXx.m = mean(TXx,na.rm=TRUE)) %>% 
  ungroup() %>% 
  mutate(CSDI.c = CSDI - CSDI.m,
         DTR.c = DTR - DTR.m,
         TN10p.c = TN10p - TN10p.m,
         TN90p.c = TN90p - TN90p.m,
         TNn.c = TNn - TNn.m,
         TNx.c = TNx - TNx.m,
         TX10p.c =  TX10p - TX10p.m,
         TX90p.c =  TX90p - TX90p.m,
         TXn.c = TXn - TXn.m,
         TXx.c = TXx - TXx.m) 

## Variable Description - Boxplots

units <- c("NA")
for(mm in 1:5){
  plot_list <- colnames(dat)[4:13] %>% 
    map( ~ BPfunc_bimonth(.x, units,mm))
  save(plot_list, file=paste0("maps/plot_list_bimonth",mm,"_temp.Rdata"))
}

for(mm in 1:5){
  heatmap_list <- colnames(dat)[4:13] %>% 
    map( ~ heatmap_function(.x,mm))
  save(heatmap_list, file=paste0("maps/heatmap_list_bimonth",mm,"_temp.Rdata"))
}

## CSDI ARE mostly ALL ZEROES. TXx has an outlier
dat <- dat %>% dplyr::select(-starts_with("CSDI"))

## Trends - Only calculates trends and correlation

cMKt <- function(var){as.numeric(MannKendall(ts(var))$tau)}
cMKs <- function(var){as.numeric(MannKendall(ts(var))$S)}
cMKv <- function(var){as.numeric(MannKendall(ts(var))$varS)}
pMK  <- function(var){as.numeric(MannKendall(ts(var))$sl)}

summary(dat) # transform into station, year, CDD.c ... SDII.c
trends <- dat %>% 
  dplyr::select(station, year,bimonth, ends_with(".c")) %>% 
  pivot_longer(cols= ends_with(".c"),
               names_to = "variable", 
               values_to = "value") %>% 
  arrange(year) %>% 
  group_by(station, variable,bimonth) %>% 
  summarize(tauMK = cMKt(value),
            SMK = cMKs(value),
            varSMK = cMKv(value),
            pMK = pMK(value),
            Z = sign(SMK)*(abs(SMK)-1)/sqrt(varSMK),
            pZ = 2*(1-pnorm(abs(Z))),
            n = length(value),
            r = cor(value[-n],value[-1]))

## Describe trends per station, variable and month:

all <- unique(trends$variable);all
i<-1 #variable
m<-1 #period
get_plots(i,m)
summary(trends %>% filter(variable==all[i]))
tab_trends_bimonth_temp <- trends %>% 
  group_by(variable, bimonth) %>% summarize(meanZ=mean(Z)) %>% 
  pivot_wider(names_from=variable, values_from=meanZ)
save(tab_trends_bimonth_temp, file="data_proc/tab_trends_bimonth_temp.Rdata")
