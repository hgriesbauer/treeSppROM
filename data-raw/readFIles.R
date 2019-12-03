# R script to process raw data from various RESULTS files

library(readr)
library(tidyverse)

# Define species of interest
speciesList=c("BL")

# Read in inventory data
# invROM <- read_csv("data-raw/RESULTS_inventory_report_December2_2019.csv")

## PLANTING DATA
# Read in planting data
plantROM <- read_csv("data-raw/RESULTS_planting_report_December2_2019.csv")
  
  plantedSPP<- # assign variable
    plantROM %>% 
    filter(SILV_TREE_SPECIES_CODE%in%speciesList) %>%  # filter for species of interst
    dplyr::select(1:3,
                  AREA=ACTUAL_TREATMENT_AREA,
                  SPP=SILV_TREE_SPECIES_CODE,
                  PLANTED=NUMBER_PLANTED,
                  SEEDLOT=SEEDLOT_NUMBER,
                  DATE=ATU_COMPLETION_DATE,
                  DISTRICT=DISTRICT_NAME,
                  ZONE=GENERALIZED_BGC_ZONE_CODE,
                  GENERALIZED_BGC_SUBZONE_CODE,
                  GENERALIZED_BGC_VARIANT,
                  GENERALIZED_BEC_SITE_SERIES,
                  DISTURBANCE_DATE=DISTURBANCE_START_DATE
                  )
  
## SILVICULTURE DATA
  silvROM<-read_csv("data-raw/RESULTS_silviculture_report_December2_2019.csv")
    
  silvSPP<-# assign variable
    silvROM %>% # take raw data and
    filter(S_SPECIES_CODE_1%in%speciesList|
             S_SPECIES_CODE_2%in%speciesList|
             S_SPECIES_CODE_3%in%speciesList|
             S_SPECIES_CODE_4%in%speciesList|
             S_SPECIES_CODE_5%in%speciesList) %>% 
    dplyr::select(1:7,
                  YEAR=REFERENCE_YEAR,
                  SITE_INDEX,
                  starts_with("S_SPECIES_"),
                  SPH=S_TOTAL_STEMS_PER_HA,
                  WS=S_TOTAL_WELL_SPACED_STEMS_HA,
                  ZONE=BGC_ZONE_CODE,
                  SUBZONE=BGC_SUBZONE_CODE,
                  VARIANT=BGC_VARIANT,
                  SITE_SERIES=BEC_SITE_SERIESs
            )