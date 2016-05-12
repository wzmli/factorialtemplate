observation <- c("P"
  , "
  obs[1] ~ dpois(I[1]*repMean)
  "
  , 
#  " for(t in 2:numobs){
    "obs[t] ~ dpois(I[t]*repMean)
"
#}"
)