% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/writeEventData.R
\name{writeEventData}
\alias{writeEventData}
\title{Write a \code{bammdata} object to disk}
\usage{
writeEventData(ephy, outtreefile, outeventfile, ...)
}
\arguments{
\item{ephy}{A \code{bammdata} object.}

\item{outtreefile}{The file name for outputting the tree.}

\item{outeventfile}{The file name for outputting the event csv file.}

\item{\dots}{Additional arguments to pass to \code{write.csv}.}
}
\description{
Takes a \code{bammdata} object and re-writes it back into a
    treefile and an event csv file.
}
\seealso{
\code{\link{subtreeBAMM}}
}
