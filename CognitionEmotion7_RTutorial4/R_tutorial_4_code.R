library(openxlsx)
library(Rmisc)
library(ggplot2)
library(patchwork)

##### Opening our data #####
data_folder <- dirname(rstudioapi::getSourceEditorContext()$path) #This gets the path of where you saved this script.You MUST save data in the same folder
data_file <- "my_long_data.xlsx" #The name of your data file
full_path <- paste(data_folder, data_file, sep = "/") #Putting the folder and file together, with a / in-between
my_data <- read.xlsx(full_path) #Open the spreadhseet from our full file path

my_data #Print to have a look at it

#calculate averages for each condition of my_data and store 
summary <- summarySEwithin(my_data, measurevar = "RT", withinvars = c("condition"), idvar = "subject_id")
summary #print summary to look at it

#Create basic bar graph
ggplot(data = summary, aes(x = condition, y = RT)) +
  geom_bar(stat = "identity")

#Add fill to each condition
ggplot(data = summary, aes(x = condition, y = RT, fill = condition)) +
  geom_bar(stat = "identity")

#Define fill and colour for all bars
ggplot(data = summary, aes(x = condition, y = RT)) +
  geom_bar(stat = "identity", fill = "white", color = "blue")

#Change x and y axis labels 
ggplot(data = summary, aes(x = condition, y = RT, fill = condition)) +
  geom_bar(stat = "identity")+
  scale_x_discrete(labels = c("Condition 1", "Condition 2", "Control"), name = "Condition") +
  scale_y_continuous(name = "Reaction Time (ms)") 
  
#Change legend labels
ggplot(data = summary, aes(x = condition, y = RT, fill = condition)) +
  geom_bar(stat = "identity")+
  scale_x_discrete(labels = c("Condition 1", "Condition 2", "Control"), name = "Condition") +
  scale_y_continuous(name = "Reaction Time (ms)") +
  scale_fill_discrete(labels = c("Condition 1", "Condition 2", "Control"), name = "Condition") 

#Remove legend
ggplot(data = summary, aes(x = condition, y = RT, fill = condition)) +
  geom_bar(stat = "identity")+
  scale_x_discrete(labels = c("Condition 1", "Condition 2", "Control"), name = "Condition") +
  scale_y_continuous(name = "Reaction Time (ms)") +
  theme(legend.position = "none")
  
#Add error bars
ggplot(data = summary, aes(x = condition, y = RT, fill = condition)) +
  geom_bar(stat = "identity")+
  scale_x_discrete(labels = c("Condition 1", "Condition 2", "Control"), name = "Condition") +
  scale_y_continuous(name = "Reaction Time (ms)") +
  scale_fill_discrete(labels = c("Condition 1", "Condition 2", "Control"), name = "Condition") +
  geom_errorbar(aes(ymin = RT - se, ymax = RT + se), width = .2, position=position_dodge(.9)) 

#Change the theme
barP <- ggplot(data = summary, aes(x = condition, y = RT, fill = condition)) +
  geom_bar(stat = "identity")+
  scale_x_discrete(labels = c("Condition 1", "Condition 2", "Control"), name = "Condition") +
  scale_y_continuous(name = "Reaction Time (ms)") +
  geom_errorbar(aes(ymin = RT - se, ymax = RT + se), width = .2, position=position_dodge(.9)) +
  theme_classic() +
  theme(legend.position = "none")
barP

#Load another set of data
setwd(data_folder)
load("dataRT")
dataRT

#Create basic scatterplot
ggplot(data = dataRT, aes(x = age, y = RT)) +
  geom_point()

#Add regression line
ggplot(data = dataRT, aes(x = age, y = RT)) +
  geom_point() +
  geom_smooth(method = lm)

#Change shape, colour by grouping variable
ggplot(data = dataRT, aes(x = age, y = RT, shape = group, colour = group)) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE)

#Final scatterplot
scatterP <- ggplot(data = dataRT, aes(x = age, y = RT, shape = group, colour = group)) +
  geom_point() +
  geom_smooth(method = lm, se = FALSE)+
  labs(x = "Age", y = "Reaction Time (ms)")+
  scale_color_hue(labels = c("Group 1", "Group 2"), name = "Group")+
  scale_shape_manual(labels = c("Group 1", "Group 2"), name = "Group", values = c("circle", "triangle"))+
  theme_classic()+
  theme(legend.position = c(.8, .25))
scatterP


#Simple box plot
ggplot(data = my_data, aes(x = condition, y = RT)) +
  geom_boxplot()

#Add data points
ggplot(data = my_data, aes(x = condition, y = RT)) +
  geom_boxplot()+
  geom_dotplot(binaxis = 'y', stackdir = 'center')


#Simple violin plot
ggplot(data = my_data, aes(x = condition, y = RT)) +
  geom_violin(trim = FALSE)

#Add box plot and data points
ggplot(data = my_data, aes(x = condition, y = RT)) +
  geom_violin(trim = FALSE)+
  geom_boxplot(width = 0.1)+
  geom_dotplot(binaxis = 'y', stackdir = 'center', dotsize = .5)

#Our final plot
violinP <- ggplot(data = my_data, aes(x = condition, y = RT, fill = condition)) +
  geom_violin(trim = FALSE)+
  geom_boxplot(width = 0.1, fill = "white")+
  geom_dotplot(binaxis = 'y', stackdir = 'center', dotsize = .5, fill = "black")+
  scale_fill_brewer(palette="Blues") + 
  scale_x_discrete(labels = c("Condition 1", "Condition 2", "Control"), name = "Condition") +
  scale_y_continuous(name = "Reaction Time (ms)") +
  theme_classic()+
  theme(legend.position = "none") #Make sure additional theme arguments are placed after theme_classic()
violinP

#Use patchwork to join plots together and use theme() to change font 
plots <- barP + scatterP / violinP +
  plot_annotation(tag_levels = "A") &
  theme(
    axis.title.y =element_text(family="Arial", size=12), 
    axis.title.x =element_text(family="Arial", size=12),
    axis.text.y = element_text(family="Arial", size=11),
    axis.text.x = element_text(family="Arial", size=11)
  )
plots

setwd(data_folder)
ggsave(plots, filename = "Plots.svg", width = 10, height = 8)
