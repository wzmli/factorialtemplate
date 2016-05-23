library(dplyr)
library(ggplot2)
library(tidyr)

names <- list.files(pattern = "RDS")
dat <- data.frame()
for(i in names){
  dat <- rbind(dat,readRDS(i))
}

sumdat <- (dat 
  %>% mutate(par=parameter)
  %>% filter(parameter=="R0")
  %>% unite(t_p_o_par,type,process,observation,par) 
  %>% group_by(t_p_o_par)
  %>% summarise(Mean = mean(mean)
                , Timing = mean(timing)
                , coverage=mean(CI95_low<true_parameter & true_parameter>CI95_upp))
)

g1 <- ggplot(sumdat,aes(x=t_p_o_par,y=mean))+geom_boxplot()

g1 %+% subset(sumdat,parameter=="R0")+ geom_hline(yintercept = 2.5)

g1 %+% subset(sumdat,parameter=="effprop")+ geom_hline(yintercept = 0.75)

ggplot(sumdat,aes(x=t_p_o_par,y=Timing)) + geom_point()
