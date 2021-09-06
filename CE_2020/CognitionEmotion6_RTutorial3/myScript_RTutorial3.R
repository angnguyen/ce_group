options(scipen = 999)
library(openxlsx)
library(ez)
library(emmeans)

##### Opening our data #####
data_folder <- dirname(rstudioapi::getSourceEditorContext()$path) #This gets the path of where you saved this script.You MUST save data in the same folder
data_file <- "my_long_data.xlsx" #The name of your data file
full_path <- paste(data_folder, data_file, sep = "/") #Putting the folder and file together, with a / in-between
my_data <- read.xlsx(full_path) #Open the spreadhseet from our full file path

my_data #Print to have a look at it

t.test(RT ~ gender, data = my_data, paired = FALSE)

Control <- subset(my_data, condition == "control")
Cond1 <- subset(my_data, condition == "condition_1")

t.test(Control$RT, Cond1$RT, paired = TRUE)

t.test(my_data$RT[my_data$condition == "control"], 
       my_data$RT[my_data$condition == "condition_1"], paired = TRUE)

options(contrasts = c("contr.sum", "contr.poly"))
ANOVA <- ezANOVA(data = my_data, 
                 dv = RT, 
                 wid = subject_id, 
                 within = c(condition),
                 return_aov = TRUE)
ANOVA

posthoc <- emmeans(ANOVA$aov, list(pairwise ~ condition), adjust = "bonferroni")
posthoc
