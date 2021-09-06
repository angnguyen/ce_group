library(readxl)
library(reshape2)
library(xlsx)

# Smart way to work with files without specifying address manually
data_folder <- dirname(rstudioapi::getSourceEditorContext()$path)# Nothing to be done here but gets address of the folder where the file is.

# create a file in excel in long format.
set.seed(45)# This just makes the numbers the same every time you run the code.
dat1 <- data.frame(
  Condition = rep(c("first_block", "second_block"), each=10),
  ID = rep(1:10, 2),
  Measurement = rnorm(20)
)

setwd(data_folder)# This set the saving folder to the same folder you have the this script.
write.xlsx(dat1, file="Test_long.xlsx", sheetName="Dat1", row.names=FALSE)# write the file to that folder

data_file <- 'Test_long.xlsx' # I call the same name I creates above here

dataLong <- as.data.frame(read_excel(paste(data_folder,data_file, sep = "/")))# creates the name and gets the data in one line of code

dataLong # just showing the data

data_wide <- dcast(dataLong, ID ~ Condition , value.var="Measurement")# transforms from long to wide format
head(data_wide, 10)# shows the data in wide format

