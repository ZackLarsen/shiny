library(tidyverse)
library(shiny)
library(pacman)
library(magrittr)

p_load(here, conflicted, jsonlite, data.table, geojsonio)

conflict_prefer("filter", "dplyr")

chi_data <- file.path("/Users/zacklarsen/Zack_Master/Datasets/Chicago")


# Read in crimes data
crimes <- fread(file.path(chi_data,"Crimes_-_2001_to_present.csv"),nrows = 100000) %>% 
  na.omit() %>% 
  select(ID, `Primary Type`, Description, Latitude, Longitude, Ward)

# saveRDS(crimes, file = here("Crimes","crimes.rds"), ascii = FALSE, 
#         version = NULL, compress = TRUE, refhook = NULL)


# Read in geojson shapefile as spatial points dataframe
ward_boundaries <- geojsonio::geojson_read(
  file.path(chi_data,"Boundaries_Wards.geojson"), what = "sp")






crimes$`Primary Type` %>% 
  unique() %>% 
  sort()

crime_categories <- c(
  "ASSAULT",
  "ARSON",
  "BURGLARY",
  "CRIM SEXUAL ASSAULT",
  "HOMICIDE",
  "HUMAN TRAFFICKING",
  "KIDNAPPING",
  "NARCOTICS",
  "OBSCENITY",
  "PROSTITUTION",
  "THEFT"
)


ward_totals <- crimes %>% 
  select(Ward, `Primary Type`) %>% 
  mutate_all(as.factor) %>% 
  filter(`Primary Type` %in% crime_categories) %>% 
  group_by(`Primary Type`, Ward, .drop = FALSE) %>% 
  summarise(n()) %>% 
  rename(count = `n()`) %>% 
  arrange(`Primary Type`)


ward_totals %<>% 
  spread(key = `Primary Type`, value = count) %>% 
  rename_all(~ gsub(" ", "_", .))

colnames(ward_totals) %>% 
  sort()


ward_boundaries$ASSAULT <- setNames(ward_totals$ASSAULT, as.character(ward_totals$Ward))
ward_boundaries$ARSON <- setNames(ward_totals$ARSON, as.character(ward_totals$Ward))
ward_boundaries$BURGLARY <- setNames(ward_totals$BURGLARY, as.character(ward_totals$Ward))
ward_boundaries$CRIM_SEXUAL_ASSAULT <- setNames(ward_totals$CRIM_SEXUAL_ASSAULT, as.character(ward_totals$Ward))
ward_boundaries$HOMICIDE <- setNames(ward_totals$HOMICIDE, as.character(ward_totals$Ward))
ward_boundaries$HUMAN_TRAFFICKING <- setNames(ward_totals$HUMAN_TRAFFICKING, as.character(ward_totals$Ward))
ward_boundaries$KIDNAPPING <- setNames(ward_totals$KIDNAPPING, as.character(ward_totals$Ward))
ward_boundaries$MOTOR_VEHICLE_THEFT <- setNames(ward_totals$MOTOR_VEHICLE_THEFT, as.character(ward_totals$Ward))
ward_boundaries$NARCOTICS <- setNames(ward_totals$NARCOTICS, as.character(ward_totals$Ward))
ward_boundaries$PROSTITUTION <- setNames(ward_totals$PROSTITUTION, as.character(ward_totals$Ward))
ward_boundaries$PUBLIC_INDECENCY <- setNames(ward_totals$PUBLIC_INDECENCY, as.character(ward_totals$Ward))
ward_boundaries$ROBBERY <- setNames(ward_totals$ROBBERY, as.character(ward_totals$Ward))
ward_boundaries$SEX_OFFENSE <- setNames(ward_totals$SEX_OFFENSE, as.character(ward_totals$Ward))
ward_boundaries$STALKING <- setNames(ward_totals$STALKING, as.character(ward_totals$Ward))
ward_boundaries$THEFT <- setNames(ward_totals$THEFT, as.character(ward_totals$Ward))




geojson::geo_write(geojson::as.geojson(ward_boundaries), 
                   file = here("Crimes_interactive","crimes_by_ward.geojson"))









