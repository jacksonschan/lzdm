# ZipValue LA County Zip Explorer

<!-- badges: start -->
<!-- badges: end -->

The purpose of ZipValue is to make exploring real estate in LA County easier by visualizing home value data by zip code. 

+ See the live version at <https://zipvalue.shinyapps.io/lzdm/>

+ You can install and run the tool locally with:
```
devtools::install_github("jacksonschan/lzdm")
shiny::runGitHub("jacksonschan/lzdm")
```
## Releases

+ 2020-08-06 - v0.1: First release with ZHVI home values filter/view only

## Data Sources

+ Data Files: 
    - Shapefile to zip level data mapping: `data-raw/lzdm_dataset.R` <https://github.com/jacksonschan/lzdm/blob/data-raw/lzdm_dataset.R>
    - Home value/rent historicals `data-raw/zillow_historicals.R` <https://github.com/jacksonschan/lzdm/blob/data-raw/zillow_historicals.R>

+ Home Prices by Zip: Imported from most updated Zillow's Home Value Index (ZHVI) for All Homes <https://www.zillow.com/research/data/>

+ Rent by Zip: Imported from most updated Zillow's Observed Rent Index (ZORI) for All Homes <https://www.zillow.com/research/data/>

+ LA County Zip Codes and Zip Code Neighborhood Names:  <http://file.lacounty.gov/SDSInter/lac/1031552_MasterZipCodes.pdf>

+ ZCTAS Boundaries: Imported from US Census Bureau via `tigris` package <https://www.census.gov/programs-surveys/geography/guidance/geo-areas/zctas.html>

## CSS

+ Added with `dev/02_dev.R` <https://github.com/jacksonschan/lzdm/blob/development/dev/02_dev.R>

+ Personnalized in `inst/app/www/custom.css` <https://github.com/jacksonschan/lzdm/blob/development/inst/app/www/out_panels.css>

+ Linked to the app at `R/app_ui.R` <https://github.com/jacksonschan/lzdm/blob/development/R/app_ui.R>

<hr>

Please note that the 'lzdm' project is released with a
[Contributor Code of Conduct](CODE_OF_CONDUCT.md).
By contributing to this project, you agree to abide by its terms.