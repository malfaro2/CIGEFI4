source("data/packages.R")

####################### TEMPERATURE INDEX #################################

dat <- list()
for(i in 1:12){
  dat[[i]]<- readMat(paste0("data_original/index_temp/mes",i,".mat"))
}

latlontemp <- readMat("data_original/index_temp/latlon.mat")
temp <- dat

# 38 stations, 1970-2004, 10 index
# 32 years x 12 meses

length(temp)#months
lapply(temp, length)#index for each month
dim(temp[[2]][[4]])#years x stations

#names = [CSDI,  DTR, TN10p, TN90p, TNn, TNx, TX10p, TX90p, TXn, TXx]
#units = [“ % days”, “ ºC”, “% days”, "% days”, “ ºC”,  “ ºC", “ % days”, 
#         “ % days”  “ ºC”, “ ºC”, "% days”]

####################### PRECIPITATION INDEX #################################

dat <- list()
for(i in 1:12){
  dat[[i]]<- readMat(paste0("data_original/index_prec/mes",i,".mat"))
}

latlonprec <- readMat("data_original/index_prec/latlon.mat")
prec <- dat
# 174 stations, 1979-2010, 10 index
# 32 years x 12 meses

length(prec)#months
lapply(prec, length)##index for each month
dim(prec[[2]][[4]])#years x stations

# names = [CDD,CWD,PRCPTOT,R10mm,R20mm,R95p,R99p,RX1day,RX5day,SDII]
# units = [days,days,mm,days,days,mm,mm,mm,mm,mm/day]

############################ CREATE TABLES ################################

## Create a tibble with all variables: 35*12*38 (years,months,stations)

datos_temp<- tibble("year" = rep(1:35,38*12),
                    "station"  = rep(rep(1:38,each=35),12),
                    "month" = rep(rep(1:12,each=35),each=38),
                    "CSDI"  = unlist(lapply(temp,function(x)x$CSDI)), 
                    "DTR"  = unlist(lapply(temp,function(x)x$DTR)), 
                    "TN10p"  = unlist(lapply(temp,function(x)x$TN10p)), 
                    "TN90p"  = unlist(lapply(temp,function(x)x$TN90p)), 
                    "TNn"  = unlist(lapply(temp,function(x)x$TNn)), 
                    "TNx"  = unlist(lapply(temp,function(x)x$TNx)), 
                    "TX10p"   = unlist(lapply(temp,function(x)x$TX10p)), 
                    "TX90p"  = unlist(lapply(temp,function(x)x$TX90p)), 
                    "TXn"  = unlist(lapply(temp,function(x)x$TXn)), 
                    "TXx"  = unlist(lapply(temp,function(x)x$TXx)))

save(datos_temp,latlontemp, file="data_proc/data_temp_month.Rdata")

## Create a tibble with all variables: 32*12*174 (years,months,stations)

datos_prec <- tibble("year" = rep(1:32,174*12),
                    "station"  = rep(rep(1:174,each=32),12),
                    "month" = rep(rep(1:12,each=32),each=174),
                    "CDD"  = unlist(lapply(prec,function(x)x$CDD)), 
                    "CWD"  = unlist(lapply(prec,function(x)x$CWD)), 
                    "PRCTOT"  = unlist(lapply(prec,function(x)x$PRCPTOT)), 
                    "R10mm"  = unlist(lapply(prec,function(x)x$R10mm)), 
                    "R20mm"  = unlist(lapply(prec,function(x)x$R20mm)), 
                    "R95p"  = unlist(lapply(prec,function(x)x$R95p)), 
                    "R99p"   = unlist(lapply(prec,function(x)x$R99p)), 
                    "RX1day"  = unlist(lapply(prec,function(x)x$RX1day)), 
                    "RX5day"  = unlist(lapply(prec,function(x)x$RX5day)), 
                    "SDII"  = unlist(lapply(prec,function(x)x$SDII)))

save(datos_prec,latlonprec, file="data_proc/data_prec_month.Rdata")

