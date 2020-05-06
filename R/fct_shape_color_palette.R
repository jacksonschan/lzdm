## function to define zip shape colour palette + mapping to data

colorpal <- reactive({
  colorNumeric(palette = "Greens", #colour palatte
               domain = lac_zctas_data@data$hm_prcs) #data for bins
})

