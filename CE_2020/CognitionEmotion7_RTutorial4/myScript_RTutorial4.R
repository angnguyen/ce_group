library(openxlsx)

##### Opening our data #####
data_folder <- dirname(rstudioapi::getSourceEditorContext()$path) #This gets the path of where you saved this script.You MUST save data in the same folder
data_file <- "my_long_data.xlsx" #The name of your data file
full_path <- paste(data_folder, data_file, sep = "/") #Putting the folder and file together, with a / in-between
my_data <- read.xlsx(full_path) #Open the spreadhseet from our full file path

my_data #Print to have a look at it

