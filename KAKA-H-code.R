library(tidyverse)

# function of our algorithm
calculate.grades <- function(group, individual, group_total) {
  # Calculate the adjustment factor
  adjustment_factor <- individual / group_total
  
  # Calculate the adjustment score
  adjustment_score <- 5 * adjustment_factor * group
  
  # Calculate the final score
  final_score <- 0.5 * group + 0.5 * adjustment_score
  
  # Special calculation of students with score lower than 2
  bad_student <- individual < 2
  final_score[bad_student] <- group * (individual - 1) * 0.1
  
  # Change all score with over 100 to 100
  final_score[final_score >= 100] <- 100
  
  return(final_score)
}

load("example-grading.data.RData")

# Read in student data, create group total appraisal score variable and number of people in group variable
student.df <- student.df %>%
  group_by(group.name) %>%
  summarise(group_total = sum(individual.score), group_size = n()) %>%
  ungroup() %>%
  inner_join(student.df)

# Read in group data, create group number variable, and group ranking variable
group.df <- group.df %>%
  mutate(group = row_number()) %>%
  arrange(desc(group.score)) %>%
  mutate(ranking = row_number())

# Join student data and group data
student_data <- left_join(group.df, student.df, by = "group.name") %>%
  arrange(group) %>%
  select(group.name, group.score, individual.score, group_total, ranking, group_size)

# Calculate final scores using mapply
algorithm_data <- student_data %>%
  mutate(final_score = mapply(calculate.grades, group = group.score, individual = individual.score, group_total = group_total))

# Density plot of score distribution
ggplot() +
  geom_density(data = algorithm_data, aes(x = final_score), fill = "blue", alpha = 0.5) +
  labs(title = "Density Plot of Final Scores",
       x = "Final Score",
       y = "Density") +
  theme_minimal()

# Point plot of score distribution
ggplot() +
  geom_point(data = algorithm_data, aes(x = individual.score, y = final_score), color = "blue", alpha = 0.5) +
  labs(title = "Scatter Plot of Individual Scores vs. Final Scores",
       x = "Individual Score",
       y = "Final Score") +
  theme_minimal()

# Boxplot of score dirstribution
ggplot() +
  geom_boxplot(data = algorithm_data, aes(x = "", y = final_score), fill = "blue", alpha = 0.5) +
  labs(title = "Boxplot of Final Scores",
       x = "",
       y = "Final Score") +
  theme_minimal() +
  theme(axis.text.x = element_blank())

# Categorize final scores into grades
algorithm_data <- algorithm_data %>%
  mutate(grade = case_when(
    final_score >= 80 ~ "A (80-100)",
    final_score >= 65 & final_score < 80 ~ "B (65-79.9)",
    final_score >= 50 & final_score < 65 ~ "C (50-54.9)",
    final_score < 50 ~ "D (0-49.9)"
  ))

# Calculate the distribution of grades
grade_distribution <- algorithm_data %>%
  count(grade) %>%
  mutate(percentage = n / sum(n) * 100)

# Create the pie chart
ggplot(grade_distribution, aes(x = "", y = percentage, fill = grade)) +
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = c("A (80-100)" = "blue", "B (65-79.9)" = "green", "C (50-54.9)" = "orange", "D (0-49.9)" = "red")) +
  labs(title = "Distribution of Grades of Sophia's algorithm",
       x = "",
       y = "Percentage",
       fill = "Grade") +
  theme_minimal() +
  theme(axis.text.x = element_blank(), axis.ticks = element_blank())
