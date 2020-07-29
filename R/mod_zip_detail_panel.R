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
      , uiOutput(ns("zipdetail"))
      , uiOutput(ns("rank"))
      , fluidRow(
        column(3,
              uiOutput(ns("homeprice"))
              ,uiOutput(ns("rent"))
              ,div(class="out-text",uiOutput(ns("ziplink")))
              ),
        column(3,
               uiOutput(ns("yoy_value"))
               ,uiOutput(ns("yoy_rent"))
              # , uiOutput(ns("rank"))
        )#,
       # column(6,#,offset=1,
        #       uiOutput(ns("plot_title"))
       #        , fillPage(plotly::plotlyOutput(ns("value_plot"), height = "80%"))
        )
      )
    , absolutePanel(id="plot-container"
                    , class= "out-panel"
                    , h2(class="out-header",id="filler", paste0("."))
                    , div(id="plot-text",uiOutput(ns("plot_title")))
                    , fixed=TRUE
                    , plotly::plotlyOutput(ns("value_plot"),width="100%", height="75%")
                    )
    )
}

#' zip_detail_panel Server Function
#'
#' @noRd 
mod_zip_detail_panel_server <- function(input, output, session,r){
  ns <- session$ns
  
  link <- reactive({
    r$mod_base_leaflet$shape_click

    })
  
  click_data <- reactive({
    l <- link()
    zip_dataset@data[zip_dataset@data$GEOID10==l,]
  })
  
  rank_data <- reactive({
    l <- link()
    pop <- zip_dataset@data %>%
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
  })
  
  output$ziplink <- renderUI({
    l <- link()
    if(is.null(l))
      return()
    else{tagList(a(href=paste0("https://www.zillow.com/los-angeles-ca-",l,"/"),"Zillow listings for this Zip",target="_blank"))}#"Click link for Zillow listing for this Zip"))
    })
  
  
output$zipdetail <- renderUI({
  d <- click_data()
  l <- link()
  if(is.null(l))
    {p(id="out-header-no-selection","Click on a Zip to See Data")}
  else{h2(class="out-header",paste0(d$name," (",l,")" ))}
})

output$plot_title <- renderUI({
  l <- link()
  if(is.null(l))
    return()
  else{HTML(paste0("<b>", "2YR Home Value Trend", "<b/>"))}
})


output$homeprice <- renderUI({
  d <- click_data()
  l <- link()
  if(is.null(l))
    return()
  else{
    tagList(
       p(id="out-bigtext-title","ZHVI (Home Values)")
      , h2(id="out-bigtext",scales::dollar(d$home_prices))
    )
    }
})

output$rent <- renderUI({
  d <- click_data()
  l <- link()
  if(is.null(l))
    return()
  else{
    tagList(
      p(id="out-bigtext-title","ZORI (Rent Index)")
      , if(is.na(d$market_rent)==TRUE){h2(id="out-bigtext",paste("No Data"))}
      else{h2(id="out-bigtext",scales::dollar(d$market_rent))}
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
    if(nrow(d)==0) {p(id="rank-text",paste("Selected zipcode is not in filtered results"))}
    else{
      tagList(
        div(id="rank-text",HTML(paste0("Zip with the ","<b>",scales::ordinal(d[,2]),"</b>"," lowest home values in your selection (of ",d[,3], " zips)")))
      )
    }
    )
  }
})

output$value_plot <- plotly::renderPlotly({
  l <- link()
  if(is.null(l))
    return()
  else{
    d <- zillow_historicals[zillow_historicals$zip_code==l,]
    gg(d)
  }
})

output$yoy_value <- renderUI({
  l <- link()
  if(is.null(l))
    return()
  else{
    d <- zillow_historicals[zillow_historicals$zip_code==l,]
    yoy <- unlist(d[nrow(d),c("home_prices")]/d[nrow(d)-12,c("home_prices")]-1)
    tagList(
    p(id="out-bigtext-title","1YR ZHVI Change")
    , h2(id="out-bigtext", scales::percent(yoy,accuracy=0.01))
    )
  }
})

output$yoy_rent <- renderUI({
  l <- link()
  if(is.null(l))
    return()
  else{
    d <- zillow_historicals[zillow_historicals$zip_code==l,]
    if(is.na(d$market_rent))
    {tagList(
      p(id="out-bigtext-title","1YR ZORI Change")
      ,h2(id="out-bigtext",paste("No Data"))
      )}
    else{
    yoy <- unlist(d[nrow(d),c("market_rent")]/d[nrow(d)-12,c("market_rent")]-1)
    tagList(
      p(id="out-bigtext-title","1YR ZORI Change")
      , h2(id="out-bigtext", scales::percent(yoy,accuracy=0.01))
    )}
  }
})

}
## To be copied in the UI
# mod_zip_detail_panel_ui("zip_detail_panel_ui_1")
    
## To be copied in the server
# callModule(mod_zip_detail_panel_server, "zip_detail_panel_ui_1")