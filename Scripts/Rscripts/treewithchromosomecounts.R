

## visualize the tree 
tree <- read.tree("/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/TreeFiles/astral4_353_supercontigs.tree")
p <- ggtree(tree)

#load sheet with old names, new names, section, & trait data
sample_data <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)

sample_data <- sample_data %>% select(sample_name,Chromosome.Count) %>% separate_rows(Chromosome.Count, sep =", ")
sample_data$Chromosome.Count <- as.numeric(sample_data$Chromosome.Count)


## visualize SNP and Trait data using dot and bar charts,
## and align them based on tree structure
p + geom_facet(panel = "SNP", data = sample_data, geom = geom_point, 
               mapping=aes(x = Chromosome.Count)) + theme_tree2(legend.position=c(.05, .85))
