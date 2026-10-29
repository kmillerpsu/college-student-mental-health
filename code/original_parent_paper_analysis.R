##############################################################
##############################################################
##############################################################

# C Jynx Pigart
# Arizona State University
# 05 August 2025

#### ENVIRONMENT & VARIABLE PREP ####
{

  library(tidyverse)
  library(psych)
  library(janitor)
  library(ggplot2)
  library(grDevices)
  library(jtools)

data <- read.csv("data/raw/original_data.csv")

data <- data %>% mutate_if(is.character, as.factor)
str(data)
data$fincur.2<- as.numeric(data$fincur.2)
data$race.2 <- relevel(data$race.2, ref = "White")
data$yr_sch.2 <- relevel(data$yr_sch.2, ref = "firstyear")
data$yr_sch.bin <- relevel(data$yr_sch.bin, ref = "1st.2nd")

# depression using mean scores
psych::describe(data$PHQ)

# anxiety using mean scores
psych::describe(data$GAD)

# STEM or nonSTEM major
table(data$field)

  # relabeling it for manuscript revisions
  data <- data %>%
    mutate(field = case_when(
      field == "STEM"  ~ "STEM",
      field == "NotSTEM" ~ "Non-STEM"
    ))

# gender (cisgender)
table(data$gender)

# CURRENT financial stress, single item 5-point likert, recoded such that
# "least stressful" = 1
# "most stressful" = 5
table(data$fincur.2)

# race
table(data$race.2)
}


##### correlation matrices & descriptive stats for regressions #####

psych::describe(data$PHQ)
psych::describe(data$GAD)
psych::describe(data$age.cent)
psych::describe(data$yr_sch.2)

regression.descriptives <- data %>%
  group_by(gender, field) %>%
  summarise(
    N = n(),
    PHQ.mean = round(mean(PHQ, na.rm = TRUE), 3),
    PHQ.sd = round(sd(PHQ, na.rm = TRUE),3),
    GAD.mean = round(mean(GAD, na.rm = TRUE),3),
    GAD.sd = round(sd(GAD, na.rm = TRUE),3),
  ) %>%
  ungroup()
regression.descriptives


regression.descriptives <- data %>%
  group_by(field, gender) %>%
  summarise(
    N = n(),
    PHQ.mean = round(mean(PHQ, na.rm = TRUE), 3),
    PHQ.sd = round(sd(PHQ, na.rm = TRUE),3),
    GAD.mean = round(mean(GAD, na.rm = TRUE),3),
    GAD.sd = round(sd(GAD, na.rm = TRUE),3),
  ) %>%
  ungroup()
regression.descriptives

regression.descriptives1 <- data %>%
  group_by(field) %>%
  summarise(
    N = n(),
    PHQ.mean = round(mean(PHQ, na.rm = TRUE), 3),
    PHQ.sd = round(sd(PHQ, na.rm = TRUE),3),
    GAD.mean = round(mean(GAD, na.rm = TRUE),3),
    GAD.sd = round(sd(GAD, na.rm = TRUE),3),
  ) %>%
  ungroup()
regression.descriptives1

regression.descriptives2 <- data %>%
  group_by(gender) %>%
  summarise(
    N = n(),
    PHQ.mean = round(mean(PHQ, na.rm = TRUE), 3),
    PHQ.sd = round(sd(PHQ, na.rm = TRUE),3),
    GAD.mean = round(mean(GAD, na.rm = TRUE),3),
    GAD.sd = round(sd(GAD, na.rm = TRUE),3),
  ) %>%
  ungroup()
regression.descriptives2

# # removing decline to states (NAs) as they were excluded from regressions
# regression.descriptives <- regression.descriptives[-(3),]
# regression.descriptives <- regression.descriptives[-(5),]
# regression.descriptives
# write.csv(regression.descriptives, file ="temporary.export.descriptives.csv")

# making correlation matrices
table(data$yr_sch.2)

data <- data %>%
  mutate(yr_sch.2=factor(yr_sch.2)) %>%
  mutate(yr_sch.2=fct_relevel(yr_sch.2, c("firstyear","secondyear",
                                          "thirdyear", "fourthyear+")))
data$yr_sch.num <- as.numeric(data$yr_sch.2)

cor_vars <- na.omit(dplyr::select(data, c(PHQ, GAD, age.cent,
                                          fincur.2 , yr_sch.num)))

table(data$yr_sch.num)
cor.matrix <- psych::corr.test(cor_vars)
temp.test1 <- as.data.frame(round(cor.matrix$r,3))  # Correlation coefficients
temp.test2 <- as.data.frame(round(cor.matrix$p,6))  # P-values
cor.matrix
# write.csv(temp.test1, file = "temporary.export.corrmatrix.r.csv")
# write.csv(temp.test2, file = "temporary.export.corrmatrix.p.csv")

# descriptives
with(data, table(field))
with(data, table(gender))
with(data, table(race.2))
with(data, table(fincur.2))

########### REGRESSIONS: DEPRESSION, ANXIETY, ACADEMIC STRESS ########

# checking, based on revisions feedback
table(data$yr_sch.2)
psych::describe(data$age)
psych::describe(data$age.cent)
round(prop.table(table(data$yr_sch.2)),3)

# DEPRESSION (PHQ-9)
model.dep.revise <- lm(PHQ ~ gender + field + gender:field + fincur.2 + race.2
                       + yr_sch.2 + age.cent, data = data)
summary_table.dep.revise <- jtools::summ(model.dep.revise, scale = FALSE, vifs = TRUE, part.corr = FALSE, confint = TRUE, pvals = TRUE, robust = "HC3")
summary_table.dep.revise

# ANXIETY (GAD-7)
model.anx.revise <- lm(GAD ~ gender + field + gender:field + fincur.2 + race.2
                       + yr_sch.2 + age.cent, data = data)
summary_table.anx.revise <- jtools::summ(model.anx.revise, scale = FALSE, vifs = TRUE, part.corr = FALSE, confint = TRUE, pvals = TRUE, robust = "HC3")
summary_table.anx.revise

# report both together in one table
jtools::export_summs(summary_table.anx.revise, summary_table.dep.revise, scale = FALSE, vifs = TRUE, part.corr = FALSE, confint = TRUE, pvals = TRUE, robust = "HC3", error_format = "({std.error})", to.file = "docx", file.name = "summ.regressions.docx")

########### REGRESSIONS: INTERACTION PLOTS ###########

# DEPRESSION (PHQ-9)
interaction.dep <- interactions::cat_plot(model.dep.revise, pred = gender, modx = field,
                                          geom = "line", colors = "Dark2", robust = TRUE,
                                          line.thickness = .8,
                                          pred.point.size = 2.5,
                                          errorbar.width = .2)

interaction.dep2 <- interaction.dep + theme_classic() +
  theme(
    plot.title = element_text(hjust = 0.5,  size = rel(1.5)),
    axis.text.y = element_text(face = "bold", size = rel(1.2)),
    axis.text.x = element_text(face = "bold", size = rel(1.2)),
    axis.title.x = element_text(face = "bold", size = rel(1.2)),
    axis.title.y = element_text(face = "bold", size = rel(1.2))) +
  labs(x = "Gender", y = "Mean PHQ-9", title = "Interaction", color = "") +
  theme(plot.margin=grid::unit(c(3,3,3,8), "mm")) +
  geom_point(size = 1) +
  geom_line(size = .7) +
  scale_y_continuous(labels = scales::label_number(accuracy = 0.01))
interaction.dep2

# ANXIETY (GAD-7)
interaction.anx <- interactions::cat_plot(model.anx.revise, pred = gender, modx = field, geom = "line",
                                          colors = "Dark2", robust = TRUE,
                                          line.thickness = .8,
                                          pred.point.size = 2.5,
                                          errorbar.width = .2)

interaction.anx2 <- interaction.anx + theme_classic() +
                        theme(
                          plot.title = element_text(hjust = 0.5,  size = rel(1.5)),
                          axis.text.y = element_text(face = "bold", size = rel(1.2)),
                          axis.text.x = element_text(face = "bold", size = rel(1.2)),
                          axis.title.x = element_text(face = "bold", size = rel(1.2)),
                          axis.title.y = element_text(face = "bold", size = rel(1.2))) +
    labs(x = "Gender", y = "Mean GAD-7", title = "Interaction", color = "") +
  theme(plot.margin=grid::unit(c(3,3,3,8), "mm")) +
  scale_y_continuous(labels = scales::label_number(accuracy = 0.01))
interaction.anx2


########### FOREST PLOT: ANXIETY #############
# data frame of the output you get from a regression
test.anx <- as.data.frame(summary(lm(formula = GAD ~ gender + field + gender:field + fincur.2 + race.2 + yr_sch.2 + age.cent, data = data))$coefficients)
test.anx$outcome <- "Anxiety"
test.anx$predictor <- rownames(test.anx)

# rename the columns
test.anx <- test.anx %>%
  rename(est = `Estimate`, se = `Std. Error`, tval = `t value`) %>%
  as.data.frame()

# calculate pvals
test.anx$pval <- pnorm(abs(test.anx$tval), lower.tail = FALSE) *2

# calculate odds ratios
test.anx$or <- exp(test.anx$est)

# calculate error bars
test.anx$FNE.all_SE.min.se <- test.anx$est -(1.96*test.anx$se)
test.anx$FNE.all_SE.max.se<- test.anx$est +(1.96*test.anx$se)
test.anx$FNE.all_SE.min.bar <- exp(test.anx$FNE.all_SE.min.se)
test.anx$FNE.all_SE.max.bar <- exp(test.anx$FNE.all_SE.max.se)

# check that the columns added to  data frame
test.anx

# forest plot generation
forest.anxiety <-test.anx %>%
  filter(predictor %in% c(

    "genderWomen",
    "fieldSTEM",
    "genderWomen:fieldSTEM"
  )) %>%
  mutate(predictor = fct_relevel(predictor,
                                 "genderWomen",
                                 "fieldSTEM",
                                 "genderWomen:fieldSTEM"
  )) %>%
  ggplot(aes(x = est, y = predictor, color = predictor)) +
  geom_point(size = 2.5) +
  geom_vline(aes(xintercept = 0), linetype="dashed", size=.7, color = "grey25") +
  geom_errorbarh(aes(xmin = (est-(1.96*se)), xmax = (est+(1.96*se)), height = .3),
                 position=ggstance::position_dodgev(height=0.5), alpha = 1, size = .8)+
  labs(x = "Coefficients", y = "", title = "GAD-7", color = "") +
  theme_classic() +
  scale_x_continuous(labels = scales::label_number(accuracy = 0.01)) +
  scale_y_discrete(labels=c(
    "Women",
    "STEM",
    "Women:STEM"
  )) +
  # scale_color_viridis(option = "", direction = -1, discrete = TRUE)+
  scale_fill_manual(values=c(
    "#675bc1" ,
    "#675bc1" ,
    "#675bc1"
  ), aesthetics = c("color", "fill")) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5,  size = rel(1.5)),
        axis.text.y = element_text(face = "bold", size = rel(1.2)),
        axis.text.x = element_text(face = "bold", size = rel(1.2)),
        axis.title.x = element_text(face = "bold", size = rel(1.2)),
        axis.title.y = element_text(face = "bold", size = rel(1.2)))
forest.anxiety


########### FOREST PLOT: DEPRESSION  #############
# data frame of regression output
test.dep <- as.data.frame(summary(lm(formula = PHQ ~ gender + field + gender:field + fincur.2 + race.2
                                     + yr_sch.2 + age.cent , data = data))$coefficients)
test.dep$outcome <- "Depression"
test.dep$predictor <- rownames(test.dep)

# rename the columns
test.dep <- test.dep %>%
  rename(est = `Estimate`, se = `Std. Error`, tval = `t value`) %>%
  as.data.frame()

# calculate pvals
test.dep$pval <- pnorm(abs(test.dep$tval), lower.tail = FALSE) *2

# calculate odds ratios
test.dep$or <- exp(test.dep$est)

# calculate error bars
test.dep$FNE.all_SE.min.se <- test.dep$est -(1.96*test.dep$se)
test.dep$FNE.all_SE.max.se<- test.dep$est +(1.96*test.dep$se)
test.dep$FNE.all_SE.min.bar <- exp(test.dep$FNE.all_SE.min.se)
test.dep$FNE.all_SE.max.bar <- exp(test.dep$FNE.all_SE.max.se)

# check that the columns added
test.dep

# forest plot generation
forest.depression <-test.dep %>%
  filter(predictor %in% c(
    "genderWomen",
    "fieldSTEM",
    "genderWomen:fieldSTEM"
  )) %>%
  mutate(predictor = fct_relevel(predictor,
                                 "genderWomen",
                                 "fieldSTEM",
                                 "genderWomen:fieldSTEM"
  )) %>%
  ggplot(aes(x = est, y = predictor, color = predictor)) +
  geom_point(size = 2.5) +
  geom_vline(aes(xintercept = 0), linetype="dashed", size=.7, color = "grey25") +
  geom_errorbarh(aes(xmin = (est-(1.96*se)), xmax = (est+(1.96*se)), height = .3),
                 position=ggstance::position_dodgev(height=0.5), alpha = 1, size = .8)+
  labs(x = "Coefficients", y = "", title = "PHQ-9", color = "") +
  theme_classic() +
  scale_y_discrete(labels=c(
    "Women",
    "STEM",
    "Women:STEM"
  )) +
  scale_fill_manual(values=c(
    "#675bc1" ,
    "#675bc1" ,
    "#675bc1"
  ), aesthetics = c("color", "fill")) +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5,  size = rel(1.5)),
        axis.text.y = element_text(face = "bold", size = rel(1.2)),
        axis.text.x = element_text(face = "bold", size = rel(1.2)),
        axis.title.x = element_text(face = "bold", size = rel(1.2)),
        axis.title.y = element_text(face = "bold", size = rel(1.2)))
forest.depression


#### REGRESSSIONS: FORMAT FOR EXPORT ####

hello <- ggpubr::ggarrange(interaction.anx2, interaction.dep2, nrow = 2,
                           labels = c("(b)","(d)")
                           ) + theme(text = element_text(family = "Arial"))
hello
hey<- ggpubr::ggarrange(forest.anxiety, forest.depression, nrow = 2,
                        labels = c("(a)","(c)")
                         ) + theme(text = element_text(family = "Arial"))
hey

# arranging plots together for export
figure1 <- ggpubr::ggarrange(
  hey,
  hello,
  ncol = 2
)
figure1

# svg file export (character kerning is a little weird, moved to TIFF format)
  # library(svglite)
  # svglite("figure1may.svg", width = 7, height = 4)
  # print
  # dev.off()

# tiff file for journal submission export
cowplot::ggsave2("Fig 1.tiff", dpi = 600)

#### REGRESSIONS: CLEANING ENV ####

rm(model.anx, model.dep, forest.anxiety, forest.depression,
   interaction.anx, interaction.anx2, interaction.dep, interaction.dep2,
   temp.test1, temp.test2, model.anx.revise, model.dep.revise,
   summary_table.anx.revise, summary_table.dep.revise, cor_vars, cor.matrix,
   hey, hello # figure parts, temporary
   )

##############################################################
##############################################################
##############################################################

#### REFERENCE: EXACT WORDING OF MH AFFECTING ACA PERFORMANCE ########

# In the past year, how has the following affected your academic performance?

# where each variable starts with "aca_dep_1." and ends with a number which means:
# 1= I did not experience this.
# 2= I experienced this, but it did not affect my academic performance.
# 3= I received a lower grade on one or more exams or projects.
# 4= I received a lower grade in one or more courses.
# 5= I received an incomplete or dropped one or more courses.
# 6= I had a significant disruption in research, practicum, thesis, or dissertation work.
# 7= Other

###### CHI-SQUARES: PREP VARIABLES #####
data$aca_dep_1.2 <- NA
data$aca_dep_2.2 <- NA
data$aca_dep_3.2 <- NA
data$aca_dep_4.2 <- NA
data$aca_dep_5.2 <- NA
data$aca_dep_6.2 <- NA
data$aca_dep_7.2 <- NA

data$aca_anx_1.2 <- NA
data$aca_anx_2.2 <- NA
data$aca_anx_3.2 <- NA
data$aca_anx_4.2 <- NA
data$aca_anx_5.2 <- NA
data$aca_anx_6.2 <- NA
data$aca_anx_7.2 <- NA

data[data$aca_dep_1 == "1" & !is.na(data$aca_dep_1),]$aca_dep_1.2 <- "1"
data[data$aca_dep_2 == "1" & !is.na(data$aca_dep_2),]$aca_dep_2.2 <- "1"
data[data$aca_dep_3 == "1" & !is.na(data$aca_dep_3),]$aca_dep_3.2 <- "1"
data[data$aca_dep_5 == "1" & !is.na(data$aca_dep_5),]$aca_dep_5.2 <- "1"
data[data$aca_dep_4 == "1" & !is.na(data$aca_dep_4),]$aca_dep_4.2 <- "1"
data[data$aca_dep_6 == "1" & !is.na(data$aca_dep_6),]$aca_dep_6.2 <- "1"
table(data$aca_dep_7)
data[data$aca_dep_7 == "TRUE" & !is.na(data$aca_dep_7),]$aca_dep_7.2 <- "1"

data[data$aca_anx_1 == "1" & !is.na(data$aca_anx_1),]$aca_anx_1.2 <- "1"
data[data$aca_anx_2 == "1" & !is.na(data$aca_anx_2),]$aca_anx_2.2 <- "1"
data[data$aca_anx_3 == "1" & !is.na(data$aca_anx_3),]$aca_anx_3.2 <- "1"
data[data$aca_anx_5 == "1" & !is.na(data$aca_anx_5),]$aca_anx_5.2 <- "1"
data[data$aca_anx_4 == "1" & !is.na(data$aca_anx_4),]$aca_anx_4.2 <- "1"
data[data$aca_anx_6 == "1" & !is.na(data$aca_anx_6),]$aca_anx_6.2 <- "1"
table(data$aca_anx_7)
data[data$aca_anx_7 == "1" & !is.na(data$aca_anx_7),]$aca_anx_7.2 <- "1"

###### CHI-SQUARES: DEPRESSION, GENDER AND STEM  #####
multicheck.dep <- dplyr::select(data, c(gender,
                                         field,
                                         aca_dep_2.2,
                                         aca_dep_3.2,
                                         aca_dep_4.2,
                                         aca_dep_5.2,
                                         aca_dep_6.2,
                                         aca_dep_7.2

))

multicheck.dep$gender <- as.factor(multicheck.dep$gender)
multicheck.dep$field <- as.factor(multicheck.dep$field)

multicheck.dep <- multicheck.dep %>% mutate_if(is.character, as.numeric)
str(multicheck.dep)
multicheck.dep <- tibble::rowid_to_column(multicheck.dep, "ID")

# doing the multi check, this makes another data table; we only want the $total
multicheck.dep2 <- multicheck.dep %>%
  mutate(total = dplyr::select(., aca_dep_2.2:aca_dep_7.2) %>% rowSums(na.rm = TRUE))

table(multicheck.dep2$total) # what we want!

# recoding it so 0 = nothing selected, 1 = at least one thing was selected
multicheck.dep2$selected <- NA
multicheck.dep2[multicheck.dep2$total == "1" & !is.na(multicheck.dep2$total),]$selected <- "1"
multicheck.dep2[multicheck.dep2$total == "2" & !is.na(multicheck.dep2$total),]$selected <- "1"
multicheck.dep2[multicheck.dep2$total == "3" & !is.na(multicheck.dep2$total),]$selected <- "1"
multicheck.dep2[multicheck.dep2$total == "4" & !is.na(multicheck.dep2$total),]$selected <- "1"
multicheck.dep2[multicheck.dep2$total == "5" & !is.na(multicheck.dep2$total),]$selected <- "1"
multicheck.dep2[multicheck.dep2$total == "6" & !is.na(multicheck.dep2$total),]$selected <- "1"
table(multicheck.dep2$selected)
multicheck.dep2$selected <- as.numeric(multicheck.dep2$selected)
str(multicheck.dep2$selected)

# filtering data to only those who responded to 2-7
datatest.dep <- multicheck.dep2 %>% filter(selected == "1") %>% filter(gender == "Men" | gender == "Women") %>% filter(field == "STEM" | field == "Non-STEM")
str(datatest.dep) # sanity check


# coding in the 0,1 format for no/yes
datatest.dep$aca_dep_2.2 <- datatest.dep$aca_dep_2.2 %>% replace_na(0)
datatest.dep$aca_dep_3.2 <- datatest.dep$aca_dep_3.2 %>% replace_na(0)
datatest.dep$aca_dep_4.2 <- datatest.dep$aca_dep_4.2 %>% replace_na(0)
datatest.dep$aca_dep_5.2 <- datatest.dep$aca_dep_5.2 %>% replace_na(0)
datatest.dep$aca_dep_6.2 <- datatest.dep$aca_dep_6.2 %>% replace_na(0)
datatest.dep$aca_dep_7.2 <- datatest.dep$aca_dep_7.2 %>% replace_na(0)

# sanity check
with(datatest.dep, table(gender, aca_dep_2.2))
with(datatest.dep, table(gender, aca_dep_3.2))
with(datatest.dep, table(gender, aca_dep_4.2))
with(datatest.dep, table(gender, aca_dep_5.2))
with(datatest.dep, table(gender, aca_dep_6.2))
with(datatest.dep, table(gender, aca_dep_7.2))
with(datatest.dep, table(field, aca_dep_2.2))
with(datatest.dep, table(field, aca_dep_3.2))
with(datatest.dep, table(field, aca_dep_4.2))
with(datatest.dep, table(field, aca_dep_5.2))
with(datatest.dep, table(field, aca_dep_6.2))
with(datatest.dep, table(field, aca_dep_7.2))

# chi-squares
gender.result.dep.2 <- chisq.test(with(datatest.dep, table(gender, aca_dep_2.2)))
gender.result.dep.3 <- chisq.test(with(datatest.dep, table(gender, aca_dep_3.2)))
gender.result.dep.4 <- chisq.test(with(datatest.dep, table(gender, aca_dep_4.2)))
gender.result.dep.5 <- chisq.test(with(datatest.dep, table(gender, aca_dep_5.2)))
gender.result.dep.6 <- chisq.test(with(datatest.dep, table(gender, aca_dep_6.2)))
gender.result.dep.7 <- chisq.test(with(datatest.dep, table(gender, aca_dep_7.2)))

field.result.dep.2 <- chisq.test(with(datatest.dep, table(field, aca_dep_2.2)))
field.result.dep.3 <- chisq.test(with(datatest.dep, table(field, aca_dep_3.2)))
field.result.dep.4 <- chisq.test(with(datatest.dep, table(field, aca_dep_4.2)))
field.result.dep.5 <- chisq.test(with(datatest.dep, table(field, aca_dep_5.2)))
field.result.dep.6 <- chisq.test(with(datatest.dep, table(field, aca_dep_6.2)))
field.result.dep.7 <- chisq.test(with(datatest.dep, table(field, aca_dep_7.2)))

# chi-square readouts
gender.result.dep.2
gender.result.dep.3
gender.result.dep.4
gender.result.dep.5
gender.result.dep.6
gender.result.dep.7
field.result.dep.2
field.result.dep.3
field.result.dep.4
field.result.dep.5
field.result.dep.6
field.result.dep.7


###### CHI-SQUARES: DEPRESSION, AUXILLARY ####

multicheck.dep2$selected <- multicheck.dep2$selected %>% replace_na(0)
table(multicheck.dep2$selected)

# chi square that looks at if something was selected at all x had gender differences
chisq.test(multicheck.dep2$selected, multicheck.dep2$gender)

# chi square that looks at if something was selected at all x field differences
chisq.test(multicheck.dep2$selected, multicheck.dep2$field)

str(multicheck.dep2)
table(multicheck.dep2$selected, multicheck.dep2$aca_dep_2.2)
table(multicheck.dep2$aca_dep_2.2)


###### CHI-SQUARES: ANXIETY,    GENDER AND STEM SECTION #####
multicheck.anx <- dplyr::select(data, c(gender,
                                         field,
                                         aca_anx_2.2,
                                         aca_anx_3.2,
                                         aca_anx_4.2,
                                         aca_anx_5.2,
                                         aca_anx_6.2,
                                         aca_anx_7.2

))

multicheck.anx$gender <- as.factor(multicheck.anx$gender)
multicheck.anx$field <- as.factor(multicheck.anx$field)

multicheck.anx <- multicheck.anx %>% mutate_if(is.character, as.numeric)
str(multicheck.anx)
multicheck.anx <- tibble::rowid_to_column(multicheck.anx, "ID")

# doing the multi check, this makes another data table; we only want the $total
multicheck.anx2 <- multicheck.anx %>%
  mutate(total = dplyr::select(., aca_anx_2.2:aca_anx_7.2) %>% rowSums(na.rm = TRUE))

table(multicheck.anx2$total) # what we want!

# recoding it so 0 = nothing selected, 1 = at least one thing was selected
multicheck.anx2$selected <- NA
multicheck.anx2[multicheck.anx2$total == "1" & !is.na(multicheck.anx2$total),]$selected <- "1"
multicheck.anx2[multicheck.anx2$total == "2" & !is.na(multicheck.anx2$total),]$selected <- "1"
multicheck.anx2[multicheck.anx2$total == "3" & !is.na(multicheck.anx2$total),]$selected <- "1"
multicheck.anx2[multicheck.anx2$total == "4" & !is.na(multicheck.anx2$total),]$selected <- "1"
multicheck.anx2[multicheck.anx2$total == "5" & !is.na(multicheck.anx2$total),]$selected <- "1"
# multicheck.anx2[multicheck.anx2$total == "6" & !is.na(multicheck.anx2$total),]$selected <- "1"
table(multicheck.anx2$selected)
multicheck.anx2$selected <- as.numeric(multicheck.anx2$selected)
str(multicheck.anx2$selected)

# filtering data to only those who responded to 2-7
datatest.anx <- multicheck.anx2 %>% filter(selected == "1") %>% filter(gender == "Men" | gender == "Women") %>% filter(field == "STEM" | field == "Non-STEM")
str(datatest.anx) # sanity check

# coding in the 0,1 format for no/yes
datatest.anx$aca_anx_2.2 <- datatest.anx$aca_anx_2.2 %>% replace_na(0)
datatest.anx$aca_anx_3.2 <- datatest.anx$aca_anx_3.2 %>% replace_na(0)
datatest.anx$aca_anx_4.2 <- datatest.anx$aca_anx_4.2 %>% replace_na(0)
datatest.anx$aca_anx_5.2 <- datatest.anx$aca_anx_5.2 %>% replace_na(0)
datatest.anx$aca_anx_6.2 <- datatest.anx$aca_anx_6.2 %>% replace_na(0)
datatest.anx$aca_anx_7.2 <- datatest.anx$aca_anx_7.2 %>% replace_na(0)

# sanity check
with(datatest.anx, table(gender, aca_anx_2.2))
with(datatest.anx, table(gender, aca_anx_3.2))
with(datatest.anx, table(gender, aca_anx_4.2))
with(datatest.anx, table(gender, aca_anx_5.2))
with(datatest.anx, table(gender, aca_anx_6.2))
with(datatest.anx, table(gender, aca_anx_7.2))
with(datatest.anx, table(field, aca_anx_2.2))
with(datatest.anx, table(field, aca_anx_3.2))
with(datatest.anx, table(field, aca_anx_4.2))
with(datatest.anx, table(field, aca_anx_5.2))
with(datatest.anx, table(field, aca_anx_6.2))
with(datatest.anx, table(field, aca_anx_7.2))

# chi-squares
gender.result.anx.2 <- chisq.test(with(datatest.anx, table(gender, aca_anx_2.2)))
gender.result.anx.3 <- chisq.test(with(datatest.anx, table(gender, aca_anx_3.2)))
gender.result.anx.4 <- chisq.test(with(datatest.anx, table(gender, aca_anx_4.2)))
gender.result.anx.5 <- chisq.test(with(datatest.anx, table(gender, aca_anx_5.2)))
gender.result.anx.6 <- chisq.test(with(datatest.anx, table(gender, aca_anx_6.2)))
gender.result.anx.7 <- chisq.test(with(datatest.anx, table(gender, aca_anx_7.2)))

field.result.anx.2 <- chisq.test(with(datatest.anx, table(field, aca_anx_2.2)))
field.result.anx.3 <- chisq.test(with(datatest.anx, table(field, aca_anx_3.2)))
field.result.anx.4 <- chisq.test(with(datatest.anx, table(field, aca_anx_4.2)))
field.result.anx.5 <- chisq.test(with(datatest.anx, table(field, aca_anx_5.2)))
field.result.anx.6 <- chisq.test(with(datatest.anx, table(field, aca_anx_6.2)))
field.result.anx.7 <- chisq.test(with(datatest.anx, table(field, aca_anx_7.2)))

# chi-square readouts
gender.result.anx.2
gender.result.anx.3
gender.result.anx.4
gender.result.anx.5
gender.result.anx.6
gender.result.anx.7
field.result.anx.2
field.result.anx.3
field.result.anx.4
field.result.anx.5
field.result.anx.6
field.result.anx.7

###### CHI-SQUARES: ANXIETY,    AUXILLARY ####


multicheck.anx2$selected <- multicheck.anx2$selected %>% replace_na(0)
table(multicheck.anx2$selected)

# chi square that looks at if something was selected at all x had gender differences
chisq.test(multicheck.anx2$selected, multicheck.anx2$gender)

with(multicheck.anx2, table(selected, gender))

# chi square that looks at if something was selected at all x field differences
chisq.test(multicheck.anx2$selected, multicheck.anx2$field)



#### CHI-SQUARES: DEP BH CORRECTIONS ####
pvalue.dep <- c(gender.result.dep.2$p.value, gender.result.dep.3$p.value,
                gender.result.dep.4$p.value, gender.result.dep.5$p.value, gender.result.dep.6$p.value,
                gender.result.dep.7$p.value)

chisqt.dep <- c("gender.result.dep.2", "gender.result.dep.3",
                "gender.result.dep.4", "gender.result.dep.5", "gender.result.dep.6",
                "gender.result.dep.7")

gender.BH.dep <- data.frame(chisqt.dep, pvalue.dep)
gender.BH.dep$BH.pvalue <- NA
gender.BH.dep$BH.pvalue <- with(gender.BH.dep, p.adjust(pvalue.dep, method = "BH"))
print(format(gender.BH.dep, scientific = F))

pvalue.dep <- c(field.result.dep.2$p.value, field.result.dep.3$p.value,
                field.result.dep.4$p.value, field.result.dep.5$p.value, field.result.dep.6$p.value,
                field.result.dep.7$p.value)

chisqt.dep <- c("field.result.dep.2", "field.result.dep.3",
                "field.result.dep.4", "field.result.dep.5", "field.result.dep.6",
                "field.result.dep.7")

field.BH.dep <- data.frame(chisqt.dep, pvalue.dep)
field.BH.dep$BH.pvalue <- NA
field.BH.dep$BH.pvalue <- with(field.BH.dep, p.adjust(pvalue.dep, method = "BH"))
print(format(field.BH.dep, scientific = F))


#### CHI-SQUARES: ANX BH CORRECTIONS ####
pvalue.anx <- c(gender.result.anx.2$p.value, gender.result.anx.3$p.value,
                gender.result.anx.4$p.value, gender.result.anx.5$p.value, gender.result.anx.6$p.value,
                gender.result.anx.7$p.value)

chisqt.anx <- c("gender.result.anx.2", "gender.result.anx.3",
                "gender.result.anx.4", "gender.result.anx.5", "gender.result.anx.6",
                "gender.result.anx.7")

gender.BH.anx <- data.frame(chisqt.anx, pvalue.anx)
gender.BH.anx$BH.pvalue <- NA
gender.BH.anx$BH.pvalue <- with(gender.BH.anx, p.adjust(pvalue.anx, method = "BH"))
print(format(gender.BH.anx, scientific = F))

pvalue.anx <- c(field.result.anx.2$p.value, field.result.anx.3$p.value,
                field.result.anx.4$p.value, field.result.anx.5$p.value, field.result.anx.6$p.value,
                field.result.anx.7$p.value)

chisqt.anx <- c("field.result.anx.2", "field.result.anx.3",
                "field.result.anx.4", "field.result.anx.5", "field.result.anx.6",
                "field.result.anx.7")

field.BH.anx <- data.frame(chisqt.anx, pvalue.anx)
field.BH.anx$BH.pvalue <- NA
field.BH.anx$BH.pvalue <- with(field.BH.anx, p.adjust(pvalue.anx, method = "BH"))
print(format(field.BH.anx, scientific = F))


#### CHI-SQUARES: FORMAT FOR EXPORT ######

# Conducting chi-square tests and storing results
results_list <- list()
results_list[[1]] <- gender.result.anx.2
results_list[[2]] <- gender.result.anx.3
results_list[[3]] <- gender.result.anx.4
results_list[[4]] <- gender.result.anx.5
results_list[[5]] <- gender.result.anx.6
results_list[[6]] <- gender.result.anx.7
results_list[[7]] <- gender.result.dep.2
results_list[[8]] <- gender.result.dep.3
results_list[[9]] <- gender.result.dep.4
results_list[[10]] <- gender.result.dep.5
results_list[[11]] <- gender.result.dep.6
results_list[[12]] <- gender.result.dep.7
results_list[[13]] <- field.result.anx.2
results_list[[14]] <- field.result.anx.3
results_list[[15]] <- field.result.anx.4
results_list[[16]] <- field.result.anx.5
results_list[[17]] <- field.result.anx.6
results_list[[18]] <- field.result.anx.7
results_list[[19]] <- field.result.dep.2
results_list[[20]] <- field.result.dep.3
results_list[[21]] <- field.result.dep.4
results_list[[22]] <- field.result.dep.5
results_list[[23]] <- field.result.dep.6
results_list[[24]] <- field.result.dep.7



# Names of the chi-square tests
test_names <- c("gender.result.anx.2",
                "gender.result.anx.3",
                "gender.result.anx.4",
                "gender.result.anx.5",
                "gender.result.anx.6",
                "gender.result.anx.7",

                "gender.result.dep.2",
                "gender.result.dep.3",
                "gender.result.dep.4",
                "gender.result.dep.5",
                "gender.result.dep.6",
                "gender.result.dep.7",

                "field.result.anx.2",
                "field.result.anx.3",
                "field.result.anx.4",
                "field.result.anx.5",
                "field.result.anx.6",
                "field.result.anx.7",

                "field.result.dep.2",
                "field.result.dep.3",
                "field.result.dep.4",
                "field.result.dep.5",
                "field.result.dep.6",
                "field.result.dep.7"
)

combined_chisq_results <- do.call(rbind, Map(function(x, y) {
  data.frame(Test_Name = y,
             Chi_Square_Value = round(x$statistic, 2),
             p_value = round(x$p.value, 3))
}, results_list, test_names))

# write.csv(combined_chisq_results, file = "chisquareoutput.csv")





###### CHI-SQUARES (DESCRIPTIVE STATS SUPP)  #####

# In the past year, how has the following affected your academic performance?

# where each variable starts with "aca_dep_1." and ends with a number which means:
# 1= I did not experience this.
# 2= I experienced this, but it did not affect my academic performance.
# 3= I received a lower grade on one or more exams or projects.
# 4= I received a lower grade in one or more courses.
# 5= I received an incomplete or dropped one or more courses.
# 6= I had a significant disruption in research, practicum, thesis, or dissertation work.
# 7= Other

long_dep <- datatest.dep %>%
  pivot_longer(cols = starts_with("aca_dep_"),
               names_to = "construct",
               values_to = "affected") %>%
  filter(affected %in% c(0, 1)) %>%
  mutate(construct = recode(construct,
                            "aca_dep_2.2" = "Experienced this; did not impact academic performance",
                            "aca_dep_3.2" = "Lower grade (on an exam or project)",
                            "aca_dep_4.2" = "Lower grade (final grade)",
                            "aca_dep_5.2" = "Received incomplete or dropped course",
                            "aca_dep_6.2" = "Disrupted research or thesis",
                            "aca_dep_7.2" = "Other"))

summarytable.dep <- long_dep %>%
  group_by(construct, gender, field) %>%
  summarise(
    N = n(),
    affected_n = sum(affected),
    percent_affected = round(100 * affected_n / N, 1),
    .groups = "drop"
  ) %>%
  arrange(construct, gender, field)

print(summarytable.dep)


long_anx <- datatest.anx %>%
  pivot_longer(cols = starts_with("aca_anx_"),
               names_to = "construct",
               values_to = "affected") %>%
  filter(affected %in% c(0, 1)) %>%
  mutate(construct = recode(construct,
                            "aca_anx_2.2" = "Experienced this; did not impact academic performance",
                            "aca_anx_3.2" = "Lower grade (on an exam or project)",
                            "aca_anx_4.2" = "Lower grade (final grade)",
                            "aca_anx_5.2" = "Received incomplete or dropped course",
                            "aca_anx_6.2" = "Disrupted research or thesis",
                            "aca_anx_7.2" = "Other"))

summarytable.anx <- long_anx %>%
  group_by(construct, gender, field) %>%
  summarise(
    N = n(),
    affected_n = sum(affected),
    percent_affected = round(100 * affected_n / N, 1),
    .groups = "drop"
  ) %>%
  arrange(construct, gender, field)

print(summarytable.anx)

summarytable.dep$mh <- "Depression/suicidality"
summarytable.anx$mh <- "Anxiety/stress"
summarytable.combined <- rbind(summarytable.anx, summarytable.dep)

write.csv(summarytable.combined, "supplemental_descriptives_chisq.csv")


#### CHI-SQUARES: CLEANING ENV ####
rm(results_list)
rm(chisqt.anx)
rm(chisqt.dep)
rm(pvalue.anx)
rm(pvalue.dep)
rm(test_names)
rm(field.result.anx.2)
rm(field.result.anx.3)
rm(field.result.anx.4)
rm(field.result.anx.5)
rm(field.result.anx.6)
rm(field.result.anx.7)
rm(field.result.dep.2)
rm(field.result.dep.3)
rm(field.result.dep.4)
rm(field.result.dep.5)
rm(field.result.dep.6)
rm(field.result.dep.7)
rm(gender.result.anx.2)
rm(gender.result.anx.3)
rm(gender.result.anx.4)
rm(gender.result.anx.5)
rm(gender.result.anx.6)
rm(gender.result.anx.7)
rm(gender.result.dep.2)
rm(gender.result.dep.3)
rm(gender.result.dep.4)
rm(gender.result.dep.5)
rm(gender.result.dep.6)
rm(gender.result.dep.7)

rm(multicheck.dep2)
rm(multicheck.dep)
rm(multicheck.anx2)
rm(multicheck.anx)

##############################################################
##############################################################
##############################################################

######## DOUBLE BAR GRAPH: DEPRESSION BY GENDER ########

data.test.dep.gender <- with(datatest.dep, data.frame(gender, aca_dep_3.2, aca_dep_4.2,
                                                    aca_dep_5.2, aca_dep_6.2,
                                                    aca_dep_7.2))

melt_data.dep.gender <- reshape2::melt(data.test.dep.gender, id = "gender")
table(melt_data.dep.gender$value) # sanity check

# proportions for double bar graphs
proportion_data.dep.gender <- melt_data.dep.gender %>%
  group_by(gender, variable) %>%
  summarise(total = n(),
            value_1_count = sum(value == 1)) %>%
  mutate(proportion = value_1_count / total)

# plotting double bar graph for depression
dep.gender <- ggplot(proportion_data.dep.gender, aes(x = variable, y = proportion, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(x = "", y = "Percent (%)", fill = "Gender") +
 # ggtitle("Ways depression affects academic performance by gender") +
  theme(legend.position = c(0.85, 0.85), legend.justification = c(1, 1),
        axis.text.x = element_text(angle = 0, hjust = 1), # x-axis font tilt
        axis.text.y = element_text(angle = 0, hjust = 1)) +
  scale_y_continuous(labels = scales::percent_format()) +
  coord_flip() +
  scale_fill_manual(values=c("#96ead7","#f7eaa2")) +
  scale_x_discrete(labels = c("aca_dep_3.2" = "Received a lower grade
                              on exams or projects",
                              "aca_dep_4.2" = "Recieved a lower grade
                              in the course",
                              "aca_dep_5.2" = "Received an incomplete
                              or dropped course",
                              "aca_dep_6.2" = "Significant disruption
                              to research or thesis",
                              "aca_dep_7.2" = "Other")) +
  geom_text(aes(label = paste0(round(proportion*100, 1), "%")),
            position = position_dodge(width = 1.2),
            vjust = .5,
            hjust = 1.02,
            size = 3.0) +
  theme(plot.margin=grid::unit(c(1,1,1,-25), "mm"))
dep.gender
######## DOUBLE BAR GRAPH: ANXIETY BY GENDER ########

data.test.anx.gender <- with(datatest.anx, data.frame(gender, aca_anx_3.2, aca_anx_4.2,
                                                    aca_anx_5.2, aca_anx_6.2,
                                                    aca_anx_7.2))

melt_data.anx.gender <- reshape2::melt(data.test.anx.gender, id = "gender")
table(melt_data.anx.gender$value) # sanity check

# proportions for double bar graphs
proportion_data.anx.gender <- melt_data.anx.gender %>%
  group_by(gender, variable) %>%
  summarise(total = n(),
            value_1_count = sum(value == 1)) %>%
  mutate(proportion = value_1_count / total)

# plotting double bar graph for anx
anx.gender <- ggplot(proportion_data.anx.gender, aes(x = variable, y = proportion, fill = gender)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(x = "", y = "Percent (%)", fill = "Gender") +

  #ggtitle("Ways anxiety affects academic performance by gender") +
  theme(legend.position = c(0.85, 0.85), legend.justification = c(1, 1),
        axis.text.x = element_text(angle = 0, hjust = 1),
        axis.text.y = element_text(angle = 0, hjust = 1)) +
  scale_y_continuous(labels = scales::percent_format()) +
  coord_flip() +
  scale_fill_manual(values=c("#96ead7","#f7eaa2")) +
  scale_x_discrete(labels = c("aca_anx_3.2" = "Received a lower grade
                              on exams or projects",
                              "aca_anx_4.2" = "Recieved a lower grade
                              in the course",
                              "aca_anx_5.2" = "Received an incomplete
                              or dropped course",
                              "aca_anx_6.2" = "Significant disruption
                              to research or thesis",
                              "aca_anx_7.2" = "Other"))+
  geom_text(aes(label = paste0(round(proportion*100, 1), "%")),
            position = position_dodge(width = 1.2),
            vjust = .5,
            hjust = 1.02,
            size = 3.0) +
  theme(plot.margin=grid::unit(c(1,1,1,-25), "mm"))
anx.gender


######## DOUBLE BAR GRAPH: DEPRESSION BY FIELD ########

table(datatest.dep$field)

data.test.dep.field <- with(datatest.dep, data.frame(field, aca_dep_3.2, aca_dep_4.2,
                                                     aca_dep_5.2, aca_dep_6.2,
                                                     aca_dep_7.2))

# verifying all participants report a field type
data.test.dep.field <- data.test.dep.field %>% filter(field == "Non-STEM" | field == "STEM")
table(data.test.dep.field$field)

# melting for plotting
melt_data.dep.field <- reshape2::melt(data.test.dep.field, id = "field")
table(melt_data.dep.field$value) # sanity check

# proportions for double bar graphs
proportion_data.dep.field <- melt_data.dep.field %>%
  group_by(field, variable) %>%
  summarise(total = n(),
            value_1_count = sum(value == 1)) %>%
  mutate(proportion = value_1_count / total)


# plotting double bar graph for depression
dep.field <- ggplot(proportion_data.dep.field, aes(x = variable, y = proportion, fill = field)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(x = "", y = "Percent (%)", fill = "Field") +

 # ggtitle("Ways depression affects academic performance by field") +
  theme(legend.position = c(0.85, 0.85), legend.justification = c(1, 1),
        axis.text.x = element_text(angle = 0, hjust = 1),
        axis.text.y = element_text(angle = 0, hjust = 1)) +
  scale_y_continuous(labels = scales::percent_format()) +
  coord_flip() +
  scale_fill_manual(values=c("#d8bfed","#d4edbf")) +
  scale_x_discrete(labels = c("aca_dep_3.2" = "Received a lower grade
                              on exams or projects",
                              "aca_dep_4.2" = "Recieved a lower grade
                              in the course",
                              "aca_dep_5.2" = "Received an incomplete
                              or dropped course",
                              "aca_dep_6.2" = "Significant disruption
                              to research or thesis",
                              "aca_dep_7.2" = "Other"))+
  geom_text(aes(label = paste0(round(proportion*100, 1), "%")),
            position = position_dodge(width = 1.2),
            vjust = .5,
            hjust = 1.02,
            size = 3.0) +
  theme(plot.margin=grid::unit(c(1,1,1,-25), "mm"))
dep.field

######## DOUBLE BAR GRAPH: ANXIETY BY FIELD ########

data.test.anx.field <- with(datatest.anx, data.frame(field, aca_anx_3.2, aca_anx_4.2,
                                                     aca_anx_5.2, aca_anx_6.2,
                                                     aca_anx_7.2))

# verifying all participants report a field type
data.test.anx.field <- data.test.anx.field %>% filter(field == "Non-STEM" | field == "STEM")
table(data.test.anx.field$field)

# melting for plotting
melt_data.anx.field <- reshape2::melt(data.test.anx.field, id = "field")
table(melt_data.anx.field$value) # sanity check

# proportions for double bar graphs
proportion_data.anx.field <- melt_data.anx.field %>%
  group_by(field, variable) %>%
  summarise(total = n(),
            value_1_count = sum(value == 1)) %>%
  mutate(proportion = value_1_count / total)

# plotting double bar graph for anx
anx.field <- ggplot(proportion_data.anx.field, aes(x = variable, y = proportion, fill = field)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(x = "", y = "Percent (%)", fill = "Field") +

  # ggtitle("Ways anxiety affects academic performance by field") +
  theme(legend.position = c(0.85, 0.85), legend.justification = c(1, 1),
        axis.text.x = element_text(angle = 0, hjust = 1),
        axis.text.y = element_text(angle = 0, hjust = 1)) +
  scale_y_continuous(labels = scales::percent_format()) +
  coord_flip() +
  scale_fill_manual(values=c("#d8bfed","#d4edbf")) +
  scale_x_discrete(labels = c("aca_anx_3.2" = "Received a lower grade
                              on exams or projects",
                              "aca_anx_4.2" = "Recieved a lower grade
                              in the course",
                              "aca_anx_5.2" = "Received an incomplete
                              or dropped course",
                              "aca_anx_6.2" = "Significant disruption
                              to research or thesis",
                              "aca_anx_7.2" = "Other"))+
  geom_text(aes(label = paste0(round(proportion*100, 1), "%")),
            position = position_dodge(width = 1.2),
            vjust = .5,
            hjust = 1.02,
            size = 3.0) +
  theme(plot.margin=grid::unit(c(1,1,1,-25), "mm"))
anx.field
#### DOUBLE BAR GRAPH: FORMAT FOR EXPORT ####

figure.dep <- ggpubr::ggarrange(dep.gender,
                             dep.field,
                             ncol= 2,
                             labels = c("(a)","(b)"))
figure.dep

cowplot::ggsave2("Fig dep_final.tiff", dpi = 600, bg = "white")


figure.anx <- ggpubr::ggarrange(anx.gender,
                             anx.field,
                             ncol= 2,
                             labels = c("(a)","(b)"))
figure.anx

cowplot::ggsave2("Fig anx_final.tiff", dpi = 600, bg = "white")

##### DOUBLE BAR GRAPH: CLEANING ENV ####
# rm(melt_data.anx.field)
# rm(melt_data.anx.gender)
# rm(melt_data.dep.field)
# rm(melt_data.dep.gender)
# rm(data.test.dep.field)
# rm(data.test.dep.gender)
# rm(data.test.anx.field)
# rm(data.test.anx.gender)
# rm(summarytable.anx)
# rm(summarytable.dep)
