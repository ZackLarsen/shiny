
# Example inspured by:
# https://www.datascience.com/blog/beginners-guide-to-shiny-and-leaflet-for-interactive-mapping

library(shiny)
library(leaflet)
library(dplyr)

df <- readRDS("stations.rds")