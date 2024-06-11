HPStats<- read.table(file = '/Users/summerblanco/Desktop/HP_Stats/hybpiper_stats.tsv', sep = '\t', header = TRUE)

library(ggplot2)

library(tidyverse)
install.packages("ggthemes")
library(ggthemes)

# Change colors
ggplot(HPStats, aes(x=GenesWithSeqs)) + geom_histogram(color="black", fill="#156082") + ylim(0,35) + theme_linedraw()+ theme(text=element_text(size=31)) +
  theme(
  panel.background = element_rect(fill='transparent'), #transparent panel bg
  plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
  panel.grid.major = element_blank(), #remove major gridlines
  panel.grid.minor = element_blank(), #remove minor gridlines
  legend.background = element_rect(fill='transparent'), #transparent legend bg
  legend.box.background = element_rect(fill='transparent') #transparent legend panel
)+ theme(axis.title.y = element_text(vjust=1.8))
ggsave("geneswithseqs_hist.png", bg="transparent",height=8, width=8)

HPStats %>% 
  ggplot(aes(x = ReadsMapped, y = GenesWithSeqs)) +
  geom_point(alpha=0.4) + ylim(0, 353) + xlim(0,35000000)

ggsave("/Users/summerblanco/Desktop/readsmapped_vs_geneswithseqs.png")

HPStats %>% 
  ggplot(aes(x = Name, y = ParalogWarningsLong)) +
  geom_point(alpha=1) + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) 

ggsave("/Users/summerblanco/Desktop/ParalogsLong_bySample.png")


plot_2 <- ggplot(HPStats, aes(x = factor(1), y = GenesWithSeqs), color = "#156082") +
  geom_jitter(aes(), 
              width = 0.1, size = 8, alpha=0.4, color = "#156082") +
  labs(x = NULL) + ylim(250,360) + theme_linedraw() + theme(text=element_text(size=50)) + theme(
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank()
  )  + theme(axis.title.y = element_text(vjust=1.8))

plot_2
ggsave("GenesWithSeqs.png", bg="transparent",height=7, width=8)


plot_1 <- ggplot(HPStats, aes(x = factor(1), y = ParalogWarningsLong)) +
  geom_boxplot(width = 0.4, fill = "white") +
  geom_jitter(aes(), 
              width = 0.1, size = 1, alpha=0.5) + labs(x = NULL)   # Remove x axis label

plot_1
plot_3 <- ggplot(HPStats, aes(x = factor(1), y = PctOnTarget)) +
  geom_violin(width = 0.4, fill="#156082", alpha=0.8) +
  geom_jitter(aes(), 
              width = 0.1, size = 3, alpha=0.8,color = "black") + labs(x = NULL) + theme_linedraw() + theme(
                axis.title.x = element_blank(),
                axis.text.x = element_blank(),
                axis.ticks.x = element_blank()
              ) + theme(
                panel.background = element_rect(fill='transparent'), #transparent panel bg
                plot.background = element_rect(fill='transparent', color=NA), #transparent plot bg
                panel.grid.major = element_blank(), #remove major gridlines
                panel.grid.minor = element_blank(), #remove minor gridlines
                legend.background = element_rect(fill='transparent'), #transparent legend bg
                legend.box.background = element_rect(fill='transparent') #transparent legend panel
              )+ theme(text=element_text(size=30)) + theme(axis.title.y = element_text(vjust=1.8)) +ylim(0,52)

plot_3
ggsave("PercentOnTarge.png", bg="transparent", height=7, width=8 )

plot_4 <- ggplot(HPStats, aes(x = factor(1), y = ReadsMapped)) +
  geom_boxplot(width = 0.4, fill = "white") +
  geom_jitter(aes(), 
              width = 0.1, size = 1, alpha=0.5) + labs(x = NULL)   # Remove x axis label

plot_4
library(gridExtra)
summary_plot <- grid.arrange(plot_4, plot_3, plot_2, plot_1, ncol=4)
ggsave(summary_plot,"/Users/summerblanco/Desktop/HPStats_Summary.png", bg="transparent")

install.packages("pacman")
library("pacman")
pacman::p_load(
  rio,             # import/export
  here,            # relative file paths
  tidyverse,       # general data management and visualization
  ape,             # to import and export phylogenetic files
  ggtree,          # to visualize phylogenetic files
  treeio,          # to visualize phylogenetic files
  ggnewscale, 
  ggtreeExtra) 

#load tree
tree <- read.tree("/Users/summerblanco/Desktop/astral353_singlecopy.tre.branchlengths.tre")

#load sheet with old names, new names, section, & trait data
sample_data <- read.table(file = "/Users/summerblanco/Desktop/hybpiper_stats.tsv", sep = '\t', header = TRUE)

#root tree
tree_root <- root(tree,outgroup=(c("ERR4179994","ERR7599223")))

# update the rooted tree with new tip labels
tree_updated <- updateLabel(tree_root, sample_data$old_names, sample_data$new.names)

#make tibble with node information
x <- as_tibble(tree_updated)
x

#check tree variables
head(tree_updated$tip.label) 
colnames(sample_data)   
head(sample_data$new.names)
sample_data$new.names %in% tree_updated$tip.label
tree_updated$tip.label %in% sample_data$new.names

#plot tree with chromosome counts and names
p1<- ggtree(tree_root) %<+% sample_data + geom_tiplab(color = 'black',offset = 1, size = 3, geom = "text", align = TRUE) + geom_nodelab(aes(label=label),
              size=2,
              hjust = 0,
               vjust = -0.5) + geom_tiplab(                          # add isolation year as a text label at the tips
                 aes(label = Chromosome.Count),
                 color = 'blue',
                 offset =2.7,
                 size = 3,
                 linetype = "blank" ,
                 geom = "text",
                 align = TRUE)


p1

#rotate nodes
p2 <- ggtree::rotate(p1,89) 
p3 <- ggtree::rotate(p2, 82) 

#see node numbers
p3 + geom_text(aes(label=node), hjust=-.3)

#
p4 <- p3 + geom_cladelabel(node=51, label="Sect. Geranium s. lat.", 
color="darkgreen", offset=4, align=TRUE) +
geom_cladelabel(node=91, label="Sect. Unguiculata", 
                    color="blue", offset=4, align=TRUE)+ 
  geom_cladelabel(node=92, label="Sect. Ruberta", 
                  color="red2", offset=4, align=TRUE)+
 geom_cladelabel(node=88, label="Sect. Lanuginosa", 
                  color="orange", offset=4, align=TRUE)+
 geom_cladelabel(node=83, label="Sect. Subacaulia", 
                  color="grey", offset=4, align=TRUE) +
 geom_cladelabel(node=87, label="Sect. Lanuginosa", 
                  color="orange", offset=4, align=TRUE)+
 geom_cladelabel(node=38, label="Sect. Tuberosa", 
                  color="purple", offset=4, align=TRUE)+
 geom_cladelabel(node=33, label="Sect. Erodioidea", 
                  color="black", offset=4, align=TRUE)+
 geom_cladelabel(node=32, label="Sect. Batrachioidea", 
                  color="pink", offset=4, align=TRUE)+
 geom_cladelabel(node=31, label="Sect. Dissecta", 
                  color="gold", offset=4, align=TRUE)+
 geom_cladelabel(node=1, label="Sect. Dissecta", 
                  color="gold", offset=4, align=TRUE)+
 geom_cladelabel(node=47, label="Sect. Divaricata", 
                  color="lightblue", offset=4, align=TRUE)

p4
p5 <- p4 + geom_point2(aes(subset=(node==27)), shape=23, size=2, fill='hotpink') + geom_point2(aes(subset=(node==28)), shape=23, size=2, fill='tan') + geom_point2(aes(subset=(node==15)), shape=23, size=2, fill='orange')+ geom_point2(aes(subset=(node==2)), shape=23, size=2, fill='orange') + xlim(NA, 18) 

p5
#caffrum - Neurophyllodes 27 
#brycei - Incana 28
#bohemicum - Lanuginosa 15
#ibericum - Lanuginosa 2

ggsave("/Users/summerblanco/Desktop/ggtree.png", height=7, width=14)


#plot discovista tree
#load tree
DVtree <- read.tree("/Users/summerblanco/Desktop/relative_freq/main-hypo.tre")

#get quartet score data
x <- as_tibble(DVtree)
x
write.csv(x, "/Users/summerblanco/Desktop/relative_freq/quartetfreq.csv")

#reroot
DVtree_root <- root(DVtree,outgroup=(c("ERR4179994","ERR7599223")))

#add name labels
DVp1<- ggtree(DVtree_root) %<+% sample_data + geom_tiplab(color = 'black',offset = 1, size = 3, geom = "text", align = TRUE) + geom_tiplab(                          # add isolation year as a text label at the tips
  aes(label = Chromosome.Count),
  color = 'blue',
  offset =2.7,
  size = 3,
  linetype = "blank" ,
  geom = "text",
  align = TRUE)

DVp1 + geom_text(aes(label=node), hjust=-.3)


DVp1


DVp1 <- DVp1 + geom_cladelabel(node=64, label="Sect. Geranium s. lat.", 
                       color="darkgreen", offset=4, align=TRUE) +
  geom_cladelabel(node=50, label="Sect. Unguiculata", 
                  color="blue", offset=4, align=TRUE)+ 
  geom_cladelabel(node=51, label="Sect. Ruberta", 
                  color="red2", offset=4, align=TRUE)+
  geom_cladelabel(node=57, label="Sect. Lanuginosa", 
                  color="orange", offset=4, align=TRUE)+
  geom_cladelabel(node=62, label="Sect. Subacaulia", 
                  color="grey", offset=4, align=TRUE) +
  geom_cladelabel(node=56, label="Sect. Lanuginosa", 
                  color="orange", offset=4, align=TRUE)+
  geom_cladelabel(node=9, label="Sect. Tuberosa", 
                  color="purple", offset=4, align=TRUE)+
  geom_cladelabel(node=14, label="Sect. Erodioidea", 
                  color="black", offset=4, align=TRUE)+
  geom_cladelabel(node=13, label="Sect. Batrachioidea", 
                  color="pink", offset=4, align=TRUE)+
  geom_cladelabel(node=12, label="Sect. Dissecta", 
                  color="gold", offset=4, align=TRUE)+
  geom_cladelabel(node=46, label="Sect. Dissecta", 
                  color="gold", offset=4, align=TRUE)+
  geom_cladelabel(node=47, label="Sect. Divaricata", 
                  color="lightblue", offset=4, align=TRUE) 


DVp2 <- ggtree::rotate(DVp1,52) +xlim(NA,18)
DVp2

#plot pie charts
library(ggimage)
library(ggtree)

dat<- read.csv("/Users/summerblanco/Desktop/quartetfreq.csv")

pies <- nodepie(dat, cols=1:3, alpha=1)

DV_pies<- inset(DVp2, pies, width=0.1,height=0.05)
DV_pies

ggsave("/Users/summerblanco/Desktop/DiscoVistaPie.png", width=20,height=6)
