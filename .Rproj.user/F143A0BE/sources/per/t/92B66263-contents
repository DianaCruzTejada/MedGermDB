#Load packages 
library(dplyr); library(sp); library(readr); library(tidyr);library(metafor); library(binom); library(data.table); library(ggplot2); library(sf);
library(rsconnect)


#Load files for the app  ************#

#Load MedGermDB Germination File
dat1 <- read.csv("data/GerminationFile.csv")

#Load MedGermDB Taxa File
taxa.file = read.csv("data/TaxaFile.csv",header = TRUE, sep = ";", quote = "\"", stringsAsFactors = FALSE)

#Load MedGermDB Habitat File
habitat.file = read.csv("data/HabitatFile.csv",header = TRUE, sep = ",", quote = "\"", stringsAsFactors = FALSE)

# Load coordinates spacial data frame
coord_sf <- st_read("data/coord_sf.shp")
#coord_sf <- readRDS("data/coord_sf.rds")

# Load Germination grouped data
df <- fread("data/df.csv")

# Load map files
shapefile <- st_read("data/Map files/MedBasin_21-07-23.shp")
world  <- st_read("data/Map files/WorldRectMap.shp")


### A function to metanalize proportions:
metanalize <- function(d) 
{
  m <- rma.glmm(measure = "PLO", xi = seeds_germinated, ni = seeds_sown, data = d)
  p <- predict(m, transf = transf.ilogit, digits = 3)
  data.frame(mean = p$pred, lower = p$ci.lb, upper = p$ci.ub)
}


#### First we check for which groups the metanalysis works:
listd <- split(df, by = "group", drop = TRUE)
ms <- lapply(listd, function(d) tryCatch(metanalize(d), error = function(e) e))
rma.works <- names(ms)[lapply(ms, length) >= 3]

#### Now we do the MA for the species that work
df.rma <- df[group %in% rma.works]
df.rma %>%
  group_by(group) %>%
  do(metanalize(.)) %>%
  group_by -> rma.species

#### And for the rest, we simply calculate the proportions and CI
df[! group %in% rma.works] %>% 
  group_by(group) %>%
  summarise(seeds_germinated = sum(seeds_germinated), seeds_sown = sum(seeds_sown)) %>%
  data.frame -> GermDF

cbind(group = GermDF[, 1],
      binom.confint(GermDF$seeds_germinated, GermDF$seeds_sown, method = "wilson")[, 4:6]) %>%
  as_tibble()-> germdf

#### join both groups of dataframes
rbind(germdf, rma.species)  %>%
  separate(group, into = c("species", "scarification", "stratification",
                           "light", "alternating", "temperature"), sep = "_", 
           convert = TRUE) %>%
  mutate(light = ifelse(is.na(light), "Light unknown", light),
         species = as.factor(species), 
         scarification = as.factor(scarification), 
         stratification = as.factor(stratification),
         light = as.factor(light), 
         alternating = as.factor(alternating),
         scarification = recode_factor(scarification, "none" = "Unscarified", "yes" = "Scarified"),
         stratification = recode_factor(stratification, "none" = "Non-stratified", "yes" = "Stratified"),
         light = recode_factor(light, "0" = "Darkness", "1" = "Light"), 
         alternating = recode_factor(alternating, "no" = "Constant temperature", 
                                     "yes" = "Alternating temperature"),
         Experiment = paste(light, alternating, stratification, scarification, sep = ",\n"),
         Experiment = as.factor(Experiment)) -> Germination

save(Germination, dat1, shapefile, metanalize,coord_sf,world,dat1,taxa.file,habitat.file,
     file = here::here("results", "appdata.RData"))
