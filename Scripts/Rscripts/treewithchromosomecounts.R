## load the tree 
tree <- read.tree("/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/TreeFiles/astral4_353_supercontigs.tree")

#plot tree
p <- ggtree(tree)

#load sheet with old names, new names, section, & trait data
sample_data <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)

#clean up file
sample_data <- sample_data %>% select(sample_name,Chromosome.Count) %>% separate_rows(Chromosome.Count, sep =", ")
sample_data$Chromosome.Count <- as.numeric(sample_data$Chromosome.Count)

#make plot with tree and counts side by side
p + geom_facet(panel = "Chromosome Count (2n)", data = sample_data, geom = geom_point, 
               mapping=aes(x = Chromosome.Count)) + theme_tree2(legend.position=c(.05, .85))
