#' Build the H-inverse-matrix from G-inverse-matrix and pedigree-full and pedigree-genotype#'
#' @param G_mat It is the matrix which has rownames and colnames(ID)
#' @param ped_full It contains the full pedigree, it has three columns:ID,Sire,Dam
#' @return The H-inverse-matrix form the formula
#' @examples
#'
#' # paper:Legarra A, Aguilar I, Misztal I. A relationship matrix including full pedigree and genomic information.[J]. Journal of Dairy Science, 2009, 92(9):4656-63.
#'ped_full <- data.frame(ID=9:17,Sire=c(1,3,5,7,9,11,11,13,13),Dam=c(2,4,6,8,10,12,4,15,14))
#'ped_full
#'G <- matrix(0.7,4,4)
#'diag(G) <- 1
#'rownames(G) <- colnames(G) <- 9:12
#'G
#'library(tidyverse)
#'hinv <- hinv_matrix(G,ped_full)
#'hinv
#'id1 <- as.character(1:17)
#'ww <- round(solve(hinv),3)
#'ww[id1,id1] # same with the paper
#'#another example
#' library(MASS)
#' animal  <- 13:26
#' data.11.1 <- data.frame(animal,
#'                         sire  = c(0,0,13,15,15,14,14,14,1,14,14,14,14,14),
#'                         dam   = c(0,0,4,2,5,6,9,9,3,8,11,10,7,12),
#'                         mean  = rep(1,length(animal)),
#'                         EDC   = c(558,722,300,73,52,87,64,103,13,125,93,66,75,33),
#'                         fat_DYD = c(9.0,13.4,12.7,15.4,5.9,7.7,10.2,4.8,7.6,8.8,9.8,9.2,11.5,13.3),
#'                         SNP1  = c(2,1,1,0,0,1,0,0,2,0,0,1,0,1),
#'                         SNP2  = c(0,0,1,0,1,1,0,1,0,0,1,0,0,0),SNP3  = c(1,0,2,2,1,0,1,1,0,0,1,0,0,1),
#'                         SNP4  = c(1,0,1,1,2,1,1,0,0,1,0,0,1,1),
#'                         SNP5  = c(0,0,1,0,0,0,0,0,0,1,0,1,1,0),
#'                         SNP6  = c(0,2,0,1,0,2,2,1,1,2,1,1,2,2),
#'                         SNP7  = c(0,0,0,0,0,0,0,0,2,0,0,0,0,0),
#'                         SNP8  = c(2,2,2,2,2,2,2,2,2,2,2,2,2,1),
#'                         SNP9  = c(1,1,1,2,1,2,2,2,1,0,2,0,1,0),
#'                         SNP10 = c(2,0,2,1,2,1,0,0,2,0,1,0,0,0))
#'                         rm(list="animal")
#'                         animal <- 1:26
#'                         sire   <- c(rep(0,12), data.11.1$sire)
#'                         dam    <- c(rep(0,12), data.11.1$dam)
#'                         ped_full    <- data.frame(animal, sire, dam)
#'                         rm(list=c("animal","dam","sire"))
#'                         M <- data.11.1[6:14, c(1, 7:16)]
#'                         rownames(M) <- M[, 1]
#'                         M012 <- as.matrix(M[, -1])
#'                         G = sommer::A.mat(M012-1)
#'                         round(hinv_matrix(M012,ped_full),3)



hinv_matrix <- function(M012,ped_full,diagadd=0.001){
  cat("G matrix diagonal add:",diagadd,"\n")
  library(MASS)
  library(sommer)
  library(nadiv)

  G <- A.mat(M012-1)
  diag(G)=diag(G) + diagadd
  pped = prepPed(ped_full)
  id = pped[,1]
  A <- as.matrix(makeA(pped))
  iA <- solve(A)
  rownames(iA) = colnames(iA) =rownames(A) = colnames(A) =  id

  idg=rownames(G)
  ida=setdiff(id,idg)
  A22 <- A[idg,idg]
  iA22 <- solve(A22)
  iG <- solve(G)

  x22 <- iG - iA22
  iH11 <- iA[ida,ida]
  iH21 <- iA[idg,ida]
  iH12 <- t(iH21)
  iH22 <-  iA[idg,idg] + x22
  Hinv <- cbind(rbind(iH11,iH21),rbind(iH12,iH22))
  return(Hinv)
}
