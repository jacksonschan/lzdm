#' user_inputs UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_user_inputs_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(11,
             sliderInput(
                ns("HomePrices"),
                label = "Median Home Price ($)",
                min = 0,
                max = 6000000,
                pre = "$",
                value = c(0,6000000),
                step = 100000,
                width = "100%"
                ))
    ),

    fluidRow(
      column(11,
             sliderInput(
               ns("HouseholdIncome"),
               label = "Median Household Income ($K)",
               min = 0,
               max = 1000,
               pre = "$",
               value = c(0,6000000),
               step = 100000,
               width = "100%"))
      ),

      fluidRow(
        column(11,
               sliderInput(
                 ns("Education"),
                 label = "Ranking of Top Highschool",
                 min = 1,
                 max = 10,
                 value = c(100),
                 step = 1,
                 width = "100%"))
      ),
    
    fluidRow(
      column(11,
             sliderInput(
               ns("Crime"),
               label = "Safety Percentile (Safer Than X% of Zips) ",
               min = 0,
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
             ns("Submit"),
             icon("refresh"),
             width = "100%",
             label = "Submit"))
    ))
  )
}
    
#' user_inputs Server Function
#'
#' @noRd 
mod_user_inputs_server <- function(input, output, session){
  
  ns <- session$ns
  
  UserInputs <- reactive({
    input$Submit
    ins <- list(
      HomePrices <- input$HomePrices,
      HouseholdIncome <- input$HouseholdIncome,
      Education <- input$Education,
      Crime <- input$Crime
    )
  })


}
    
## To be copied in the UI
# mod_user_inputs_ui("user_inputs_ui_1")
    
## To be copied in the server
# callModule(mod_user_inputs_server, "user_inputs_ui_1")
 
