library(ggtree)
library(tidyverse)
library(ape)

#plot discovista tree
#load tree
DVtree <- read.tree("/Users/summerblanco/Desktop/astral4_353_supercontigs_scored.tree")

#get quartet score data
x <- as_tibble(DVtree)
x
write.csv(x, "/Users/summerblanco/Desktop/astral4_353_supercontigs_scored.tree.csv")
#manually manipulate excel file so that you have the columns like this: F1, F2, F3, node; only the nodes with quartet scores

#plot branch length tree
sample_data <- read.table(file = "/Users/summerblanco/Desktop/April2024_PhylogenomicsGeranium/hybpiper_Chromosome_petalcolor.csv", sep = ',', header = TRUE)
tr2 <- read.tree("/Users/summerblanco/Desktop/Github/GeraniumPhylogenetics/SpeciesTree_351NuclearGenes/astral4_353_supercontigs.tree")
tr2 <- updateLabel(tr2, sample_data$sample_name, sample_data$NewName)
tr2$node.label <- as.numeric(tr2$node.label)
tr2$node.label <- round(tr2$node.label,2)
p2 <- ggtree(tr2)%<+% sample_data + geom_tiplab(color = 'black', size = 4, geom = "text", ) #+ geom_nodelab(aes(label=label,  subset=label<0.95), size=3,hjust = 1.8, vjust=2)
ggsave("/Users/summerblanco/Desktop/ASTRAL4_supercontigs_branches.png", width=10,height=12, bg='transparent')
#rotate tree at node
p2 + geom_text(aes(label=node), hjust=-.3)
p3 <- ggtree::rotate(p2,48) 
p3 + geom_treescale()

ggsave("/Users/summerblanco/Desktop/ASTRAL4_supercontigs_branches.png", width=17,height=10, bg='transparent')


#plot pie chart tree


#plot tree with names
tr2 <- read.tree("/Users/summerblanco/Desktop/Github/GeraniumPhylogenetics/SpeciesTree_351NuclearGenes/astral4_353_supercontigs.tree")
tr2$node.label <- as.numeric(tr2$node.label)
tr2$node.label <- round(tr2$node.label,2)
tr2 <- updateLabel(tr2, sample_data$sample_name, sample_data$NewName)
p2 <- ggtree(tr2, branch.length = "none")%<+% sample_data + geom_tiplab(color = 'black', size = 4, geom = "text", ) + geom_nodelab(aes(label=label,  subset=label<0.95), size=3,hjust = 1.8, vjust=2)
p2
#rotate tree at node
p2 + geom_text(aes(label=node), hjust=-.3)
p3 <- ggtree::rotate(p2,48) 
#read in quartet score excel sheet
dat2<-read.csv("/Users/summerblanco/Desktop/astral4_353_supercontigs_scored.tree.csv")

#make pie charts
dat2 <- data.frame(dat2)
pies <- nodepie(dat2, cols=1:3)
pietree <- inset(p3, pies,width=0.06,height = 0.1)
pietree + ggplot2::xlim(0, 20) +
  theme(
    panel.background = element_rect(fill='transparent'),
    plot.background = element_rect(fill='transparent', color=NA),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.background = element_rect(fill='transparent'),
    legend.box.background = element_rect(fill='transparent'),
  )


ggsave("/Users/summerblanco/Desktop/ASTRAL4_piechart_supercontigs_nolabels.png", width=10,height=12, bg='transparent')

