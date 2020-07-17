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


# ## load oc zip code names
# oc.d <- read_csv("https://enjoyorangecounty.com/wp-content/uploads/2018/05/zip-codes-in-orange-county.csv")
# 
# oc.d$`ZIP Code` <- stringr::str_remove_all(oc.d$`ZIP Code`,"ZIP Code ")
# 
# oc_df <- data.frame("zip_code" = oc.d$`ZIP Code`, "name" = oc.d$City)

## union la and oc zip code names
#dff <- rbind(la_df,oc_df)
#dff <- dff[is.na(df$name)==FALSE,]

## join data to zip code names
lac_zctas_data <- geo_join(lac_zctas_data, 
                           la_df, 
                           by_sp = "GEOID10", 
                           by_df = "zip_code",
                           how = "inner")
lac_zctas_data@data$name <- str_squish(lac_zctas_data@data$name)

#lac_zctas_data@data$name <- str_replace_na(lac_zctas_data@data$name,"")

usethis::use_data(lac_zctas_data, overwrite = TRUE)
