# Building a Prod-Ready, Robust Shiny Application.
# 
# README: each step of the dev files is optional, and you don't have to 
# fill every dev scripts before getting started. 
# 01_start.R should be filled at start. 
# 02_dev.R should be used to keep track of your development during the project.
# 03_deploy.R should be used once you need to deploy your app.
# 
# 
###################################
#### CURRENT FILE: DEV SCRIPT #####
###################################

# Engineering

## Dependencies ----
## Add one line by package you want to add as dependency
usethis::use_package( "shiny" )
usethis::use_package( "dplyr" )
usethis::use_package( "ggplot2" )
usethis::use_package( "tidyr" )
usethis::use_package( "lubridate" )
usethis::use_package( "sf" )
usethis::use_package( "tigris" )
usethis::use_package( "leaflet" )
usethis::use_package( "rgdal" )
usethis::use_package( "htmltools" )
usethis::use_package( "DT" )
usethis::use_package( "scales" )
usethis::use_package( "plotly" )
usethis::use_package( "stringr" )
usethis::use_package( "htmlwidgets" )
usethis::use_package( "grDevices" )
usethis::use_package( "RColorBrewer" )

## Add modules ----
## Create a module infrastructure in R/
golem::add_module( name = "base_leaflet" ) # Name of the module
golem::add_module( name = "zip_detail_panel" )
golem::add_module( name = "top_zipcodes_panel" )
golem::add_module( name = "inputs_panel" )
golem::add_module( name = "user_inputs" )
golem::add_module( name = "title_panel" )
golem::add_module( name = "metric_selection" )
#golem::add_module( name = "name_of_module2" ) # Name of the module

## Add helper functions ----
## Creates ftc_* and utils_*
golem::add_fct( "ggplot" ) 

## External resources
## Creates .js and .css files at inst/app/www
golem::add_css_file( "out_panels" )

## Add internal datasets ----
## If you have data in your package
usethis::use_data_raw( name="lzdm_dataset", open = FALSE) 
usethis::use_data_raw( name="zillow_historicals", open = FALSE) 

## Tests ----
## Add one line by test you want to create
usethis::use_test( "app" )

# Documentation

## Vignette ----
usethis::use_vignette("lzdm")
devtools::build_vignettes()

## Code coverage ----
## (You'll need GitHub there)
usethis::use_github()
#usethis::use_travis()
#usethis::use_appveyor()

# You're now set! ----
# go to dev/03_deploy.R
rstudioapi::navigateToFile("dev/03_deploy.R")

install.packages("rgdal")
