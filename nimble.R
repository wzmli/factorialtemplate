library(nimble)
library(methods)
# args <- c("dat.R","dis.BB.BB.nimR")
# input_files <- "hyb_BB_P.nimR"

args <- commandArgs(trailingOnly = T)


type <- unlist(strsplit(args[2],"[_]"))
type4sep <- unlist(strsplit(type[4],"[.]"))
seed <- type4sep[1]
source(args[1])
source(args[2])

##options(mc.cores = parallel::detectCores())
nimbleOptions(verifyConjugatePosteriors=TRUE)
nimdata <- lme4:::namedList(obs=sim$Iobs)
nimcon <- lme4:::namedList(numobs
                           , N
                           , i0
)

niminits <- lme4:::namedList(I=sim$I,effprop,R0,repMean,N0, 
                             initDis=0.2, Ndis=2, Nmean=1)
if(type[1] == "dis"){
if(type[2] == "BB"){
  nimcon <- c(nimcon, lme4:::namedList(pSISize=repSize,eps))
  niminits <- c(niminits, lme4:::namedList(pSIa=sim$pSI,pSIb=sim$pSI))
}
if(type[2] == "NB"){
    nimcon <- c(nimcon, lme4:::namedList(eps))
    niminits <- c(niminits, lme4:::namedList(IMean=sim$I,Pdis))
}

if(type[3] == "BB"){
  nimcon <- c(nimcon, lme4:::namedList(repobsSize=repSize))
  niminits <- c(niminits, lme4:::namedList(repobsa=repMean, repobsb=repMean))
}
}
 
# 
# if(type[1] == "hyb"){
#   if(type[2] == "BB"){
#     nimdata <- c(nimdata,lme4:::namedList(Pdis))
#     # nimcon <- c(nimcon, lme4:::namedList(Pdis=repSize))
#     # niminits <- c(niminits, lme4:::namedList(x=sim$pSI,y=sim$pSI))
#   }
#   if(type[2] == "NB"){
#     nimdata <- c(nimdata,lme4:::namedList(Pdis))
#     nimcon <- c(nimcon, lme4:::namedList(eps))
#   }
# }
#   
  
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
                      savePlot=FALSE)

print(FitModel$summary)

# saveRDS(FitModel,file=paste(type[1],type[2],type3sep[1],"nim","RDS",sep = "."))

