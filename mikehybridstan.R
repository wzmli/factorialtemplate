require(rstan)

data <- list(obs=c(0,0,0,5,4,12,60,209,169,178,219,123,32,1,2)
             ,N=10000
             ,numobs=15
             ,i0=1
             ,eps=0.001
             
)
inits <- list(list(I=c(1,3,4,12,37,140,537,764,1755,1893,975,570,173,53,7)
              ,effprop=0.75
              ,R0=3
              ,repMean=0.2
              ,N0=9000
              ,Nmean=100))
sim <- stan(file="hybrid.stan",data=data,init=inits,
             pars=c("R0"),
             iter=200,
             chains=1)

print(sim)
