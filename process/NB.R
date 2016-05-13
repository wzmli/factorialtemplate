process <- c("NB"
  ,"
  Pdis ~ dgamma(1,1)
	IMean[1] ~ dgamma(Pdis,Pdis/(initDis*i0))
  I[1] ~ dpois(IMean[1])
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))
  "
  , 
  "
  IMean[t] ~ dgamma(Pdis,Pdis/(pSI[t-1]*S[t-1] + eps))
  I[t] ~ dpois(IMean[t])
  pSI[t] <- 1 - exp(I[t]*log(beta))
  "
)