get_maps <- function(datos,i){
  #coordinates
  xlabs = seq(-102,-77, 5)
  ylabs = seq(7, 23, 3)
  #map
  map1 <- rnaturalearth::ne_countries(
    country = c("guatemala", "honduras",
                "el salvador", "panama",
                "nicaragua", "costa rica",
                "belize", "mexico",
                "colombia","cuba","jamaica"), returnclass = "sf")
  #dataset
  a<- datos %>%
    mutate(filtro = ifelse(data.table::between(S,P_025,P_975), 
                           'TRUE', 'FALSE')) %>% 
    mutate(Significance = case_when(
      filtro == FALSE & signo == "NEGATIVE"  ~ "red",
      filtro == FALSE & signo == "POSITIVE"~ "black",
      filtro == TRUE & signo == "NEGATIVE" ~"NA",
      filtro == TRUE & signo == "POSITIVE" ~"NA"))
  #check 
  print(length(unique(a$Significance))==3)
  #ifelse
  if(length(unique(a$Significance))==3){
    mapa <- a %>% ggplot(aes(-lon, lat)) +
      geom_sf(data = map1, inherit.aes = FALSE, 
              color = "black", fill = "white") +
      coord_sf(xlim = c(-102, -77), ylim = c(7,23)) +
      geom_point(aes(fill = Significance , size = abs(S),
                     shape=Significance)) + 
      scale_shape_manual(values = c(24, 5, 25),
                         labels=c("NEGATIVE","POSITIVE","NA")) +
      scale_fill_manual(values=c("black",NA,"indianred1"),
                        labels=c("Positive", "non-significant", "Negative")) +
      guides(fill = guide_legend(override.aes = list(shape = c(24,5,25)))) +
      guides(shape = "none") +
      theme_ipsum() + theme(
        panel.spacing = unit(0.1, "lines"),
        strip.text.x = element_text(size = 12)) +
      scale_size_area(max_size = 6, guide = "none") +
      theme_linedraw() +
      labs(x = "Longitude", y = "Latitude")+ 
      scale_x_continuous(breaks = xlabs, labels = paste0(xlabs,'°W')) +
      scale_y_continuous(breaks = ylabs, labels = paste0(ylabs,'°N')) 
  }else{
    print(unique(a$Significance))
    if("black" %in% unique(a$Significance)){
      mapa <- a %>%  ggplot(aes(-lon, lat)) +
        geom_sf(data = map1, inherit.aes = FALSE, 
                color = "black", fill = "white") +
        coord_sf( xlim = c(-102, -77), ylim = c(7,23)) +
        geom_point(aes(fill = Significance , size = abs(S),
                       shape=Significance)) + 
        scale_shape_manual(values = c(24, 5),
                           labels=c("POSITIVE", "NA")) +
        scale_fill_manual(values=c("black",NA),
                          labels=c("Positive", "non-significant")) +
        guides(fill = guide_legend(override.aes = list(shape = c(24,5))))+
        guides(shape = "none")+
        theme_ipsum() + theme(
          panel.spacing = unit(0.1, "lines"),
          strip.text.x = element_text(size = 12)) +
        scale_size_area(max_size = 6, guide = "none") +
        theme_linedraw() +
        labs(x = "Longitude", y = "Latitude")+ 
        scale_x_continuous(breaks = xlabs, labels = paste0(xlabs,'°W')) +
        scale_y_continuous(breaks = ylabs, labels = paste0(ylabs,'°N')) 
    }else{
      mapa <- a %>%  ggplot(aes(-lon, lat)) +
        geom_sf(data = map1, inherit.aes = FALSE, 
                color = "black", fill = "white") +
        coord_sf( xlim = c(-102, -77), ylim = c(7,23)) +
        geom_point(aes(fill = Significance , size = abs(S),
                       shape=Significance)) + 
        scale_shape_manual(values = c(5, 25),
                           labels=c("NA","NEGATIVE")) +
        scale_fill_manual(values=c(NA,"red"),
                          labels=c("non-significant","Negative")) +
        guides(fill = guide_legend(override.aes = list(shape = c(5,25))))+
        guides(shape = "none")+
        theme_ipsum() + theme(
          panel.spacing = unit(0.1, "lines"),
          strip.text.x = element_text(size = 12)) +
        scale_size_area(max_size = 6, guide = "none") +
        theme_linedraw() +
        labs(x = "Longitude", y = "Latitude")+ 
        scale_x_continuous(breaks = xlabs, labels = paste0(xlabs,'°W')) +
        scale_y_continuous(breaks = ylabs, labels = paste0(ylabs,'°N')) 
      
    }
  }
  return(mapa)
}



