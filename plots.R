library(dplyr)
library(ggplot2)
library(tidyr)
library(reshape2)
scale_colour_discrete <- function(...,palette="Dark2")
  scale_colour_brewer(...,palette=palette)

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
#  %>% mutate(Timing=timing/max(timing,na.rm=TRUE))
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
                , Median = median(median)
                , timing = median(timing)
                , coverage=mean(CI95_low<true_parameter & true_parameter<CI95_upp)
                , ESS = median(ess)
                , efficiency = median(efficiency) 
                , lowerCI = median(CI95_low)
                , upperCI = median(CI95_upp)
                , type = first(t)
                , process = first(p)
                , observation = first(o)
                , platform = first(plat)
                , parameter = first(parameter)
  )
)

msumdat <- melt(sumdat,id=c("t_p_o_par_plat"
                            , "timing"
                            , "type"
                            , "process"
                            , "observation"
                            , "platform"
                            , "parameter"
                            , "coverage"
                            , "ESS"
                            , "efficiency"))

g1 <- (ggplot(msumdat,aes(x=t_p_o_par_plat,y=value,color=observation,group=t_p_o_par_plat))
  + geom_point()
  + geom_line()
  + facet_grid(parameter~type+process,scale="free",space = "free_x")
  # + geom_line(aes(group=sample),alpha=0.5)
  + theme_bw()
  + ggtitle("Parameter Estimates")
)

hline.data <- data.frame(z = c(0.7,2,0.4), parameter = c("effprop","R0","repMean"))
g1 + geom_hline(aes(yintercept = z), hline.data)

msumdat2 <- melt(sumdat,id=c("t_p_o_par_plat"
                            , "type"
                            , "process"
                            , "observation"
                            , "platform"
                            , "parameter"
                            , "Mean"
                            , "lowerCI"
                            , "upperCI"))

g2 <- (ggplot(msumdat2,aes(x=platform,y=value,color=parameter,group=platform))
  + geom_point(size=2)
  + facet_grid(variable+observation~type+process,scale="free")
  + theme_bw()
  + ggtitle("Performance")
  )


g3 <- (ggplot(msumdat,aes(x=timing,y=coverage,color=platform,group=platform,shape=parameter))
       + geom_point(size=4)
       + facet_grid(type~process)
       + theme_bw()
       + ggtitle("Performance")
)

g3
