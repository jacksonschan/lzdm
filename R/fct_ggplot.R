<<<<<<< HEAD
library(ggplot2)
library(plotly)

=======
>>>>>>> a784b99db2dd3bc2a98b2c81209932ba2af4163b
gg <- function(g){
  g <- ggplot2::ggplot(data=g, aes(x=month,y=home_prices,group=zip_code,text=paste("Month: ", month, '<br>Home Value: ', scales::dollar(home_prices)))) + geom_line() + scale_x_date(date_breaks = "3 month", date_labels = "%m/%y") + theme(panel.background = element_rect(fill = "transparent",colour = NA),axis.title.x = element_blank(), plot.background = element_rect(fill = "transparent",colour = NA)) + labs(y= "ZHVI Home Value") + scale_y_continuous(breaks=scales::pretty_breaks(n = 10),labels = scales::dollar_format(scale=0.001,suffix="K")) 
  
  plotly::ggplotly(g,tooltip = c("text")) %>% layout(plot_bgcolor='transparent') %>% layout(paper_bgcolor='transparent')
}