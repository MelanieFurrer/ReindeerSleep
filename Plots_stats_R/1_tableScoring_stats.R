

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


df <- read_excel("totdurations_episodes_tbl1.xlsx")
df$reindeer <- as.factor(df$reindeer)
df$season <- as.factor(df$season)


# repeated measures anova, BUT like this rd-5 gets excluded because of missing data of Dec.
model2 <- aov(nrem_dur ~ season + Error(reindeer), df)
summary(model2)


# linear mixed model (to keep RD-5 in statistics)
model1 <- lmer(nrem_dur ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(rem_dur ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(rum_dur ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(wake_dur ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(nrem_epi_dur ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(rem_epi_dur ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(rum_epi_dur ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(wake_epi_dur ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(nrem_epi_nr ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(rem_epi_nr ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(rum_epi_nr ~ season + (1|reindeer), df)
anova(model1)

model1 <- lmer(wake_epi_nr ~ season + (1|reindeer), df)
anova(model1)

