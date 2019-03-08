## This function converts MCMCTree output trees into a format acceptable to treeio's read.beast function.
## This allows for easy plotting via available functions in ggtree (and deeptime)
## Usage: read.mcmctree(inputfilename)->output
##
## All credit goes to Guangchuang Yu and colleagues for the excellent work on ggtree, treeio, and related packages.
## If you use this function in a manuscript, please cite Guangchuang Yu, David Smith, Huachen Zhu, Yi Guan, Tommy 
## Tsan-Yuk Lam. 'ggtree: an R package for visualization and annotation of phylogenetic trees with their covariates and 
## other associated data.' Methods in Ecology and Evolution 2017, 8(1):28-36, doi:10.1111/2041-210X.12628

read.mcmctree <- function(input_filename){
  fileName <- input_filename
  readChar(fileName, file.info(fileName)$size) -> mcmctree
  str_replace_all(mcmctree, "(?<!\\]):", " [&95%={NA,NA}]:") -> newtree
  str_replace_all(newtree, "UTREE", "TREE") -> newtree
  fileConn<-file("output_temp.txt")
  writeLines(newtree, fileConn)
  close(fileConn)
  treeio::read.beast("output_temp.txt")->beast_tree
  file.remove("output_temp.txt")
  return(beast_tree)
}
