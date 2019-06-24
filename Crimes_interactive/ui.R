ui <- bootstrapPage(
  leafletOutput("mymap", height = 1000),
  absolutePanel(
    top = 250, 
    right = 10, 
    selectInput("tiles", "Tile Source",c("Default","Stamen.Toner","Stamen.Watercolor","Wikimedia")),
    selectInput("colors", "Color Scheme",
                rownames(subset(brewer.pal.info, category %in% c("seq", "div")))
    ),
    selectInput("crime", "Crime Category",c("ASSAULT","ARSON","BURGLARY",
                                            "CRIM_SEXUAL_ASSAULT","HOMICIDE",
                                            "HUMAN_TRAFFICKING","KIDNAPPING",
                                            "MOTOR_VEHICLE_THEFT","NARCOTICS",
                                            "PROSTITUTION","PUBLIC_INDECENCY",
                                            "ROBBERY","SEX_OFFENSE","STALKING",
                                            "THEFT"))
  )
)


#names(providers %>% grep("Stamen|HERE",.,value = TRUE))

