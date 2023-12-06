

library(dplyr)
library("readxl")
library(ggplot2)
library(patchwork)

setwd("C:/Users/schlaf/Documents/GitHub/ReindeerSleep/data")


df <- read_excel("arousals48.xlsx")
df$reindeer <- as.factor(df$reindeer)
df$body_position <- as.factor(df$body_position)
df$state <- as.factor(df$state)
df$reaction <- as.factor(df$reaction)
df$condition <- as.factor(df$condition)
df$condition2 <- as.factor(df$condition2)
df$up_down <- as.factor(df$up_down)


df_counts <- df %>% count(state, reindeer, reaction, condition, up_down, .drop=FALSE)

p1 <- ggplot(subset(df_counts, state=="n"),aes(reaction,n)) + 
  geom_col()
p2 <- ggplot(subset(df_counts, state=="rum"),aes(reaction,n)) + 
  geom_col()
p3 <- ggplot(subset(df_counts, state=="w"),aes(reaction,n)) + 
  geom_col()


p1 + p2 + p3


##### scale in percentage, absolute number as number

df_counts_pooled <- df %>% count(state, reaction, .drop=FALSE)

df_counts_pooled <- df_counts_pooled %>%
  group_by(state) %>%
  mutate(percent = n/sum(n)*100)


p1 <- ggplot(subset(df_counts_pooled, state=="n"),aes(reaction, percent)) + 
  geom_col()+
  geom_text(aes(label=n),size = 9, position=position_dodge(width=0.9), vjust=1.2, colour = "white" )+
  ylim(0,65)+
  theme_bw()+
  ggtitle("NREM sleep")+
  scale_x_discrete(labels=c("none","undirected","directed"))+
  xlab("reaction") +  ylab("Incidence (%)")+
  theme(axis.text=element_text(size=26,colour = "black"), axis.title=element_text(size=26, face="bold"), 
        axis.ticks.length=unit(.15, "cm"), axis.title.y=element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x=element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)),plot.title = element_text(size=26, face="bold",vjust = - 8, hjust = 0.02))


p2 <- ggplot(subset(df_counts_pooled, state=="rum"),aes(reaction, percent)) + 
  geom_col()+
  geom_text(aes(label=n),size = 9, position=position_dodge(width=0.9), vjust=1.2, colour = "white")+
  ylim(0,65)+
  theme_bw()+
  ggtitle("rumination")+
  scale_x_discrete(labels=c("none","undirected","directed"))+
  xlab("") + ylab("")+
  theme(axis.text=element_text(size=26,colour = "black"), axis.title=element_text(size=26, face="bold"),
        axis.ticks.length=unit(.15, "cm"), plot.title = element_text(size=26, face="bold",vjust = - 8, hjust = 0.02))

p3 <- ggplot(subset(df_counts_pooled, state=="w"),aes(reaction, percent)) + 
  geom_col()+
  geom_text(aes(label=n),size = 9, position=position_dodge(width=0.9), vjust=1.2, colour = "white")+
  ylim(0,65)+
  theme_bw()+
  ggtitle("wake")+
  scale_x_discrete(labels=c("none","undirected","directed"))+
  xlab("") + ylab("")+
  theme(axis.text=element_text(size=26,colour = "black"), axis.title=element_text(size=26, face="bold"),
        axis.ticks.length=unit(.15, "cm"), plot.title = element_text(size=26, face="bold",vjust = - 8, hjust = 0.02))

p1 + p2 + p3








#only 4 hours after Sleep Deprivation

df_counts_pooled_sd <- subset(df, condition2=="SD") %>% count(state, reaction, .drop=FALSE)

df_counts_pooled_sd <- df_counts_pooled_sd %>%
  group_by(state) %>%
  mutate(percent = n/sum(n)*100)



p1 <- ggplot(subset(df_counts_pooled_sd, state=="n"),aes(reaction, percent)) + 
  geom_col()+
  geom_text(aes(label=n),size = 9, position=position_dodge(width=0.9), vjust=1.2, colour = "white" )+
  ylim(0,75)+
  theme_bw()+
  ggtitle("NREM sleep")+
  scale_x_discrete(labels=c("none","undirected","directed"))+
  xlab("reaction") +  ylab("Incidence (%)")+
  theme(axis.text=element_text(size=26,colour = "black"), axis.title=element_text(size=26, face="bold"), 
        axis.ticks.length=unit(.15, "cm"), axis.title.y=element_text(margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.title.x=element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)),plot.title = element_text(size=26, face="bold",vjust = - 8, hjust = 0.02))


p2 <- ggplot(subset(df_counts_pooled_sd, state=="rum"),aes(reaction, percent)) + 
  geom_col()+
  geom_text(aes(label=n),size = 9, position=position_dodge(width=0.9), vjust=1.2, colour = "white")+
  ylim(0,75)+
  theme_bw()+
  ggtitle("rumination")+
  scale_x_discrete(labels=c("none","undirected","directed"))+
  xlab("") + ylab("")+
  theme(axis.text=element_text(size=26,colour = "black"), axis.title=element_text(size=26, face="bold"),
        axis.ticks.length=unit(.15, "cm"), plot.title = element_text(size=26, face="bold",vjust = - 8, hjust = 0.02))

p3 <- ggplot(subset(df_counts_pooled_sd, state=="w"),aes(reaction, percent)) + 
  geom_col()+
  geom_text(aes(label=n),size = 9, position=position_dodge(width=0.9), vjust=1.2, colour = "white")+
  ylim(0,75)+
  theme_bw()+
  ggtitle("wake")+
  scale_x_discrete(labels=c("none","undirected","directed"))+
  xlab("") + ylab("")+
  theme(axis.text=element_text(size=26,colour = "black"), axis.title=element_text(size=26, face="bold"),
        axis.ticks.length=unit(.15, "cm"), plot.title = element_text(size=26, face="bold",vjust = - 8, hjust = 0.02))

p1 + p2 + p3



#only when neighbour goes up

p1 <- ggplot(subset(df_counts, state=="n" & up_down=="u"),aes(reaction,n)) + 
  geom_col()
p2 <- ggplot(subset(df_counts, state=="rum" & up_down=="u"),aes(reaction,n)) + 
  geom_col()
p3 <- ggplot(subset(df_counts, state=="w" & up_down=="u"),aes(reaction,n)) + 
  geom_col()

p1 + p2 + p3


#### heatmaps (percentage reaction per state)   #####


#### pooled

df_counts_pooled <- df %>% count(state, reaction, .drop=FALSE)

df_counts_pooled <- df_counts_pooled %>%
  group_by(state) %>%
  mutate(percent = n/sum(n)*100)


ggplot(subset(df_counts_pooled, state!="rem"),aes(state, reaction, fill = percent)) + 
  geom_tile()+
  geom_text(aes(label=n),size = 9)+
  scale_y_discrete(labels=c("none","undirected","directed"))+
  scale_x_discrete(labels=c("NREM sleep","rumination","wake"))+
  scale_fill_gradient(low="white", high="blue",breaks=c(5.1,57.4999999999999),labels=c("Minimum","Maximum"))+
  theme_bw()+
  theme(axis.text=element_text(size=26,colour = "black"), axis.title=element_text(size=26, face="bold"), legend.text=element_text(size=26,colour = "black"),
        axis.title.x=element_text(margin = margin(t = 10, r = 0, b = 0, l = 0)),legend.title = element_text(size=26,colour = "black"), legend.key.size = unit(1.2, 'cm'), axis.ticks.length=unit(.15, "cm"))
  


#### per reindeer

df_counts <- df %>% count(state, reindeer, reaction, .drop=FALSE)

df_counts <- df_counts %>%
  group_by(state,reindeer) %>%
  mutate(percent = n/sum(n)*100)


p1 <- ggplot(subset(df_counts, reindeer==2 & state!="rem"), aes(state, reaction, fill = percent)) + 
  geom_tile()+
  ggtitle("reindeer 2")+
  geom_text(aes(label=n),size = 9)+
  scale_fill_gradient(low="white", high="blue")+
  theme_bw()+
  theme(axis.text=element_text(size=0), axis.title=element_text(size=0),
        plot.title = element_text(size=26,colour = "black"), legend.position="none", axis.ticks.length=unit(0, "cm"))

p2 <- ggplot(subset(df_counts, reindeer==3 & state!="rem"), aes(state, reaction, fill = percent)) + 
  geom_tile()+
  ggtitle("reindeer 3")+
  geom_text(aes(label=n),size = 9)+
  scale_fill_gradient(low="white", high="blue")+
  theme_bw()+
  theme(axis.text=element_text(size=0), axis.title=element_text(size=0),
        plot.title = element_text(size=26,colour = "black"), legend.position="none", axis.ticks.length=unit(0, "cm"))

p3 <- ggplot(subset(df_counts, reindeer==5 & state!="rem"), aes(state, reaction, fill = percent)) + 
  geom_tile()+
  ggtitle("reindeer 5")+
  geom_text(aes(label=n),size = 9)+
  scale_fill_gradient(low="white", high="blue")+
  theme_bw()+
  theme(axis.text=element_text(size=0), axis.title=element_text(size=0),
        plot.title = element_text(size=26,colour = "black"), legend.position="none", axis.ticks.length=unit(0, "cm"))

p4 <- ggplot(subset(df_counts, reindeer==6 & state!="rem"), aes(state, reaction, fill = percent)) + 
  geom_tile()+
  ggtitle("reindeer 6")+
  geom_text(aes(label=n),size = 9)+
  scale_fill_gradient(low="white", high="blue")+
  theme_bw()+
  theme(axis.text=element_text(size=0), axis.title=element_text(size=0),
        plot.title = element_text(size=26,colour = "black"), legend.position="none", axis.ticks.length=unit(0, "cm"))


p1 + p2 + p3 + p4





#### stats ######

df2 <- droplevels(subset(df, state!="rem"))

### ordinal ######
library(ordinal)
library(emmeans)

fmm1 <- clmm(reaction ~ state + (1|reindeer), df2)
summary(fmm1)

summary(lsmeans(fmm1,pairwise~state,adjust="tukey",mode="linear.predictor",type="Score"))


### do other factors have an effect?
df3 <- droplevels(subset(df2, condition!="BLb"))


fmm1 <- clmm(reaction ~ state * condition + (1|reindeer), df3)
summary(fmm1)
summary(lsmeans(fmm1,pairwise~state*condition,adjust="tukey",mode="linear.predictor",type="Score"))


fmm1 <- clmm(reaction ~ state * up_down + (1|reindeer), df2)
summary(fmm1)
summary(lsmeans(fmm1,pairwise~state*up_down,adjust="tukey",mode="linear.predictor",type="Score"))



fmm1 <- clmm(reaction ~ state + (1|reindeer), subset(df2, up_down=="u"))
summary(fmm1)
summary(lsmeans(fmm1,pairwise~state,adjust="tukey",mode="linear.predictor",type="Score"))



### linear-mixed model on counts (interaction reaction&state?) ######
library(lme4)
library(lmerTest)

model1 <- lmer(percent ~ reaction * state + (1|reindeer), df_counts)
summary(model1)
anova(model1)



#### chi-squared test  ####

library(gmodels)
library(MASS)


df2 <- droplevels(subset(df, state!="rem"))
counts <- table(df2$reaction, df2$state)
chisq.test(counts)

df3 <- droplevels(subset(df, state!="rem" & state!="w"))
counts <- table(df3$reaction, df3$state)
chisq.test(counts)

df4 <- droplevels(subset(df, state!="rem" & state!="n"))
counts <- table(df4$reaction, df4$state)
chisq.test(counts)

CrossTable(counts, fisher = TRUE, chisq = TRUE, expected = TRUE,
           sresid = TRUE, format = "SPSS")



##### arousal

df$arousal <- as.factor(df$arousal)


p1 <- ggplot(subset(df, state=='rum' | state=="n"), aes(state, arousal)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("EEG arousal")

p2 <- ggplot(subset(df, state=="n" & condition!='BLb'), aes(condition, arousal)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("EEG arousal")


p3 <- ggplot(subset(df, state=="rum" & condition!='BLb'), aes(condition, arousal)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("EEG arousal")

p1 + p2 + p3



subset(df, state=='rum' & arousal!='unclear') %>% 
  count(arousal) %>% 
  mutate() -> perc_arousal_rum

subset(df, state=='n') %>% 
  count(arousal) %>% 
  mutate() -> perc_arousal_nrem

subset(df, state=='rum' & condition == 'SD' & arousal!='unclear') %>% 
  count(arousal) %>% 
  mutate() -> perc_arousal_rum_SD

subset(df, state=='n' & condition == 'SD') %>% 
  count(arousal) %>% 
  mutate() -> perc_arousal_nrem_SD


perc_arousal <- data.frame(perc_arousal_rum,perc_arousal_nrem,perc_arousal_rum_SD,perc_arousal_nrem_SD)

##### arousal length


df$arousal_time <- as.numeric(df$arousal_time)


p1 <- ggplot(subset(df, state=='rum' | state=="n"), aes(state, arousal_time)) + 
  geom_boxplot()+
ggtitle("arousal time (sec)")

p2 <- ggplot(subset(df, state=="n" & condition!='BLb'), aes(condition, arousal_time)) + 
  geom_boxplot()+
ggtitle("arousal time (sec) for NREM sleep")


p3 <- ggplot(subset(df, state=="rum" & condition!='BLb'), aes(condition, arousal_time)) + 
  geom_boxplot()+
ggtitle("arousal time (sec) for rumination")


p1 + p2 + p3



##### transitions

df$transition <- as.factor(df$transition)



p1 <- ggplot(subset(df, state=='rum' | state=="n"), aes(state, transition)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("transitions")

p2 <- ggplot(subset(df, state=="n" & condition!='BLb'), aes(condition, transition)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("transitions NREM sleep")


p3 <- ggplot(subset(df, state=="rum" & condition!='BLb'), aes(condition, transition)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("transitions rumination")


p1 + p2 + p3



subset(df, state=='rum') %>% 
  count(transition) %>% 
  mutate() -> perc_trans_rum

subset(df, state=='n') %>% 
  count(transition) %>% 
  mutate() -> perc_trans_nrem


subset(df, state=='rum' & condition == 'SD') %>% 
  count(transition) %>% 
  mutate() -> perc_trans_rum_SD

subset(df, state=='n' & condition == 'SD') %>% 
  count(transition) %>% 
  mutate() -> perc_trans_nrem_SD

perc_trans <- data.frame(perc_trans_rum,perc_trans_nrem,perc_trans_rum_SD,perc_trans_nrem_SD)


##### rum-score (wake or NREM like)

p1 <- ggplot(subset(df, state=='rum'), aes(rum_score, arousal)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("arousal")

p2 <- ggplot(subset(df, state=='rum'), aes(rum_score, arousal_time)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("arousal time (sec)")

p3 <- ggplot(subset(df, state=='rum'), aes(rum_score, transition )) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("transitions")

p4 <- ggplot(subset(df, state=='rum'), aes(rum_score, reaction)) + 
  geom_jitter(width = 0.1, height=0.2)+
  ggtitle("reaction")


p1 + p2 + p3 + p4



