process <- c("P"
  , "
  beta <- exp(-R0/N0)
	IMean[1] <- i0*R0
  I[1] ~ dpois(IMean[1])
  "
  , 
#  "for(t in 2:numobs){
  " IMean[t] <- (1 - exp(I[t-1]*log(beta)))*S[t-1]
    I[t] ~ dpois(IMean[t])"
#  }
)