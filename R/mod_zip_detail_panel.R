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
      , fluidRow(
        column(4,offset=1,
              div(uiOutput(ns("homeprice")))
              ),
        column(6,
               div(uiOutput(ns("rank")))
        )
      , fluidRow(
        column(11,offset=1,
               div(uiOutput(ns("rent")))
      )
          )
      )
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
  
  click_data <- reactive({
    l <- link()
    dclick <- lac_zctas_data@data[lac_zctas_data@data$GEOID10==l,]
    dclick
  })
  
  rank_data <- reactive({
    
    l <- link()
    pop <- lac_zctas_data@data %>%
    dplyr::filter(.,home_prices >= r$user_inputs_server$HomePrices[1], home_prices <= r$user_inputs_server$HomePrices[2]) %>%
      dplyr::select(.,GEOID10,home_prices) %>%
      dplyr::mutate(
        perc_rank = percent_rank(home_prices)
        ,num_rank = dplyr::dense_rank(home_prices)
        ,rows = nrow(.)) 
    selected <- data.frame(
      perc_rank=1-pop[pop$GEOID10==l,c("perc_rank")], 
      num_rank=pop[pop$GEOID10==l,c("num_rank")],
      num_zips=pop[pop$GEOID10==l,c("rows")]
)
    selected
  })
  
  output$ziplink <- renderUI({
    l <- link()
    if(is.null(l))
      return()
    else{tagList(a(href=paste0("https://www.zillow.com/los-angeles-ca-",l,"/home-values/"),"Click link for Zillow profile for this Zip",target="_blank"))}#"Click link for Zillow listing for this Zip"))
    })
  
  
output$zipdetail <- renderText({
  d <- click_data()
  l <- link()
  if(is.null(l))
    return("Click on a Zip to See Data")
  else{paste0(d$name," (",l,")" )}
})


output$homeprice <- renderUI({
  d <- click_data()
  l <- link()
  if(is.null(l))
    return()
  else{
    tagList(
      h2("Median Home Values")
      , h2(scales::dollar(d$home_prices)))
    }
})

output$rent <- renderUI({
  d <- click_data()
  l <- link()
  if(is.null(l))
    return()
  else{
    tagList(
      h2("Rent Index")
      , if(is.na(d$market_rent)==TRUE){h2(paste("No Data"))}
      else{h2(scales::dollar(d$market_rent))}
           )
  }
})

output$rank <- renderUI({
  d <- rank_data()
  l <- link()
  if(is.null(l))
    return()
  else{
    tagList(
      h3("Affordability Rank (of filtered Zips)")
    , if(nrow(d)==0) {p(paste("Selected zip not in filtered zip results"))}
    else{
      tagList(
        h4(paste0("#",d[,2]," (out of ",d[,3], ") most affordable"))
        , h4(paste0("More Affordable Then ",round(d[,1]*100,1),"% of Zips"))
      )
    }
    )
  }
})

}
## To be copied in the UI
# mod_zip_detail_panel_ui("zip_detail_panel_ui_1")
    
## To be copied in the server
# callModule(mod_zip_detail_panel_server, "zip_detail_panel_ui_1")