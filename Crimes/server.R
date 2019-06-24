server <- function(input, output, session){
  
  data <- reactive({
    x <- df
  })
  
  output$mymap <- renderLeaflet({
    df <- data()
    
    labels <- sprintf(
      "<strong>Ward #%s</strong><br/> %g crimes committed in this ward",
      df$ward, df$crime_total
    ) %>% 
      lapply(htmltools::HTML)
    
    qpal <- colorQuantile("Reds", df$crime_total, n = 10)
    
    leaflet(df) %>%
      addTiles(group = "Default") %>%
      addPolygons(
        fillColor = ~qpal(crime_total),
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
        ),
        label = ~labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>% 
      addLegend(
        pal = qpal, 
        values = ~crime_total,
        opacity = 0.7, 
        title = "Crime Count Quantile",
        position = "topright"
      )
  })
}
