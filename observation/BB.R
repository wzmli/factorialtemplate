observation <- c("BB",
  "
  repobsa ~ dgamma(repobsSize/(1-repMean), 1)
	repobsb ~ dgamma(repobsSize/repMean, 1)
	reporting <- repobsa/(repobsa + repobsb)
	obs[1] ~ dbin(reporting , I[1])
  "
  , 
#  " for(t in 2:numobs){
  "obs[t] ~ dbin(reporting , I[t])
"
#}"
)