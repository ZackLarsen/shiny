server <- function(input,output, session){
  
  data <- reactive({
    x <- df
  })
  
  output$mymap <- renderLeaflet({
    df <- data()
    
    m <- leaflet(data = df) %>%
      addTiles() %>%
      addMarkers(lng = ~longitude,
                 lat = ~latitude,
                 popup = paste("Name", df$stationName, "<br>",
                               "Bikes Available:", df$availableBikes))
    m
  })
}