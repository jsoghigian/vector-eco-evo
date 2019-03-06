#!/usr/bin/env Rscript
library(phytools)
library(ape)
#This script is intended to drop tips from a tree based on the taxa in an alignment in phylip format.  Note that it 
#could also drop tips based on any text object where the rownames of the object correspond to taxa labels to keep in the tree. 
#At present, the alignment is loaded as a text object, instead of as a nucleotide alignment.

#The script expects an alignment in phylip format, a phylogenetic tree in Newick format, 
#and the output file name.
#example usage:
#Rscript tree_trim.R input.aln input.tre.newick output.tre.newick

args_input = commandArgs(trailingOnly=TRUE)

#aln1 <- read.table(file.choose(),header=TRUE,row.names=1)
aln1 <- read.table(args_input[1],header=TRUE,row.names=1)
#tree1 <- read.tree(file.choose())
tree1 <- read.tree(args_input[2])

tree2<-drop.tip(tree1, setdiff(tree1$tip.label, rownames(aln1)))

#write.tree(tree2,file=file.choose())
write.tree(tree2,file=args_input[3])
