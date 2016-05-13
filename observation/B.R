
R version 3.2.2 (2015-08-14) -- "Fire Safety"
Copyright (C) 2015 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

  Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

> # require(R2jags)
> # # options(mc.cores = parallel::detectCores())
> # 
> # type <- unlist(strsplit(rtargetname,"[.]"))
> # 
> # mult <- 1:4
> # data <- lme4:::namedList(obs=sim$Iobs
> #   , N
> #   , i0=6
> #   , numobs
> # )
> # 
> # iList <- lme4:::namedList(effprop=0.7
> #   , R0 = 1
> #   , N0
> #   , initDis=0.2
> #   , repMean=0.5
> # )
> # 
> # if(type[3] == "BB"){
> #   data <- c(data, lme4:::namedList(pSISize=repSize, eps))
> #   iList <- c(iList, lme4:::namedList(pSIa=sim$pSI,pSIb=sim$pSI))
> # }
> # 
> # if(type[3] == "NB"){
> #   data <- c(data, lme4:::namedList(Pdis,eps))
> #   iList <- c(iList, lme4:::namedList(IMean=sim$I))
> # }
> # 
> # if(type[4] == "BB"){
> #   data <- c(data, lme4:::namedList(repobsSize=repSize))
> #   iList <- c(iList, lme4:::namedList(repobsa=repMean, repobsb=repMean))
> # }
> # 
> # inits <- lapply (mult, function(m){
> #   return(c(iList, list(I = c(m+sim$Iobs))))
> # })
> # 
> # params <- c("R0","effprop","repMean")
> # 
> # print(type)
> # print(data)
> # print(inits)
> # print(length(inits))
> # 
> # 
> # # Jagsmod <- jags.model(file="CB.bug",data=data,inits=inits)
> # 
> # # list.samplers(Jagsmod)
> # 
> # system.time(JagsDiscrete <- jags(data=data,
> #                 inits=inits,
> #                 param = params,
> #                 model.file = input_files[[1]],
> #                 n.iter = iterations,
> #                 n.chains = length(inits))
> #             )
> # 
> # print(JagsDiscrete)
> # 
> # # rdsave(JagsDiscrete)
> 
> proc.time()
   user  system elapsed 
  0.180   0.024   0.203 
