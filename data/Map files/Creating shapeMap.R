library(sf); library(tidyr); library(dplyr); library(ggplot2)

#crs(your_shapefile) <- "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"  
#plot(your_shapefile[2])
#plot(your_shapefile[3])
#require(rgdal)
#shape <- readOGR(dsn = "C:/Users/Diana Cruz/OneDrive - University of Pisa/Documenti/PhD UNIPI_Home/MedGermDB_folder/DATASETS creation_MedGermDB/Map files/", layer = "MedBasinShape_map")

## Create a Coordinates dataframe
setwd("C:\\Users\\Diana Cruz\\OneDrive - University of Pisa\\Documenti\\PhD UNIPI_Home\\MedGermDB_folder\\GitHub_MedGermDB\\data")
dat1 = read.csv("GerminationFile.csv",header = TRUE, sep = ",", quote = "\"", stringsAsFactors = FALSE)
# Load your shapefile
shapefile <- st_read("C:\\Users\\Diana Cruz\\OneDrive - University of Pisa\\Documenti\\PhD UNIPI_Home\\MedGermDB_folder\\DATASETS creation_MedGermDB\\Map files\\MedBasin_21-07-23.shp")
plot(shapefile)
#Coordinates dataset
dat1 %>%
  dplyr::select(accepted_binomial, longitude, latitude) %>%
  unique() -> coordinates

# Assuming your 'coordinates' data frame contains columns 'longitude' and 'latitude'
#world <- map_data("world")
#sf_data <- st_as_sf(coordinates, coords = c("longitude", "latitude"), crs = 4326)
#sf_world <- st_as_sf(map_data("world"),coords = c("long", "lat"), crs = 4326)
#coords_world <- st_coordinates(sf_world)
#coords_world = as.data.frame(coords_world)

#Creating the map
ggplot() + 
  geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group),
                 color = "gray", fill = "gainsboro", alpha = 0.5) +
  coord_cartesian(xlim = c(-10, 50), ylim = c(25, 50)) +
  geom_sf(data = shapefile, fill = "blue", color = "black", alpha = 0.5)

# Check the structure of the shapefile to see the geometry column name
st_geometry(shapefile)

# Extract the data from the sf object as a data frame
shapefile_df <- as.data.frame(shapefile)

# Create a new "group" column for the shapefile_df
shapefile_df <- shapefile_df %>%
  mutate(group = 1)

# Plotting the world map and shapefile using geom_polygon
ggplot() +
  geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group), color = "gray", fill = "gainsboro", alpha = 0.5) +
  geom_polygon(data = shapefile_df, aes(x = long, y = lat, group = group, fill = "blue"), color = "black", alpha = 0.5) +
  coord_cartesian(xlim = c(-10, 50), ylim = c(25, 50)) +
  guides(fill = "none")  # To remove the legend for the shapefile



f2a <- ggplot() + 
  geom_polygon(data = map_data("world"), aes(x = long, y = lat, group = group), 
               color = "gray", fill = "gainsboro", alpha = 0.5) +
  coord_cartesian(xlim = c(-10, 50), ylim = c(25, 50)) +
  geom_point(data = coordinates, 
             aes(x = longitude, y = latitude), 
             color = "gold", size = 2, alpha = 0.8) +
  labs(title = "Origin of the germination records.", 
       subtitle = "The golden circles are the coordinates of the seed lots used in the experiments") +
  theme(axis.line = element_blank(), axis.text.x = element_blank(),
        axis.text.y = element_blank(), axis.ticks = element_blank(),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        legend.position = "none", panel.background = element_blank(),
        panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), plot.background = element_blank(),
        text = element_text(size = 12),
        plot.title = element_text(face = c("bold"), size = 14),
        plot.subtitle = element_text(face = c("italic"))) +
  geom_sf(data = your_shapefile, fill = "blue", color = "black", alpha = 0.5)

print(f2a)



# Continue with your existing ggplot code and add the geom_sf() layer
f2a <- ggplot() + 
  geom_polygon(data = coords_world, aes(x = X, y = Y), 
               color = "gray", fill = "gainsboro", alpha = 0.5) +
    coord_cartesian(xlim = c(-10, 50), ylim = c(25, 50))+
  geom_sf(data = your_shapefile, color = "black", fill = NA)+
  
  labs(title = "Origin of the germination records.", 
       subtitle = "The golden circles are the coordinates of the seed lots used in the experiments") +
  theme(axis.line = element_blank(), axis.text.x = element_blank(),
        axis.text.y = element_blank(), axis.ticks = element_blank(),
        axis.title.x = element_blank(), axis.title.y = element_blank(),
        legend.position = "none", panel.background = element_blank(),
        panel.border = element_blank(), panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), plot.background = element_blank(),
        text = element_text(size = 12),
        plot.title = element_text(face = c("bold"), size = 14),
        plot.subtitle = element_text(face = c("italic")))
+
  geom_point(color = "gold", size = 4, alpha = 0.8) +
   +
    # Add the shapefile as a new layer using geom_sf()
  geom_sf(data = your_shapefile[1], fill = "blue", color = "black", alpha = 0.5)
  #geom_polygon(data = your_shapefile[1], fill = "blue", color = "black", alpha = 0.5)
  
# Plot the figure
plot(shape[1])
plot(f2a, add=T)
print(f2a)

a <- map_data("world")
