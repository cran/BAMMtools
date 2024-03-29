
#############################################################
#
#	plotRateThroughTime <- function(...)
#
#	ephy = object of class 'bammdata' or 'bamm-ratematrix'
#		if bamm-ratematrix, start.time, end.time, node, nslices, nodetype are not used.
#	useMedian = boolean, will plot median if TRUE, mean if FALSE.
#	intervals if NULL, no intervals will be plotted, otherwise a vector of quantiles must be supplied (these will define shaded polygons)
#	ratetype = autodetects diversification vs traits (based on input object 'type'), if 'auto', defaults to speciation (for diversification) or beta (for traits). Can alternatively specify 'netdiv' or 'extinction'. 
#	nBins = number of time slices used to generate rates through time
#	smooth = boolean whether or not to apply loess smoothing
#	smoothParam = loess smoothing parameter, ignored if smooth = F
#	opacity = opacity of color for interval polygons
#	intervalCol = transparent color for interval polygons
#	avgCol = color for mean/median line
#	start.time = start time in time before present to be fed to getRateThroughTimeMatrix
#	end.time = end time in time before present to be fed to getRateThroughTimeMatrix
#	node = if supplied, the clade descended from this node will be used.
#	nodetype = supplied to getRateThroughTimeMatrix
#	plot = boolean: if TRUE, a plot will be returned, if FALSE, the data for the plot will be returned. 
#	xticks = number of ticks on the x-axis, automatically inferred if NULL.
#	yticks = number of ticks on the y-axis, automatically inferred if NULL.
#	xlim = vector of length 2 with min and max times for x axis. X axis is time since present, so if plotting till the present, xlim[2]==0. Can also be 'auto'.
#	ylim = vector of length 2 with min and max rates for y axis. Can also be 'auto'. 
#	add = boolean: should rates be added to an existing plot
#
#	+ several undocumented args to set plot parameters: mar, cex, xline, yline, etc.
#	

##' @title Plot rates through time
##'
##' @description Generates a plot of diversification or phenotypic rate through
##'     time with confidence intervals.
##'
##' @param ephy Object of class \code{bammdata} or \code{bamm-ratematrix}.
##' @param useMedian A logical: will plot median if \code{TRUE}, mean if
##'     \code{FALSE}.
##' @param intervals If \code{NULL}, no intervals will be plotted, otherwise a
##'     vector of quantiles must be supplied (these will define shaded
##'     polygons).
##' @param ratetype If 'auto', defaults to speciation (for diversification) or
##'     beta (for traits). Can alternatively specify 'netdiv' or 'extinction'. 
##' @param nBins Number of time slices used to generate rates through time.
##' @param smooth A logical: whether or not to apply loess smoothing.
##' @param smoothParam Loess smoothing parameter, ignored if
##'     \code{smooth = FALSE}.
##' @param opacity Opacity of color for interval polygons.
##' @param intervalCol Color for interval polygons.
##' @param avgCol Color for mean/median line (line will not be plotted if
##'     \code{avgCol = NULL}).
##' @param start.time Start time (in units before present). If \code{NULL},
##'     starts at root.
##' @param end.time End time (in units before present). If \code{NULL}, ends
##'     at present.
##' @param node If supplied, the clade descended from this node will be used
##'     or ignored, depending on \code{nodetype}.
##' @param nodetype If 'include', rates will be plotted only for the clade
##'     descended from \code{node}. If 'exclude', the clade descended from
##'     \code{node} will be left out of the calculation of rates. 
##' @param plot A logical: if \code{TRUE}, a plot will be returned, if
##'     \code{FALSE}, the data for the plot will be returned.
##' @param cex.axis Size of axis tick labels.
##' @param cex.lab Size of axis labels.
##' @param lwd Line width of the average rate.  	
##' @param xline Margin line for placing x-axis label.
##' @param yline Margin line for placing y-axis label. 
##' @param mar Passed to \code{par()} to set plot margins.
##' @param xticks Number of ticks on the x-axis, automatically inferred if
##'     \code{NULL}.
##' @param yticks Number of ticks on the y-axis, automatically inferred if
##'     \code{NULL}.
##' @param xlim Vector of length 2 with min and max times for x axis. X axis
##'     is time since present, so if plotting till the present,
##'     \code{xlim[2] == 0}. Can also be 'auto'.
##' @param ylim Vector of length 2 with min and max rates for y axis. Can also
##'     be 'auto'.
##' @param add A logical: should rates be added to an existing plot.
##' @param axis.labels A logical: if \code{TRUE}, axis labels will be plotted.
##'
##' @details If the input \code{ephy} object has been generated by
##'     \code{\link{getEventData}} and is of class \code{bammdata}, then
##'     \code{start.time}, \code{end.time}, \code{node}, and \code{nodetype}
##'     can be specified. If the input \code{ephy} object has been generated
##'     by \code{\link{getRateThroughTimeMatrix}} and is of class
##'     \code{bamm-ratematrix}, then those arguments cannot be specified
##'     because they are needed to generate the rate matrix, which in this
##'     case has already happened. 
##' 
##'     The user has complete control of the plotting of the confidence
##'     intervals. Confidence intervals will not be plotted at all if
##'     \code{intervals=NULL}. If a single confidence interval polygon is
##'     desired, rather than overlapping polygons, then \code{intervals} can
##'     specify the confidence interval bounds, and \code{opacity} should be
##'     set to 1 (see examples).
##' 
##'     If working with a large dataset, we recommend first creating a
##'     \code{bamm-ratematrix} object with
##'     \code{\link{getRateThroughTimeMatrix}} and then using that object as
##'     input for \code{plotRateThroughTime}. This way, the computation of
##'     rates has already happened and will not slow the plotting function
##'     down, making it easier to adjust plotting parameters.
##'
##' @return If \code{plot = FALSE}, then a list is returned with the following
##'     components:
##'     \itemize{
##'         \item poly: A list of matrices, where each matrix contains the
##'             coordinates that define each overlapping confidence interval
##'             polygon.
##'         \item avg: A vector of y-coordinates for mean or median rates
##'             used to plot the average rates line.
##'         \item times: A vector of time values, used as x-coordinates in
##'             this plot function.
##'     }
##'
##' @author Pascal Title
##'
##' @seealso See \code{\link{getEventData}} and
##'     \code{\link{getRateThroughTimeMatrix}} to generate input data.
##'
##' @examples
##' \dontrun{
##' data(events.whales)
##' data(whales)
##' ephy <- getEventData(whales,events.whales)
##'
##' # Simple plot of rates through time with default settings
##' plotRateThroughTime(ephy)
##' 
##' # Plot two processes separately with 90% CI and loess smoothing
##' plotRateThroughTime(ephy, intervals = seq(from = 0, 0.9, by = 0.01), smooth = TRUE,
##'                     node = 141, nodetype = 'exclude', ylim = c(0, 1.2))
##' 
##' plotRateThroughTime(ephy, intervals = seq(from = 0, 0.9, by = 0.01), smooth = TRUE, 
##'                     node = 141, nodetype = 'include', add = TRUE,
##'                     intervalCol = 'orange')
##' 
##' legend('topleft', legend = c('Dolphins','Whales'), col = 'red',
##'     fill = c('orange', 'blue'), border = FALSE, lty = 1, lwd = 2, merge = TRUE,
##'            seg.len=0.6)
##' 
##' # Same plot, but from bamm-ratematrix objects
##' rmat1 <- getRateThroughTimeMatrix(ephy, node = 141, nodetype = 'exclude')
##' rmat2 <- getRateThroughTimeMatrix(ephy, node = 141, nodetype = 'include')
##'
##' plotRateThroughTime(rmat1, intervals=seq(from = 0, 0.9, by = 0.01), 
##'     smooth = TRUE, ylim = c(0, 1.2))
##' 
##' plotRateThroughTime(rmat2, intervals = seq(from = 0, 0.9, by = 0.01), 
##'     smooth = TRUE, add = TRUE, intervalCol = 'orange')
##'
##' # To plot the mean rate without the confidence envelope
##' plotRateThroughTime(ephy, useMedian = FALSE, intervals = NULL)
##'
##' # To plot the mean rate, with a single 95% confidence envelope, grayscale
##' plotRateThroughTime(ephy, useMedian = FALSE, intervals = c(0.05, 0.95),
##'     intervalCol = 'gray70', avgCol = 'black', opacity = 1)
##'
##' # To not plot, but instead return the plotting data generated in this
##' # function, we can make plot = FALSE
##' plotRateThroughTime(ephy, plot = FALSE)}
##' @export
plotRateThroughTime <- function(ephy, useMedian = TRUE, intervals = seq(from = 0, to = 1, by = 0.01), ratetype = 'auto', nBins = 100, smooth = FALSE, smoothParam = 0.20, opacity = 0.01, intervalCol = 'blue', avgCol = 'red', start.time = NULL, end.time = NULL, node = NULL, nodetype = 'include', plot = TRUE, cex.axis = 1, cex.lab = 1.3, lwd = 3, xline = 3.5, yline = 3.5, mar = c(6, 6, 1, 1), xticks = NULL, yticks = NULL, xlim = 'auto', ylim = 'auto',add = FALSE, axis.labels = TRUE) {
	
	if (!any(inherits(ephy, c('bammdata', 'bamm-ratematrix')))) {
		stop("ERROR: Object ephy must be of class 'bammdata' or 'bamm-ratematrix'.\n");
	}
	if (!is.logical(useMedian)) {
		stop('ERROR: useMedian must be either TRUE or FALSE.');
	}
	if (!any(inherits(intervals, c('numeric', 'NULL')))) {
		stop("ERROR: intervals must be either 'NULL' or a vector of quantiles.");
	}
	if (!is.logical(smooth)) {
		stop('ERROR: smooth must be either TRUE or FALSE.');
	}
	
	if (inherits(ephy, 'bammdata')) {
		#get rates through binned time
		rmat <- getRateThroughTimeMatrix(ephy, start.time = start.time, end.time = end.time, node = node, nslices = nBins, nodetype=nodetype);
	}
	if (inherits(ephy, 'bamm-ratematrix')) {
		if (!any(is.null(c(start.time, end.time, node)))) {
			stop('ERROR: You cannot specify start.time, end.time or node if the rate matrix is being provided. Please either provide the bammdata object instead or specify start.time, end.time or node in the creation of the bamm-ratematrix.')
		}
		#use existing rate matrix
		rmat <- ephy;
	}

	#set appropriate rates
	if (ratetype == 'speciation') {
		ratetype <- 'auto';
	}
	if (ratetype != 'auto' & ratetype != 'extinction' & ratetype != 'netdiv') {
		stop("ERROR: ratetype must be 'auto', 'extinction', or 'netdiv'.\n");
	}
	if (ephy$type == 'trait' & ratetype != 'auto') {
		stop("ERROR: If input object is of type 'trait', ratetype can only be 'auto'.")
	}
	if (ratetype == 'auto' & ephy$type == 'diversification') {
		rate <- rmat$lambda;
		ratelabel <- 'speciation rate';
	}
	if (ratetype == 'auto' & ephy$type == 'trait') {
		rate <- rmat$beta;
		ratelabel <- 'trait rate';
	}
	if (ratetype == 'extinction') {
		rate <- rmat$mu;
		ratelabel <- 'extinction rate';
	}
	if (ratetype == 'netdiv') {
		rate <- rmat$lambda - rmat$mu;
		ratelabel <- 'net diversification rate';
	}
	
	# times in rate matrix are in terms of node heights (where root age = 0 and present = max divergence time)
	## Now reorganize in terms of time before present
	timeBP <- as.numeric(names(rmat$times))

	#remove NaN columns
	nanCol <- apply(rate, 2, function(x) any(is.nan(x)));
	rate <- rate[,which(nanCol == FALSE)];
	timeBP <- timeBP[which(nanCol == FALSE)];

	#generate coordinates for polygons
	if (!is.null(intervals)) {
		mm <- apply(rate, MARGIN = 2, quantile, intervals);

		poly <- list();
		q1 <- 1;
		q2 <- nrow(mm);
		repeat {
			if (q1 >= q2) {break}
			a <- as.data.frame(cbind(timeBP, mm[q1,]));
			b <- as.data.frame(cbind(timeBP, mm[q2,]));
			b <- b[rev(rownames(b)),];
			colnames(a) <- colnames(b) <- c('x','y');
			poly[[q1]] <- rbind(a,b);
			q1 <- q1 + 1;
			q2 <- q2 - 1;
		}
	}

	#Calculate averaged data line
	if (!useMedian) {
		avg <- colMeans(rate);
	} else {
		avg <- unlist(apply(rate, 2, median));
	}
	
	#apply loess smoothing to intervals
	if (smooth) {
		for (i in 1:length(poly)) {
			p <- poly[[i]];
			rows <- nrow(p);
			p[1:rows/2,2] <- loess(p[1:rows/2, 2] ~ p[1:rows/2, 1], span = smoothParam)$fitted;
			p[(rows/2):rows, 2] <- loess(p[(rows/2):rows, 2] ~ p[(rows/2):rows, 1], span = smoothParam)$fitted;
			poly[[i]] <- p;
		}
		avg <- loess(avg ~ timeBP,span = smoothParam)$fitted;
	}

	#begin plotting
	if (plot) {
		if (!add) {
			plot.new();
			par(mar = mar);
			if (unique(xlim == 'auto')) {
				xMin <- max(timeBP);
				xMax <- min(timeBP);				
			} else {
				xMin <- xlim[1];
				xMax <- xlim[2];				
			}
			if (unique(ylim == 'auto')) {
				if (!is.null(intervals)){
					yMin <- min(poly[[1]][, 2]);
					yMax <- max(poly[[1]][, 2]);
				} else {
					yMin <- min(avg);
					yMax <- max(avg);
				}
				if (yMin >= 0) {
					yMin <- 0;
				}				
			} else {
				yMin <- ylim[1];
				yMax <- ylim[2];				
			}			
			plot.window(xlim = c(xMin, xMax), ylim = c(yMin, yMax));
			if (is.null(xticks)) {
				axis(side = 1, cex.axis = cex.axis, lwd = 0, lwd.ticks = 1);
			}
			if (!is.null(xticks)) {
				axis(side = 1, at = seq(xMin, xMax, length.out = xticks + 1), labels = signif(seq(xMin, xMax, length.out = xticks + 1),digits = 2), cex.axis = cex.axis, lwd = 0, lwd.ticks = 1);
			}
			if (is.null(yticks)) {
				axis(side = 2, cex.axis = cex.axis, las = 1, lwd = 0, lwd.ticks = 1);
			}
			if (!is.null(yticks)) {
				axis(side = 2, at = seq(yMin, 1.2 * yMax, length.out = yticks + 1), labels = signif(seq(yMin, 1.2 * yMax, length.out = yticks + 1),digits = 2), las=1, cex.axis = cex.axis, lwd = 0, lwd.ticks = 1);	
			}
			if (axis.labels) {
				mtext(side = 1, text = 'time before present', line = xline, cex = cex.lab);
				mtext(side = 2, text = ratelabel, line = yline, cex = cex.lab);
			}
			box(which = "plot", bty = "l");
		}
		#plot intervals
		if (!is.null(intervals)) {
			for (i in 1:length(poly)) {
				polygon(x = poly[[i]][, 1],y = poly[[i]][, 2], col = BAMMtools::transparentColor(intervalCol, opacity), border = NA);
			}
		}
		lines(x = timeBP, y = avg, lwd = lwd, col = avgCol);
	} else {
		return(list(poly = poly,avg = avg, times = timeBP));
	}
}
