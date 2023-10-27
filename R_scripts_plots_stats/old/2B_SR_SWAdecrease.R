library("readxl")
library(ggplot2)
library(NlinTS)
library(dplyr)
library(lme4)
library(lmerTest)
library(tidyverse)
library(gridExtra)
library("emmeans")

setwd("C:/Users/schlaf/Documents/reindeer/Data_Analysis_main_experiment/excel_overview_data")

df <- read_excel("SWA_SR_perH.xlsx")
df$reindeer <- as.factor(df$reindeer)
df$season <- as.factor(df$season)
df$timepoint <- as.factor(df$timepoint)
df$hour <- as.factor(df$hour)




model3 <- lmer(SWA_after ~ hour *season * timepoint + (1|reindeer), df)
summary(model3)
anova(model3)



model1 <- lmer(SWA_after ~ hour *season + (1|reindeer) + (1|timepoint), df)
summary(model1)
anova(model1)






#pairwise comparisons




model1 <- lmer(SWA_before ~ hour *season + (1|reindeer) + (1|timepoint), df)
summary(model1)
anova(model1)

model2 <- lmer(SWA_before ~ hour *season + (1|reindeer), df)
summary(model2)
anova(model2)

model3 <- aov(SWA_before  ~ hour * season * timepoint + Error(reindeer), df)
summary(model3)


