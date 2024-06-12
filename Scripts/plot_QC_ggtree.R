setwd("/Users/summerblanco/Desktop/QuartetResults2/")


tr_qc <- read.tree("RESULT.labeled.tre.qc")
tr_qd <- read.tree("RESULT.labeled.tre.qd")
tr_qi <- read.tree("RESULT.labeled.tre.qi")

# process node labels of above three labeled trees
# qc tree
tree <- tr_qc
tree$node.label <- gsub("qc=", "", tree$node.label)
write.tree(tree, file = file.path("tree_qc.tre"))

# qd tree
tree <- tr_qd
tree$node.label <- gsub("qd=", "", tree$node.label)
write.tree(tree, file = file.path("tree_qd.tre"))

# qi tree
tree <- tr_qi
tree$node.label <- gsub("qi=", "", tree$node.label)
write.tree(tree, file = file.path("tree_qi.tre"))


# read into three modified tree files for QC/QD/QI
tr_qc_m <- read.newick(file.path("tree_qc.tre"), node.label = "support")
tr_qd_m <- read.newick(file.path("tree_qd.tre"), node.label = "support")
tr_qi_m <- read.newick(file.path("tree_qi.tre"), node.labe = "support")


# add a customized label for internode or inter-branch, i.e., qc/qd/qi
score_raw <- paste(tr_qc_m@data$support, tr_qd_m@data$support, tr_qi_m@data$support, sep = "/")
score <- gsub("NA/NA/NA", "", score_raw)
score <- gsub("NA", "-", score)

# set labeled QC tree as the main plot tree
tree <- tr_qc_m
tree@data$score <- score

# extract the internodes number without QC value, and not plot with colored circle
node_noQC <- tree@data$node[is.na(tree@data$support)]

# (3) in tird plot, color circle points for four categories of QC, and label 
#     each internode with QC/QD/QI.
BiocManager::install("ggtree")

library(ggtree)


p3 <-   ggtree(tree, branch.length = "none") +
  geom_tiplab() +
  geom_text(aes(label = score),hjust=1,vjust=-0.6) + xlim(0,18) + theme_tree()

rotate(p3, 49)

ggsave("QCQCQI_Tree_astral4_supercontigs.png",height=10,width=10)


