## plotting simulated data
library(dplyr)
library(ggplot2)
library(reshape2)
library(tidyr)

seed = 1:100
simdat <- data.frame()
for(i in 1:50){
  tempdat <- data.frame(seed=i,simm(R0=R0,N=N,effprop=effprop,i0=i0,repMean=repMean,
                             repSize=repSize,numobs=numobs,seed=i))
  simdat <- rbind(simdat,tempdat)
}

simdf <- (simdat 
  %>% select(c(seed,time,I,Iobs))
)

msimdf <- melt(simdf,id.vars = c("seed","time"))

msimdf <- msimdf %>% mutate(t=variable,s=seed) %>% unite(s_t,s,t)

msimdf$variable <- factor(msimdf$variable,levels = c("Iobs","I"))

(ggplot(msimdf,aes(x=time,y=value,group=s_t,color=factor(seed),linetype=variable))
  + geom_line()
  + theme(legend.position="none")
  + ylab("Number of Infectives")
  + xlab("Time")
)



