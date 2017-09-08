#This R function is essentially a wrapper written to simulate null distributions under different evolutionary 
#models from mvMORPH and geiger.  Following Garland et al., a null distribution is simulated based on the 
#evolutionary model chosen and the phylogeny.  The code borrows heavily from the R pacakge geiger. Moreover, 
#this has only been tested with the data from Soghigian et al. and a few simulations, so it is a good idea to 
#ensure results make sense through other potential analyses as well! 
phyaov <- function (formula, phy, nsim = 1000, test = c("Wilks", "Pillai", 
        "Hotelling-Lawley", "Roy"),preset=NULL,model=c("BM","OU","EB","OUM"),
          maxit=1000,...) 
{
  #This function was written for Soghigian et al., but is just a wrapper for mvMorph and aov.phylo from geiger, and thus requires both..  Please cite(geiger) and cite(mvMORPH)!
  #load the required packages.  abind is used for binding together matrices generating during simulations.
  require(geiger)
  require(abind)
  require(mvMORPH)
  xx = lapply(all.vars(formula), get)
  flag = "'formula' must be of the form 'dat~group', where 'group' is a named factor vector and 'dat' is a data matrix or named vector"
  if (!is.factor(xx[[2]])) 
    stop(flag)
  if (is.null(names(xx[[2]]))) 
    stop(flag)
  yy = merge(xx[[1]], xx[[2]], by = 0)
  if (nrow(yy) == 0) 
    stop(flag)
  rownames(yy) = yy[, 1]
  yy = yy[, -1]
  tmp <- treedata(phy, yy, sort = TRUE)
  phy = tmp$phy
  yy = yy[phy$tip.label, ]
  group = structure(yy[, ncol(yy)], names = rownames(yy))
  dat = as.matrix(yy[, -ncol(yy)])
  rownames(dat) = rownames(yy)
  
  multivar = ifelse(ncol(dat) > 1, TRUE, FALSE)
  if (is.null(preset) == FALSE ) {
    cat("Simulating from a preset null model with parameters: \n")
    print(preset)
    simulate(preset,nsim=nsim,tree=phy) -> set_sims
    abind(set_sims, along=3) -> sims  
    test = match.arg(test, c("Wilks", "Pillai", "Hotelling-Lawley", 
                             "Roy"))
    m = summary.manova(mod <- manova(dat ~ group), test = test)
    f.data = m[[4]][1, 2]
    
    if (multivar) {
    FUN = function(xx) summary.manova(manova(as.matrix(xx) ~ 
                                               group), test = test)[[4]][1, 2]
    
    f.null <- apply(sims, 3, FUN)
    out = as.data.frame(m[[4]])
    attr(out, "heading") = c("Multivariate Analysis of Variance Table\n", 
                             "Response: dat") }
    else {
        test = NULL
        m = anova(mod <- lm(dat ~ group))
        f.data <- m[1, 4]
        FUN = function(xx) anova(lm(xx ~ group))[1, 4]
        out = as.data.frame(m)
    }
  }
  else {
    cat("Simulating from a null model of: ", model, '\n')
      if (model == "BM") {
        s <- ratematrix(phy, dat)
        sims <- sim.char(phy, s, nsim = nsim) }
      else if (model == "OU") {
        print("Simulating from OU model, this could take some time...")
        mvOU(phy,dat,control=list(maxit=maxit),param=list(root=FALSE)) -> mvoutput
        simulate(mvoutput,nsim=nsim,tree=phy) -> ousims
        abind(ousims, along=3) -> sims }
      else if (model == "EB") {
        mvEB(phy,dat) -> ebout
        simulate(ebout,nsim=nsim,tree=phy) -> ebsims
        abind(ebsims, along=3) -> sims  }
      else if (model == "OUM") {
        print("Simulating from OU model, this could take some time...")
        mvOU(phy,dat,control=list(maxit=maxit),param=list(root=FALSE)) -> mvoutput
        simulate(mvoutput,nsim=nsim,tree=phy) -> ousims
        abind(ousims, along=3) -> sims }
    if (multivar) { 
      test = match.arg(test, c("Wilks", "Pillai", "Hotelling-Lawley", 
                               "Roy"))
      m = summary.manova(mod <- manova(dat ~ group), test = test)
      f.data = m[[4]][1, 2]
      FUN = function(xx) summary.manova(manova(as.matrix(xx) ~ 
                                                 group), test = test)[[4]][1, 2]
      
      f.null <- apply(sims, 3, FUN)
      out = as.data.frame(m[[4]])
      attr(out, "heading") = c("Multivariate Analysis of Variance Table\n", 
                               "Response: dat") }
    else {
      test = NULL
      m = anova(mod <- lm(dat ~ group))
      f.data <- m[1, 4]
      FUN = function(xx) anova(lm(xx ~ group))[1, 4]
      out = as.data.frame(m)
    }
    
    }
  colnames(out) = gsub(" ", "-", colnames(out))
  f.null <- apply(sims, 3, FUN)
  if (multivar) {
    if (test == "Wilks") {
      p.phylo = (sum(f.null < f.data) + 1)/(nsim + 1)
    }
    else {
      p.phylo = (sum(f.null > f.data) + 1)/(nsim + 1)
    }
  }
  else {
    p.phylo = (sum(f.null > f.data) + 1)/(nsim + 1)
  }
  out$"Pr(>F) given phy" = c(p.phylo, NA)
  class(out) <- c("anova", "data.frame")
  #print(out, ...)
  attr(mod, "summary") = out
  return(out)
}
