set.seed(2019-05-02)
x <- rtree(30)

p <- ggtree(x) + geom_tiplab()

p

d <- data.frame(label = x$tip.label, 
                value = rnorm(30))
p2 <- p + geom_facet(panel = "Dot", data = d, 
                     geom = geom_point, mapping = aes(x = value))
p2 + xlim_tree(6) + xlim_expand(c(-10, 10), 'Dot')


############

tree <- read.tree("/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/TreeFiles/astral4_353_supercontigs.tree")
p <- ggtree(tree, branch.length = "none")+ geom_tiplab() + geom_nodelab(aes(label=label,  subset=label<0.95), size=3,hjust = 1.8, vjust=2)
p

d <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)

d <- d %>% select(sample_name,Chromosome.Count) %>% separate_rows(Chromosome.Count, sep =", ")

d$Chromosome.Count <- as.numeric(d$Chromosome.Count)

d <- d %>% rename (label = sample_name, value = Chromosome.Count)

p2 <- p + geom_facet(panel = "Dot", data = d, 
                     geom = geom_point, mapping = aes(x = value)) + xlim_expand(c(-10, 80), 'Tree') + theme_tree2() 

facet_widths(p2, widths = c(2, 1))

ggsave("test1.png")

############
sample_data <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)
tree <- read.tree("/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/TreeFiles/astral4_353_supercontigs.tree")
tree$node.label <- as.numeric(tree$node.label)
tree$node.label <- round(tree$node.label,2)
tree <- updateLabel(tree, sample_data$sample_name, sample_data$NewName)
p <- ggtree(tree, branch.length = "none")%<+% sample_data + geom_tiplab(color = 'black', size = 4, geom = "text", hjust=-1 ) + geom_nodelab(aes(label=label,  subset=label<0.95), hjust=1, vjust=1)
p

d <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)

d <- d %>% select(NewName,Chromosome.Count) %>% separate_rows(Chromosome.Count, sep =", ")

d$Chromosome.Count <- as.numeric(d$Chromosome.Count)

d <- d %>% rename (label = NewName, value = Chromosome.Count)

p2 <- p + geom_facet(panel = "Chromosome Counts (2n)", data = d, 
                     geom = geom_point, mapping = aes(x = value),alpha=0.7) + xlim_tree(23) + theme_tree2() 

facet_widths(p2, widths = c(2, 1))

ggsave("test2.png")

############
sample_data <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)
tree <- read.tree("/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/TreeFiles/astral4_353_supercontigs.tree")
tree$node.label <- as.numeric(tree$node.label)
tree$node.label <- round(tree$node.label,2)
tree <- updateLabel(tree, sample_data$sample_name, sample_data$NewName)
p <- ggtree(tree, branch.length = "none")%<+% sample_data + geom_tiplab(color = 'black', size = 5, geom = "text", hjust=-.1) + geom_nodelab(aes(label=label,  subset=label<0.95), hjust=1.5, vjust=-0.5, size=4)
p

dat2<-read.csv("/Users/summerblanco/Desktop/astral4_353_supercontigs_scored.tree.csv")

#make pie charts
dat2 <- data.frame(dat2)
pies <- nodepie(dat2, cols=1:3)
pietree <- inset(p, pies,width=0.08,height = 0.15)
pietree

d <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_colordata.tsv", sep = '\t', header = TRUE)

d <- d %>% select(NewName,Chromosome.Count) %>% separate_rows(Chromosome.Count, sep =", ")

d$Chromosome.Count <- as.numeric(d$Chromosome.Count)

d <- d %>% rename (label = NewName, value = Chromosome.Count)
pietree
p2 <- pietree + geom_facet(panel = "Chromosome Counts (2n)", data = d, 
                     geom = geom_point, mapping = aes(x = value),alpha=0.7) + xlim_tree(23) + theme_tree()

p2
p2<- p2 + theme(text=element_text(family="Helvetica"),size=5,
                       panel.background = element_rect(fill='transparent'),
                       plot.background = element_blank(),
                       panel.grid.major = element_blank(),
                       panel.grid.minor = element_blank(),
                       legend.background = element_rect(fill='transparent'),
                       legend.box.background = element_rect(fill='transparent'),
                       strip.background = element_blank(), strip.text = element_blank(),
                       
                     )

p3<- facet_widths(p2, widths = c(3, 1))
ggsave(file="jtest.png")

install.packages("svglite")
library(svglite)
svglite("test.svg")
plot(p3,height=10*72,width=8*72)
dev.off()

