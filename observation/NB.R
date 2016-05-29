observation <- c("NB"
  , "
  obsdis ~ dunif(1,100)
  obsMean[1] ~ dgamma(obsdis,obsdis/(repMean*I[1]+eps))
  obs[1] ~ dpois(obsMean[1])
  "
  ,
  "obsMean[t] ~ dgamma(obsdis,obsdis/(repMean*I[t]+eps))
  obs[t] ~ dpois(obsMean[t])
"
)