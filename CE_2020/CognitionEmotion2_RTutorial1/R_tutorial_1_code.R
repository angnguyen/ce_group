######################
### R Tutorial - 1 ### 
######################

# Code for R Tutorial 1 by An Nguyen and Aaron McInnes for Cognition and Emotion Group

############################
### Playing around in R ####
############################

1+1 # can run simple calculations
mean( c(3.3, 2.0, 5.0, 4.3) ) # can do more complex caluclations
sd( c(3.3, 2.0, 5.0, 4.3) ) # c() stands for concatenate


hello <- 50 # can assign numbers to variables (can have any name)
hello # prints variable so you can have a look at it
hello + 20 # can do mathmatical operations on variables (if they are numeric)


var1 <- "hello" # can also store words in variables (cannot do mathematical operations on these though)
var1 # if you just run the variable, it will tell you what's in it


##############################################
### R Tutorial - How to load an excel file ###
##############################################

# I normally put these on top of my script to clear R
rm(list = ls()) # clears environment
cat("\014") # clears console

library(openxlsx) # loads package with functions to open excel files - DOCUMENTATION: https://cran.r-project.org/web/packages/openxlsx/openxlsx.pdf

data_folder <- "E:/Cognition_emotion_group_2020/R_tutorial_1/data_is_here/" # define folder where the data file lives - NOTE: use forward-slash "/" not back-slash "\"
data_file <- "example_data_single_sheet.xlsx" # define the file name
full_file_path <- paste0(data_folder,data_file) #  combine folder path and file name to get the full file path

data2use <- read.xlsx(full_file_path) # reads data from this path, and store data inside "data2use" variable

# data2use <- read.xlsx("E:/Cognition_emotion_group_2020/R_tutorial_1/data_is_here/") # equivalent to above
# data2use <- read.xlsx(paste0(data_folder,data_file)) # equivalent to above

View(data2use)

######################################################
### Example of opening data across multiple sheets ###
######################################################

data_file_2 <- "example_data_multiple_sheets.xlsx" # define the file name
full_file_path_2 <- paste0(data_folder,data_file_2)

sheet_names <- getSheetNames(full_file_path_2) # get sheet names
excel_data_list <- lapply(sheet_names, read.xlsx, xlsxFile = full_file_path_2) # gets data from all sheets - except in separate 'lists'. Need to convert to single data-frame.
data2use <- do.call(rbind, excel_data) # stacks the sheets on top of each other

#####################################################
### Example of opening data across multiple files ###
#####################################################

data_folder <- "E:/Cognition_emotion_group_2020/R_tutorial_1/data_is_here/multiple_files_long_format/"

# subject_id <- c("P001", "P002", "P003", "P004", "P005") # specify manually
subject_id <- list.files(path = data_folder, full.names = FALSE) #get file names automatically
subject_id <- substring(subject_id,1,4) #only keeps first 4 charaters
subject_id

data2use <- list() #initialise empty list to store all of the participants data

# below is a for-loop - it *LOOPs* through the same code *FOR* a specific number of times
# it has a *counter* that keeps track of how many times it's looped.
# the counter can be used to get the code to do different things on each loop.

for (subi in 1: length(subject_id)){ # subi is the counter, it starts at 1 and it keeps looping until it reaches length(subject_id) - which is 5
  indiv_data_file <- paste0(subject_id[subi],".xlsx") # figuring out what file to open 
  full_file_path <- paste0(data_folder, indiv_data_file)
  indiv_data <- read.xlsx(full_file_path)
  data2use[[subi]] <- indiv_data
}
data2use <- do.call(rbind,data2use)

View(data2use)

###################################################################
### Example of convering data in 'wide format' to 'long format' ###
###################################################################

library(tidyr)
library(openxlsx)

data_folder <- "E:/Cognition_emotion_group_2020/R_tutorial_1/data_is_here/"
data_file <- "gather_example_data.xlsx"
full_path <- paste0(data_folder,data_file)
full_path <- "/Users/aaronmcinnes/ODcurtin/Git/ce_group/CognitionEmotion2_RTutorial1/data_is_here/gather_example_data.xlsx"

data2use <- read.xlsx(full_path)
data2use

data2use_v2 <- gather(data = data2use, key = "condition", value = "RT", c("RT_control","RT_condition_1", "RT_condition_2"))  # gather
View(data2use_v2)

data2use_v2$condition <-  substring(data2use_v2$condition, 4) # get rid of "RT_"

############################
### Convert back to Wide ###
############################

data2use_v3 <- spread(data = data2use_v2, key = "condition", value = "RT")

names(data2use_v3)[names(data2use_v3) == "control"] <- "RT_control"
names(data2use_v3)[names(data2use_v3) == "condition_1"] <- "RT_condition_1"
names(data2use_v3)[names(data2use_v3) == "condition_2"] <- "RT_condition_2"

##########################
### Save to Excel File ###
##########################

export_folder <-  "E:/Cognition_emotion_group_2020/R_tutorial_1/data_is_here/"
export_file <- "R_export.xlsx"
full_path <- paste0(export_folder,export_file)

write.xlsx(data2use_v3,full_path)

####################################
### Another Wide to Long Example ###
####################################

load("/Users/aaronmcinnes/ODcurtin/Git/ce_group/CognitionEmotion2_RTutorial1/data_is_here/wide_data_ex") #type the file path here
wide_data_ex #print the data so we can look at it 
# gather function
long_DF <- gather(wide_data_ex, Quarter, Revenue, Qtr.1:Qtr.4) #gather(data, key, value, columns to use)
# spread function
wide_DF <- spread(long_DF, Quarter, Revenue)

#########################
### End of Tutorial 1 ###
#########################

# Exercises:
# 1) Open your own excel data in R
# 2a) If your data is wide, convert it to long using gather()
# 2b) If your data is long, convert it to wide using spread()
# 3) Save the output as excel file
