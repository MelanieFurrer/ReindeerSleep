install.packages("MuMIn")

library("readxl")
library(ggplot2)
library(NlinTS)
library(dplyr)
library(lme4)
library(lmerTest)
library(tidyverse)
library(gridExtra)
library(MuMIn)


setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/excel_overview_data")

df <- read_excel("nrem_rum_durations.xlsx")
df$reindeer <- as.factor(df$reindeer)
df$season <- as.factor(df$season)
df$condition <- as.factor(df$condition)


dfBL2 <- df[ which(df$condition=='BL2'), ]
#dfBL1 <- df[ which(df$condition=='BL1'), ]
dfSD <- df[ which(df$condition=='SD'), ]
dfSD1 <- df[ which(df$condition=='SD1'), ]
dfSD2 <- df[ which(df$condition=='SD2'), ]
#dfHSP <- df[ which(df$condition=='HSP'), ]
#dfLSP <- df[ which(df$condition=='LSP'), ]
#dfSDA <- df[ which(df$condition=='SDA'), ]
#dfSDA2 <- df[ which(df$condition=='SDA2'), ]
#dfBLA <- df[ which(df$condition=='BLA'), ]
df2 <- df[ which(df$condition=='BL2' | df$condition=='SD'),]



##### compare rum and nrem durations between SR and BL2 #########

model1  <- lmer(nrem_dur ~ condition + (1|season)  + (1|reindeer),df2)
summary(model1)


##### correlations rum-nrem durations BL2 #########

pBL2 <- ggplot(dfBL2, aes(x=rum_dur, y=nrem_dur, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  ylab("NREM sleep duration (min/24 h)")+
  xlab("rumination duration (min/24 h)")+

  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


model1  <- lmer(nrem_dur ~ rum_dur + (1|season),dfBL2)
summary(model1)
r.squaredGLMM(model1)

cor.test(dfBL2$nrem_dur,dfBL2$rum_dur)

#cor.test(dfBL2$nrem_dur,dfBL2$rum_dur)


##### correlations rum-nrem durations sleep deprivation #########

pSD <- ggplot(dfSD1, aes(x=rum_dur, y=nrem_dur, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(200,500)+
  xlim(20,400)+
  ylab("NREM sleep (min/24 h)")+
  xlab("Rumination (min/24 h)")+
  ggtitle("after sleep restriction")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))
pSD

model1  <- lmer(nrem_dur ~ rum_dur + (1|season),dfSD)
summary(model1)


##### correlations rum-nrem durations high sleep pressure vs. low sleep pressure #########

pHSP <- ggplot(dfHSP, aes(x=rum_dur, y=nrem_dur, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(200,500)+
  xlim(20,400)+
  ylab("NREM sleep (min/24 h)")+
  xlab("Rumination (min/24 h)")+
  ggtitle("Baseline: 12:00 - 00:00")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))

r_HSP <- c()
r_HSP[1] <- cor(dfHSP[ which(dfHSP$season=='Sep'), ]$nrem_dur,dfHSP[ which(dfHSP$season=='Sep'), ]$rum_dur)
r_HSP[2] <- cor(dfHSP[ which(dfHSP$season=='July'), ]$nrem_dur,dfHSP[ which(dfHSP$season=='July'), ]$rum_dur)
r_HSP[3] <- cor(dfHSP[ which(dfHSP$season=='Dec'), ]$nrem_dur,dfHSP[ which(dfHSP$season=='Dec'), ]$rum_dur)

p_HSP <- c()
p_HSP[1] <- cor.test(dfHSP[ which(dfHSP$season=='Sep'), ]$nrem_dur,dfHSP[ which(dfHSP$season=='Sep'), ]$rum_dur)$p.value
p_HSP[2] <- cor.test(dfHSP[ which(dfHSP$season=='July'), ]$nrem_dur,dfHSP[ which(dfHSP$season=='July'), ]$rum_dur)$p.value
p_HSP[3] <- cor.test(dfHSP[ which(dfHSP$season=='Dec'), ]$nrem_dur,dfHSP[ which(dfHSP$season=='Dec'), ]$rum_dur)$p.value


pLSP <- ggplot(dfLSP, aes(x=rum_dur, y=nrem_dur, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(200,500)+
  xlim(20,400)+
  ylab("NREM sleep (min/24 h)")+
  xlab("Rumination (min/24 h)")+
  ggtitle("Baseline: 00:00 - 12:00")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))

r_LSP <- c()
r_LSP[1] <- cor(dfLSP[ which(dfLSP$season=='Sep'), ]$nrem_dur,dfLSP[ which(dfLSP$season=='Sep'), ]$rum_dur)
r_LSP[2] <- cor(dfLSP[ which(dfLSP$season=='July'), ]$nrem_dur,dfLSP[ which(dfLSP$season=='July'), ]$rum_dur)
r_LSP[3] <- cor(dfLSP[ which(dfLSP$season=='Dec'), ]$nrem_dur,dfLSP[ which(dfLSP$season=='Dec'), ]$rum_dur)

p_LSP <- c()
p_LSP[1] <- cor.test(dfLSP[ which(dfLSP$season=='Sep'), ]$nrem_dur,dfLSP[ which(dfLSP$season=='Sep'), ]$rum_dur)$p.value
p_LSP[2] <- cor.test(dfLSP[ which(dfLSP$season=='July'), ]$nrem_dur,dfLSP[ which(dfLSP$season=='July'), ]$rum_dur)$p.value
p_LSP[3] <- cor.test(dfLSP[ which(dfLSP$season=='Dec'), ]$nrem_dur,dfLSP[ which(dfLSP$season=='Dec'), ]$rum_dur)$p.value


results_nrem_rum_corr <- data.frame(r_HSP,p_HSP,r_LSP,p_LSP)


grid.arrange(pBL2,pSD,pLSP,pHSP)





##### correlations rum-nrem durations adaptation and BL1 #########

pSD <- ggplot(dfBL1, aes(x=rum_dur, y=nrem_dur, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(0,800)+
  xlim(0,400)+
  ylab("NREM sleep (min/24 h)")+
  xlab("Rumination (min/24 h)")+
  ggtitle("after sleep restriction (2x4h)")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


model1  <- lmer(nrem_dur ~ rum_dur + (1|season),dfSD)
summary(model1)






##### boxplot durations #########

 ggplot(dfBL1, aes(x=season, y=nrem_dur)) +
  geom_boxplot()+
  geom_point( aes(x=season, y=nrem_dur, color=reindeer),size=4)+
  geom_line( aes(x=season, y=nrem_dur, group=reindeer, color=reindeer))+
  theme_bw()+
  ylab("NREM sleep (min/24 h)")+
  theme(text = element_text(size=20))


ggplot(dfBL2, aes(x=season, y=rem_dur)) +
  geom_boxplot()+
  geom_point( aes(x=season, y=rem_dur, color=reindeer),size=4)+
  geom_line( aes(x=season, y=rem_dur, group=reindeer, color=reindeer))+
  theme_bw()+
  ylab("REM sleep (min/24 h)")+
  theme(text = element_text(size=20))


ggplot(dfBL2, aes(x=season, y=rum_dur)) +
  geom_boxplot()+
  geom_point( aes(x=season, y=rum_dur, color=reindeer),size=4)+
  geom_line( aes(x=season, y=rum_dur, group=reindeer, color=reindeer))+
  theme_bw()+
  ylab("Rumination (min/24 h)")+
  theme(text = element_text(size=20))

model2 <- aov(nrem_dur ~ season + Error(reindeer),dfBL2)
summary(model2)


model2 <- lmer(nrem_dur ~ season + (1|reindeer),dfBL2)
summary(model2)
model2 <- lmer(nr_nremepi ~ season + (1|reindeer),dfBL2)
summary(model2)


aggregate(dfBL2$nrem_dur, list(dfBL2$season), FUN=mean) 
aggregate(dfBL2$nrem_dur, list(dfBL2$season), FUN=sd) 

t.test(dfBL2[ which(dfBL2$season=='July'), ]$nrem_dur, dfBL2[ which(dfBL2$season=='Sep'), ]$nrem_dur, paired = TRUE)
t.test(dfBL2[ which(dfBL2$season=='Dec'), ]$nrem_dur, dfBL2[ which(dfBL2$season=='July' & dfBL2$reindeer!=5), ]$nrem_dur, paired = TRUE)


ggplot(dfBL2, aes(x=season, y=nrem_rum_dur)) +
  geom_boxplot()+
  geom_point( aes(x=season, y=nrem_rum_dur, color=reindeer), size=4)+
  geom_line( aes(x=season, y=nrem_rum_dur, group=reindeer, color=reindeer))+
  theme_bw()+
  ylab("NREM sleep + rumination (min/24 h)")+
  theme(text = element_text(size=20))

model2 <- aov(nrem_rum_dur ~ season + Error(reindeer),dfBL2)
summary(model2)


model2 <- lmer(nrem_rum_dur ~ season + (1|reindeer),dfBL2)
summary(model2)



t.test(dfBL2[ which(dfBL2$season=='July'), ]$nrem_rum_dur, dfBL2[ which(dfBL2$season=='Sep'), ]$nrem_rum_dur, paired = TRUE)
t.test(dfBL2[ which(dfBL2$season=='Dec'), ]$nrem_rum_dur, dfBL2[ which(dfBL2$season=='July' & dfBL2$reindeer!=5), ]$nrem_rum_dur, paired = TRUE)




###### corr rum with food intake ########


ggplot(dfBL2, aes(x=rum_dur, y=food, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylab("food intake (kg/kg bw)")+
  xlab("Rumination (min/24 h)")+
  theme(text = element_text(size=20))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


model1  <- lmer(food ~ rum_dur + (1|season),dfBL2)
summary(model1)

cor.test(dfBL2$food,dfBL2$rum_dur)


