## code to prepare `lzdm_dataset` dataset goes here

library(rgdal)
library(dplyr)
library(readr)
library(tidyr)
library(tigris)

options(scipen = 999)

###load updated Zillow home data 
d <- read_csv("http://files.zillowstatic.com/research/public/Zip/Zip_Zhvi_AllHomes.csv")

###filter for Los Angeles County and pivot home price years and #filter most updated qtr and relevant columns only

d1 <- d %>%
  filter(grepl("Los Angeles", d$Metro, ignore.case = TRUE)) %>%
  pivot_longer(
    cols = 10:300
    , names_to = "qtr"
    , values_to = "home_prices"
  ) %>%
  filter(.,qtr==last(qtr)) %>%
  select(.,RegionName,home_prices) %>%
  rename(zip_code = RegionName) %>%
  mutate(zip_code = as.factor(zip_code), home_prices = as.numeric(home_prices)) 

#dummy data
d1$household_income <- round(runif(nrow(d1),10000,5000000),0)
d1$education <- round(runif(nrow(d1),1,100),0)
d1$safety <- round(runif(nrow(d1),1,100),0)

### load zip boundaries from tigris package
lac_zctas_data <- zctas(cb = TRUE, starts_with = d1$zip_code)

# join zillow housing data to shapefile
lac_zctas_data <- geo_join(lac_zctas_data, 
                           d1, 
                           by_sp = "GEOID10", 
                           by_df = "zip_code",
                           how = "inner")

### write file in data folder
#writeOGR(obj=lac_zctas_data,dsn="./data/joined_lac_zctas_shapedata",layer="lac_zctas_data", driver="ESRI Shapefile")


usethis::use_data(lac_zctas_data, overwrite = TRUE)
