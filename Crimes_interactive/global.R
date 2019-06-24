
library(shiny)
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(geojsonio)
library(htmltools)
library(RColorBrewer)

#df <- geojsonio::geojson_read("./Crimes_interactive/crimes_by_ward.geojson", what = "sp")
df <- geojsonio::geojson_read("crimes_by_ward.geojson", what = "sp")