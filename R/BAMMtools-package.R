##' @title BAMMtools
##' @description An R package for the analysis and visualization of complex
##'     macroevolutionary dynamics. Functions in \code{BAMMtools} are oriented
##'     entirely around analysis of results obtained using the \code{BAMM}
##'     software (\url{http://bamm-project.org/}).
##'
##' @author Dan Rabosky, Mike Grundler, Pascal Title, Jonathan Mitchell,
##'     Carlos Anderson, Jeff Shi, Joseph Brown, Huateng Huang
##'
##' @references \url{http://bamm-project.org/}
##'
##'     Rabosky, D., M. Grundler, C. Anderson, P. Title, J. Shi, J. Brown,
##'     H. Huang and J. Larson. 2014. BAMMtools: an R package for the
##'     analysis of evolutionary dynamics on phylogenetic trees. Methods in
##'     Ecology and Evolution 5: 701-707.
##'
##'     Rabosky, D. L. 2014. Automatic detection of key innovations, rate
##'     shifts, and diversity-dependence on phylogenetic trees. PLoS ONE 9:
##'     e89543.
##'
##'     Shi, J. J., and D. L. Rabosky. 2015. Speciation dynamics during the
##'     global radiation of extant bats. Evolution 69: 1528-1545.
##'
##'     Rabosky, D. L., F. Santini, J. T. Eastman, S. A. Smith, B. L.
##'     Sidlauskas, J. Chang, and M. E. Alfaro. 2013. Rates of speciation
##'     and morphological evolution are correlated across the largest
##'     vertebrate radiation. Nature Communications DOI: 10.1038/ncomms2958.
##'
##' @name BAMMtools
##' @keywords package
##' @useDynLib BAMMtools
##' @importFrom Rcpp evalCpp
##' @importFrom gplots rich.colors
##' @importFrom methods hasArg
##' @importFrom utils lsf.str read.csv read.table tail write.csv write.table
##' @importFrom stats cor.test dbinom density dgeom kruskal.test loess median
##'     optim quantile reorder runif sd setNames wilcox.test
##' @importFrom grDevices col2rgb colorRampPalette dev.off gray pdf rgb
##'     terrain.colors
##' @importFrom graphics abline axTicks axis barplot box grconvertX grconvertY
##'     image layout legend lines locator mtext par plot plot.new plot.window
##'     points polygon rect segments text
##' @importFrom stats qchisq
##' @import ape
"_PACKAGE"
