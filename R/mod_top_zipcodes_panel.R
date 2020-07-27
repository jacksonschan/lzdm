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
    #  , br()
      , h5(id="zip-table-title","Filtered Zips Table")
      , fluidRow(
      column(10, offset=1,
       div(id= "data-table",DT::dataTableOutput(ns("ziptable")))
       )
    )
      )
    #)
    )
}
    

#' top_zipcodes_panel Server Function
#'
#' @noRd 
mod_top_zipcodes_panel_server <- function(input, output, session,r){
  ns <- session$ns
 # output$TopZips <- renderText({})
  
  data <- reactive({
    d <- zip_dataset@data %>%
      dplyr::filter(.
                    , home_prices >= r$user_inputs_server$HomePrices[1]
                    , home_prices <= r$user_inputs_server$HomePrices[2]) %>%
      dplyr::mutate(.,name=unlist(lapply(name,function(x)if(stringr::str_length(gsub("/.*$","",x)) < 20){gsub("/.*$", "",x)} else{stringr::str_c(substr(gsub("/.*$", "",x),1,17),"...")}))
) %>%
      dplyr::select(.,GEOID10,name,home_prices,market_rent) 
  })

  output$ziptable <- DT::renderDataTable({
    d <- data()
    DT::datatable(d, options = list(
      lengthMenu=5
      , pageLength =5
      , lengthChange = FALSE
     # , autoWidth = TRUE
    #  , columnDefs = list(list(width = "30%", targets = "_all"))
      , columnDefs = list(list(className = 'dt-left', targets = 0:3))
     # , scrollY = "150px"
      , order = list(2, 'asc')
      ) 
      , colnames = c('Zip', 'Name', 'Home Value', 'Rent')
      , rownames = FALSE
      , selection = 'single'
      #, caption = 'Zip Table'
      ) %>% DT::formatCurrency(columns=c('home_prices','market_rent'),digits = 0)

  })
  
  observeEvent(input$ziptable_rows_selected,
               { d <- data()
               if(is.null(input$ziptable_rows_selected))
                 return()
               else{
                r$mod_base_leaflet$shape_click <- d[input$ziptable_rows_selected,c("GEOID10")]
               }
               }, ignoreNULL = FALSE)  
  
}
    
## To be copied in the UI
# mod_top_zipcodes_panel_ui("top_zipcodes_panel_ui_1")
    
## To be copied in the server
# callModule(mod_top_zipcodes_panel_server, "top_zipcodes_panel_ui_1")