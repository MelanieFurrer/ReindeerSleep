


library("readxl")
library(ggplot2)
library(NlinTS)
library(dplyr)
library(lme4)
library(lmerTest)
library(tidyverse)
library(gridExtra)
library("emmeans")
library(Hmisc)
library(plyr)
library(patchwork)


setwd("C:/Users/schlaf/Documents/GitHub/ReindeerSleep/Z_processS/docs")

df<-read.table("Stats&Params_BLnorm.txt",header=T)

df$reindeer <- as.factor(df$Individual)
df$season <- as.factor(df$Season)
df$RID <- as.factor(df$RID)
df$x <- as.factor(df$x)



p1 <- ggplot(df , aes(x=x, y=DeltaBIC_RumDec_Fix)) +
  stat_boxplot(coef=4)+
  geom_jitter(width=0,aes(size=meanRum))+
  geom_point(aes(x=1,y=mean(DeltaBIC_RumDec_Fix*meanRum/mean(meanRum))),color="red",fill="red",size=5,shape=23)+ #plot weighed mean in red
  theme_bw()+
  theme(legend.position = "none")+
  geom_abline(intercept = 0,linetype = "dashed")+
  #ylab(expression(paste(Delta, " BIC ")))+
  scale_y_continuous(breaks=c(-500,-400,-300,-300,-200,-100,0,100),limits=c(-560,110))+
  xlab("")+
  #scale_x_discrete(labels=c("RUM fix"))+
  ylab("")


p2 <- ggplot(df , aes(x=x, y=DeltaBIC_RumDec_Free)) +
  stat_boxplot(coef=4)+
  geom_jitter(width=0,aes(size=meanRum))+
  geom_point(aes(x=1,y=mean(DeltaBIC_RumDec_Free*meanRum/mean(meanRum))),color="red",fill="red",size=5,shape=23)+ #plot weighed mean in red
  theme_bw()+
  theme(legend.position = "none")+
  geom_abline(intercept = 0,linetype = "dashed")+
  #ylab(expression(paste(Delta, " BIC ")))+
  scale_y_continuous(breaks=c(-500,-400,-300,-300,-200,-100,0,100),limits=c(-560,110))+
  xlab("")+
  ylab("")



p3 <- ggplot(df , aes(x=x, y=DeltaBIC_RumFree)) +
  stat_boxplot(coef=4)+
  geom_jitter(width=0,aes(size=meanRum))+
  geom_point(aes(x=1,y=mean(DeltaBIC_RumFree*meanRum/mean(meanRum))),color="red",fill="red",size=5,shape=23)+ #plot weighed mean in red
  theme_bw()+
  geom_abline(intercept = 0,linetype = "dashed")+
  #ylab(expression(paste(Delta, " BIC ")))+
  scale_y_continuous(breaks=c(-500,-400,-300,-300,-200,-100,0,100),limits=c(-560,110))+
  xlab("")+
  ylab("")+
  labs(size="tot. rumination (h)",fill="weighed mean")



p1 + p3 & theme(text = element_text(size=22),axis.text.x = element_text(size=0,color="black"),axis.text.y = element_text(size=15))



##### newplot paper #####


setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/processS")
tiff("PS_Fig4.png", units="in", width=5.5, height=4.6, res=300)


ggplot(df , aes(x=x, y=DeltaBIC_RumDec_Fix)) +
  stat_boxplot(coef=4)+
  geom_jitter(width=0,aes(size=meanRum))+
  geom_point(aes(x=1,y=mean(DeltaBIC_RumDec_Fix*meanRum/mean(meanRum))),color="red",fill="red",size=5,shape=23)+ #plot weighed mean in red
  theme_bw()+
  theme(text=element_text(size=19),axis.text.x =element_blank(),axis.ticks.x=element_blank(),axis.text.y = element_text(size=17,color="black"),axis.ticks.length=unit(.15, "cm"),legend.text=element_text(size=17))+
  geom_abline(intercept = 0,linetype = "dashed")+
  ylab(expression(paste(Delta, " BIC (decrease - increase)")))+
  scale_y_continuous(breaks=c(-400,-200,0,200),limits=c(-510,210))+
  xlab("")+
  labs(size="tot. rumination",fill="weighed mean")
  #scale_x_discrete(labels=c("RUM fix"))+


dev.off()
#



#####seasonal differences#####

m <- lmer(DeltaBIC_RumDec_Fix ~ season + (1|reindeer), data=df)
anova(m)

m <- lmer(parameters_L ~ season + (1|reindeer), data=df)
anova(m)

m <- lmer(parameters_tauWake ~ season + (1|reindeer), data=df)
anova(m)

m <- lmer(parameters_tauNREM ~ season + (1|reindeer), data=df)
anova(m)




m1 <- lmer(parameters_tau_swa_synchro ~ season + (1|reindeer), data=df)
anova(m1)
emmeans(m1, pairwise ~ season, adjust = "tukey")

m2 <- lmer(parameters_tau_swa_desynchro ~ season + (1|reindeer), data=df)
anova(m2)
emmeans(m2, pairwise ~ season, adjust = "tukey")



#####significant ones#####


setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/processS")
tiff("PS_SuppFig_synchro.png", units="in", width=5, height=6, res=300)

ggplot(df , aes(x=season, y=parameters_tau_swa_synchro)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(size=5)+
  geom_line(aes(group = reindeer))+
  theme_bw()+
  theme(text = element_text(size=20),axis.text.y = element_text(size=18,color="black",hjust = 0.5),axis.text.x = element_text(size=20,color="black",vjust = .5),axis.title.x=element_blank())+
  ylim(0.018,0.055)+
  ylab("Time constant for synchronization of SWA")+
  scale_x_discrete(labels= c("Winter","Summer","Fall"))

dev.off()


setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/processS")
tiff("PS_SuppFig_desynchro.png", units="in", width=5.15, height=6, res=300)

ggplot(df , aes(x=season, y=parameters_tau_swa_desynchro)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(size=5)+
  geom_line(aes(group = reindeer))+
  theme_bw()+
  theme(text = element_text(size=20),axis.text.y = element_text(size=18,color="black",hjust = 0.5),axis.text.x = element_text(size=20,color="black",vjust = .5),axis.title.x=element_blank())+
  ylim(0.0013,0.014)+
  ylab("Time constant for desynchronization of SWA")+
  scale_x_discrete(labels= c("Winter","Summer","Fall"))

dev.off()



#####and the rest#####


ggplot(df , aes(x=season, y=parameters_tauWake)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(size=5)+
  geom_line(aes(group = reindeer))+
  theme_bw()+
  theme(text = element_text(size=20),axis.text.y = element_text(size=18,color="black",hjust = 0.5),axis.text.x = element_text(size=20,color="black",vjust = .5),axis.title.x=element_blank())+
  scale_x_discrete(labels= c("Winter","Summer","Fall"))




ggplot(df , aes(x=season, y=parameters_tauNREM)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(size=5)+
  geom_line(aes(group = reindeer))+
  theme_bw()+
  theme(text = element_text(size=20),axis.text.y = element_text(size=18,color="black",hjust = 0.5),axis.text.x = element_text(size=20,color="black",vjust = .5),axis.title.x=element_blank())+
  scale_x_discrete(labels= c("Winter","Summer","Fall"))



##### try out how to find asymptotes for modeling ########

max_SWA <- c()

for (x in 1:11) {
  
  max_SWA[x] <- quantile(na.omit(dataReindeer$FullDeltaPow[[x]]$SWA),prob=0.99, names = FALSE)
  
}



print(max_SWA)

mean(max_SWA)


mean_SWA <- c()

for (x in 1:11) {
  
  mean_SWA[x] <- mean(na.omit(dataReindeer$FullDeltaPow[[x]]$SWA))
  
}

print(mean_SWA)



median_SWA <- c()

for (x in 1:11) {
  
  median_SWA[x] <- median(na.omit(dataReindeer$FullDeltaPow[[x]]$SWA))
  
}

print(median_SWA)
mean(median_SWA)



