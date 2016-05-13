# args <- c("fitting/jags.R", "observation/NB.R", "process/P.R")

args <- commandArgs(trailingOnly = T)
source(args[2])
source(args[3])

priors <- ("
  repMean ~ dbeta(1,1)
	effprop ~ dbeta(100,35)
	initDis ~ dbeta(1,1)
  Ndis ~ dgamma(1,1)

	## This may be a bad prior
	R0 ~ dgamma(3,1)

	## This one should probably be negative binomial
	Nmean ~ dgamma(Ndis,Ndis/effprop*N)
  N0 ~ dpois(Nmean)
")

S <- c("
  S[1] <- N0 - I[1]
  "
  ,"
    S[t] <- S[t-1] - I[t]
")

iterloop <- c("for(t in 2:numobs){","}")

## Jags bugs script
cat("model{"
     , priors
     , process[2]
     , S[1]
     , observation[2]
     , iterloop[1]
     , process[3]
     , S[2]
     , observation[3]
     , iterloop[2]
     , "}"
     # , file=paste("jags_",process[1],"_",observation[1],".bug",sep=""))
)


