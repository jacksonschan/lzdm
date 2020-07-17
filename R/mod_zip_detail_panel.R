#' zip_detail_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_zip_detail_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel(
      id = "zip-detail"
      , class = "out-panel" 
      , fixed=TRUE
      , h2(class="out-header",textOutput(ns("zipdetail")))
      , div(class="out-text",uiOutput(ns("ziplink")))
    )
  )
}

#' zip_detail_panel Server Function
#'
#' @noRd 
mod_zip_detail_panel_server <- function(input, output, session,r){
  ns <- session$ns
  
  link <- reactive({
    z <- r$mod_base_leaflet$shape_click
    z
  #  print(l)
  #  url <- a("Click link for Zillow listing for this Zip", href=l)
    })
  
  data <- reactive({
    l <- link()
    dclick <- lac_zctas_data@data[lac_zctas_data@data$GEOID10==l,]
    dclick
  })
  
  output$ziplink <- renderUI({
    l <- link()
    if(is.null(l))
      return()
    else{tagList(a(href=paste0("https://www.zillow.com/los-angeles-ca-",l,"/home-values/"),"Click link for Zillow profile for this Zip",target="_blank"))}#"Click link for Zillow listing for this Zip"))
    })
  
  
output$zipdetail <- renderText({
  d <- data()
  l <- link()
  if(is.null(l))
    return("Click on a Zip to See Data")
  else{paste0(d$name," (",l,")" )}
})
}



## To be copied in the UI
# mod_zip_detail_panel_ui("zip_detail_panel_ui_1")
    
## To be copied in the server
# callModule(mod_zip_detail_panel_server, "zip_detail_panel_ui_1")