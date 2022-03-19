#' inputs_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_inputs_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel( #input panel
      id = "controls"
      , class = "panel panel-default"
      , h2(id="input-header", "LA County Zip Explorer")
      , tags$div(id='demo',
                 class="collapse in",
                 div(id="in-text",textOutput(ns("InputPanel"))),
                 fluidRow(column(11,
                                 sliderInput(
                                   inputId = ns("HomePrices"),
                                   label = "ZHVI Home Values ($)",
                                   min = 200000,
                                   max = 6000000,
                                   pre = "$",
                                   value = c(200000,2000000), 
                                   step = 100000,
                                   width = "100%"))),
                          
                  fluidRow(     
                          
                          column(8,
                                 sliderInput(
                                   inputId = ns("YoY"),
                                   label = "ZHVI Change (%)",
                                   min = -10,
                                   max = 120,
                                   post = "%",
                                   value = c(-10,120), 
                                   step = 1,
                                   width = "100%")),
                          column(4,
                                 selectInput(
                                   inputId = ns("years"),
                                   label = "vs Year",
                                   choices = list("2021" = 1, "2020" = 2, "2019" = 3, "2018" = 4,"2017" = 5),
                                   selected = 1,
                                   width = "100%")),
                          
                          
                          )
                                 ,    
                 fluidRow(     
                   
                   column(11,
                          sliderInput(
                            inputId = ns("forecast"),
                            label = "ZHVF 1YR Forecast (% Change)",
                            min = -5,
                            max = 20,
                            post = "%",
                            value = c(-5,20), 
                            step = 1,
                            width = "100%"))
                   ),
                 
                                 div(id = "submit",
                                     fluidRow(column(6, offset=3,
                                                     actionButton(
                                                       inputId = ns("Submit"),
                                                       icon("sync"),
                                                       width = "100%",
                                                       label = "Apply")))
                                 
                          
                 )
      )
    ),
    
    #adding seperate minimize button
    absolutePanel( 
      id = "minimize-button"
      , class = "panel panel-default"
      , HTML('<button 
                    data-toggle="collapse" 
                    data-target="#demo">Collapse/Expand
                    </button>'))
    
  )}

#' inputs_panel Server Function
#'
#' @noRd 
mod_inputs_panel_server <- function(input, output, session,r){
  ns <- session$ns
  output$InputPanel <- renderText({paste0('Adjust filters below and click "Apply" to update the map. Home value data is from Zillow\'s Home Value Index (ZHVI) and Home Value Forecast (ZHVF). Data includes all home types; last updated ',max(zillow_historicals$month),".")})
  
  

  ## observer to apply home value filter after "apply" 
  observeEvent(input$Submit,
               {r$user_inputs_server$HomePrices <- input$HomePrices
               }, ignoreNULL = FALSE)
  
  
  observeEvent(input$Submit,
               {r$user_inputs_server$YoY <- input$YoY
               }, ignoreNULL = FALSE)
  
  observeEvent(input$Submit,
               {r$user_inputs_server$years <- input$years
               }, ignoreNULL = FALSE)
  
  observeEvent(input$Submit,
               {r$user_inputs_server$forecast <- input$forecast
               }, ignoreNULL = FALSE)
}

## To be copied in the UI
# mod_inputs_panel_ui("inputs_panel_ui_1")

## To be copied in the server
# callModule(mod_inputs_panel_server, "inputs_panel_ui_1")
