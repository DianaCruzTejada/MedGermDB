# Codes to join the MedGermDB files


#Load MedGermDB Germination File
germ.file <- read.csv("data/GerminationFile.csv")

#Load MedGermDB Taxa File
taxa.file = read.csv("data/TaxaFile.csv",header = TRUE, sep = ";", quote = "\"", stringsAsFactors = FALSE)

#Load MedGermDB Habitat File
habitat.file = read.csv("data/HabitatFile.csv",header = TRUE, sep = ",", quote = "\"", stringsAsFactors = FALSE)

# To join Germination File and Taxa File
GermTaxa <- merge(germ.file,taxa.file,by="accepted_binomial",all.x = TRUE)
####** there are some duplicates because in some cases one accepted_binomial has more than one EUNIS name

# To join Germination File and Habitat File
GermHabitat <- merge(germ.file,habitat.file,by="accepted_binomial",all.x = TRUE)
####** there are some duplicates because frequently one species are present in more than one habitat



