df = read.csv("/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/all_D.txt", 
              sep="\t",
              stringsAsFactors = FALSE,
              check.names = FALSE)
names(df) <- sub("^\\d+_", "", names(df))

df = Filter(function(x)!all(is.na(x)), df)
drops <- c(".1",".2",".3",".4",".5", "SNPs", "Coverage", "")
df = df[ , !(names(df) %in% drops)]
df[df=="na"] <- "0"
chr_col = df$CHR
df <- mutate_all(df, function(x) as.numeric(as.character(x)))
df$CHR = chr_col
write.csv(df, "/home/stephen/Documents/Thesis/Population_model/Results/all_d_fixed.txt", row.names=FALSE, sep=",")
# get list of all average tajimas D based on group (hybrid, location etc)
# make these into separate dataframes i.e all hybrid/pure lists into one

pool_meta = read.csv("/home/stephen/Documents/Thesis/Population_model/pool-seq_metadata_tajimas.csv", 
                     sep=",",
                     stringsAsFactors = FALSE,
                     check.names = FALSE)

row.names(pool_meta) = pool_meta$`Colony Name`
row.names(pool_meta)
hybrid_colonies = rownames(pool_meta)[pool_meta$Species == "Hybrid"]
pure_colonies = rownames(pool_meta)[pool_meta$Species == "Amm"]
managed_colonies = rownames(pool_meta)[pool_meta$Type == "Managed"]
wild_colonies = rownames(pool_meta)[pool_meta$Type == "Wild"]
treated_colonies = rownames(pool_meta)[pool_meta$Treatment == "Treated"]
untreated_colonies = rownames(pool_meta)[pool_meta$Treatment == "Untreated"]


df$wild = rowMeans(subset(df, select = wild_colonies), na.rm = TRUE)
df$managed = rowMeans(subset(df, select = managed_colonies), na.rm=TRUE)

df[is.na(df)] <- 0

df_wild = subset(df, select = c("CHR", "POS", "wild"))
df_wild
write.csv(df_wild,"/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/wild_df.csv")

df_managed = subset(df, select = c("CHR", "POS", "managed"))

write.csv(df_managed,"/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/managed_df.csv")

# treated untreated python 
df$treated = rowMeans(subset(df, select = treated_colonies), na.rm = TRUE)
df$untreated = rowMeans(subset(df, select = untreated_colonies), na.rm=TRUE)

df[is.na(df)] <- 0

df_treated = subset(df, select = c("CHR", "POS", "treated"))

write.csv(df_treated,"/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/treated_df.csv")

df_untreated = subset(df, select = c("CHR", "POS", "untreated"))

write.csv(df_untreated,"/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/untreated_df.csv")
tail(df_wild)

# hybrids etc 
df$hybrid = rowMeans(subset(df, select = hybrid_colonies), na.rm = TRUE)
df$pure = rowMeans(subset(df, select = pure_colonies), na.rm=TRUE)
                 
df_hybrid = subset(df, select = c("CHR", "POS", "hybrid"))

write.csv(df_hybrid,"/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/hybrid_df.csv")

df_pure = subset(df, select = c("CHR", "POS", "pure"))

write.csv(df_pure,"/home/stephen/Documents/Thesis/Population_model/Results/tajimasD/for_python/pure_df.csv")

