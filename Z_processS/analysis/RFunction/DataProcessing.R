ReadReindeerScoring<-function(Mres,concat="mean",nepochs=86400,epochlengthsec=4,concattimesec=300,rumWN=F){
  
  
  l_window<-concattimesec/epochlengthsec
  n_window<-nepochs/l_window
  McountW<-matrix(ncol=ncol(Mres),nrow=n_window) # Wake
  McountN<-matrix(ncol=ncol(Mres),nrow=n_window) # NREM
  McountR<-matrix(ncol=ncol(Mres),nrow=n_window) # REM
  McountM<-matrix(ncol=ncol(Mres),nrow=n_window) # M value (NA)
  if (rumWN == T){
    McountRumS<-matrix(ncol=ncol(Mres),nrow=n_window) # Rumination/Sleep
    McountRumW<-matrix(ncol=ncol(Mres),nrow=n_window) # Rumination/Wake
  }else{
    McountRum<-matrix(ncol=ncol(Mres),nrow=n_window) # Rumination
  }
  
  for (i in 1:n_window){
    for (j in 1:ncol(Mres)){
      tmp<-Mres[seq((i-1)*l_window + 1,i*l_window),j]
      McountW[i,j]<-length(tmp[tmp == "w" | tmp == "0"])
      McountN[i,j]<-length(tmp[tmp == "n" | tmp == "2"])
      McountR[i,j]<-length(tmp[tmp == "r" | tmp == "3"])
      if (rumWN ==F){
        McountRum[i,j]<-length(tmp[tmp == "t" | tmp == "4"])
      }else{
        McountRumS[i,j]<-length(tmp[tmp == "t"])
        McountRumW[i,j]<-length(tmp[tmp == "4"])
      }
      McountM[i,j]<-length(tmp[tmp == "m"])
      
      # Add a SW seq
      tmpS<-tmp
      if (rumWN == F){
        tmpS[tmp == "w" | tmp == "0"]<-1
        tmpS[tmp == "n" | tmp == "2" | tmp == "r" | tmp == "3" | tmp == "t" | tmp == "4" | tmp == "m"]<-0
        tmpS<-as.numeric(tmpS)
      }else{
        tmpS[tmp == "w" | tmp == "0" | tmp == "4"]<-1
        tmpS[tmp == "n" | tmp == "2" | tmp == "r" | tmp == "3" | tmp == "t" | tmp == "m"]<-0
        tmpS<-as.numeric(tmpS)
      }
      
      
      # Mean continuous length of wake
      r<-rle(tmpS)
      m1<-mean(r$lengths[r$values == 1])
      m0<-mean(r$lengths[r$values == 0])
      
    }
  }
  
  if (nrow(Mres)>1){
    CatValW<-apply(McountW,1,concat)*epochlengthsec/3600
    CatValN<-apply(McountN,1,concat)*epochlengthsec/3600
    CatValR<-apply(McountR,1,concat)*epochlengthsec/3600
    CatVarM<-apply(McountM,1,concat)*epochlengthsec/3600
    CatValS<-CatValN+CatValR
    
    if (rumWN == F){
      CatVarRum<-apply(McountRum,1,concat)*epochlengthsec/3600
    }else{
      CatVarRumW<-apply(McountRumW,1,concat)*epochlengthsec/3600
      CatVarRumS<-apply(McountRumS,1,concat)*epochlengthsec/3600
    }
    
    LValW<-round(apply(McountW,1,concat))
    LValS<-round(apply(McountN,1,concat)+apply(McountR,1,concat))
    
  }else{
    CatValW<-as.numeric(McountW[,1])*epochlengthsec/3600
    CatValN<-as.numeric(McountN[,1])*epochlengthsec/3600
    CatValR<-as.numeric(McountR[,1])*epochlengthsec/3600
    CatValS<-CatValN+CatValR
    
    if (rumWN == F){
      CatVarRum<-as.numeric(McountRum[,1])*epochlengthsec/3600
    }else{
      CatVarRumW<-as.numeric(McountRumW[,1])*epochlengthsec/3600
      CatVarRumS<-as.numeric(McountRumS[,1])*epochlengthsec/3600
    }    
    
    
    LValW<-round(as.numeric(McountW[,1]))
    LValS<-round(as.numeric(McountN[,1])+as.numeric(McountR[,1]))
  }
  
  if (rumWN == F){
    df <- data.frame(list(NREM=CatValN,REM=CatValR,Wake=CatValW,Rumination=CatVarRum,Sleep=CatValS,Missing=CatVarM,LenW=LValW,LenS=LValS))
  }else{
    df <- data.frame(list(NREM=CatValN,REM=CatValR,Wake=CatValW,RuminationW=CatVarRumW,RuminationS=CatVarRumS,Rumination=CatVarRumW+CatVarRumS,
                          Sleep=CatValS,Missing=CatVarM,LenW=LValW,LenS=LValS))
  }
  
  return(df)
  
}


GetMaxSWAperBout<-function(deerid,DoPlot=F){
  
  # Recursive function to test if score at the index 
  # is NREM and return longest index number with NREM (inbetween must contain also NREM)
  GetBoutPerEpoch<-function(iter,Scoring){
    if (iter <= length(Scoring) & Scoring[iter] %in% NREMcharac){
      return(GetBoutPerEpoch(iter+1,Scoring))
    }else{
      return(iter)
    }
  }
  
  # character representing NREM
  NREMcharac<-c("n","2")
  
  # Length of the bout per epoch
  BLpE<-sapply(1:length(Scoring[,deerid]),GetBoutPerEpoch,Scoring=Scoring[,deerid])-seq(1,length(Scoring))
  
  Time<-c()
  MaxSWA<-c()
  for (i in 1:nrow(dataMat$episodes[,,deerid]$nremdura)){
    
    lenEpi<-dataMat$episodes[,,deerid]$nremdura[i,1]
    start<-dataMat$episodes[,,deerid]$nremdura[i,2]
    end<-dataMat$episodes[,,deerid]$nremdura[i,3]
    # longest continuous sleep > 5 minutes
    if (max(BLpE[start:end])*4/60 > 5){
      
      ## Use splinde
      print(paste(deerid,i))
      SWA<-dataMat$SWA.normalized[start:end,deerid]
      
      idx<- ! is.na(SWA)
      relTime<-seq(1,length(SWA))[idx]
      mm<-smooth.spline(x=relTime,y=SWA[idx],spar = .9)
      
      #Time<-c(Time,start + relTime[which.max(fitted(mm))])
      #MaxSWA<-c(MaxSWA,max(fitted(mm),na.rm=T))
      
      ## Use exponential
      
      # use 5 minutes from maximum bout of sleep (75*4sec)
      idxstart<-which.max(BLpE[start:end])
      SWAvalues<-dataMat$SWA.normalized[(start+idxstart):(start+idxstart+75),deerid]
      Timevals<-0:(length(SWAvalues)-1)
      
      idxfilt<- ! is.na(SWAvalues)
      SWAvalues<-SWAvalues[idxfilt]
      Timevals<-Timevals[idxfilt]
      
      mmExp<-try(mmExp<-nls(SWAvalues~C+A*(1-exp(-Timevals/k)),start=list(C=0,A=1,k=30),algorithm = "port",lower = c(C=0,A=0,k=(75/3)),upper=c(C=2,A=8,k=(75/2))))
      if (class(mmExp) != "try-error"){
        Time<-c(Time,idxstart+start+75)
        MaxSWA<-c(MaxSWA,coef(mmExp)[["A"]]+coef(mmExp)[["C"]])
      }
      
      
      
      if (DoPlot == T){
        SWAvalues<-dataMat$SWA.normalized[start:end,deerid]
        plot(SWAvalues,type="l",main=max(BLpE[start:end])*4/60,ylim=c(0,max(SWAvalues,na.rm=T)),xlab="Epochs")
        lines(seq(1,length(SWA))[idx],fitted(mm))
        lines(BLpE[start:end]/300,col="blue");points(x=which.max(BLpE[start:end]/300),y=max(BLpE[start:end]/300),pch=19,col="blue")
        
        # use 5 minutes from maximum bout of sleep (75*4sec)
        if (class(mmExp) != "try-error"){
          lines(Timevals+idxstart,fitted(mmExp),col="red")
          abline(h=coef(mmExp)[["A"]]+coef(mmExp)[["C"]],col="red")
        }
      }
    }
  }
  return(list(Time=Time*4/3600,SWA=MaxSWA))
}

GetSWA4BoutsOfNREM<-function(SWA,Scoring,minboutlength_sec=360,epochlengthsec = 4){
  
  # Recursive function to test if score at the index 
  # is NREM and return longest index number with NREM (inbetween must contain also NREM)
  GetBoutPerEpoch<-function(iter,Scoring){
    if (iter <= length(Scoring) & Scoring[iter] %in% NREMcharac){
      return(GetBoutPerEpoch(iter+1,Scoring))
    }else{
      return(iter)
    }
  }
  
  # # Example:
  # Scoring<-c("w","w","n","n","n")
  # GetBoutPerEpoch(1,Scoring)
  # GetBoutPerEpoch(2,Scoring)
  # GetBoutPerEpoch(3,Scoring)
  
  # character representing NREM
  NREMcharac<-c("n","2")
  
  # Length of the bout per epoch
  BLpE<-sapply(1:length(Scoring),GetBoutPerEpoch,Scoring=Scoring)-seq(1,length(Scoring))
  par(mar=c(3,5,1,1))
  plot(BLpE,type="l",ylab="NREM Bout length\nper eprochs [amount of epoch]")
  abline(h=minboutlength_sec/epochlengthsec,col="red")
  
  # Isolate bout of X seconds
  Boutsidx<-c()
  iter <- 1
  while (iter < length(BLpE)){
    if (BLpE[iter]>=(minboutlength_sec/epochlengthsec)){
      Boutsidx<-c(Boutsidx,iter)
      iter <- iter + (minboutlength_sec/epochlengthsec)
    }else{
      iter <- iter + 1
    }
  }
  
  par(mar=c(3,5,1,1))
  plot(BLpE,type="l",ylab="NREM Bout \n length[amount of epoch]")
  points(Boutsidx,BLpE[Boutsidx],pch=19)
  abline(h=minboutlength_sec/epochlengthsec,col="red")
  
  plot(BLpE,type="l",ylab="NREM Bout \n length[amount of epoch]",xlim=c(20000,30000))
  points(Boutsidx,BLpE[Boutsidx],pch=19)
  abline(h=minboutlength_sec/epochlengthsec,col="red")
  
  # Compute mean SWA per bout
  Bouts<-t(sapply(Boutsidx,function(x){
    idx_start<-x
    idx_end<-x + (minboutlength_sec/epochlengthsec) - 1
    return(list(idx_start=(x+(idx_end-idx_start)+1),SWA=mean(SWA[idx_start:idx_end],na.rm=T)))
  }))
  
  return(cbind.data.frame(idx_start=unlist(Bouts[,1]),SWA=unlist(Bouts[,2])))
  
}