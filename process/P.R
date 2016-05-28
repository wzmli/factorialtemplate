process <- c("P"
  , "
    beta <- exp(-R0/N0)
    IMean[1] <- (1-beta)*(N0-1)
    I[1] ~ dpois(IMean[1])
    beta <- exp(-R0/N0)
	  pSI[1] <- 1 - exp(I[1]*log(beta))
  "
  , "
    IMean[t] <- pSI[t-1]*S[t-1]
    pSI[t] <- 1 - exp(I[t]*log(beta))
    I[t] ~ dpois(IMean[t])
  "
)

hyb.process <- c("P"
  , "
    beta <- exp(-R0/N0)
    IMean[1] <- (1-beta)*(N0)
    I[1] ~ dgamma(IMean[1],1)
    pSI[1] <- 1 - exp(I[1]*log(beta))
  "
  , " 
    IMean[t] <- pSI[t-1]*S[t-1]
    pSI[t] <- 1 - exp(I[t]*log(beta))
    I[t] ~ dgamma(IMean[t],1)
  "
)
