% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/snp_trans_012.R
\name{snp_trans_012}
\alias{snp_trans_012}
\title{Change the Siminute SNP data to 012 format}
\usage{
snp_trans_012(geno)
}
\arguments{
\item{geno}{A format that has row.name(ID), and first column is first allet of SNP(1,2)}

\item{y}{A number.}
}
\value{
The sum of \code{x} and \code{y}.
}
\description{
Change the Siminute SNP data to 012 format
}
\examples{
gg <- data.frame(V1 = c(1,1,2,2,1,2,1,2),V2 = c(1,1,2,2,1,2,1,2),V3 = c(2,1,2,2,1,1,2,1),V4=round(runif(8,1,2)),V5=round(runif(8,1,2)),V6=round(runif(8,1,2)))
row.names(gg) <- paste("ID",1:8,sep="")
gg
snp_trans_012(gg)

}
