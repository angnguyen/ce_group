###########################
### R Tutorial - Basics ### 
###########################
rm(list = ls()) # clears environment
cat("\014") # clears console


1+1

hello <- 50
there <- 20
hello + there

var1 <- "hello"
var1

##############################################
### R Tutorial - How to load an excel file ###
##############################################

rm(list = ls()) # clears environment
cat("\014") # clears console

 
library(openxlsx) # loads package with functions to open excel files - DOCUMENTATION: https://cran.r-project.org/web/packages/openxlsx/openxlsx.pdf


data_folder <- "E:/Cognition_emotion_group_2020/R_tutorial_1/data_is_here/" # define folder where the data file lives - NOTE: use forward-slash "/" not back-slash "\"
data_file <- "example_data_single_sheet.xlsx" # define the file name
full_file_path <- paste0(data_folder,data_file) #  combine folder path and file name to get the full file path

data2use <- read.xlsx(full_file_path) # reads data from this path, and store data inside "data2use" variable
# data2use <- read.xlsx("E:/Cognition_emotion_group_2020/R_tutorial_1/data_is_here/") # equivalent to above
# data2use <- read.xlsx(paste0(data_folder,data_file)) # equivalent to above


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

# subject_id <- c("P001", "P002", "P003", "P004", "P005") #specify manually
subject_id <- list.files(path = data_folder, full.names = FALSE) #get file names automatically

data2use <- list()
for (subi in 1: length(subject_id)){
  # indiv_data_file <- paste0(subject_id[subi],".xlsx")
  indiv_data_file <- subject_id[subi]
  full_file_path <- paste0(data_folder, indiv_data_file)
  indiv_data <- read.xlsx(full_file_path)
  data2use[[subi]] <- indiv_data
}
data2use <- do.call(rbind,data2use)

###################################################################
### Example of convering data in 'wide format' to 'long format' ###
###################################################################

load("wide_data_ex") #type the file path here

wide_data_ex #print the data so we can look at it 

long_DF <- gather(wide_data_ex, Quarter, Revenue, Qtr.1:Qtr.4) #gather(data, key, value, columns to use)


# spread function
wide_DF <- spread(long_DF, Quarter, Revenue)


###################################################################
### Example of Analysis ###
###################################################################
library(lmerTest)
RT_model <- lmer(RT ~ Condition + (1|Subject_ID), data = data2use)
anova(RT_model)
