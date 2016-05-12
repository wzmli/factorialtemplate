process <- c("BB"
  ,"
	I[1] ~ dbin(initDis,i0)
  beta <- exp(-R0/N0)
	pSI[1] <- 1 - exp(I[1]*log(beta))+eps
	pSIa[1] ~ dgamma(pSISize/(1-pSI[1]),1)
	pSIb[1] ~ dgamma(pSISize/(pSI[1]),1)
  "
  , 
#  "for(t in 2:numobs){
  "I[t] ~ dbin(pSIa[t-1]/(pSIa[t-1]+pSIb[t-1]),S[t-1])
  pSI[t] <- 1 - exp(I[t]*log(beta))+eps
	pSIa[t] ~ dgamma(pSISize/(1-pSI[t]),1)
	pSIb[t] ~ dgamma(pSISize/(pSI[t]),1)
"
#}"
)