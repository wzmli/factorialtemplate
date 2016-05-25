observation <- c("NB"
  , "
  obsdis ~ dgamma(1,1)
  obsMean[1] ~ dgamma(obsdis,obsdis/(repMean*I[1]))
  obs[1] ~ dpois(obsMean[1])
  "
  ,
  "obsMean[t] ~ dgamma(obsdis,obsdis/(repMean*I[t]))
  obs[t] ~ dpois(obsMean[t])
"
)