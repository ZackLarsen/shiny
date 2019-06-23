

library(tidyverse)
library(shiny)
library(pacman)
library(magrittr)

p_load(here, conflicted, jsonlite, data.table, geojsonio)

knitr::opts_chunk$set(echo = TRUE)

conflict_prefer("filter", "dplyr")

#here::here() # "/Users/zacklarsen/Zack_Master/Projects/Dataviz/R/Dataviz_dashboard"





stations <- fromJSON("https://feeds.divvybikes.com/stations/stations.json")$stationBeanList

stations %<>% 
  select(stationName, latitude, longitude, availableBikes)

saveRDS(stations, file = here("first_try","stations.rds"), ascii = FALSE, version = NULL,
        compress = TRUE, refhook = NULL)




#chi_data <- file.path("/Users/zacklarsen/Zack_Master/Datasets/Chicago")

#crimes <- fread(file.path(chi_data,"Crimes_sample.csv")) %>% 
#  na.omit()

#ward_boundaries <- geojsonio::geojson_read(file.path(chi_data,"Boundaries_Wards.geojson"), what = "sp")



