require(nimble)

type <- unlist(strsplit(rtargetname,"[.]"))

##options(mc.cores = parallel::detectCores())
nimbleOptions(verifyConjugatePosteriors=TRUE)
nimdata <- lme4:::namedList(obs=sim$Iobs)
nimcon <- lme4:::namedList(numobs
  , N
  , i0
)

niminits <- lme4:::namedList(I=sim$I,effprop,R0,repMean,N0, 
                               initDis=0.2)

if(type[2] == "BB"){
  nimcon <- c(nimcon, lme4:::namedList(pSISize=repSize, eps))
  niminits <- c(niminits, lme4:::namedList(pSIa=sim$pSI,pSIb=sim$pSI))
}

if(type[3] == "BB"){
  nimcon <- c(nimcon, lme4:::namedList(repobsSize=repSize,eps))
  niminits <- c(niminits, lme4:::namedList(repobsa=repMean, repobsb=repMean))
}

params <- c("R0","effprop","repMean")

# nimmod <- nimbleModel(code=nimcode,constants=nimCBcon, data=nimCBdata,
#                       inits=nimCBinits)
# aa <- configureMCMC(nimmod,print=TRUE)
# 
# # nimble is not picking up the conjugate beta priors for nimble
NimbleCB <- MCMCsuite(code=nimcode,
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

print(NimbleCB$timing)
print(NimbleCB$summary)
