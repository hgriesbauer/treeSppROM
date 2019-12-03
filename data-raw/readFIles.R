# R script to process raw data from various RESULTS files

library(readr)
library(tidyverse)
library(magrittr)

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
  save(plantedSPP,file="data/plantedBL_ROM.RData")
  
  
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
                  WS=S_WELL_SPACED_STEMS_PER_HA,
                  WS2=S_TOTAL_WELL_SPACED_STEMS_HA,
                  ZONE=BGC_ZONE_CODE,
                  SUBZONE=BGC_SUBZONE_CODE,
                  VARIANT=BGC_VARIANT,
                  SITE_SERIES=BEC_SITE_SERIES,
                  DISTRICT=DISTRICT_NAME
                  ) %>% 
    
    # use wither WS or WS2 column (seems data isn't consistent)
    
    
    
    # formatting to pivot multiple columns

    unite(col=Species_1,ends_with("_1"),sep="_") %>%
    unite(col=Species_2,ends_with("_2"),sep="_") %>%
    unite(col=Species_3,ends_with("_3"),sep="_") %>%
    unite(col=Species_4,ends_with("_4"),sep="_") %>%
    unite(col=Species_5,ends_with("_5"),sep="_") %>% 
    
    # pivot longer to allow for summaries
    pivot_longer(
      cols=starts_with("Species_"),
      names_to="SPECIES_RANK",
      values_to = "value") %>%
    
    # Remove rows with NA values 
    filter(value!="NA_NA") %>%   
    
    # extract species information
    mutate(SPECIES_CODE=stringr::str_split(value,"_",simplify = TRUE)[,1]) %>%
    mutate(SPECIES_PCT=stringr::str_split(value,"_",simplify = TRUE)[,2]) %>%
    mutate(SPECIES_AGE=stringr::str_split(value,"_",simplify = TRUE)[,3]) %>%
    mutate(SPECIES_HT=stringr::str_split(value,"_",simplify = TRUE)[,4]) %>%
    filter(SPECIES_CODE!="NA")  # remove any rows with NA in SPECIES_CODE
    
    # some formatting that I can't figure out how to do in a pipe
      silvSPP$WS[is.na(silvSPP$WS)]=silvSPP$WS2[is.na(silvSPP$WS)]
  
    # adjust well spaced stems based on species percentages
    silvSPP%<>%
      mutate(WSH=round(WS*as.numeric(SPECIES_PCT)/100,0)) %>% 
      select(-WS,-WS2,-value) %>%  # get rid of original WS and WS2 columns, they are now in WSH
      select(1:9,starts_with("SPECIES"),WSH,everything())
    
    save(silvSPP,file="data/silvBL_ROM.RData")
  
  ## TREE SPECIES REPORT FROM RESULTS
  treeSPP<-read_csv("data-raw/RESULTS_species_report_December2_2019.csv")
  