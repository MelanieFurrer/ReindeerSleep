GetParametersLimits<-function(RuminationFree){
  
  tausync<-(60*5/3600)/3 # @ 5 minutes, difference from process-S is less than 5%
  taudesync<-(60*1/3600)/3 # @ 1 minutes, difference from process-S is less than 5%

  # Use as initial value for optimization
  params<-c(L=LLIMITS,tau_wake = 10,tau_nrem = 3,tau_rumination = 3,
            tau_swa_synchro = tausync,tau_swa_desynchro = taudesync,init_PS=2)
  
  # Limits of SWA time-constant (from 0.1 to 10 minutes)
  mintausync<-(60*01/3600)/3
  maxtausync<-(60*10/3600)/3
  maxtaudesync<-(60*10/3600)/3
  mintaudesync<-(60*.01/3600)/3
  
  # Limits of parameters of process-S
  # init_PS: See first episode of NREM sleep in Fit_Reindeer_061022.Rmd
  lower<-c(L=LLIMITS,tau_wake = .5,tau_nrem = .5,tau_rumination = .5,
           tau_swa_synchro = mintaudesync,tau_swa_desynchro = mintaudesync,init_PS=0.1)
  upper<-c(L=LLIMITS,tau_wake = 30,tau_nrem = 30,tau_rumination = 30,
           tau_swa_synchro = 24,tau_swa_desynchro = 24,init_PS=5) 
  
  # log transform as we don't expect negative value
  if (RuminationFree == T){
    return(list(init=log(params),lower=log(lower),upper=log(upper)))
  }else{
    idxf<-which(names(params) == "tau_rumination")
    return(list(init=log(params[-idxf]),lower=log(lower[-idxf]),upper=log(upper[-idxf])))
  }
  
}

Get_SWAdf_SWdf<-function(Deerid,dataReindeer,RuminationFree=T,RuminationDecreasePS=T,RUMWN=F){
  ###### Get data.frames of SWA and sleep-wake
  SWA<-dataReindeer$FullDeltaPow[[Deerid]]
  SWA<-SWA[! is.na(SWA$SWA),]
  SWdf<-dataReindeer$SWdf[[Deerid]]
  SWdf$Wake<-SWdf$Wake+SWdf$REM # REM sleep is considered as wake (increase process-S)
  
  if (RuminationFree == F){
    if (RUMWN == F){
      if (RuminationDecreasePS == T){
        SWdf$NREM<-SWdf$NREM+SWdf$Rumination
        SWdf$Rumination<-0
      }else{
        SWdf$Wake<-SWdf$Wake+SWdf$Rumination
        SWdf$Rumination<-0
      }
    }else{
      SWdf$NREM<-SWdf$NREM+SWdf$RuminationS
      SWdf$Wake<-SWdf$NREM+SWdf$RuminationW
      SWdf$Rumination<-0
      SWdf$RuminationW<-0
      SWdf$RuminationS<-0
    }
    
  }
  return(list(SWA=SWA,SWdf=SWdf))
}

###### Objective function for 
ObjFun<-function(params,SWA,SWdf,RuminationFree=T,RuminationDecreasePS=T){
  
  if (RuminationFree == T){
    SWAsimu<-SWA_Simulation(NREM = SWdf$NREM,Wake = SWdf$Wake,
                            Rumination = SWdf$Rumination,Time = SWdf$Time,
                            U = ULIMITS,L=exp(params["L"]),tau_wake=exp(params["tau_wake"]),
                            tau_nrem = exp(params["tau_nrem"]),tau_rumination = exp(params["tau_rumination"]),
                            tau_swa_synchro = exp(params["tau_swa_synchro"]),
                            tau_swa_desynchro = exp(params["tau_swa_desynchro"]),
                            L_swa = exp(params["L"]),init_ProcessS = exp(params["init_PS"]), #
                            init_SWA = 1,RuminationDecreasePS = RuminationDecreasePS)
  }else{
    # Rumination is included in Wake or NREM
    SWAsimu<-SWA_Simulation(NREM = SWdf$NREM,Wake = SWdf$Wake,
                            Rumination = SWdf$Rumination,Time = SWdf$Time,
                            U = ULIMITS,L=exp(params["L"]),tau_wake=exp(params["tau_wake"]),
                            tau_nrem = exp(params["tau_nrem"]),tau_rumination = 1,
                            tau_swa_synchro = exp(params["tau_swa_synchro"]),
                            tau_swa_desynchro = exp(params["tau_swa_desynchro"]),
                            L_swa = exp(params["L"]),init_ProcessS = exp(params["init_PS"]), #
                            init_SWA = 1,RuminationDecreasePS = RuminationDecreasePS)
  }
  
  appx<-approxfun(x=SWdf$Time,y=SWAsimu$SWAdynamics[-1])
  RSS<-sum((appx(SWA$Time)-SWA$SWA)^2)

  return(RSS)
}

FitParameters<-function(Deerid,dataReindeer,RuminationFree=T,RuminationDecreasePS=T,RUMWN=F){
  
  ###### Parameter start and limits
  paramslim<-GetParametersLimits(RuminationFree=RuminationFree)
  params<-paramslim[["init"]]
  lower<-paramslim[["lower"]]
  upper<-paramslim[["upper"]]
  
  ###### Get df
  SWA_SWdf<-Get_SWAdf_SWdf(Deerid,dataReindeer,
                           RuminationFree=RuminationFree,
                           RuminationDecreasePS=RuminationDecreasePS,RUMWN=RUMWN)
  SWA<-SWA_SWdf[["SWA"]]
  SWdf<-SWA_SWdf[["SWdf"]]
  
  ###### Get parameters by optimx
  print("START OPTIMX")
  fits<-optimx(fn = ObjFun,par = params,method = c("nlminb"),lower=lower,upper=upper,
               SWA=SWA,SWdf=SWdf,RuminationFree=RuminationFree,RuminationDecreasePS=RuminationDecreasePS)
  
  #,"L-BFGS-B"
  fits<-fits[which.min(fits$value),]
  print("END")
  
  # Fitted
  if (RuminationFree == T){tau_rum<-exp(fits[1,"tau_rumination"])}else{tau_rum<-1}
  SWAsimu<-SWA_Simulation(NREM = SWdf$NREM,Wake = SWdf$Wake,
                          Rumination = SWdf$Rumination,Time = SWdf$Time,
                          U = ULIMITS,L=exp(fits[1,"L"]),tau_wake=exp(fits[1,"tau_wake"]),
                          tau_nrem = exp(fits[1,"tau_nrem"]),tau_rumination = tau_rum ,
                          tau_swa_synchro = exp(fits[1,"tau_swa_synchro"]),
                          tau_swa_desynchro = exp(fits[1,"tau_swa_desynchro"]),
                          L_swa = exp(fits[1,"L"]),init_ProcessS = exp(fits[1,"init_PS"]),
                          init_SWA = 1,RuminationDecreasePS = RuminationDecreasePS)
  
  appx<-approxfun(x=SWdf$Time,y=(SWAsimu$SWAdynamics[-1]))
  residslog<-appx(SWA$Time)-(SWA$SWA)
  
  return(list(fits=exp(fits[,names(params)]),
              RSS=fits$value,n=nrow(SWA),
              fitted=SWAsimu,obs=(SWA$SWA),
              fittedobs=appx(SWA$Time),resids=residslog))
  
}


GetBIC<-function(fitsReindeer){
  
  n<-fitsReindeer$n
  RSS<-fitsReindeer$RSS
  k<-length(fitsReindeer$fits)+1
  
  # biased estimator of sigma^2
  var<-RSS/n
  NLL <- (n/2)*(log(2*pi)+log(var)+1)
  
  BIC <- -2*(-NLL)+(k)*log(n)
  
  return(BIC)
  
}