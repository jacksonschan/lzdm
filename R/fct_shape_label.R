## reactive for information contained in zip hover tooltap 

labels <- reactive({ 
  paste0(
    "Zip Code: ",
    lac_zctas_data@data$GEOID10, "<br/>",
    "Home Prices: ",
    scales::dollar(lac_zctas_data@data$home_prices)) %>%
    lapply(htmltools::HTML) })