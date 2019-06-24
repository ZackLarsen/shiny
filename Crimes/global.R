
library(shiny)
library(leaflet)
library(dplyr)
library(geojsonio)

df <- geojsonio::geojson_read("ward_boundaries.geojson",
                              what = "sp")