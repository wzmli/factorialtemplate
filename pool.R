library(nimble)
library(coda)

filenames <- list.files(pattern="nim.RDS")

temp <- head(filenames)
getsum <- function(n){
  nimbleobject <- readRDS(n)
  name <- unlist(strsplit(n,"[.]"))
  # type/process/observation/sample/nim/RDS
  sam <- nimbleobject$samples
  prod1sam <- sam["jags","effprop",] * sam["jags","repMean",]
  prod2sam <- sam["nimble","effprop",] * sam["nimble","repMean",]
  prod3sam <- sam["nimble_slice","effprop",] * sam["nimble_slice","repMean",]
  class(prod1sam) <- class(prod2sam) <- class(prod3sam) <- "mcmc"
  proddf <- data.frame(mean=c(mean(prod1sam),mean(prod2sam),mean(prod3sam))
                       , median=c(median(prod1sam),median(prod2sam),median(prod3sam))
                       , sd=c(sd(prod1sam),sd(prod2sam),sd(prod3sam))
                       , CI95_low=c(HPDinterval(prod1sam)[,1],HPDinterval(prod2sam)[,1],HPDinterval(prod3sam)[,1])
                       , CI95_upp=c(HPDinterval(prod1sam)[,2],HPDinterval(prod2sam)[,2],HPDinterval(prod3sam)[,2])
                       , n=length(prod1sam)
                       , ess = NA
                       , efficiency= NA)
  sum_output <- nimbleobject$summary
  sumdf <- rbind(sum_output[,,1],sum_output[,,2],sum_output[,,3])
  rownames(sum) <- NULL
  sumdf <- data.frame(sumdf)
  tempdf <- rbind(sumdf,proddf)
  fulldf <- data.frame(sample=name[4]
                       , type=name[1]
                       , process=name[2]
                       , observation=name[3]
                       , parameter=rep(c("R0","effprop","repMean","Effprop*rep"),each=3)
                       , true_parameter=rep(c(2.5,0.75,0.25,0.1875),each=3)
                       , tempdf
                       , platform=rep(c("jags","nimble","nimble_slice"),4)
                       , timing=c(rep(c(nimbleobject$timing[1:3]),3),NA,NA,NA)
  )
}

combineDat <- function(nlist){
  dat <- data.frame()
  for(i in nlist){
    dat <- rbind(dat,getsum(i))
  }
  return(dat)
}

dat <- combineDat(filenames)

#saveRDS(dat,file="dis1.RDS")
