## code to prepare `zillow_historicals` dataset goes here

library(rgdal)
library(dplyr)
library(readr)
library(tidyr)
library(tigris)
library(pdftools)
library(stringr)
library(lubridate)
options(scipen = 999)

###load updated Zillow home data 
h <- read_csv("http://files.zillowstatic.com/research/public_v2/zhvi/Zip_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_mon.csv") #home values
r <- read_csv("http://files.zillowstatic.com/research/public_v2/zori/Zip_ZORI_AllHomesPlusMultifamily_SSA.csv") #rent

###filter for Los Angeles County and pivot home price years and #filter most updated qtr and relevant columns only - housing price

h1 <- h %>%
  filter(grepl("Los Angeles", h$Metro, ignore.case = TRUE)) %>%
  select(.,-c(10:(ncol(h)-24))) %>%
  pivot_longer(
    cols = 10:ncol(.)
    , names_to = "month"
    , values_to = "home_prices"
  ) %>%
  select(.,RegionName,month,home_prices) %>%
  rename(zip_code = RegionName) %>%
  mutate(month=str_sub(month,1,7),zip_code = as.factor(zip_code), home_prices = as.numeric(home_prices)) 

###filter for Los Angeles County and pivot home price years and #filter most updated qtr and relevant columns only - rent
r1 <- r %>%
  select(.,-c(4:(ncol(r)-24))) %>%
  pivot_longer(
    cols = 4:ncol(.)
    , names_to = "month"
    , values_to = "market_rent"
  ) %>%
  select(.,RegionName,month,market_rent) %>%
  rename(zip_code = RegionName) %>%
  mutate(zip_code = as.factor(zip_code), market_rent= as.numeric(market_rent)) 

### join home price and rent data
zillow_historicals <- dplyr::left_join(x=h1,y=r1,by=c("zip_code"="zip_code","month"="month"))
zillow_historicals <- zillow_historicals %>% 
  dplyr::mutate(month=ymd(str_c(month,"-01")))

### deploy
usethis::use_data(zillow_historicals, overwrite = TRUE)

