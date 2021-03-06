#' Multidimensional Scaling
#' 
#' Given multiple functional summaries \eqn{\Lambda_1 (t), \Lambda_2 (t), \ldots, \Lambda_N (t)}, 
#' apply multidimensional scaling to get low-dimensional representation in Euclidean space. Usually, 
#' \code{ndim=2,3} is chosen for visualization.
#' 
#' @param fslist a length-\eqn{N} list of functional summaries of persistent diagrams.
#' @param ndim an integer-valued target dimension (default: 2).
#' @param method name of an algorithm type (default: classical).
#' 
#' @return an \eqn{(N\times ndim)} matrix of embedding.
#' 
#' @examples
#' \donttest{
#' # ---------------------------------------------------------------------------
#' #     Multidimensional Scaling for Multiple Landscapes and Silhouettes
#' #
#' # We will compare dim=0 with top-5 landscape and silhouette functions with 
#' # - Class 1 : 'iris' dataset with noise
#' # - Class 2 : samples from 'gen2holes()'
#' # - Class 3 : samples from 'gen2circles()'
#' # ---------------------------------------------------------------------------
#' ## Generate Data and Diagram from VR Filtration
#' ndata     = 10
#' list_rips = list()
#' for (i in 1:ndata){
#'   dat1 = as.matrix(iris[,1:4]) + matrix(rnorm(150*4), ncol=4)
#'   dat2 = gen2holes(n=100, sd=1)$data
#'   dat3 = gen2circles(n=100, sd=1)$data
#'   
#'   list_rips[[i]] = diagRips(dat1, maxdim=1)
#'   list_rips[[i+ndata]] = diagRips(dat2, maxdim=1)
#'   list_rips[[i+(2*ndata)]] = diagRips(dat3, maxdim=1)
#' }
#' 
#' ## Compute Landscape and Silhouettes of Dimension 0
#' list_land = list()
#' list_sils = list()
#' for (i in 1:(3*ndata)){
#'   list_land[[i]] = diag2landscape(list_rips[[i]], dimension=0)
#'   list_sils[[i]] = diag2silhouette(list_rips[[i]], dimension=0)
#' }
#' list_lab = rep(c(1,2,3), each=ndata)
#' 
#' ## Run Classical/Metric Multidimensional Scaling
#' land_cmds = fsmds(list_land, method="classical")
#' land_mmds = fsmds(list_land, method="metric")
#' sils_cmds = fsmds(list_sils, method="classical")
#' sils_mmds = fsmds(list_sils, method="metric")
#' 
#' ## Visualize
#' opar <- par(no.readonly=TRUE)
#' par(mfrow=c(2,2))
#' plot(land_cmds, pch=19, col=list_lab, main="Landscape+CMDS")
#' plot(land_mmds, pch=19, col=list_lab, main="Landscape+MMDS")
#' plot(sils_cmds, pch=19, col=list_lab, main="Silhouette+CMDS")
#' plot(sils_mmds, pch=19, col=list_lab, main="Silhouette+MMDS")
#' par(opar)
#' }
#' 
#' @concept summaries
#' @export
fsmds <- function(fslist, ndim=2, method=c("classical","metric")){
  mydim = max(1, round(ndim))
  mymds = match.arg(method)
  
  if (inherits(fslist, "dist")){
    pdist = fslist
  } else {
    dtype = check_list_summaries("fsmds", fslist)
    pdist = TDAkit::fsdist(fslist, p=2, as.dist=TRUE)
  }

  ## MDS FROM MAOTAI
  if (all(mymds=="classical")){
    func.import = utils::getFromNamespace("hidden_cmds","maotai")
    output      = func.import(pdist, ndim=mydim)
    return(output$embed)
  } else {
    func.import = utils::getFromNamespace("hidden_mmds","maotai")
    output      = func.import(pdist, ndim=mydim)
    return(output)
  }
}