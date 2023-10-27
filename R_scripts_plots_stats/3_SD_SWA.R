
library("readxl")
library(ggplot2)
library(NlinTS)
library(dplyr)
library(lme4)
library(lmerTest)
library(tidyverse)
library(gridExtra)
library("emmeans")
library(patchwork)


setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/excel_overview_data")

df <- read_excel("SWA_SR_per2H.xlsx")
df$reindeer <- as.factor(df$reindeer)
df$season <- as.factor(df$season)
df$timepoint <- as.factor(df$timepoint)
df$timewindow <- as.factor(df$timewindow)



gd <- df %>% 
  group_by(interaction (season, timewindow)) %>% 
  summarise(meanSWA = mean(SWA), seSWA = sd(SWA))
gd$timewindow <- c(1,1,1,2,2,2,3,3,3,4,4,4)
gd$season <- c('December','July','September','December','July','September','December','July','September','December','July','September')

gd$timewindow <- as.factor(gd$timewindow)



##increase##

model1 <- lmer(SWA ~ timewindow * season + (1|timepoint) + (1|reindeer), data=subset(df, timewindow== 1 | timewindow== 2))
anova(model1)
summary(model1)


##decrease##

model2 <- lmer(SWA ~ timewindow * season + (1|timepoint) + (1|reindeer), data=subset(df, timewindow== 2 | timewindow== 3 | timewindow== 4))
anova(model2)
emmeans(model2, pairwise ~ timewindow, adjust = "tukey")



setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/SleepRestriction")
tiff("SR_Fig2.png", units="in", width=14.4, height=6.8, res=300)

p1 <-ggplot(data=subset(gd, timewindow== 1 | timewindow== 2), aes(x=timewindow, y=meanSWA)) +
  geom_point(data=subset(gd, timewindow== 1 | timewindow== 2), aes(x=timewindow, y=meanSWA, color=season), size=6)+
  geom_errorbar( aes(ymin=meanSWA-seSWA, ymax=meanSWA+seSWA, group=season, color=season), size=1.5, width = 0.2)+
  geom_line(data=subset(gd, timewindow== 1 | timewindow== 2), aes(x=timewindow, y=meanSWA, group=season, color=season), size=1.5, linetype=1) +
  theme_bw()+
  theme(text = element_text(size=24,color="black"),axis.text.x = element_text(size=24,color="black",vjust = .5),axis.text.y = element_text(size=22,color="black",hjust = 0.5),legend.position = "none",axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)),axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),plot.margin = margin(0, 60, 0,0),axis.ticks.length=unit(.2, "cm"))+
  scale_x_discrete(labels= c("-2 to 0","0 to +2"))+
  xlab("hours from sleep deprivation")+
  ylab("slow-wave activity\nduring NREM sleep")+
  ylim(0.4, 2.3)+
  scale_color_manual(values=c("#004F96", "#990000", "#FF8A15"))


p2 <- ggplot(data=subset(gd, timewindow== 2 | timewindow== 3 | timewindow== 4), aes(x=timewindow, y=meanSWA)) +
  geom_point(data=subset(gd, timewindow== 2 | timewindow== 3 | timewindow== 4), aes(x=timewindow, y=meanSWA, color=season), size=6)+
  geom_errorbar( aes(ymin=meanSWA-seSWA, ymax=meanSWA+seSWA, group=season, color=season), size=1.5, width = 0.2)+
  geom_line(data=subset(gd, timewindow== 2 | timewindow== 3 | timewindow== 4), aes(x=timewindow, y=meanSWA, group=season, color=season), size=1.5, linetype=1) +
  theme_bw()+
  theme(text = element_text(size=24,color="black"),axis.text.x = element_text(size=24,color="black",vjust = .5),axis.text.y = element_text(size=22,color="black",hjust = 0.1),axis.title.y = element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),legend.position = "none",axis.title.x = element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)),axis.ticks.length=unit(.2, "cm"))+
  scale_x_discrete(labels= c("0 to +2","+2 to +4","+4 to +6"))+
  xlab("hours from sleep deprivation")+
  ylab("slow-wave activity\nduring NREM sleep")+
  ylim(0.4, 2.3)+
  scale_color_manual(values=c("#004F96", "#990000", "#FF8A15"))


p1 + p2 


dev.off()
"#8B008B" #8B8B00



setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/SleepRestriction")
tiff("SR_legend.png", units="in", width=7, height=7, res=300)

ggplot(data=subset(gd, timewindow== 1 | timewindow== 2), aes(x=timewindow, y=meanSWA)) +
  geom_point(data=subset(gd, timewindow== 1 | timewindow== 2), aes(x=timewindow, y=meanSWA, color=season), size=4)+
  geom_errorbar( aes(ymin=meanSWA-seSWA, ymax=meanSWA+seSWA, group=season, color=season), size=1, width = 0.2)+
  geom_line(data=subset(gd, timewindow== 1 | timewindow== 2), aes(x=timewindow, y=meanSWA, group=season, color=season), size=1, linetype=1) +
  theme_bw()+
  theme(text = element_text(size=24),axis.text.x = element_text(size=24))+
  scale_x_discrete(labels= c("-2 to 0","0 to +2"))+
  xlab("hours from sleep deprivation")+
  ylab("normalized SWA")+
  ylim(0.4, 2.3)+
  scale_color_manual(values=c("#004F96", "#990000", "#FF8A15"),labels=c('Winter', 'Summer', 'Fall'))
 
dev.off()






## models for timepoints separately


model1 <- lmer(SWA ~ timewindow * season + (1|reindeer), data=subset(df, timewindow== 1 & timepoint== "midday" | timewindow== 2 & timepoint== "midday"))
anova(model1)


model1 <- lmer(SWA ~ timewindow * season + (1|reindeer), data=subset(df, timewindow== 1 & timepoint== "midnight" | timewindow== 2 & timepoint== "midnight"))
anova(model1)


model1 <- lmer(SWA ~ timewindow * season + (1|reindeer), data=subset(df, timewindow== 3 & timepoint== "midday" | timewindow== 4 & timepoint== "midday"| timewindow== 2 & timepoint== "midday"))
anova(model1)


model1 <- lmer(SWA ~ timewindow * season + (1|reindeer), data=subset(df, timewindow== 3 & timepoint== "midnight" | timewindow== 4 & timepoint== "midnight" | timewindow== 2 & timepoint== "midnight"))
anova(model1)


