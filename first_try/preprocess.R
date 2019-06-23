
library(tidyverse)
library(shiny)
library(pacman)
library(magrittr)

p_load(here, conflicted, jsonlite, data.table, geojsonio)

conflict_prefer("filter", "dplyr")

stations <- fromJSON("https://feeds.divvybikes.com/stations/stations.json")$stationBeanList

stations %<>% 
  select(stationName, latitude, longitude, availableBikes)

saveRDS(stations, file = here("first_try","stations.rds"), ascii = FALSE, version = NULL,
        compress = TRUE, refhook = NULL)