# Read in RESULTS species monitoring files

# Billed Volume
vol<-read_csv("data-raw/RSLTRPT_BILLED_VOL.csv")

# Planting data
plant<-read_csv("data-raw/RSLTRPT_PLANT_BY_SPEC.csv")

# Regen forest cover
regen<-read_csv("data-raw/RSLTRPT_REGEN_FC.csv")

# compile into variable
romSpecies<-list(vol=vol,
                 plant=plant,
                 regen=regen)

# save variable
save(romSpecies,file="data/romSpecies.RData")
