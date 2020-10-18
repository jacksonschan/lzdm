## code to prepare `lzdm_dataset` dataset goes here

library(rgdal)
library(dplyr)
library(readr)
library(tidyr)
library(tigris)
library(pdftools)
library(stringr)
options(scipen = 999)


z <- read_csv("http://files.zillowstatic.com/research/public_v2/zhvf/AllRegionsForPublic.csv") #zillow 1 year forecast

h <- read_csv("http://files.zillowstatic.com/research/public_v2/zhvi/Zip_zhvi_uc_sfrcondo_tier_0.33_0.67_sm_sa_mon.csv") #home values

r <- read_csv("http://files.zillowstatic.com/research/public_v2/zori/Zip_ZORI_AllHomesPlusMultifamily_SSA.csv") #rent

###filter for Los Angeles County and pivot home price years and #filter most updated qtr and relevant columns only - housing price

h1 <- h %>%
  filter(grepl("Los Angeles", h$Metro, ignore.case = TRUE)) %>%
  pivot_longer(
    cols = 10:ncol(h)
    , names_to = "month"
    , values_to = "home_prices"
  ) %>%
  filter(.,month==last(month)) %>%
  select(.,RegionName,home_prices) %>%
  rename(zip_code = RegionName) %>%
  mutate(zip_code = as.factor(zip_code), home_prices = as.numeric(home_prices)) 

###filter for Los Angeles County and pivot home price years and #filter most updated qtr and relevant columns only - rent

r1 <- r %>%
  dplyr::select(-SizeRank,-MsaName,-RegionID) %>%
  tidyr::pivot_longer(
    cols = 2:ncol(.)
    , names_to = "month"
    , values_to = "market_rent"
  ) %>%
  dplyr::filter(.,month==last(month)) %>%
  dplyr::select(.,RegionName,market_rent) %>%
  dplyr::rename(zip_code = RegionName) %>%
  dplyr::mutate(zip_code = as.factor(zip_code), market_rent= as.numeric(market_rent)) 

### filter for LA County
z1 <- z %>% 
  dplyr::filter(.,Region=="Zip", CountyName %in% c("Los Angeles County","Ventura County","Orange County")) %>%
  dplyr::select("zip_code"=RegionName, "forecast"=ForecastYoYPctChange)

### calc YoY  

y1 <- zillow_historicals[,1:3] %>%
  dplyr::mutate(.
                ,yoy=home_prices/dplyr::lag(home_prices,11)-1
                ,yo2y=home_prices/dplyr::lag(home_prices,23)-1
                ,yo3y=home_prices/dplyr::lag(home_prices,35)-1
                ,yo4y=home_prices/dplyr::lag(home_prices,47)-1
                ,yo5y=home_prices/dplyr::lag(home_prices,59)-1
                ) %>%
  dplyr::group_by(zip_code) %>%
  dplyr::summarise(.
                   ,yoy = dplyr::last(yoy, order_by=month)
                   ,yo2y = dplyr::last(yo2y, order_by=month)
                   ,yo3y = dplyr::last(yo3y, order_by=month)
                   ,yo4y = dplyr::last(yo4y, order_by=month)
                   ,yo5y = dplyr::last(yo5y, order_by=month))

### calc Max value 
max <- h %>%
  dplyr::filter(grepl("Los Angeles", h$Metro, ignore.case = TRUE)) %>%
  tidyr::pivot_longer(
    cols = 10:ncol(h)
    , names_to = "month"
    , values_to = "home_prices"
  ) %>%
  dplyr::group_by(RegionName) %>%
  dplyr::filter(home_prices == max(na.omit(home_prices))) %>%
  dplyr::select(.,RegionName,home_prices,month) %>%
  dplyr::rename(zip_code = RegionName, max_price=home_prices, max_month=month) %>%
  dplyr::mutate(zip_code = as.factor(zip_code), max_price = as.numeric(max_price)) 


### join home price and rent data
d1 <- dplyr::left_join(x=h1,y=r1,by="zip_code") %>% 
  dplyr::left_join(x=., y=z1, by="zip_code") %>% 
  dplyr::left_join(x=.,y=y1, by="zip_code") %>%
  dplyr::left_join(x=.,y=max, by="zip_code")

#dummy feature data
d1$household_income <- round(runif(nrow(d1),10000,5000000),0)
d1$education <- round(runif(nrow(d1),1,100),0)
d1$safety <- round(runif(nrow(d1),1,100),0)

### load zip boundaries from tigris package
lac_zctas_data <- zctas(cb = TRUE, starts_with = d1$zip_code)

# join data to shapefile
lac_zctas_data <- geo_join(lac_zctas_data, 
                           d1, 
                           by_sp = "GEOID10", 
                           by_df = "zip_code",
                           how = "inner")


lac_zctas_data <- as(lac_zctas_data,'Spatial')

## load la county zip code name mapping table 
p <- pdf_text("http://file.lacounty.gov/SDSInter/lac/1031552_MasterZipCodes.pdf") %>% 
  readr::read_lines()

# correct bad imports
p[84] <- "90078 Los Angeles"
p[366] <- "91342 Lake View Terrace"
p[140] <- "90274 Palos Verdes Estates/Rolling Hills/Rolling Hills Estates"

# subset for lines of interest
pt <- p[5:530]

# remove bad strings
removal <- c(" X", "City of LA", "\\(|\\)")

# split strings
pf <- pt %>%
  str_squish() %>%
  str_remove_all(.,paste(removal, collapse = "|")) %>%
  str_split_fixed(.," ",n=2) 

# get rid of junk lines after split
df <- data.frame("zip_code" = pf[,1], "name" = pf[,2])
df$zip_code <- lapply(df$zip_code, function(x) as.numeric(as.character(x)))
la_df <- df[!is.na(df$zip_code),]
la_df$zip_code <- as.character(la_df$zip_code)

## join data to zip code names
zip_dataset <- geo_join(lac_zctas_data, 
                           la_df, 
                           by_sp = "GEOID10", 
                           by_df = "zip_code",
                           how = "inner")

## clean remaining extra spaces
zip_dataset@data$name <- str_squish(zip_dataset@data$name)
zip_dataset@data$name <- str_replace(zip_dataset@data$name, " /","/")


### deploy
usethis::use_data(zip_dataset, overwrite = TRUE)

