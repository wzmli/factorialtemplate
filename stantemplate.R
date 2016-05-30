if(type[2] == "P"){

cat("I = c(",niminits$I[1],sub("",",",niminits$I[-1]),")"
    , "\n" ,"effprop = ",effprop
    , "\n" , "R0 =", R0
    , "\n" , "repMean = ", repMean
    , "\n" , "Nmean = ", Nmean
    , file = paste(type[2],type[3],seed,"init.R",sep=".")
)

cat("obs = c(",sim$Iobs[1],sub("",",",sim$Iobs[-1]),")"
    , "\n" ,"N = ",N
    , "\n" , "numobs =", numobs
    , "\n" , "i0 = ", i0
    , "\n" , "eps = ", eps
    , file = paste(type[2],type[3],seed,"data.R",sep=".")
)

#poisson process
cat("data {
int<lower=0> numobs; // number of data points
    int obs[numobs]; // response
    int N;
    int i0;
    real eps;
    }
    parameters {
    real <lower=0.01,upper=4> R0;
    real <lower=0.1,upper=0.5> repMean;
    real <lower=0.5,upper=0.9> effprop;
    real <lower=0> I[numobs];
    real  <lower=0> N0;
    real <lower=0,upper=N> Nmean;
    real <lower=0> Ndis;
    }
    model {
    vector[numobs] S;
    vector[numobs-1] pSI;
    vector[numobs] Imean;
    real BETA;
    Ndis ~ uniform(0,100);
    effprop ~ beta(100,35);
    repMean ~ beta(70,100);
    Nmean ~ gamma(fmax(Ndis,eps),Ndis/(effprop*N));
    N0 ~ gamma(Nmean,1);
    BETA <- exp(-R0/N0);
    Imean[1] <- fmax((1-BETA)*N0,eps);
    I[1] ~ gamma(Imean[1],1);
    S[1] <- N0 - I[1];
    obs[1] ~ poisson(repMean*I[1]);
    
    
    for (t in 2:numobs) {
    pSI[t-1] <- 1 - BETA^I[t-1];
    Imean[t] <- fmax(pSI[t-1]*S[t-1],eps);
    I[t] ~ gamma(Imean[t],1);
    S[t] <- S[t-1] - I[t];
    obs[t] ~ poisson(repMean*I[t]);
    }
    }"
    , file = paste(type[2],type[3],seed,"stan",sep=".")
)

stanmod = paste(type[2],type[3],seed,"stan",sep=".")
}

if(type[2] == "NB"){
  
  cat("I = c(",niminits$I[1],sub("",",",niminits$I[-1]),")"
      , "\n" ,"effprop = ",effprop
      , "\n" , "R0 =", R0
      , "\n" , "repMean = ", repMean
      , "\n" , "Nmean = ", Nmean
      , file = paste(type[2],type[3],seed,"init.R",sep=".")
  )
  
  cat("obs = c(",sim$Iobs[1],sub("",",",sim$Iobs[-1]),")"
      , "\n" ,"N = ",N
      , "\n" , "numobs =", numobs
      , "\n" , "i0 = ", i0
      , "\n" , "eps = ", eps
      , file = paste(type[2],type[3],seed,"data.R",sep=".")
  )
  
  #NB process
  cat("data {
      int<lower=0> numobs; // number of data points
      int obs[numobs]; // response
      int N;
      int i0;
      real eps;
}
parameters {
real <lower=0.01,upper=4> R0;
real <lower=0.1,upper=0.5> repMean;
real <lower=0.5,upper=0.9> effprop;
real <lower=0> I[numobs];
real  <lower=0> N0;
real <lower=0,upper=N> Nmean;
real <lower=0> Ndis;
real <lower=0> Pdis;
}
model {
vector[numobs] S;
vector[numobs-1] pSI;
vector[numobs] Imean;
real BETA;
Ndis ~ uniform(0.1,100);
effprop ~ beta(100,35);
repMean ~ beta(70,100);
Pdis ~ uniform(0.1,100);
Nmean ~ gamma(fmax(Ndis,eps),Ndis/(effprop*N));
N0 ~ gamma(Nmean,1);

I[1] ~ gamma(i0,1);
BETA <- exp(-R0/N0);
S[1] <- N0 - I[1];
obs[1] ~ poisson(repMean*I[1]);


for (t in 2:numobs) {
pSI[t-1] <- 1 - BETA^I[t-1];
I[t] ~ gamma(fmax(Pdis,eps),fmax(Pdis/(pSI[t-1]*S[t-1]),eps));
S[t] <- S[t-1] - I[t];
obs[t] ~ poisson(repMean*I[t]);
}
}"
    , file = paste(type[2],type[3],seed,"stan",sep=".")
)

stanmod = paste(type[2],type[3],seed,"stan",sep=".")
}


if(type[2] == "B"){
  
  cat("I = c(",niminits$I[1],sub("",",",niminits$I[-1]),")"
      , "\n" ,"effprop = ",effprop
      , "\n" , "R0 =", R0
      , "\n" , "repMean = ", repMean
      , "\n" , "Nmean = ", Nmean
      , file = paste(type[2],type[3],seed,"init.R",sep=".")
  )
  
  cat("obs = c(",sim$Iobs[1],sub("",",",sim$Iobs[-1]),")"
      , "\n" ,"N = ",N
      , "\n" , "numobs =", numobs
      , "\n" , "i0 = ", i0
      , "\n" , "eps = ", eps
      , file = paste(type[2],type[3],seed,"data.R",sep=".")
  )
  
  #B process
  cat("data {
      int<lower=0> numobs; // number of data points
      int obs[numobs]; // response
      int N;
      int i0;
      real eps;
}
parameters {
real <lower=0.01,upper=4> R0;
real <lower=0.1,upper=0.5> repMean;
real <lower=0.5,upper=0.9> effprop;
real <lower=0> I[numobs];
real  <lower=0> N0;
real <lower=0,upper=N> Nmean;
real <lower=0> Ndis;
}
model {
vector[numobs] S;
vector[numobs-1] pSI;
vector[numobs] Imean;
vector[numobs-1] SIGshape;
vector[numobs-1] SIGrate;
real BETA;
Ndis ~ uniform(0.1,100);
effprop ~ beta(100,35);
repMean ~ beta(70,100);
Nmean ~ gamma(fmax(Ndis,eps),Ndis/(effprop*N));
N0 ~ gamma(Nmean,1);

I[1] ~ gamma(i0,1);
BETA <- exp(-R0/N0);
S[1] <- N0 - I[1];
obs[1] ~ poisson(repMean*I[1]);


for (t in 2:numobs) {
pSI[t-1] <- 1 - BETA^I[t-1];
SIGrate[t-1] <- 1/(1-pSI[t-1] + eps);
SIGshape[t-1] <- pSI[t-1]*S[t-1]*SIGrate[t-1];
I[t] ~ gamma(fmax(SIGshape[t-1],eps),fmax(SIGrate[t-1],eps));
S[t] <- S[t-1] - I[t];
obs[t] ~ poisson(repMean*I[t]);
}
}"
    , file = paste(type[2],type[3],seed,"stan",sep=".")
)

stanmod = paste(type[2],type[3],seed,"stan",sep=".")
}


if(type[2] == "BB"){
  
  cat("I = c(",niminits$I[1],sub("",",",niminits$I[-1]),")"
      , "\n" ,"effprop = ",effprop
      , "\n" , "R0 =", R0
      , "\n" , "repMean = ", repMean
      , "\n" , "Nmean = ", Nmean
      , file = paste(type[2],type[3],seed,"init.R",sep=".")
  )
  
  cat("obs = c(",sim$Iobs[1],sub("",",",sim$Iobs[-1]),")"
      , "\n" ,"N = ",N
      , "\n" , "numobs =", numobs
      , "\n" , "i0 = ", i0
      , "\n" , "eps = ", eps
      , file = paste(type[2],type[3],seed,"data.R",sep=".")
  )
  
  #BB process
  cat("data {
      int<lower=0> numobs; // number of data points
      int obs[numobs]; // response
      int N;
      int i0;
      real eps;
}
parameters {
real <lower=0.01,upper=4> R0;
real <lower=0.1,upper=0.5> repMean;
real <lower=0.5,upper=0.9> effprop;
real <lower=0> I[numobs];
real  <lower=0> N0;
real <lower=0,upper=N> Nmean;
real <lower=0> Pdis;
real <lower=0> Ndis;
}
model {
vector[numobs] S;
vector[numobs-1] pSI;
vector[numobs-1] x;
vector[numobs-1] y;
vector[numobs-1] kappa;
vector[numobs-1] SIGshape;
vector[numobs-1] SIGrate;
real BETA;
Pdis ~ uniform(0.1,100);
Ndis ~ uniform(0.1,100);
effprop ~ beta(100,35);
repMean ~ beta(70,100);
Nmean ~ gamma(fmax(Ndis,eps),Ndis/(effprop*N));
N0 ~ gamma(Nmean,1);

I[1] ~ gamma(i0,1);
BETA <- exp(-R0/N0);
S[1] <- N0 - I[1];
obs[1] ~ poisson(repMean*I[1]);


for (t in 2:numobs) {
pSI[t-1] <- 1 - BETA^I[t-1];
x[t-1] <- Pdis/(1-pSI[t-1]+eps);
y[t-1] <- Pdis/(pSI[t-1]+eps);
kappa[t-1] <- (x[t-1]+y[t-1]+1)/(y[t-1]*(x[t-1]+y[t-1]+S[t-1]));
SIGrate[t-1] <- (x[t-1]+y[t-1])*kappa[t-1];
SIGshape[t-1] <- S[t-1]*x[t-1]*kappa[t-1];
I[t] ~ gamma(fmax(SIGshape[t-1],eps),fmax(SIGrate[t-1],eps));
S[t] <- S[t-1] - I[t];
obs[t] ~ poisson(repMean*I[t]);
}
}"
    , file = paste(type[2],type[3],seed,"stan",sep=".")
)

stanmod = file = paste(type[2],type[3],seed,"stan",sep=".")
}