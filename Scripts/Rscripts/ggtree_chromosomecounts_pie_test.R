#load tsv with new names and chromosome count data
sample_data <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)

#read in tree
tree <- read.tree("/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/TreeFiles/astral4_353_supercontigs.tree")

#truncate LPP to only 2 sig figs
tree$node.label <- as.numeric(tree$node.label)
tree$node.label <- round(tree$node.label,2)

#rename tips with New Names from tsv
tree <- updateLabel(tree, sample_data$sample_name, sample_data$NewName)

#plot tree cladogram with new names, node support <0.95,
p <- ggtree(tree, branch.length = "none")%<+% sample_data + geom_tiplab(color = 'black', size = 5, geom = "text", hjust=-.1) + geom_nodelab(aes(label=label,  subset=label<0.95), hjust=1.5, vjust=-0.5, size=4)
p

#read in quartet frequencies
dat2<-read.csv("/Users/summerblanco/Desktop/astral4_353_supercontigs_scored.tree.csv")

#make pie chart insets from quartet frequencies
dat2 <- data.frame(dat2)
pies <- nodepie(dat2, cols=1:3)
pietree <- inset(p, pies,width=0.08,height = 0.15)
pietree

#read in chromosome ount data and clean up 
d <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)
d <- d %>% select(NewName,Chromosome.Count) %>% separate_rows(Chromosome.Count, sep =", ")
d$Chromosome.Count <- as.numeric(d$Chromosome.Count)
d <- d %>% rename (label = NewName, value = Chromosome.Count)

#plot tree with chromosome counts and pie charts at nodes
p2 <- pietree + geom_facet(panel = "Chromosome Counts (2n)", data = d, 
                     geom = geom_point, mapping = aes(x = value),alpha=0.7) + xlim_tree(23) + theme_tree()

p2

#make the background transparent for nice poster diagram
p2<- p2 + theme(text=element_text(family="Helvetica"),size=5,
                       panel.background = element_rect(fill='transparent'),
                       plot.background = element_blank(),
                       panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(),
                       legend.background = element_rect(fill='transparent'),
                       legend.box.background = element_rect(fill='transparent'),
                       strip.background = element_blank(), strip.text = element_blank(),
                       
                     )

#make the visualization 75% tree and 25% chromosome counts vis for poster
p3<- facet_widths(p2, widths = c(3, 1))

#save as png
ggsave(file="jtest.png")

