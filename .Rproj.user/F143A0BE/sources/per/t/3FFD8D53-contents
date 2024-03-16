#Visualization app
library(maps); library(dplyr); library(ggplot2);library(data.table)
#load("results/appdata.RData")

#Map
mapplot <- function(coord_sf) {
ggplot() +
  geom_sf(data = world, fill = "gainsboro", color = "darkgray") +
  geom_sf(data = shapefile, fill = rgb(0, 1, 0, alpha = 0.1), color ="darkgray")+
  geom_sf(data = coord_sf, color = "black", size = 3, alpha = 0.8)+
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
}
#Germination plot
seedplot <- function(Germination) {
  ggplot(Germination, aes(x = as.factor(temperature), y = mean, ymin = lower, ymax = upper, fill = Experiment)) + 
    geom_bar(stat = "identity", alpha = 0.6, show.legend = FALSE) + 
    geom_errorbar(aes(color = Experiment), width = 0.1, size = 1, 
                  position = position_dodge(.9), show.legend = FALSE) +
    coord_cartesian(ylim = c(0, 1)) +
    labs(title = "Seed germination tests", subtitle = "Bars are the mean germination proportions,\n brackets the binomial confidence intervals.") +
    ylab(label = "Germination proportion") + xlab(label = "Average germination temperature (C)") +
    theme(text = element_text(size = 12),
          plot.title = element_text(face = c("bold"), size = 14),
          plot.subtitle = element_text(face = c("italic"))) +
    theme(panel.background = element_blank(),panel.grid.minor = element_line(color = "gainsboro"))+
    facet_wrap( ~ Experiment, scales = "free", ncol = 4)
}

#References table
references <- function(df1 = dat1, sp = "Achillea maritima") {
  filter(df1, accepted_binomial == sp) %>%
    select(doi) %>%
    unique %>%
    arrange(doi) %>%
    rename(Doi = doi) %>%
    as_tibble
}

#Taxonomic information
taxanomic <- function(df2 = taxa.file, sp = "Achillea maritima") {
  filter(df2,accepted_binomial == sp) %>%
    select(EUNIS_name,accepted_binomial, family, order, APG_clade) %>%
    as_tibble
}
#Habitat information
habitat <- function(habitat.file, sp = "Achillea maritima") {
  filter(habitat.file,accepted_binomial == sp) %>%
    select(species_type,Habitat_level.1, Habitat_level.3) %>%
    as_tibble
}

