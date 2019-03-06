#!/usr/bin/env Rscript
library(phytools)
library(ape)
#This script is intended to root unrooted trees.  It should also be able to re-root trees.  The script expects a phylogenetic tree in Newick format, 
#and the exact name of the taxa on which to root the tree... to specify multiple taxa use comma separated list with NO spaces
#Please note that this function resolves the root, meaning that a zero length branch is placed at the MRCA of the root + ingroup!
#example usage:
#Rscript root_tree.R input.tre.newick taxa1,taxa2 out.tre.newick
#in case you want to use this script manually instead of at the command line, open it RStudio and use the commented out lines.

args_input = commandArgs(trailingOnly=TRUE)

print(args_input)

#tree1<-read.tree(file.choose())
tree1<-read.tree(args_input[1])

tree1$node.label <- NULL

tree2 <- root(tree1, strsplit(args_input[2],",")[[1]], resolve.root = TRUE)

#write.tree(tree2,file.coose())
write.tree(tree2,args_input[3])

