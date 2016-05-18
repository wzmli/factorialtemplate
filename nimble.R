library(nimble)
# args <- c("dat.R","dis_BB_BB.nimR")

args <- commandArgs(trailingOnly = T)

source(args[1])
source(args[2])
type <- unlist(strsplit(args[2],"[_]"))
type3sep <- unlist(strsplit(type[3],"[.]"))

##options(mc.cores = parallel::detectCores())
nimbleOptions(verifyConjugatePosteriors=TRUE)
nimdata <- lme4:::namedList(obs=sim$Iobs)
nimcon <- lme4:::namedList(numobs
                           , N
                           , i0
)

niminits <- lme4:::namedList(I=sim$I,effprop,R0,repMean,N0, 
                             initDis=0.2)
if(type[1] == "dis"){
if(type[2] == "BB"){
  nimcon <- c(nimcon, lme4:::namedList(pSISize=repSize, eps))
  niminits <- c(niminits, lme4:::namedList(pSIa=sim$pSI,pSIb=sim$pSI))
}
if(type[2] == "NB"){
    data <- c(data, lme4:::namedList(Pdis,eps))
    iList <- c(iList, lme4:::namedList(IMean=sim$I))
}

if(type[3] == "BB.nimR"){
  nimcon <- c(nimcon, lme4:::namedList(repobsSize=repSize))
  niminits <- c(niminits, lme4:::namedList(repobsa=repMean, repobsb=repMean))
}
}
 
params <- c("R0","effprop","repMean")

# nimmod <- nimbleModel(code=nimcode,constants=nimcon, data=nimdata,
#                       inits=niminits)
# aa <- configureMCMC(nimmod,print=TRUE)
# 
# nimble is not picking up the conjugate beta priors for nimble
FitModel <- MCMCsuite(code=nimcode,
                      data=nimdata,
                      inits=niminits,
                      constants=nimcon,
                      MCMCs=c("jags","nimble","nimble_slice"),
                      monitors=params,
                      calculateEfficiency=TRUE,
                      niter=iterations,
                      makePlot=FALSE,
                      savePlot=FALSE,
                      setSeed=5)

print(FitModel$summary)

saveRDS(FitModel,file=paste(type[1],type[2],type3sep[1],"nim","RDS",sep = "."))

