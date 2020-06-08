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
        , h2(id="input-header", "Inputs")
        , tags$div(id='demo',
                   class="collapse in"
                   , div(
                         div(id="in-text",textOutput(ns("InputPanel")))
                         , tagList(
                           fluidRow(
                             column(11,
                                    sliderInput(
                                      inputId = ns("HomePrices"),
                                      label = "Median Home Price ($)",
                                      min = 0,
                                      max = 6000000,
                                      pre = "$",
                                      value = c(0,6000000), 
                                      step = 100000,
                                      width = "100%"
                                    ))
                           )
                           ,
                           
                           fluidRow(
                             column(11,
                                    sliderInput(
                                      ns("HouseholdIncome"),
                                      label = "Median Household Income ($K)",
                                      min = 10000,
                                      max = 5000000,
                                      pre = "$",
                                      value = c(10000,5000000),
                                      step = 10000,
                                      width = "100%"))
                           ),
                           
                           fluidRow(
                             column(11,
                                    sliderInput(
                                      ns("Education"),
                                      label = "Ranking of Top High School",
                                      min = 1,
                                      max = 100,
                                      value = c(50),
                                      step = 5,
                                      width = "100%"))
                           ),
                           
                           fluidRow(
                             column(11,
                                    sliderInput(
                                      ns("Crime"),
                                      label = "Safety Percentile (Safer Than X% of Zips) ",
                                      min = 1,
                                      max = 100,
                                      post = "%",
                                      value = c(50),
                                      step = 5,
                                      width = "100%"))
                           ),
                           
                           div(id = "submit",
                               fluidRow(
                                 column(6,offset=3,
                                        actionButton(
                                          inputId = ns("Submit"),
                                          icon("refresh"),
                                          width = "100%",
                                          label = "Submit"))
                               ))
                         )
                        )
                   
                   )
        ### ZHVI price slider

      ),
      absolutePanel( #adding seperate minimize button
        id = "minimize-button"
        , class = "panel panel-default"
        , HTML('<button 
                    data-toggle="collapse" 
                    data-target="#demo">Collapse/Expand
                    </button>')
      )
      
  )
}
    
#' inputs_panel Server Function
#'
#' @noRd 
mod_inputs_panel_server <- function(input, output, session,r){
  ns <- session$ns
  output$InputPanel <- renderText({'Zorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incidi'})
  
  observeEvent(input$Submit,
               {r$user_inputs_server$HomePrices <- input$HomePrices
               })
   observeEvent(input$Submit, {
     r$user_inputs_server$HouseholdIncome <- input$HouseholdIncome
   })
  #   
     observeEvent(input$Submit, {
       r$user_inputs_server$Education <- input$Education
     })
  #   
     observeEvent(input$Submit, {
       r$user_inputs_server$Crime <- input$Crime
     })
  # 
}

    
## To be copied in the UI
# mod_inputs_panel_ui("inputs_panel_ui_1")
    
## To be copied in the server
# callModule(mod_inputs_panel_server, "inputs_panel_ui_1")
 