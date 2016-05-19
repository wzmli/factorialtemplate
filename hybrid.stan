data {
int<lower=0> numobs; // number of data points
int obs[numobs]; // response
int N;
real eps;
}
parameters {
real <lower=0.01,upper=10> R0;
real <lower=0,upper=0.9> repMean;
real <lower=0,upper=1> effprop;
real <lower=0,upper=1> initDis;
real <lower=0> I[numobs];
real  <lower=0> N0;
real <lower=0,upper=N> Nmean;
real <lower=0.001> Pdis;
real <lower=0.001> Ndis;
real <lower=0> i0;
}
transformed parameters{
real <lower=0.0000000001> beta;
beta <- exp(-R0/N0);

}
model {
vector[numobs] S;
vector[numobs] pSI;
vector[numobs-1] SIGshape;
vector[numobs-1]SIGrate;
vector[numobs] x;
vector[numobs] y;
vector[numobs-1] kappa;
N0 ~ gamma(Ndis,Ndis/effprop*N);

I[1] ~ gamma(i0,1);
S[1] <- N0 - I[1];
pSI[1] <- 1 - exp(I[1]*log(beta)) + eps;
x[1] <- Pdis/(1-pSI[1]);
y[1] <- Pdis/(pSI[1]);
obs[1] ~ poisson(repMean*I[1]);


for (t in 2:numobs) {
  kappa[t-1] <- (x[t-1]+y[t-1]+1)/(y[t-1]*(x[t-1]+y[t-1]+S[t-1]));
  SIGshape[t-1] <- S[t-1]*x[t-1]*kappa[t-1];
  SIGrate[t-1] <- (x[t-1]+y[t-1])*kappa[t-1];
  print(" pSI=",pSI);
  I[t] ~ gamma(SIGshape[t-1],SIGrate[t-1]);
  pSI[t] <- 1 - exp(I[t]*log(beta))+eps;
  x[t] <- Pdis/(1-pSI[t]); 
  y[t] <- Pdis/(pSI[t]);
  S[t] <- S[t-1] - I[t];
  obs[t] ~ poisson(repMean*I[t]);
  }
}