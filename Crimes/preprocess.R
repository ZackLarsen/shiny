
library(tidyverse)
library(shiny)
library(pacman)
library(magrittr)

p_load(here, conflicted, jsonlite, data.table, geojsonio)

conflict_prefer("filter", "dplyr")

chi_data <- file.path("/Users/zacklarsen/Zack_Master/Datasets/Chicago")



crimes <- fread(file.path(chi_data,"Crimes_sample.csv")) %>% 
  na.omit()

crimes %<>% select(ID, `Primary Type`, Description, Latitude, Longitude, Ward)




ward_boundaries <- geojsonio::geojson_read(
  file.path(chi_data,"Boundaries_Wards.geojson"), what = "sp")





saveRDS(stations, file = here("first_try","stations.rds"), ascii = FALSE, 
        version = NULL, compress = TRUE, refhook = NULL)










ward_totals <- crimes %>% 
  select(Ward, `Primary Type`) %>% 
  group_by(Ward) %>% 
  summarise(n()) %<>% 
  mutate(count = `n()`)

ward_totals <- setNames(ward_totals$count, as.character(ward_totals$Ward))

ward_boundaries$crime_total <- ward_totals

labels <- sprintf(
  "<strong>Ward #%s</strong><br/> %g crimes committed in this ward",
  ward_boundaries$ward, ward_boundaries$crime_total
) %>% 
  lapply(htmltools::HTML)

qpal <- colorQuantile("Reds", ward_boundaries$crime_total, n = 10)

leaflet(ward_boundaries) %>%
  addTiles() %>%
  addPolygons(fillColor = ~qpal(crime_total),
              weight = 2,
              opacity = 1,
              color = "white",
              dashArray = "3",
              fillOpacity = 0.9,
              highlight = highlightOptions(
                weight = 3, # This is the width of the dashed line
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = ~labels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) %>% 
  addLegend(pal = qpal, 
            values = ~crime_total,
            opacity = 0.7, 
            title = "Crime Count Quantile",
            position = "topright")
