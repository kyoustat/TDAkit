% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summaries_sum.R
\name{fssum}
\alias{fssum}
\title{Weighted Sum of Multiple Functional Summaries}
\usage{
fssum(fslist, weight = NULL)
}
\arguments{
\item{fslist}{a length-\eqn{N} list of functional summaries of persistent diagrams.}

\item{weight}{a weight vector of length \eqn{N}. If \code{NULL} (default), weights are automatically set as \eqn{w_1=\cdots=w_N = 1/N}.}
}
\value{
a functional summary object.
}
\description{
Given multiple functional summaries \eqn{\Lambda_1 (t), \Lambda_2 (t), \ldots, \Lambda_N (t)},
compute the weighted sum 
\deqn{\bar{\Lambda} (t) = \sum_{n=1}^N w_n \Lambda_n (t)}
with a specified vector of given weights \eqn{w_1,w_2,\ldots,w_N}.
}
\examples{
# ---------------------------------------------------------------------------
#     Weighted Average of 10 Persistence Landscapes from '2holes' data
# ---------------------------------------------------------------------------
## Generate 10 Diagrams with 'gen2holes()' function
list_rips = list()
for (i in 1:10){
  list_rips[[i]] = diagRips(gen2holes(n=100, sd=2)$data, maxdim=1)
}

## Compute Persistence Landscapes from Each Diagram with k=5 Functions
list_land = list()
for (i in 1:10){
  list_land[[i]] = diag2landscape(list_rips[[i]], dimension=0, k=5)
}

## Some Random Weights
wrand = abs(stats::rnorm(10))
wrand = wrand/sum(wrand)

## Compute Weighted Sum of Landscapes
ldsum = fssum(list_land, weight=wrand)

## Visualize
sam5  <- sort(sample(1:10, 5, replace=FALSE))
opar  <- par(no.readonly=TRUE)
par(mfrow=c(2,3), pty="s")
for (i in 1:5){
  tgt = list_land[[sam5[i]]]
  matplot(tgt$tseq, tgt$lambda[,1:5], type="l", lwd=3, main=paste("landscape no.",sam5[i]))
}
matplot(ldsum$tseq, ldsum$lambda[,1:5], type="l", lwd=3, main="weighted sum")
par(opar)

}
\concept{summaries}
