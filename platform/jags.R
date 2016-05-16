require(R2jags)
# options(mc.cores = parallel::detectCores())

type <- unlist(strsplit(rtargetname,"[.]"))

mult <- 1:4
data <- lme4:::namedList(obs=sim$Iobs
  , N
  , i0=6
  , numobs
)

iList <- lme4:::namedList(effprop=0.7
  , R0 = 1
  , N0
  , initDis=0.2
  , repMean=0.5
)

if(type[3] == "BB"){
  data <- c(data, lme4:::namedList(pSISize=repSize, eps))
  iList <- c(iList, lme4:::namedList(pSIa=sim$pSI,pSIb=sim$pSI))
}

if(type[3] == "NB"){
  data <- c(data, lme4:::namedList(Pdis,eps))
  iList <- c(iList, lme4:::namedList(IMean=sim$I))
}

if(type[4] == "BB"){
  data <- c(data, lme4:::namedList(repobsSize=repSize))
  iList <- c(iList, lme4:::namedList(repobsa=repMean, repobsb=repMean))
}

inits <- lapply (mult, function(m){
  return(c(iList, list(I = c(m+sim$Iobs))))
})

params <- c("R0","effprop","repMean")

print(type)
print(data)
print(inits)
print(length(inits))


# Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

# list.samplers(Jagsmod)

system.time(JagsDiscrete <- jags(data=data,
                inits=inits,
                param = params,
                model.file = input_files[[1]],
                n.iter = iterations,
                n.chains = length(inits))
            )

print(JagsDiscrete)

# rdsave(JagsDiscrete)
