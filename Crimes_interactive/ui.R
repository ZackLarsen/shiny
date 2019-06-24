ui <- bootstrapPage(
  leafletOutput("mymap", height = 1000),
  absolutePanel(
    top = 250, 
    right = 10, 
    selectInput("tiles", "Tile Source",c("Default","Toner","Watercolor")),
    selectInput("crime", "Crime Category",c("ASSAULT","ARSON","BURGLARY",
                                            "CRIM_SEXUAL_ASSAULT","HOMICIDE",
                                            "HUMAN_TRAFFICKING","KIDNAPPING",
                                            "MOTOR_VEHICLE_THEFT","NARCOTICS",
                                            "PROSTITUTION","PUBLIC_INDECENCY",
                                            "ROBBERY","SEX_OFFENSE","STALKING",
                                            "THEFT"))
  )
)