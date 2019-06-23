
library(tidyverse)
library(shiny)
library(pacman)
library(magrittr)

p_load(here, conflicted, jsonlite, data.table, geojsonio)

conflict_prefer("filter", "dplyr")

chi_data <- file.path("/Users/zacklarsen/Zack_Master/Datasets/Chicago")


# Read in crimes data
crimes <- fread(file.path(chi_data,"Crimes_-_2001_to_present.csv"), nrows = 10000) %>% 
  na.omit() %>% 
  select(ID, `Primary Type`, Description, Latitude, Longitude, Ward)

saveRDS(crimes, file = here("Crimes","crimes.rds"), ascii = FALSE, 
        version = NULL, compress = TRUE, refhook = NULL)


# Read in geojson shapefile as spatial points dataframe
ward_boundaries <- geojsonio::geojson_read(
  file.path(chi_data,"Boundaries_Wards.geojson"), what = "sp")





# Preprocess the geojson data to add the count of crimes committed by ward:
ward_totals <- crimes %>% 
  select(Ward, `Primary Type`) %>% 
  group_by(Ward) %>% 
  summarise(n()) %<>% 
  rename(count = `n()`)

ward_totals <- setNames(ward_totals$count, as.character(ward_totals$Ward))

ward_boundaries$crime_total <- ward_totals

geojson::geo_write(geojson::as.geojson(ward_boundaries), 
                   file = here("Crimes","ward_boundaries.geojson"))

