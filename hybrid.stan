data {
int<lower=0> numobs; // number of data points
int obs[numobs]; // response
int N;
real eps;
}
parameters {
real <lower=0.01,upper=4> R0;
real <lower=0.1,upper=0.5> repMean;
real <lower=0.5,upper=0.9> effprop;
real <lower=0> I[numobs];
real  <lower=0> N0;
real <lower=0,upper=N> Nmean;
real <lower=0> i0;
real <lower=0> Ndis;
}
model {
vector[numobs] S;
vector[numobs-1] pSI;
vector[numobs] Imean;
real BETA;
Nmean ~ gamma(fmax(Ndis,eps),Ndis/(effprop*N));
N0 ~ gamma(Nmean,1);
BETA <- exp(-R0/N0);
effprop ~ beta(100,35);
repMean ~ beta(70,100);
Imean[1] <- fmax((1-BETA)*N0,eps);
I[1] ~ gamma(Imean[1],1);
S[1] <- N0 - I[1];
obs[1] ~ poisson(repMean*I[1]);


for (t in 2:numobs) {
  pSI[t-1] <- 1 - BETA^I[t-1];
  Imean[t] <- fmax(pSI[t-1]*S[t-1],eps);
  I[t] ~ gamma(Imean[t],1);;
  S[t] <- S[t-1] - I[t];
  obs[t] ~ poisson(repMean*I[t]);
  }
}