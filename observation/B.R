observation <- c("B"
  , "
  obs[1] ~ dbin(repMean,I[1])
  "
  ,
#  "for(t in 2:numobs){
    "obs[t] ~ dbin(repMean,I[t]) 
"
#}"
)