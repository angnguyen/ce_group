library(openxlsx)
library(ez)
library(emmeans)

##### Opening our data #####
data_folder <- dirname(rstudioapi::getSourceEditorContext()$path) #This gets the path of where you saved this script.You MUST save data in the same folder
data_file <- "my_long_data.xlsx" #The name of your data file
full_path <- paste(data_folder, data_file, sep = "/") #Putting the folder and file together, with a / in-between
my_data <- read.xlsx(full_path) #Open the spreadhseet from our full file path

my_data #Print to have a look at it


################################################################################################
################################ HOW TO RUN T-TESTS ############################################
################################################################################################

##### Running our t test to determine whether males and females differ in Reaction Time #####
t.test(RT ~ gender, data = my_data) #There is no difference, lets try something more meaningful....


##### Subsetting different conditions in our data (Method 1) #####
Control <- subset(my_data, condition == "control") #Crearing object with control data
Control #Print it so we can see what it looks like
Cond1 <- subset(my_data, condition == "condition_1") #Crearing object with condition_1 data
Cond1 #Print it so we can see what it looks like

t.test(Control$RT, Cond1$RT, paired = TRUE) #The control condition and condition_1 differ


#### Subsetting different conditions in our data (Method 2) #####
t.test(my_data$RT[my_data$condition == "control"], my_data$RT[my_data$condition == "condition_1"], paired = TRUE)
# or, 
t.test(RT ~ condition, data=subset(my_data, condition %in% c("control", "condition_1")), paired = TRUE)



################################################################################################
############################# HOW TO RUN ANOVA #################################################
################################################################################################

ANOVA <- ezANOVA(data = my_data, dv = .(RT), wid = .(subject_id), within = .(condition), return_aov = TRUE) #RT differs between conditions. Return_aov must be called to run pairwise comparisons
ANOVA #Print it to look at it

posthoc <- emmeans(ANOVA$aov, list(pairwise ~ condition), adjust = "tukey") #Pairwise comparisons of our anova object with tukey correction
posthoc #Print it to look at it


################################################################################################
########################## HOW TO TEST CORRELATIONS ############################################
################################################################################################

cor.test(my_data$RT, my_data$age) #Test correlation of RT with age, default method is pearson

cor.test(~RT + age, data = my_data, condition == "control") #Subsetting the control condition


