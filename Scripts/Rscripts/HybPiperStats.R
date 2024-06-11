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
