# args <- c("fitting/jags.R", "observation/NB.R", "process/P.R")

args <- commandArgs(trailingOnly = T)
source(args[1])
source(args[2])
source(args[3])

if(type == "hyb"){
  process <- hyb.process
}

priors <- c("
            repMean ~ dbeta(1,1)
            effprop ~ dbeta(1,1)
            initDis ~ dbeta(1,1)
            Ndis ~ dunif(0.1,100)
            
            ## This may be a bad prior
            R0 ~ dgamma(0.1,0.1)
            Nmean ~ dgamma(Ndis,Ndis/(effprop*N))
            N0 ~ dpois(Nmean)
            "
)

S <- c("
       S[1] <- N0 - I[1]
       "
       ,"
       S[t] <- S[t-1] - I[t]
       ")

iterloop <- c("for(t in 2:numobs){","}")

nimstart <- ("
  library(nimble)
  nimcode <- nimbleCode({
")

cat(nimstart
     , priors
     , process[2]
     , S[1]
     , observation[2]
     , iterloop[1]
     , process[3]
     , S[2]
     , observation[3]
     , iterloop[2]
     , "})")