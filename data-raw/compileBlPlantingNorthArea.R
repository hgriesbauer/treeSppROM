# Script to compile planted Bl and Ba in north regions

# load original dataset
dat<-readr::read_csv("data-raw/Bl_Ba_Planting_4Regions_February2020.csv")

# Determine if there are any rows that are duplicated
# Remove any duplicated rows
# Nothing duplicated so that's good
identical(nrow(dat),nrow(dplyr::distinct(dat)))

# Rename and select columns of choice
blDat<-  
  dat %>% 
  dplyr::select(ACTIVITY_TREATMENT_UNIT_ID,
                OPENING_ID,
                AREA=ACTUAL_TREATMENT_AREA, # note: area is total unit area, not prorated for species comp
                SPECIES=SILV_TREE_SPECIES_CODE,
                NUMBER_PLANTED,
                SEEDLOT_NUMBER,
                PLANTING_DATE=ATU_COMPLETION_DATE, # I'm confident this is the planting date, but could do a bit more digging to double check
                REGION=REGION_CODE,
                DISTRICT=DISTRICT_CODE,
                BGC_ZONE=contains("BGC_ZONE_CODE"),
                BGC_SUBZONE=contains("BGC_SUBZONE_CODE")
                ) %>% 
  mutate(YEAR=lubridate::year(PLANTING_DATE)) %>%  # extract year
  mutate(BGC_SUBZONE=tolower(BGC_SUBZONE)) %>% # ensure that all subzones are lower case
  mutate(BGC=paste(BGC_ZONE,BGC_SUBZONE,sep="")) # create BGC unit column

# Some entries are missing BGC codes:
# I can download geometry for these openings and get BEC data for them in a separate file
blDat[blDat$BGC=="NANA",] %>% 
  group_by(SPECIES) %>% 
  summarise(Num.Openings=n(),
            Num.Trees=sum(NUMBER_PLANTED))


