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

# 1.4 Visualizing distributions -----------------------------------------------

# 1.4.1 A categorical variable
# Let's visualize the distribution of the variable "class" using a bar plot.
# We will use the geom_bar() function to create a bar plot.
ggplot(
  data = students,
  mapping = aes(x = class)) +
  geom_bar()

# Clearly this is boring. Let's add some color to the bars.
# And let's also disaggregate by gender like they did in 1.5.2.
ggplot(
  data = students,
  mapping = aes(x = class, fill = gender)) +
  geom_bar()

# 1.4.2 A numercical variable ------------------------------------------------
# Let's visualize the distribution of the variable "math" using a histogram.
# We will use the geom_histogram() function to create a histogram.
ggplot(
  data = students,
  mapping = aes(x = math)) +
  geom_histogram()
           
# A histogram divides the x-axis into equally spaced bins and then uses the 
# height of a bar to display the number of observations that fall in each bin.
# The number of bins can be adjusted with the bins argument in geom_histogram().
# The default number of bins is 30.
# Let's change the number of bins to 10.
ggplot(
  data = students,
  mapping = aes(x = math)) +
  geom_histogram(bins = 10)

# An alternative visualization for distributions of numerical variables is a density plot. 
# A density plot is a smoothed-out version of a histogram and a practical alternative. 
# We can create a density plot with the geom_density() function.
ggplot(
  data = students,
  mapping = aes(x = math)) +
  geom_density()

# Similar to the ways that the New York Times displays COVID infections over time, 
# we can look at a single data variable — like spelling test scores — 
# to display the counts for each score (from 38 to 76) 
# AND smoothed conditional means (known as a kernel smooth).
ggplot(
  data = students,
  aes(x = spelling, y = after_stat(count))) +
  geom_histogram(binwidth = 1, color = "black", fill = "grey") +
  geom_density(lwd = .5, color = "black", adjust = .7, fill = "grey", alpha = .5) +
  labs(title = "Spelling Scores for Two Classes") + 
  labs(subtitle = "and overlayed density plot") +  
  theme_classic() 


# 1.5.1 A numerical and a categorical variable --------------------------------
# Let's visualize the distribution of the variable "math" by "class" using a box plot.
# We will use the geom_boxplot() function to create a box plot.
ggplot(
  data = students,
  mapping = aes(x = class, y = math)) +
  geom_boxplot()

# To visualize the relationship between a numerical and a categorical variable 
# we can use side-by-side box plots. 
# A boxplot is a type of visual shorthand for measures of position (percentiles) 
# that describe a distribution. 
# It is also useful for identifying potential outliers.

# A box that indicates the range of the middle half of the data, 
# a distance known as the interquartile range (IQR), 
# stretching from the 25th percentile of the distribution to the 75th percentile. 
# In the middle of the box is a line that displays the median, 
# i.e. 50th percentile, of the distribution. 

# Alternatively, we can make density plots with geom_density()
ggplot(
  data = students,
  mapping = aes(x = math, fill = class)) +
  geom_density(alpha = 0.5)

# 1.5.2 Two categorical variables ---------------------------------------------
# Let's visualize the distribution of the variable "class" and gender again
# using a bar plot. We will use the geom_bar() function to create a bar plot.
ggplot(
  data = students,
  mapping = aes(x = class, fill = gender)) +
  geom_bar()

# 1.5.4 Three or more variables ------------------------------------------------
# Another way to approach three variables is to split your plot into facets.
# Each subplot will display the relationship between two variables,
# and the third variable will be represented by the facets.
# Let's visualize the relationship between "spelling" and "math" by "class"
# using a scatter plot with facets. 
# We will use the facet_wrap() function to create facets.
ggplot(
  data = students,
  mapping = aes(x = spelling, y = math)) +
  geom_point(aes(color = class, shape = class)) +
  facet_wrap(~class)
