process <- c("NB"
  , "
    Pdis ~ dunif(1,100)
	  IMean[1] ~ dgamma(Pdis,Pdis/(initDis*i0))
    I[1] ~ dpois(IMean[1])
    beta <- exp(-R0/N0)
	  pSI[1] <- 1 - beta
  "
  , "
    IMean[t] ~ dgamma(Pdis,Pdis/(pSI[t-1]*S[t-1] + eps))
    I[t] ~ dpois(IMean[t])
    pSI[t] <- 1 - exp(I[t]*log(beta))
  "
)

hyb.process <- c("NB"
  , "
	  I[1] ~ dgamma(i0,1)
    beta <- exp(-R0/N0)
	  pSI[1] <- 1 - exp(I[1]*log(beta))
    Pdis ~ dunif(0,100)
  "
  , "
    I[t] ~ dgamma(Pdis,Pdis/(pSI[t-1]*S[t-1]))
    pSI[t] <- 1 - exp(I[t]*log(beta))
  "
)
