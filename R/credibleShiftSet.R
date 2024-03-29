# Feb 28 2014

##' @title Credible set of macroevolutionary rate shift configurations from
##'     \code{BAMM} results
##'
##' @description Computes the 95\% (or any other \%) credible set of
##'     macroevolutionary rate shift configurations from a \code{bammdata}
##'     object. These results can be analyzed further and/or plotted.
##'
##' @param ephy An object of class \code{bammdata}.
##' @param expectedNumberOfShifts The expected number of rate shifts under the
##'     prior.
##' @param threshold The marginal posterior-to-prior odds ratio for a rate
##'     shift on a specific branch, used to distinguish core and non-core
##'     shifts.
##' @param set.limit The desired limit to the credible set. A value of 0.95
##'     will return the 95\% credible set of shift configurations.
##' @param \dots Other arguments to \code{credibleShiftSet}.
##'
##' @details Computes the 95\% credible set (or XX\% credible set, depending
##'     on \code{set.limit}) of diversification shift configurations sampled
##'     using \code{BAMM}. This is analogous to a credible set of phylogenetic
##'     tree topologies from a Bayesian phylogenetic analysis. 
##'
##'     To understand how this calculation is performed, one must first
##'     distinguish between "core" and "non-core" rate shifts. A "core shift"
##'     is a rate shift with a marginal probability that is substantially
##'     elevated above the probability expected on the basis of the prior
##'     alone. With \code{BAMM}, every branch in a phylogenetic tree is
##'     associated with some non-zero prior probability of a rate shift.
##'     Typically this is a very low per-branch shift probability (this prior
##'     is determined by the value of the "poissonRatePrior" parameter in a
##'     \code{BAMM} analysis). 
##'
##'     If we compute distinct shift configurations with every sampled shift
##'     (including those shifts with very low marginal probabilities), the
##'     number of distinct shift configurations will be overwhelmingly high.
##'     However, most of these configurations include shifts with marginal
##'     probabilities that are expected even under the prior alone. Hence,
##'     using these shifts to identify distinct shift configurations simply
##'     generates noise and isn't particularly useful.
##'
##'     The solution adopted in \code{BAMMtools} is, for each branch in the
##'     phylogeny, to compute both the posterior and prior probabilities of a
##'     rate shift occurring. The ratio of these probabilities is a
##'     branch-specific marginal odds ratio: it is the marginal posterior
##'     frequency of one or more rate shifts normalized by the corresponding
##'     prior probability. Hence, any branch with a marginal odds ratio of
##'     1.0 is one where the observed (posterior) odds of a rate shift are no
##'     different from the prior odds. A value of 10 implies that the
##'     posterior probability is 10 times the prior probability. 
##'
##'     The user of \code{credibleShiftSet} must specify a \code{threshold}
##'     argument. This is simply a cutoff value for identifying "important"
##'     shifts for the purposes of identifying distinct shift configurations.
##'     This does not imply that it is identifying "significant" shifts. See
##'     the online documentation on this topic available at
##'     \url{http://bamm-project.org} for more information. If you specify
##'     \code{threshold = 5} as an argument to \code{credibleShiftSet}, the
##'     function will ignore all branches with marginal odds ratios less than
##'     5 during the enumeration of topologically distinct shift
##'     configurations. Only shifts with marginal odds ratios greater than or
##'     equal to \code{threshold} will be treated as core shifts for the
##'     purposes of identifying distinct shift configurations.
##'
##'     For each shift configuration in the credible set, this function will
##'     compute the average diversification parameters. For example, the most
##'     frequent shift configuration (the maximum a posteriori shift
##'     configuration) might have 3 shifts, and 150 samples from your
##'     posterior (within the \code{bammdata} object) might show this shift
##'     configuration. However, the parameters associated with each of these
##'     shift configurations (the actual evolutionary rate parameters) might
##'     be different for every sample. This function returns the mean set of
##'     rate parameters for each shift configuration, averaging over all
##'     samples from the posterior that can be assigned to a particular shift
##'     configuration. 
##'
##' @return A class \code{credibleshiftset} object with many components. Most
##'     components are an ordered list of length L, where L is the number of
##'     distinct shift configurations in the credible set. The first list
##'     element in each case corresponds to the shift configuration with the
##'     maximum a posteriori probability. 
##'
##'     \item{frequency}{A vector of frequencies of shift configurations,
##'         including those that account for \code{set.limit} (typically, 0.95
##'         or 0.99) of the probability of the data. The index of the i'th
##'         element of this vector is the i'th most probable shift
##'         configuration (excepting ties).}
##'     \item{shiftnodes}{A list of the "core" rate shifts (marginal
##'         probability > threshold) that occurred in each distinct shift
##'         configuration in the credible set. The i'th vector from this list
##'         gives the core shift nodes for the i'th shift configuration. They
##'         are sorted by frequency, so \code{x$shiftnodes[[1]]} gives the
##'         shift nodes that occurred together in the shift configuration with
##'         the highest posterior probability.}
##'     \item{indices}{A list of vectors containing the indices of samples in
##'         the \code{bammdata} object that are assigned to a given shift
##'         configuration. All are sorted by frequency.}
##'     \item{cumulative}{Like \code{frequency}, but contains the cumulative
##'         frequencies.}
##'     \item{threshold}{The marginal posterior-to-prior odds for rate shifts
##'         on branches used during enumeration of distinct shift
##'         configurations.}
##'     \item{number.distinct}{Number of distinct shift configurations in the
##'         credible set.}
##'     \item{set.limit}{which credible set is this (0.9, 0.95, etc)?}
##'     \item{coreshifts}{A vector of node numbers corresponding to the core
##'         shifts. All of these nodes have a Bayes factor of at least
##'         \code{BFcriterion} supporting a rate shift.}
##'
##'     In addition, a number of components that are defined similarly in
##'     class \code{phylo} or class \code{bammdata} objects:
##'
##'     \item{edge}{See documentation for class \code{phylo} in package ape.}
##'     \item{Nnode}{See documentation for class \code{phylo} in package ape.}
##'     \item{tip.label}{See documentation for class \code{phylo} in package
##'         ape.}
##'     \item{edge.length}{See documentation for class \code{phylo} in package
##'         ape.}
##'     \item{begin}{The beginning time of each branch in absolute time (the
##'         root is set to time zero)}
##'     \item{end}{The ending time of each branch in absolute time.}
##'     \item{numberEvents}{An integer vector with the number of core events
##'         contained in the \code{bammdata} object for each shift
##'         configuration in the credible set. The length of this vector is
##'         equal to the number of distinct shift configurations in the
##'         credible set.}
##'     \item{eventData}{A list of dataframes. Each element holds the average
##'         rate and location parameters for all samples from the posterior
##'         that were assigned to a particular distinct shift configuration.
##'         Each row in a dataframe holds the data for a single event. Data
##'         associated with an event are: \code{node} - a node number. This
##'         identifies the branch where the event originates. \code{time} -
##'         this is the absolute time on that branch where the event
##'         originates (with the root at time 0). \code{lam1} - an initial
##'         rate of speciation or trait evolution.\code{lam2} - a decay/growth
##'         parameter. \code{mu1} - an initial rate of extinction. \code{mu2}
##'         - a decay/growth parameter. \code{index} - a unique integer
##'         associated with the event. See 'Details' in the documentation for
##'         \code{\link{getEventData}} for more information.}
##'     \item{eventVectors}{A list of integer vectors. Each element is for a
##'         single shift configuration in the posterior. For each branch in
##'         the \code{bammdata} object, gives the index of the event governing
##'         the (tipwards) end of the branch. Branches are ordered increasing
##'         here and elsewhere.}
##'     \item{eventBranchSegs}{A list of matrices. Each element of the list is
##'         a single distinct shift configuration. Each matrix has four
##'         columns: \code{Column 1} identifies a node in \code{phy}.
##'         \code{Column 2} identifies the beginning time of the branch or
##'         segment of the branch that subtends the node in \code{Column 1}.
##'         \code{Column 3} identifies the ending time of the branch or
##'         segment of the branch that subtends the node in \code{Column 1}.
##'         \code{Column 4} identifies the index of the event that occurs
##'         along the branch or segment of the branch that subtends the node
##'         in \code{Column 1}.}
##'     \item{tipStates}{A list of integer vectors. Each element is a single
##'         distinct shift configuration. For each tip the index of the event
##'         that occurs along the branch subtending the tip. Tips are ordered
##'         increasing here and elsewhere.}
##'     \item{tipLambda}{A list of numeric vectors. Each element is a single
##'         distinct shift configuration. For each tip is the average rate of
##'         speciation or trait evolution at the end of the terminal branch
##'         subtending that tip (averaged over all samples that are assignable
##'         to this particular distinct shift configuration).}
##'     \item{tipMu}{A list of numeric vectors. Each element is a single
##'         distinct shift configuration. For each tip the rate of extinction
##'         at the end of the terminal branch subtending that tip. Meaningless
##'         if working with \code{BAMM} trait results.}
##'     \item{type}{A character string. Either "diversification" or "trait"
##'         depending on your \code{BAMM} analysis.}
##'     \item{downseq}{An integer vector holding the nodes of \code{phy}. The
##'         order corresponds to the order in which nodes are visited by a
##'         pre-order tree traversal.}
##'     \item{lastvisit}{An integer vector giving the index of the last node
##'         visited by the node in the corresponding position in
##'         \code{downseq}. \code{downseq} and \code{lastvisit} can be used to
##'         quickly retrieve the descendants of any node. e.g. the descendants
##'         of node 89 can be found by
##'         \code{downseq[which(downseq==89):which(downseq==lastvisit[89])}.}
##'
##' @author Dan Rabosky
##'
##' @seealso \code{\link{distinctShiftConfigurations}},
##'     \code{\link{plot.bammshifts}}, \code{\link{summary.credibleshiftset}},
##'     \code{\link{plot.credibleshiftset}},
##'     \code{\link{getBranchShiftPriors}}
##'
##' @references \url{http://bamm-project.org/}
##'
##' @examples
##' data(events.whales, whales)
##' ed <- getEventData(whales, events.whales, burnin=0.1, nsamples=500)
##' 
##' cset <- credibleShiftSet(ed, expectedNumberOfShifts = 1, threshold = 5)
##' 
##' # Here is the total number of samples in the posterior:
##' length(ed$eventData)
##' 
##' # And here is the number of distinct shift configurations:
##' cset$number.distinct
##' 
##' # here is the summary statistics:
##' summary(cset)
##' 
##' # Accessing the raw frequency vector for the credible set:
##' cset$frequency
##' 
##' #The cumulative frequencies:
##' cset$cumulative
##' 
##' # The first element is the shift configuration with the maximum 
##' #  a posteriori probability. We can identify all the samples from 
##' #  posterior that show this shift configuration:
##' 
##' cset$indices[[1]]
##'
##' # Now we can plot the credible set:
##' plot(cset, plotmax=4)
##' @keywords models
##' @export
credibleShiftSet <- function(ephy, expectedNumberOfShifts, threshold = 5, set.limit = 0.95, ...){
	
	prior <- getBranchShiftPriors(ephy, expectedNumberOfShifts)
	
	dsc <- distinctShiftConfigurations(ephy, expectedNumberOfShifts, threshold);
	cfreq <- cumsum(dsc$frequency);
	cut <- min(which(cfreq >= set.limit));
	nodeset <- NULL;
 	
 	shiftnodes <- dsc$shifts[1:cut];
	indices <- dsc$samplesets[1:cut];
	frequency <- dsc$frequency[1:cut];
	cumulative <- cumsum(dsc$frequency)[1:cut];
	
	ephy$marg.probs <- dsc$marg.probs;
 	
 	ephy$shiftnodes <- shiftnodes;
 	ephy$indices <- indices;
 	ephy$frequency <- frequency;
 	ephy$cumulative <- cumulative;
 	ephy$coreshifts <- dsc$coreshifts;
 	ephy$threshold <- threshold;
 	ephy$set.limit <- set.limit;
 	ephy$number.distinct <- length(indices);
 	
	class(ephy) <- 'credibleshiftset';
	return(ephy);	
	
}


