library(ape)
library(ggtree)

args_input = commandArgs(trailingOnly=TRUE)


tree1 <- read.tree(file=args_input[1])

drop_num <- args_input[2]
tree_new <- NULL
if (class(tree1)=="multiPhylo") {
  for (i in 1:length(tree1)) {
    as.polytomy(tree1[[i]], feature='node.label', fun=function(x) as.numeric(x) < drop_num) -> tree_new[[i]]}
  class(tree_new) <- "multiPhylo"
} else {
  as.polytomy(tree1, feature='node.label', fun=function(x) as.numeric(x) < drop_num) -> tree_new
}

write.tree(tree_new,file=args_input[3])
