library(tidyverse)
library(reshape2)
library(tibble)

## CSD REGION ANALYSIS
# read in csd sliding window file
csd_df = read.csv("CSD_sliding_window_pi.csv", sep="\t", check.names = FALSE)
# get rid of the novogene number for the plots
names(csd_df) <- sub("^\\d+_", "", names(csd_df))

# read in the metadata file
all_meta = read.csv("/home/stephen/Documents/Thesis/Pool-seq_datasheet.csv")

# transpose it so the sample names are a column
csd_df_t = t(csd_df)
# make the first row (POSs) the column names
csd_df_t = csd_df_t %>%
  row_to_names(row_number = 1)

# turn it back into a dataframe
csd_df_t = as.data.frame(csd_df_t)

# make a new column from our rownames (sample names)
csd_df_t <- tibble::rownames_to_column(csd_df_t, "Colony.Name")

# merge the two dataframe by the new common column 
csd_meta = merge(all_meta, csd_df_t, by="Colony.Name")

# extract only the columns we want
drops <- c("Latitude", "Longitude", "Novogene.Sample.Number", 
           "Sequences..millions.", "GC.", "X", "Mapped.to.Bee", "Number.of.bees", 
           "Unmapped.Sequence.Count", "DNA.concentration.ng.microL", "DNA.quality.260.280",
           "GC..1", "DNA.quality.260.230", "Sequence.length", "Sequences..millions..1",
           "Mapped.to.Bee.1", "Unmapped.Sequence.Count.1","County", "Treatment", "Type")
csd_meta_species= csd_meta[ , !(names(csd_meta) %in% drops)]

# check to see if all of our samples are present
length(csd_meta_species$Colony.Name)
setdiff(csd_df_t$Colony.Name,csd_meta_species$Colony.Name)

# plot our line plot for the whole CSD gene
df.m <- melt(csd_meta_species, id.vars=c("Colony.Name", "Species"))
ggplot(data = df.m,
       aes(x = variable, y = as.numeric(value), group = Species, 
           shape = Species, color = Species)) +
  stat_summary(fun = "mean", geom = "point", size=0.8)+
  scale_x_discrete(breaks= seq(11771150,11781650, 1000)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  coord_cartesian(ylim = c(0, 0.065)) + 
  geom_smooth(method="loess", size=0.7, se=F) +
  ggtitle("CSD nucleotide diversity by hybrid status")+
  xlab("Genomic position") +
  ylab("Nucleotide diversity") +
  theme_minimal()


## HYPERVARIABLE REGION PLOT (BY SPECIES)

# Filter file to contain only the HVR rows

keeps =  c("Colony.Name", "Species", 
           "11771850","11771950", "11772050",
           "11772150", "11772250", "11772350")
csd_meta_species_hvr= csd_meta[ , (names(csd_meta) %in% keeps)]

df.m <- melt(csd_meta_species_hvr, id.vars=c("Colony.Name", "Species"))
ggplot(data = df.m,
       aes(x = variable, y = as.numeric(value), group = Species, color = Species)) +
  stat_summary(fun = "mean", geom = "point")+
  scale_x_discrete(breaks= seq(11771150,11781650, 1000)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  coord_cartesian(ylim = c(0.005, 0.05)) + 
  geom_smooth(method="loess", se=F) +
  ggtitle("Hypervariable region nucleotide diversity by hybrid status")+
  xlab("Genomic position") +
  ylab("Nucleotide diversity") +
  theme_minimal()

# HYPERVARIABLE REGION BY LOCATION
library(RColorBrewer)

mycolors = c(brewer.pal(name="Dark2", n = 8), brewer.pal(name="Paired", n = 6))

keeps =  c("Colony.Name", "County", 
           "11771850","11771950", "11772050",
           "11772150", "11772250", "11772350")
csd_meta_county_hvr= csd_meta[ , (names(csd_meta) %in% keeps)]

df.m <- melt(csd_meta_county_hvr, id.vars=c("Colony.Name", "County"))
ggplot(data = df.m,
       aes(x = variable, y = as.numeric(value), group = County, shape = County, color = County)) +
  stat_summary(fun = "mean", geom = "point")+
  scale_x_discrete(breaks= seq(11771150,11781650, 1000)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  coord_cartesian(ylim = c(0.005, 0.05)) + 
  geom_smooth(method="loess", se=F, size = 0.5) +
  ggtitle("Hypervariable region nucleotide diversity by geographic location")+
  xlab("Genomic position") +
  ylab("Nucleotide diversity") +
  scale_color_manual(values = mycolors) + 
  scale_shape_manual(values=1:14) +
  theme_minimal()
