library(shiny)
library(leaflet)
library(RColorBrewer)
library(tidyverse)
library(shiny)
library(pacman)

p_load(here, conflicted, jsonlite, data.table, geojsonio)

conflict_prefer("filter", "dplyr")

#here::here() # "/Users/zacklarsen/Zack_Master/Projects/Dataviz/R/Dataviz_dashboard"


chi_data <- file.path("/Users/zacklarsen/Zack_Master/Datasets/Chicago")

crimes <- fread(file.path(chi_data,"Crimes_sample.csv")) %>% 
  na.omit()

ward_boundaries <- geojsonio::geojson_read(
  file.path(chi_data,"Boundaries_Wards.geojson"),
  what = "sp"
  )






ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(top = 10, right = 10,
                sliderInput("range", "Magnitudes", min(quakes$mag), max(quakes$mag),
                            value = range(quakes$mag), step = 0.1
                ),
                selectInput("colors", "Color Scheme",
                            rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
                )
  )
)


# We need the following elements in our server functionL
# 1) A checkbox for each type of crime to be plotted

server <- function(input, output, session) {
  
  # Reactive expression for the data subsetted to what the user selected
  filteredData <- reactive({
    quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2],]
  })
  
  # This reactive expression represents the palette function,
  # which changes as the user makes selections in UI.
  colorpal <- reactive({
    colorNumeric(input$colors, quakes$mag)
  })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(quakes) %>% 
      addTiles() %>%
      fitBounds(~min(long), ~min(lat), ~max(long), ~max(lat))
  })
  
  # Incremental changes to the map (in this case, replacing the
  # circles when a new color is chosen) should be performed in
  # an observer. Each independent set of things that can change
  # should be managed in its own observer.
  observe({
    pal <- colorpal()
    
    leafletProxy("map", data = filteredData()) %>%
      clearShapes() %>%
      addCircles(radius = ~10^mag/10, weight = 1, color = "#777777",
                 fillColor = ~pal(mag), fillOpacity = 0.7, popup = ~paste(mag)
      )
  })
}

shinyApp(ui, server)