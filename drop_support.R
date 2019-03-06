#!/usr/bin/env Rscript
library(phytools)
#This script is intended to remove support values (node labels) from trees, such as would be useful in preparing trees for MCMCTree.  This file can just be combined with drop_branchlength.R for a single script if desired.  Would save a small amount of time reloading the phytools library etc.

#example usage:
#Rscript drop_branchlength.R input.newick.tre output.newick.tre
#in case you want to use this script manually instead of at the command line, open it RStudio and use the commented out lines.

args_input = commandArgs(trailingOnly=TRUE)

# tree1 <- read.tree(file.choose())
tree1 <- read.tree(file=args_input[1])
# drop edge lengths
tree1$edge.length<-NULL
# remove the node labels (branch support usually)
tree1$node.label<-NULL
# write the new tree to location specified in arg2
# write.tree(tree1,file=file.choose())
write.tree(tree1,file=args_input[2])