library(tidyverse)

# Define the function calculate.grades
calculate.grades <- function(group, individual) {
  group_total <- sum(individual)
  
  # Calculate the adjustment factor
  adjustment_factor <- individual / group_total
  
  # Calculate the adjustment score
  adjustment_score <- 5 * adjustment_factor * group
  
  # Calculate the final score
  final_score <- 0.5 * group + 0.5 * adjustment_score
  
  # Special calculation of students with score lower than 2
  bad_student <- individual < 2
  final_score[bad_student] <- group * (individual[bad_student] - 1) * 0.1
  
  # Change all scores over 100 to 100
  final_score[final_score >= 100] <- 100
  
  final_score <- sapply(final_score, function(num) round(num, 1))
  
  return(final_score)
}


## Small examples to check validaty
# Scenario 1: Group Score: 70%; Individual teammate appraisal scores: 3, 3, 3, 3, 3.
calculate.grades(group = 70, individual = c(3, 3, 3, 3, 3))
# Scenario 2: Group Score: 70%; Individual teammate appraisal scores: 5, 5, 5, 5, 5.
calculate.grades(group = 70, individual = c(5, 5, 5, 5, 5))
# Scenario 3: Group Score: 80%; Individual teammate appraisal scores: 3, 3, 3, 3, 3.
calculate.grades(group = 80, individual = c(3, 3, 3, 3, 3))
#Scenario 4: Group Score: 70%; Individual teammate appraisal scores: 1, 2, 3, 4, 5.
calculate.grades(group = 70, individual = c(1, 2, 3, 4, 5))
# Scenario 5: Group Score: 90%; Individual teammate appraisal scores: 1, 4, 4, 5.
calculate.grades(group = 90, individual = c(1, 4, 4, 5))


## Demonstration of the calculate.grades function with given assignment example
# Read in the data
load("example-grading.data.RData")

# Join student data and group data
student_data <- left_join(group.df, student.df, by = "group.name") %>%
  select(group.name, group.score, individual.score)

# Calculate final scores using mapply
algorithm_data <- student_data %>%
  group_by(group.name) %>%
  mutate(final_score = calculate.grades(first(group.score), individual.score)) %>%
  ungroup()

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

