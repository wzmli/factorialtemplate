require(R2jags)
# options(mc.cores = parallel::detectCores())

args <- commandArgs(trailingOnly = T)
source(args[1])
type <- unlist(strsplit(args[2],"[_]"))
type3sep <- unlist(strsplit(type[3],"[.]"))

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

if( type[1] == "dis"){
  if(type[2] == "BB"){
    data <- c(data, lme4:::namedList(pSISize=repSize, eps))
    iList <- c(iList, lme4:::namedList(pSIa=sim$pSI,pSIb=sim$pSI))
  }

  if(type[2] == "NB"){
    data <- c(data, lme4:::namedList(Pdis,eps))
    iList <- c(iList, lme4:::namedList(IMean=sim$I))
  }

  if(type[3] == "BB.bug"){
    data <- c(data, lme4:::namedList(repobsSize=repSize))
    iList <- c(iList, lme4:::namedList(repobsa=repMean, repobsb=repMean))
  }
}

inits <- lapply (mult, function(m){
  return(c(iList, list(I = c(m+sim$Iobs))))
})

params <- c("R0","effprop","repMean")

# Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)

# list.samplers(Jagsmod)

system.time(JagsModel <- jags(data=data,
                inits=inits,
                param = params,
                model.file = args[2],
                n.iter = iterations,
                n.chains = length(inits))
            )

print(JagsModel)

saveRDS(JagsModel,file=paste(type[1],type[2],type3sep[1],"RDS",sep = "."))
# 
# # rdsave(JagsDiscrete)
