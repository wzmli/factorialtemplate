library(dplyr)
library(ggplot2)
library(tidyr)
library(reshape2)

names <- list.files(pattern = "RDS")
dat <- data.frame()
for(i in names){
  dat <- rbind(dat,readRDS(i))
}

## true parameter is wrong for effprop, repMean, effprop*repMean
Tpara <- function(x){
  if(x=="R0"){return(2)}
  if(x=="effprop"){return(0.7)}
  if(x=="repMean"){return(0.4)}
  if(x=="Effprop*rep"){return(0.28)}
}

dat2 <- (dat 
  %>% rowwise()
  %>% mutate(par=parameter
      , true_parameter=Tpara(par)
      , p = process
      , o = observation
      , plat = platform
      , t = type
      )
  %>% unite(t_p_o_par_plat,type,process,observation,par,platform) 
  %>% ungroup()
  %>% group_by(sample,p,o,parameter)
  %>% mutate(Timing=timing/max(timing,na.rm=TRUE))
  %>% filter(parameter!="Effprop*rep")
  %>% ungroup()
  %>% group_by(p,o,parameter,t,plat)
  %>% mutate(lower = min(CI95_low)
             , upper = max(CI95_upp)
             )
  %>% ungroup()
)
sumdat <- (dat2
  %>% group_by(t_p_o_par_plat)
  %>% summarise(Mean = mean(mean)
                , Timing = mean(Timing)
                , coverage=mean(CI95_low<true_parameter & true_parameter<CI95_upp)
                , type = first(t)
                , process = first(p)
                , observation = first(o)
                , platform = first(plat)
                , parameter = first(parameter)
  )
)

g1 <- (ggplot(dat2,aes(x=t_p_o_par_plat,y=mean,color=o))
  + geom_boxplot()
  + facet_grid(parameter~t+p,scale="free")
  # + geom_line(aes(group=sample),alpha=0.5)
  + theme_bw()
)

sumdat2 <- melt(sumdat,id=c("t_p_o_par_plat"
                            , "type"
                            , "process"
                            , "observation"
                            , "platform"
                            , "parameter"
                            , "Mean"))

g2 <- (ggplot(subset(sumdat2,parameter=="R0"),aes(x=platform,y=value,color=variable))
  + geom_point()
  + geom_line(aes(group=variable))
  + facet_grid(observation~type+process,scale="free")
  + theme_bw()
  )

g1 %+% subset(sumdat,parameter=="R0")+ geom_hline(yintercept = 2.5)

g1 %+% subset(sumdat,parameter=="effprop")+ geom_hline(yintercept = 0.75)

ggplot(sumdat,aes(x=t_p_o_par,y=Timing)) + geom_point()
