observation <- c("NB"
  , "
  obsdis ~ dgamma(1,1)
  obsMean[1] ~ dgamma(obsdis,repMean*I[1])
  obs[1] ~ dpois(obsMean[1])
  "
  ,
  #  "for(t in 2:numobs){
  "obsMean[t] ~ dgamma(obsdis,repMean*I[t])
  obs[t] ~ dpois(obsMean[t])
"
#}"
)