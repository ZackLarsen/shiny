server <- function(input, output, session){
  
  data <- reactive({
    x <- df
  })
  
  output$mymap <- renderLeaflet({
    df <- data() # Executing this function gives us the crimes_by_ward.geojson
    # as a SpatialPolygonsDataFrame
    
    # qpal <- reactive({
    #   colorQuantile(input$colors, df$ARSON %>% unique(), n = 9)
    # })
    
    qpal <- colorQuantile("Reds", df$ARSON %>% unique(), n = 10)

    leaflet(df) %>%
      addTiles() %>%
      #addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
      #addProviderTiles(providers$Stamen.Watercolor, group = "Watercolor") %>% 
      #addProviderTiles(providers$tiles) %>% 
      addPolygons(
        fillColor = ~qpal(ARSON),
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
          bringToFront = TRUE
         )
      ) %>% 
      addLegend(
        pal = qpal(), 
        values = ~ARSON,
        opacity = 0.7, 
        title = "Crime Count Quantile",
        position = "topright"
      )
  })
}











# labels <- reactive({
#   sprintf("<strong>Ward #%s</strong><br/> %g arsons committed in this ward",
#   df$ward, df$input$crime
#   ) %>%
#   lapply(htmltools::HTML)
# })

# label = ~labels,
# labelOptions = labelOptions(
#   style = list("font-weight" = "normal", padding = "3px 8px"),
#   textsize = "15px",
#   direction = "auto"
# )





#%>% 
# addLayersControl(
#   baseGroups = c("Default", "Toner", "Watercolor"),
#   #overlayGroups = c("BATTERY","ROBBERY","HOMICIDE","ASSAULT","PROSTITUTION","GTA"),
#   options = layersControlOptions(collapsed = FALSE)
# )








# BATTERY <- crimes[crimes$`Primary Type` == 'BATTERY',]
# ROBBERY <- crimes[crimes$`Primary Type` == 'ROBBERY',]
# HOMICIDE <- crimes[crimes$`Primary Type` == 'HOMICIDE',]
# ASSAULT <- crimes[crimes$`Primary Type` == 'ASSAULT',]
# PROSTITUTION <- crimes[crimes$`Primary Type` == 'PROSTITUTION',]
# GTA <- crimes[crimes$`Primary Type` == 'MOTOR VEHICLE THEFT',]
# 
# leaflet(crimes) %>%
#   # Base groups
#   addTiles(group = "Default") %>%
#   addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
#   addProviderTiles(providers$Stamen.Watercolor, group = "Watercolor") %>% 
#   addProviderTiles(providers$NASAGIBS.ViirsEarthAtNight2012, group = "NASA") %>%
#   # Overlay groups
#   addCircles(~BATTERY$Longitude, ~BATTERY$Latitude, group = "BATTERY") %>%
#   addCircles(~ROBBERY$Longitude, ~ROBBERY$Latitude, group = "ROBBERY") %>%
#   addCircles(~HOMICIDE$Longitude, ~HOMICIDE$Latitude, group = "HOMICIDE") %>%
#   addCircles(~ASSAULT$Longitude, ~ASSAULT$Latitude, group = "ASSAULT") %>%
#   addCircles(~PROSTITUTION$Longitude, ~PROSTITUTION$Latitude, group = "PROSTITUTION") %>%
#   addCircles(~GTA$Longitude, ~GTA$Latitude, group = "GTA") %>%
#   # Layers control
#   addLayersControl(
#     baseGroups = c("Default", "Toner", "Watercolor", "NASA"),
#     overlayGroups = c("BATTERY","ROBBERY","HOMICIDE","ASSAULT","PROSTITUTION","GTA"),
#     options = layersControlOptions(collapsed = FALSE)
#   )