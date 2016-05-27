## plotting simulated data

seed = 1:200
sims = lapply(seed,simm,R0=R0,N=N,
              effprop=effprop,i0=i0,repMean=repMean,repSize=repSize,numobs=numobs)
matplot(sapply(sims,"[[","Iobs"),type="l",lty=1)

