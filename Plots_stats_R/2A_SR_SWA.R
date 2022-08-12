
install.packages("dplyr")

library("readxl")
library(ggplot2)
library(NlinTS)
library(dplyr)
library(lme4)
library(lmerTest)
library(tidyverse)
library(gridExtra)

setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/excel_overview_data")

df <- read_excel("SWA_SR.xlsx")
df$reindeer <- as.factor(df$reindeer)
df$season <- as.factor(df$season)
df$timepoint <- as.factor(df$timepoint)
df$ba <- as.factor(df$ba)
df$tp <- as.factor(df$tp)


#df$SWA <- df$SWA_rum
df$SWA <- as.numeric(df$SWA)


####### stats ######

model1 <- lmer(SWA ~ ba * season * tp + (1|reindeer), df)
model2 <- lmer(SWA ~ ba * season + (1|tp) + (1|reindeer), df)
anova(model1)
anova(model2)




####### mean over seasons, without boxplot ###########



setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/SleepRestriction")
tiff("SR_boxplot_meanseasons_4h.png", units="in", width=6, height=3, res=300)

#df$SWA <- df$SWA_4


df1 <- df[ which(df$timepoint=='1' | df$timepoint=='2'), ]
gd <- df1 %>% 
  group_by(interaction (season, ba)) %>% 
  summarise(meanSWA = mean(SWA), seSWA = sd(SWA))
gd$ba <- c(1,1,1,2,2,2)
gd$season <- c('December','July','September','December','July','September')

gd$ba <- as.factor(gd$ba)



p1 <- ggplot(gd, aes(x=ba, y=meanSWA)) +
  geom_point( aes(x=ba, y=meanSWA, color=(season)), size=3)+
  geom_line( aes(x=ba, y=meanSWA, group=season, color=season), size=0.9)+
  geom_errorbar( aes(ymin=meanSWA-seSWA, ymax=meanSWA+seSWA, group=season, color=season), width = 0.2)+
  theme_bw()+
  theme(text = element_text(size=20),legend.position = "none",axis.title.x = element_blank())+
  scale_x_discrete(labels= c("before","after"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.8)+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))




df2 <- df[ which(df$timepoint=='3' | df$timepoint=='4'), ]

gd <- df2 %>% 
  group_by(interaction (season, ba)) %>% 
  summarise(meanSWA = mean(SWA), seSWA = sd(SWA))
gd$ba <- c(1,1,1,2,2,2)
gd$season <- c('December','July','September','December','July','September')

gd$ba <- as.factor(gd$ba)


p2 <- ggplot(gd, aes(x=ba, y=meanSWA)) +
  geom_point( aes(x=ba, y=meanSWA, color=season), size=3)+
  geom_line( aes(x=ba, y=meanSWA, group=season, color=season), size=0.9)+
  geom_errorbar( aes(ymin=meanSWA-seSWA, ymax=meanSWA+seSWA, group=season, color=season), width = 0.2)+
  theme_bw()+
  theme(text = element_text(size=20),legend.position = "none",axis.title.x = element_blank())+
  scale_x_discrete(labels= c("before","after"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.8)+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))



grid.arrange(p1, p2,ncol=2)


dev.off()



gd <- df %>% 
  group_by(interaction (season, ba)) %>% 
  summarise(meanSWA = mean(SWA), seSWA = sd(SWA))
gd$ba <- c(1,1,1,2,2,2)
gd$season <- c('December','July','September','December','July','September')


gd2 <- df %>% 
  group_by(ba) %>% 
  summarise(meanSWA = mean(SWA), seSWA = sd(SWA))
gd2$ba <- c(1,2)

gd2$ba <- as.factor(gd2$ba)
gd$ba <- as.factor(gd$ba)

setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/SleepRestriction")
tiff("SR_boxplot_meanseasonstimepoint_3h.png", units="in", width=6, height=5, res=300)

ggplot(gd, aes(x=ba, y=meanSWA)) +
  geom_point( aes(x=ba, y=meanSWA, color=season), size=4)+
  geom_errorbar( aes(ymin=meanSWA-seSWA, ymax=meanSWA+seSWA, group=season, color=season), size=1.5, width = 0.1)+
  geom_line( aes(x=ba, y=meanSWA, group=season, color=season), size=1.5)+
  geom_point( data=gd2, aes(x=ba, y=meanSWA, group=ba), size=4)+
  geom_line( data=gd2, aes(x=ba, y=meanSWA, group=1), size=1.5)+
  theme_bw()+
  theme(text = element_text(size=22),legend.position = "none",axis.title.x = element_blank())+
  scale_x_discrete(labels= c("before","after"))+
  ylab("normalized SWA")+
  ylim(0.4, 1.9)+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


dev.off()







####### two subplots divided by "night" vs "day" sleep restriction ###########

model1 <- lmer(SWA ~ ba * season * tp + (1|reindeer), df)
model2 <- lmer(SWA ~ ba * season + (1|tp) + (1|reindeer), df)
anova(model1)
anova(model2)

setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/SleepRestriction")
tiff("SR_change_4h.png", units="in", width=5, height=5, res=300)


df1 <- df[ which(df$timepoint=='1' | df$timepoint=='2'), ]


p1 <- ggplot(df1, aes(x=timepoint, y=SWA)) +
  #geom_boxplot()+
  geom_point( aes(x=timepoint, y=SWA, color=(season)), size=2)+
  geom_line( aes(x=timepoint, y=SWA, group=interaction(reindeer, season), color=season), size=0.8)+
  theme_bw()+
  theme(text = element_text(size=20),legend.position = "none",axis.title.x = element_blank())+
  scale_x_discrete(labels= c("09-12","14-17"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.9)+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


df2 <- df[ which(df$timepoint=='3' | df$timepoint=='4'), ]

p2 <- ggplot(df2, aes(x=timepoint, y=SWA)) +
  #geom_boxplot()+
  geom_point( aes(x=timepoint, y=SWA, color=(season)), size=2)+
  geom_line( aes(x=timepoint, y=SWA, group=interaction(reindeer, season), color=season), size=0.8)+
  theme_bw()+
  theme(text = element_text(size=20),legend.position = "none",axis.title.y = element_blank(),axis.title.x = element_blank())+
  #theme(text = element_text(size=20),legend.title = element_blank(),axis.title.y = element_blank(),axis.title.x = element_blank())+
  scale_x_discrete(labels= c("21-00","02-05"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.9)+
  scale_color_manual(values=c("#377eb8", "#4daf4a", "#ff7f00"))


grid.arrange(p1, p2,ncol=2)
dev.off()


####### three subplots divided by season, time point of sleep restriction coded by color ###########


setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/SleepRestriction")
tiff("SR_change_seasons_4h.png", units="in", width=9, height=6, res=300)


df3 <- df[ which(df$season=='Dec'), ]

p3 <- ggplot(df3, aes(x=ba, y=SWA)) +
  geom_boxplot()+
  geom_point( aes(x=ba, y=SWA, color=tp), size=2)+
  geom_line( aes(x=ba, y=SWA, color=tp, group=interaction(reindeer, tp), color=tp), size=0.8)+
  theme_bw()+
  theme(text = element_text(size=20),legend.position = "none",axis.title.x = element_blank(),axis.title.y = element_blank())+
  scale_x_discrete(labels= c("before","after"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.8)+
  ggtitle("December")+
  scale_color_manual(values=c("#fc8d62", "#8da0cb"))


df4 <- df[ which(df$season=='July'), ]

p4 <- ggplot(df4, aes(x=ba, y=SWA)) +
  geom_boxplot()+
  geom_point( aes(x=ba, y=SWA, color=tp), size=2)+
  geom_line( aes(x=ba, y=SWA, color=tp, group=interaction(reindeer, tp), color=tp), size=0.8)+
  theme_bw()+
  theme(text = element_text(size=20),legend.position = "none",axis.title.x = element_blank(),axis.title.y = element_blank())+
  scale_x_discrete(labels= c("before","after"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.8)+
  ggtitle("July")+
  scale_color_manual(values=c("#fc8d62", "#8da0cb"))

df5 <- df[ which(df$season=='Sep'), ]

p5 <- ggplot(df5, aes(x=ba, y=SWA)) +
  geom_boxplot()+
  geom_point( aes(x=ba, y=SWA, color=tp), size=2)+
  geom_line( aes(x=ba, y=SWA, color=tp, group=interaction(reindeer, tp), color=tp), size=0.8)+
  theme_bw()+
  theme(text = element_text(size=20),legend.position = "none",axis.title.x = element_blank(),axis.title.y = element_blank())+
  scale_x_discrete(labels= c("before","after"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.8)+
  ggtitle("September")+
  scale_color_manual(values=c("#fc8d62", "#8da0cb"))



grid.arrange(p3, p4, p5, ncol=3) 

dev.off()



model <- lmer(SWA ~ ba + (1|reindeer) + (1|season) + (1|timepoint), df )
summary(model)



####### grouped boxplots to compare ratios across seasons ###########



setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/excel_overview_data")

df <- read_excel("SWA_SR.xlsx")
df$reindeer <- as.factor(df$reindeer)
df$season <- as.factor(df$season)
df$timepoint <- as.factor(df$timepoint)
df$ba <- as.factor(df$ba)
df$tp <- as.factor(df$tp)


df$SWA <- df$SWA_3



df1 <- df[ which(df$timepoint=='1' | df$timepoint=='2'), ]
df2 <- df[ which(df$timepoint=='3' | df$timepoint=='4'), ]


SWAdiff1 <- df[ which(df1$timepoint=='2'), ]$SWA - df[ which(df1$timepoint=='1'), ]$SWA
dfdiff1 <- df1[ which(df1$timepoint=='2'), ]
dfdiff1$SWAdiff <- SWAdiff1

SWAdiff2 <- df2[ which(df2$timepoint=='4'), ]$SWA - df2[ which(df2$timepoint=='3'), ]$SWA
dfdiff2 <- df2[ which(df2$timepoint=='4'), ]
dfdiff2$SWAdiff <- SWAdiff2

dfdiff <- rbind(dfdiff1,dfdiff2)

model <- lmer(SWAdiff ~ timepoint * season + (1|reindeer) , dfdiff )
summary(model)
anova(model)

model <- lmer(SWA ~ ba + (1|season) + (1|reindeer) , df )
summary(model)
anova(model)


ggplot(dfdiff, aes(x=season, y=SWAdiff, fill=timepoint)) +
  scale_fill_manual(labels = c("midday","midnight"),values=c("yellow","black"))+
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(position=position_dodge(width=0.75),aes(group=timepoint,color=reindeer), size=5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Change in normalized SWA")



standard_error <- function(x) sd(x) / sqrt(length(x)) # Create own function
SWAdiffmean <- aggregate(dfdiff$SWAdiff, list(interaction (dfdiff$season, dfdiff$timepoint)), FUN=mean)
SWAdiffsd <- aggregate(dfdiff$SWAdiff, list(interaction (dfdiff$season, dfdiff$timepoint)), FUN=standard_error)
SWAdiffmean$timepoint <- c('midday','midnight','midday','midnight','midday','midnight')
SWAdiffmean$season <- c('December','July','September')
SWAdiffmean$m<- SWAdiffmean$x
SWAdiffmean$std<- SWAdiffsd$x
  

ggplot(SWAdiffmean, aes(x=season, y=m, fill=timepoint)) +
  scale_fill_manual(labels = c("midday","midnight"),values=c("#fed976","#969696"))+
  geom_bar(stat="identity",position = "dodge", width = 0.9,alpha=1) +
  geom_errorbar(aes(ymin=m-std, ymax=m+std), width=.2,
                position=position_dodge(.9))+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Change in normalized SWA")+
  ylim(-0.1, 1)
  
t.test(dfdiff[ which(dfdiff$season=='Sep' & dfdiff$timepoint==2), ]$SWAdiff,dfdiff[ which(dfdiff$season=='Sep' & dfdiff$timepoint==4), ]$SWAdiff, paired=TRUE)
t.test(dfdiff[ which(dfdiff$season=='Dec'), ]$SWAdiff,dfdiff[ which(dfdiff$season=='July' ), ]$SWAdiff, paired=FALSE)


model <- lmer(SWAdiff ~ timepoint * season + (1|reindeer) , dfdiff )
summary(model)
anova(model)

model <- aov(SWAdiff ~ season * timepoint + Error(reindeer), dfdiff )
summary(model)
TukeyHSD(model)

####### separate boxplots ###########  


SWAdiff1 <- df1[ which(df1$timepoint=='2'), ]$SWA - df1[ which(df1$timepoint=='1'), ]$SWA
dfdiff1 <- df1[ which(df1$timepoint=='2'), ]
dfdiff1$SWAdiff <- SWAdiff1

SWAdiff2 <- df2[ which(df2$timepoint=='4'), ]$SWA - df2[ which(df2$timepoint=='3'), ]$SWA
dfdiff2 <- df2[ which(df2$timepoint=='4'), ]
dfdiff2$SWAdiff <- SWAdiff2

dfdiff <- rbind(dfdiff1,dfdiff2)



p1 <- ggplot(dfdiff1, aes(x=season, y=SWAdiff)) +
  geom_boxplot()+
  geom_point( aes(x=season, y=SWAdiff, color=reindeer))+
  theme_bw()+
  ylab("Ratio normalized SWA")



p2 <- ggplot(dfdiff2, aes(x=season, y=SWAdiff)) +
  geom_boxplot()+
  geom_point( aes(x=season, y=SWAdiff, color=reindeer))+
  theme_bw()+
  ylab("Ratio normalized SWA")


grid.arrange(p1, p2)







####### two subplots divided by "night" vs "day" sleep restriction, no distinction between seasons ###########

setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/Results/SleepRestriction")
tiff("SR_boxplot.png", units="in", width=5, height=5, res=300)


df1 <- df[ which(df$timepoint=='1' | df$timepoint=='2'), ]

p1 <- ggplot(df1, aes(x=timepoint, y=SWA)) +
  geom_boxplot()+
  theme_bw()+
  theme(text = element_text(size=20),legend.position = "none",axis.title.x = element_blank())+
  scale_x_discrete(labels= c("before","after"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.9)



df2 <- df[ which(df$timepoint=='3' | df$timepoint=='4'), ]

p2 <- ggplot(df2, aes(x=timepoint, y=SWA)) +
  geom_boxplot()+
  theme_bw()+
  #theme(text = element_text(size=20),legend.position = "none",axis.title.y = element_blank(),axis.title.x = element_blank())+
  theme(text = element_text(size=20),legend.position = "none",axis.title.x = element_blank())+
  scale_x_discrete(labels= c("before","after"))+
  ylab("normalized SWA")+
  ylim(0.3, 1.9)



grid.arrange(p1, p2,ncol=2)
dev.off()







####### NREM sleep duration: grouped boxplots to compare across seasons ###########




df$SWA <- df$nremdur_4h


df3 <- df[ which(df$timepoint=='2' | df$timepoint=='4'), ]




ggplot(df3 , aes(x=season, y=SWA, fill=timepoint)) +
  scale_fill_manual(labels = c("midday","midnight"),values=c("yellow","black"))+
  stat_boxplot(coef=2,alpha=0.3)+
  geom_boxplot(alpha=0.2)+
  geom_point(position=position_dodge(width=0.75),aes(group=timepoint,color=reindeer), size=5)+
  theme_bw()+
  theme(text = element_text(size=20))+
  ylab("Change in normalized SWA")



t.test(dfdiff[ which(dfdiff$season=='Sep' & dfdiff$timepoint==2), ]$SWAdiff,dfdiff[ which(dfdiff$season=='Sep' & dfdiff$timepoint==4), ]$SWAdiff, paired=TRUE)
t.test(dfdiff[ which(dfdiff$season=='Dec'), ]$SWAdiff,dfdiff[ which(dfdiff$season=='July' ), ]$SWAdiff, paired=FALSE)


model <- lmer(SWA ~ timepoint + season + (1|reindeer) , df3 )
summary(model)

model2 <- lmer(SWA ~ ba * season + (1|reindeer) + (1|tp), df)
summary(model2)
anova(model2)

model3 <- lmer(SWA ~ ba * season * tp + (1|reindeer), df)
summary(model3)
anova(model3)

model3 <- aov(SWA ~ ba * season * tp + Error(reindeer), df)
summary(model3)



