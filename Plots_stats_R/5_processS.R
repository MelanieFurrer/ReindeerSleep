

library("readxl")
library(ggplot2)
library(NlinTS)
library(dplyr)
library(lme4)
library(lmerTest)
library(tidyverse)
library(gridExtra)
library("emmeans")

setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/excel_overview_data/processS")

df <- read_excel("Stats&Params_newNorm.xlsx")
df$reindeer <- as.factor(df$Individual)
df$season <- as.factor(df$Season)
df$RID <- as.factor(df$RID)
df$x <- as.factor(df$x)


model1 <- lmer(parameters_tauWake ~ season + (1|reindeer), df)
summary(model1)
anova(model1)

model1 <- lmer(parameters_tauNREM ~ season + (1|reindeer), df)
summary(model1)
anova(model1)

model1 <- lmer(parameters_tau_swa_synchro ~ season + (1|reindeer), df)
summary(model1)
anova(model1)

model1 <- lmer(parameters_tau_swa_desynchro ~ season + (1|reindeer), df)
summary(model1)
anova(model1)


ggplot(df , aes(x=season, y=DeltaMSE_RumDecreaseS)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(position=position_dodge(width=0.75),aes(color=reindeer), size=5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Mean Standard Error")


df1 <- df[ which(df$reindeer!='2' | df$season!='Dec'), ]

model1 <- lmer(parameters_tauWake ~ season + (1|reindeer), df1)
summary(model1)
anova(model1)

model1 <- lmer(parameters_tauNREM ~ season + (1|reindeer), df1)
summary(model1)
anova(model1)

model1 <- lmer(parameters_tau_swa_synchro ~ season + (1|reindeer), df1)
summary(model1)
anova(model1)


ggplot(df , aes(x=season, y=parameters_tauWake)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(position=position_dodge(width=0.75),aes(color=reindeer), size=5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Time Constant Wake")


ggplot(df , aes(x=season, y=parameters_tauNREM)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(position=position_dodge(width=0.75),aes(color=reindeer), size=5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Time Constant NREM")

ggplot(df , aes(x=season, y=parameters_tau_swa_synchro)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(position=position_dodge(width=0.75),aes(color=reindeer), size=5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("SWA Synchro")





ggplot(df , aes(x=season, y=DeltaMSE_RumDecreaseS)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(position=position_dodge(width=0.75),aes(color=reindeer), size=5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Diff. mean standard error")



ggplot(df , aes(x=season, y=DeltaMSE_RumDecreaseS)) +
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(position=position_dodge(width=0.75),aes(color=reindeer), size=5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Diff. mean standard error")



ggplot(df , aes(x=x, y=DeltaMSE_RumDecreaseS)) +
  geom_violin(fill = "grey90")+
  geom_jitter(height = 0, width = 0.19,size = 5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Diff. mean standard error")+
  ylim(-0.0044,0.001)

#draw_quantiles = c(0.25, 0.5, 0.75),


####### plot process S, mean over seasons ############

df2 <- read_excel("SimulationSeason.xlsx")
df2$variable <- as.factor(df2$variable)
df2$season <- as.factor(df2$Season)


df3 <- subset(df2, variable == "ProcessS")


#### all process S (wihout SWA) ####

ggplot(df3 , aes(x=Time, y=value, colour=season)) +
  geom_line(size=2)+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))+ 
  #geom_jitter(height = 0, width = 0.18,size = 5)+
  theme_bw()+
  theme(text = element_text(size=24))+
  ylab("Process S")+
  xlab("Time (min)")


#### accumulation process S (wihout SWA) ####

ggplot(df3 , aes(x=Time, y=value, colour=season)) +
  geom_line(size=2)+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))+ 
  #geom_jitter(height = 0, width = 0.18,size = 5)+
  theme_bw()+
  theme(text = element_text(size=24))+
  ylab("Process S")+
  xlab("Wake time (min)")+
  xlim(0,20)



