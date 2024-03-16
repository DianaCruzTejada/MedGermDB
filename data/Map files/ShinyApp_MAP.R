library(ggplot2); library(rgdal); library(rgeos); library(sf); 
library(tidyr); library(dplyr); library(ggplot2); library(gridExtra)
library(raster); library(ggspatial)

# Load the shapefile created in QGIS
shapefile <- st_read("C:\\Users\\Diana Cruz\\OneDrive - University of Pisa\\Documenti\\PhD UNIPI_Home\\MedGermDB_folder\\DATASETS creation_MedGermDB\\Map files\\MedBasin_21-07-23.shp")
# Load the world map rectangle created in QGIS
world <- st_read("C:\\Users\\Diana Cruz\\OneDrive - University of Pisa\\Documenti\\PhD UNIPI_Home\\MedGermDB_folder\\DATASETS creation_MedGermDB\\Map files\\WorldRectMap.shp")
## Create a Coordinates dataframe
setwd("C:\\Users\\Diana Cruz\\OneDrive - University of Pisa\\Documenti\\PhD UNIPI_Home\\MedGermDB_folder\\GitHub_MedGermDB\\data")
dat1 = read.csv("GerminationFile.csv",header = TRUE, sep = ",", quote = "\"", stringsAsFactors = FALSE)
#Coordinates dataset
dat1 %>%
  dplyr::select(accepted_binomial, longitude, latitude) %>%
  unique() -> coordinates
coord_sf <- st_as_sf(coordinates, coords = c("longitude", "latitude"), crs = 4326)

#e <- extent(-10,50,25,50)
#crop(shapefile,e)

#Plot Wordl rect
ggplot() +
  geom_sf(data = world, fill = "gainsboro", color = "darkgray") +
  geom_sf(data = shapefile, fill = rgb(0, 1, 0, alpha = 0.1), color ="darkgray")+
  geom_sf(data = coord_sf, color = "gold", size = 1, alpha = 0.8)+
  labs(title = "Origin of the germination records.", 
       subtitle = "The golden circles are the coordinates of the seed lots used in the experiments")+
  theme_minimal() +  # Use theme_minimal as a base theme
  theme(axis.line=element_blank(), axis.text.x=element_blank(),
        axis.text.y=element_blank(), axis.ticks=element_blank(),
        axis.title.x=element_blank(), axis.title.y=element_blank(),
        legend.position="none", panel.background=element_blank(),
        panel.border=element_blank(), panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(), plot.background=element_blank(),
        text = element_text(size = 12),
        plot.title = element_text(face = c("bold"), size = 14),
        plot.subtitle = element_text(face = c("italic")))
      # Add Scale Bar
        #scalebar(data = coord_sf, location = "bottomleft", dist = 100, st.dist = 0.05))

# Add North Arrow and Scale Bar using geom_text or annotate
#annotate("text", x = 0.5, y = 2, label = "N", color = "black", size = 8, angle = 0))

        # annotate("text", x = 30, y = 30, label = "Scale Bar", color = "black", size = 4, hjust = 0))
        # 
  

