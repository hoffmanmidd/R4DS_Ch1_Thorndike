# SCRIPT CORRESPONDING TO CHAPTER 1: Data visualization IN R4DS

# 1.1.1 Prerequisites --------------------------------------------------------- 

# This chapter focuses on ggplot2, one of the core packages in the tidyverse. 
# To access the datasets, help pages, and functions used in this chapter, load the tidyverse by running:
library(tidyverse)

# We will load the ggthemes package, which offers a colorblind safe color palette
library(ggthemes)

# And we will grab our play dataset from Google Sheets
# So, load the package called googlesheets4
library(googlesheets4)

# And follow the instructions to download data from Google Sheets
# R4DS (2e) Chapter 20.3 Google Sheets

gs4_deauth() # deauthorize Google Sheet so that anyone can access it
students <- read_sheet("https://docs.google.com/spreadsheets/d/1hPYA-1X5RBlPzlH-tsdnXjM7wN0wq7FF3BmyigUJOPc/edit?usp=sharing")

# 1.2.1 The "students" dataframe ----------------------------------------------

# Type the name of the data frame in the console (in this case, "students")
# and R will print a preview of its contents
students

# This data frame contains 7 columns. 
# For an alternative view, where you can see all variables and the first few 
# observations of each variable, use glimpse():
glimpse(students)

# 1.2.3. Creating a ggplot ----------------------------------------------------
# The blank canvas of a ggplot is created with the ggplot() function.
ggplot(data = students)

# Let's put "spelling" on the x axis
ggplot(
  data = students,
  mapping = aes(x = spelling)) # aes() stands for aesthetic

# Let's put "math" on the y axis
ggplot(
  data = students,
  mapping = aes(x = spelling, y = math))

# Create a scatterplot 
# Use the function geom_point() adds a layer of points to your plot
ggplot(
  data = students,
  mapping = aes(x = spelling, y = math)) +
  geom_point()
