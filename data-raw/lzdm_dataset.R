## code to prepare `lzdm_dataset` dataset goes here

library(rgdal)
library(dplyr)
library(readr)
library(tidyr)
library(tigris)
library(pdftools)
library(stringr)
options(scipen = 999)

###load updated Zillow home data 

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
  pivot_longer(
    cols = 4:ncol(r)
    , names_to = "month"
    , values_to = "market_rent"
  ) %>%
  filter(.,month==last(month)) %>%
  select(.,RegionName,market_rent) %>%
  rename(zip_code = RegionName) %>%
  mutate(zip_code = as.factor(zip_code), market_rent= as.numeric(market_rent)) 

### join home price and rent data
d1 <- dplyr::left_join(x=h1,y=r1,by="zip_code")

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

