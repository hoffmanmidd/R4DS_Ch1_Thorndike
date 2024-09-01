# SCRIPT CORRESPONDING TO CHAPTER 3: Data transformation IN R4DS

# 3.1.1 Prerequisites --------------------------------------------------------- 

# In this chapter we’ll focus on the dplyr package, another core member of the 
# tidyverse. 
# We’ll illustrate the key ideas using data from the Thorndike book,
# and use ggplot2 to help us understand the data.
library(tidyverse)
library(googlesheets4)
gs4_deauth() # deauthorize Google Sheet so that anyone can access it
students <- read_sheet("https://docs.google.com/spreadsheets/d/1hPYA-1X5RBlPzlH-tsdnXjM7wN0wq7FF3BmyigUJOPc/edit?usp=sharing")

# 3.2 Rows
# 3.2.1 Filtering rows --------------------------------------------------------
students |> 
  filter(spelling > 60)

# This shows all the students who scored above 60 on the spelling test.
# In this case, we show the first 10 rows and note that there are 11 more rows

# female students in Johnson's classroom
students |> 
  filter(class == "Johnson" & gender == "female")

# This shows the 11 girls in Johnson's classroom

# boys in Johnson's classroom who scored above 60 on the spelling test
students |> 
  filter(class == "Johnson", gender == "male", spelling > 60)
# 8 boys in Johnson's classrrom who are scored higher than 60 on spelling

# 3.2.3 arrange ----------------------------------------------------------------
# arrange () changes the order of the rows based on the value of the columns
students |> 
  arrange(spelling)
# Here we see the students ordered by their spelling scores from worst to best
# (the first 10 scores with the other 42 available)

# descending order
# You can use desc() on a column inside of arrange() to re-order the data frame 
# based on that column in descending (big-to-small) order. 
students |> 
  arrange(desc(spelling))
# Salim Salik is the highest score in spelling, for example

# 3.2.4 distinct ----------------------------------------------------------------
students |> 
  distinct()
# There are no duplicates (because all the rows are unique)

students |> 
  distinct(class, gender)
# Not super useful, but this shows that there are two classrooms with two genders
#> A tibble: 4 × 2
#> class   gender
#> <chr>   <chr> 
#> 1 Johnson male  
#> 2 Johnson female
#> 3 Cordero female
#> 4 Cordero male  

# 3.3 columns -----------------------------------------------------
# There are four important verbs that affect the columns without changing the rows: 
#   mutate() creates new columns that are derived from the existing columns, 
#   select() changes which columns are present, 
#   rename() changes the names of the columns, and 
#   relocate() changes the positions of the columns.

# 3.3.1 mutate -----------------------------------------------------
students |> 
  mutate(spelling_pct = spelling / 80 * 100) 

# Here we create a new column called spelling_pct that is the spelling score
# as a percentage of the maximum score (80).

# We can use the .before argument to instead add the variables to the left hand side

students |> 
  mutate(spelling_pct = spelling / 80 * 100, .before = spelling)

# or we can put it before all of the other columns
students |> 
  mutate(spelling_pct = spelling / 80 * 100, .before = 1)

# Alternatively, you can control which variables are kept with the .keep argument.
# A particularly useful argument is "used" which specifies that we only keep the 
# columns that were involved or created in the mutate() step. 
students |> 
  mutate(spelling_pct = spelling / 80 * 100, .keep = "used")
# Though in this case we only get spelling and spelling_pct

# Maybe we want the kid's names, too:
students |> 
  mutate(spelling_pct = spelling / 80 * 100) |> 
  select(first, spelling_pct, spelling)

# 3.3.2 select -----------------------------------------------------
# Select columns by name:
students |> 
  select(first, class, spelling)

# Select all columns between first and class:
students |> 
  select(first:class)

# Select all columns except those from last to class:
students |> 
  select(-last:-class)
# This is what GitHub copilot suggested

students |> 
  select(!last:class)
# Same answer: first, reading, spelling, math

# Select all columns that are characters:
students |> 
  select(where(is.character))

# You can rename variables as you selct using =.
# The new name appears on the left hand side of the = and the old on the right
students |> 
  select(first_name = first)

# 3.3.4 relocate -----------------------------------------------------
# relocate() is used to move columns to a new position in the data frame
students |> 
  relocate(class, .after = first)
# Seems a little useless in our example, but OK

# 3.5 Groups
# dplyr gets even more powerful when you add in the ability to work with groups. 
# In this section, we’ll focus on the most important functions: 
#   group_by(), 
#   summarize(), 
#   and the slice family of functions.

# 3.5.1 group_by -----------------------------------------------------
# Use group_by to divide your data into meaningful groups for analysis
students |> 
  group_by(gender)
# This doesn't change the data but it shows:
# A tibble: 52 × 7
# Groups:   gender [2]

# 3.5.2 summarize -----------------------------------------------------
# summarize() is used to collapse each group into a single row
students |>
  group_by(class) |>
  summarize(
    avg_spelling = mean(spelling))
# Cordero's class has an average spelling score of 53.1
# Johnson's class has an average spelling score of 61.2

# one very useful summary is n(), which returns the number of rows in each group:
students |> 
  group_by(class) |> 
  summarize(n = n())
# And here we see that Cordero has 26 kids and Johnson has 26 kids

# 3.5.3 slice -----------------------------------------------------
# There are five handy functions that allow you extract specific rows within each group:

# df |> slice_head(n = 1) takes the first row from each group.
students |> 
  group_by(class) |> 
  slice_head(n = 1)

# df |> slice_tail(n = 1) takes the last row in each group.
students |> 
  group_by(class) |> 
  slice_tail(n = 1)

# df |> slice_min(x, n = 1) takes the row with the smallest value of column x.
students |> 
  group_by(class) |> 
  slice_min(spelling, n = 1)

# df |> slice_max(x, n = 1) takes the row with the largest value of column x.
students |> 
  group_by(class) |> 
  slice_max(spelling, n = 1)

# df |> slice_sample(n = 1) takes one random row.
students |> 
  group_by(class) |> 
  slice_sample(n = 1)
# Maybe for cold calling a student ???

# 3.5.4 Grouping by multiple variables ----------------------------------------
# You can create groups using more than one variable. 
# For example, we could make a group for each classroom.
students |>
  group_by(class, gender)  
# This doesn't change the data but it shows:
# A tibble: 52 × 7
# Groups:   class, gender [4]

classrooms <- students |> 
  group_by(class) |>
  summarize(n = n())

classrooms
#  A tibble: 2 × 2
#   class       n
#     <chr>   <int>
#  1 Cordero    26
#  2 Johnson    26

# 3.5.5 Ungrouping -------------------------------------------------------------
# You can remove the grouping with ungroup()
classrooms |> 
  ungroup()
