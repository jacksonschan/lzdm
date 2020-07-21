#' top_zipcodes_panel UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_top_zipcodes_panel_ui <- function(id){
  ns <- NS(id)
  tagList(
    absolutePanel(
      id = "top-zips"
      , class = "out-panel" 
      , fixed=TRUE
<<<<<<< HEAD
      , h2(class="out-header", id="table-header", "Zip Table")
=======
      , h3(class="out-header", id="table-header", "Zip Table")
>>>>>>> development
    #  , div(class="out-text",textOutput(ns("TopZips")))
      , fluidRow(
      column(10,offset=1,
       DT::dataTableOutput(ns("ziptable")))
      )
    )
    )
}
    

#' top_zipcodes_panel Server Function
#'
#' @noRd 
mod_top_zipcodes_panel_server <- function(input, output, session,r){
  ns <- session$ns
 # output$TopZips <- renderText({})
  
  data <- reactive({
<<<<<<< HEAD
    d <- lac_zctas_data@data %>%
      dplyr::filter(.
                    , home_prices >= r$user_inputs_server$HomePrices[1]
                    , home_prices <= r$user_inputs_server$HomePrices[2]) %>% 
      dplyr::mutate(.,home_prices = scales::dollar(home_prices), market_rent=scales::dollar(market_rent)) %>%
=======
    d <- zip_dataset@data %>%
      dplyr::filter(.
                    , home_prices >= r$user_inputs_server$HomePrices[1]
                    , home_prices <= r$user_inputs_server$HomePrices[2]) %>% 
      dplyr::mutate(.,home_prices = home_prices, market_rent) %>%
>>>>>>> development
      dplyr::select(.,GEOID10,home_prices,market_rent)
      
    d
  })
  
  output$ziptable <- DT::renderDataTable({
    d <- data()
    DT::datatable(d, options = list(
<<<<<<< HEAD
      lengthMenu=4
      , pageLength =4
      , autoWidth = TRUE
      , columnDefs = list(list(width = '150px', targets = "_all"))
      ) 
      , colnames = c('Zip', 'Home Value', 'Rent')
      , rownames = FALSE
      )
=======
      lengthMenu=5
      , pageLength =5
      , lengthChange = FALSE
      , autoWidth = TRUE
      , columnDefs = list(list(width = '150px', targets = "_all"))
      , scrollY = '100px'
      , order = list(1, 'asc')
      ) 
      , colnames = c('Zip', 'Value', 'Rent')
      , rownames = FALSE
      ) %>% DT::formatCurrency(columns=c('home_prices','market_rent'))
>>>>>>> development
  })
}
    
## To be copied in the UI
# mod_top_zipcodes_panel_ui("top_zipcodes_panel_ui_1")
    
## To be copied in the server
# callModule(mod_top_zipcodes_panel_server, "top_zipcodes_panel_ui_1")