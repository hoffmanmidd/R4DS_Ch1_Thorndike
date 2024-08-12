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

# 1.2.4 Adding aesthetics and layers ------------------------------------------
# Does the relationship between spelling and math differ by classroom? 
# We incorporate "class"  into our plot and see if this reveals any additional 
# insights into the apparent relationship between these variables. 
# We do this by representing classroom with different colored points.
# To achieve this, we  modify the aesthetic. 

ggplot(
  data = students,
  mapping = aes(x = spelling, y = math, color = class)) +
  geom_point()

# Now let’s add one more layer: a smooth curve displaying the relationship. 
# Since this is a new geometric object representing our data, 
# we will add a new geom as a layer on top of our point geom: geom_smooth(). 
# And we will specify that we want to draw the line of best fit 
# based on a linear model with method = "lm".

ggplot(
  data = students,
  mapping = aes(x = spelling, y = math, color = class)) +
  geom_point() +
  geom_smooth(method = "lm")

# While this is informative and is probably the best choice for us.
# However, if we are mimicking the book, we can allow the aesthetic
# mappings to identify the classroom for the points but to have the line of best fit
# represent the relationship for all students. We can do this by moving the color
# for geom_point only

ggplot(
  data = students,
  mapping = aes(x = spelling, y = math)) +
  geom_point(aes(color = class)) +
  geom_smooth(method = "lm")

# And should also identify the classroom with shapes of the points.
# We can do this by adding the shape aesthetic to geom_point().
ggplot(
  data = students,
  mapping = aes(x = spelling, y = math)) +
  geom_point(aes(color = class, shape = class)) +
  geom_smooth(method = "lm")

# And finally, we can improve the labels of our plot using the labs() function 
# in a new layer. 
# Some of the arguments to labs() might be self explanatory: 
# title adds a title and subtitle adds a subtitle to the plot. 
# Other arguments match the aesthetic mappings, x is the x-axis label, 
# y is the y-axis label, and color and shape define the label for the legend. 
# In addition, we can improve the color palette to be colorblind safe with the 
# scale_color_colorblind() function from the ggthemes package.

ggplot(
  data = students,
  mapping = aes(x = spelling, y = math)) +
  geom_point(aes(color = class, shape = class)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Relationship between spelling and math",
    subtitle = "By classroom",
    x = "Spelling score",
    y = "Math score",
    color = "Classroom",
    shape = "Classroom") +
  scale_color_colorblind()
