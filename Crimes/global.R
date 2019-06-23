
library(shiny)
library(leaflet)
library(dplyr)
library(here)

df <- geojsonio::geojson_read(here("Crimes","ward_boundaries.geojson"),
                              what = "sp")