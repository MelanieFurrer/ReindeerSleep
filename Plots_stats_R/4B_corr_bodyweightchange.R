
library("readxl")
library(ggplot2)
library(NlinTS)
library(dplyr)
library(lme4)
library(lmerTest)
library(tidyverse)
library(gridExtra)

setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/excel_overview_data")

df <- read_excel("bw_change_food.xlsx")
df$reindeer <- as.factor(df$reindeer)
df$season <- as.factor(df$season)



#### 0. plot change in body weight (and food intake) across the year   #######


ggplot(df, aes(x=season, y=body_weight, fill=season)) +
  geom_boxplot()+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  ylab("body weight (g)")+
  theme(text = element_text(size=20),legend.position = "none")+
  scale_fill_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))+
  geom_point(size=5) + 
  geom_line(aes(group=reindeer)) 


ggplot(df, aes(x=season, y=food_total, fill=season)) +
  geom_boxplot()+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  ylab("weighed food intake (g/kg)")+
  theme(text = element_text(size=20),legend.position = "none")+
  scale_fill_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))+
  geom_point(size=5)




##### 1. food intake determines how much reindeer ruminate #####


model <- lmer(rum ~ food_total * season + (1|reindeer)  , df)
summary(model)
anova(model)


model <- lmer(rum ~ food_total + (1|reindeer)  + (1|season) , df)
summary(model)
anova(model)



ggplot(df, aes(x=food_total, y=rum, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  ylab("rumination duration (min/24h)")+
  xlab("weighed food intake per day (g/kg)")+
  theme(text = element_text(size=20),legend.position = c(0.4, 0.9),legend.title = element_blank())+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"),labels=c("December: all food incl. pellets and twigs", "July: pellets, excl. twigs", "September: pellets, excl. twigs"))







##### 2. what determines body weight change from one to the next season #####

model <- lmer(bw_change ~ rum + (1|reindeer) + (1|season)  , df)
summary(model)
anova(model)


ggplot(df, aes(x=rum, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(-15,25)+
  #xlim(20,400)+
  ylab("bodyweight change (%)")+
  xlab("rumination duration (min/24h)")+
  theme(text = element_text(size=18),legend.title = element_blank(),legend.text.align = 0,legend.position = c(0.25, 0.9))+
  scale_color_manual(breaks=c("July", "December") ,labels=c(expression(Summer %->% Fall), expression(Winter %->% Summer)),values=c("#990000","#004F96",""))



model <- lmer(bw_change ~ rum + (1|season)  + (1|reindeer)   , df)
summary(model)
anova(model)

ggplot(df, aes(x=food_total, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(-15,25)+
  #xlim(20,400)+
  ylab("bodyweight change (%)")+
  xlab("weighed food intake per day (g/kg)")+
  theme(text = element_text(size=20),legend.title = element_blank(),legend.text.align = 0.1,legend.position = c(0.25, 0.9))+
  scale_color_manual(breaks=c("July", "December") ,labels=c(expression(July %->% September), expression(December %->% July)),values=c("#4daf4a","#377eb8",""))



##### 2b. estimated number of chews (chew frequency * tot. rum duration) correlates with bw-change #######




p1 <- ggplot(df, aes(x=rum_indx, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(-15,25)+
  #xlim(20,400)+
  ylab("bodyweight change (%)")+
  xlab("estimated # rum-chews/ 24 hours")+
  theme(text = element_text(size=20),legend.title = element_blank(),legend.text.align = 0,legend.position = c(0.25, 0.9))+
  scale_color_manual(breaks=c("July", "December") ,labels=c(expression(Summer %->% Fall), expression(Winter %->% Summer)),values=c("#4daf4a","#377eb8",""))


p2 <- ggplot(df, aes(x=rum, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(-15,25)+
  #xlim(20,400)+
  ylab("bodyweight change (%)")+
  xlab("rumination duration (min/24h)")+
  theme(text = element_text(size=20),legend.title = element_blank(),legend.text.align = 0,legend.position = c(0.25, 0.9))+
  scale_color_manual(breaks=c("July", "December") ,labels=c(expression(Summer %->% Fall), expression(Winter %->% Summer)),values=c("#4daf4a","#377eb8",""))

grid.arrange(p2,p1, ncol = 2)



model1 <- lmer(bw_change ~ rum + (1|season) + (1|reindeer)  , df)
anova(model1)

model2 <- lmer(bw_change ~ rum_indx + (1|season) + (1|reindeer)  , df)
anova(model2)



#### 3. plot change in sleep stages   #######

model <- lmer(wake ~ season + (1|reindeer) , df)
summary(model)
anova(model)

model <- lmer(nrem ~ season + (1|reindeer) , df)
summary(model)
anova(model)

model <- lmer(rem ~ season + (1|reindeer) , df)
summary(model)
anova(model)

model <- lmer(rum ~ season + (1|reindeer) , df)
summary(model)
anova(model)

ggplot(df, aes(x=season, y=wake, fill=season)) +
  geom_boxplot(outlier.size = 2)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  ylab("duration (min/24h)")+
  theme(text = element_text(size=18),legend.position = "none")+
  scale_fill_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))+
  geom_point(size=5)


p1 <- ggplot(df, aes(x=season, y=rum, fill=season)) +
  geom_boxplot(outlier.size = 2)+
  theme_bw()+
  #ylim(10,410)+
  #xlim(20,400)+
  ylab("duration (min/24h)")+
  theme(text = element_text(size=20),legend.position = "none")+
  scale_fill_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))+
  geom_point(size=5) 


p2 <- ggplot(df, aes(x=season, y=nrem, fill=season)) +
  geom_boxplot(outlier.size = 2)+
  theme_bw()+
  #ylim(10,410)+
  #xlim(20,400)+
  #ylab("weighed food intake (g/kg)")+
  theme(text = element_text(size=20),legend.position = "none")+
  scale_fill_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))+
  geom_point(size=5) 

p3 <- ggplot(df, aes(x=season, y=rem, fill=season)) +
  geom_boxplot(outlier.size = 3)+
  theme_bw()+
  #ylim(10,410)+
  #xlim(20,400)+
  #ylab("weighed food intake (g/kg)")+
  theme(text = element_text(size=20),legend.position = "none")+
  scale_fill_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))+
  geom_point(size=5)


grid.arrange(p1,p2,p3,ncol=3)


##### something with wake? ########

ggplot(df, aes(x=tau_wake, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  ylim(-15,25)+
  #xlim(20,400)+
  ylab("bodyweight change (%)")+
  xlab("rumination duration (min/24h)")+
  theme(text = element_text(size=20),legend.title = element_blank(),legend.text.align = 0.1,legend.position = c(0.22, 0.92))+
  scale_color_manual(breaks=c("July", "December") ,labels=c(expression(July %->% September), expression(December %->% July)),values=c("#4daf4a","#377eb8",""))




##### corr rum with food_twigs, but not food_pellets #######

cor.test(df$food_twigs, df$rum,  method = "spearman", use = "complete.obs")


cor.test(df$food_pellets, df$bw_change_within,  method = "pearson", use = "complete.obs")


model1 <- lmer(bw_change ~ bw_change_within + (1|reindeer) + (1|season), df)
summary(model1)
anova(model1)


model1 <- lmer(bw_change ~ bw_change_within * season + (1|reindeer), df)
summary(model1)
anova(model1)


model_bw_change <- lmer(bw_change ~ rum + (1|reindeer) + (1|season)  , df)
summary(model_bw_change)
anova(model_bw_change)

model_bw_change_within <- lmer(bw_change_within ~ rum + (1|reindeer) + (1|season)  , df)
summary(model_bw_change_within)
anova(model_bw_change_within)


model_bw_change_within <- lmer(bw_change_within ~ food_pellets + (1|reindeer) + (1|season)  , df)
summary(model_bw_change_within)
anova(model_bw_change_within)

model_bw_change_within <- lmer(bw_change_within ~ longwakeepi + (1|reindeer) + (1|season)  , df)
summary(model_bw_change_within)
anova(model_bw_change_within)


model_bw_change_twigs <- lm(bw_change~ food_twigs , df)
summary(model_bw_change_twigs)
anova(model_bw_change_twigs)

model_rum_twigs <- lm(rum ~ food_twigs , df)
summary(model_rum_twigs)
anova(model_rum_twigs)


model <- lmer(rum ~ food_total * season + (1|reindeer)  , df)
summary(model)
anova(model)



#### corr. body weight change from season to season with body weight change within experiment ########

plot_bodyweight <- ggplot(df, aes(x=bw_change_within, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  ylab("bodyweight change")+
  xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))
plot_bodyweight



#### corr. body weight change with fodd intake twigs (only december) ########

p1 <- ggplot(df, aes(x=food_twigs, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
 # ylab("bodyweight change")+
  #xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


p2 <- ggplot(df, aes(x=food_twigs, y=bw_change_within, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
#  ylab("bodyweight change")+
#  xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))

grid.arrange(p1, p2)


#### corr. rum with fodd intake twigs (only december) ########

p1 <- ggplot(df, aes(x=food_twigs, y=rum, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  # ylab("bodyweight change")+
  #xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


p2 <- ggplot(df, aes(x=food_total, y=rum, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  #  ylab("bodyweight change")+
  #  xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))

grid.arrange(p1, p2)



#### corr. body weight change with food intake pellets ########

p1 <- ggplot(df, aes(x=food_pellets, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  # ylab("bodyweight change")+
  #xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


p2 <- ggplot(df, aes(x=food_pellets, y=bw_change_within, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  #  ylab("bodyweight change")+
  #  xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


p3 <- ggplot(df, aes(x=food_total, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  # ylab("bodyweight change")+
  #xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


p4 <- ggplot(df, aes(x=food_total, y=bw_change_within, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  #  ylab("bodyweight change")+
  #  xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))

grid.arrange(p1, p2, p3, p4)





#### corr. body weight change with rumination ########

p1 <- ggplot(df, aes(x=rum, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  # ylab("bodyweight change")+
  #xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


p2 <- ggplot(df, aes(x=rum, y=bw_change_within, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  #  ylab("bodyweight change")+
  #  xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))

grid.arrange(p1, p2)





#### corr. body weight change with rumination ########

p1 <- ggplot(df, aes(x=longwakeepi, y=bw_change, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  # ylab("bodyweight change")+
  #xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


p2 <- ggplot(df, aes(x=longwakeepi, y=bw_change_within, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  #  ylab("bodyweight change")+
  #  xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))

grid.arrange(p1, p2)





#### corr. body weight change with rumination ########

p1 <- ggplot(df, aes(x=longwakeepi, y=food_pellets, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  # ylab("bodyweight change")+
  #xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


p2 <- ggplot(df, aes(x=longwakeepi, y=food_total, color=season)) +
  geom_point(size=5) + 
  geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
  theme_bw()+
  #ylim(200,500)+
  #xlim(20,400)+
  #  ylab("bodyweight change")+
  #  xlab("bodyweight change within")+
  theme(text = element_text(size=16))+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))

grid.arrange(p1, p2)
