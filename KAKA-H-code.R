library(tidyverse)

load("example-grading.data.RData")

student.df <- student.df %>%
  group_by(group.name) %>%
  summarise(group_total = sum(individual.score)) %>%
  ungroup() %>%
  inner_join(student.df)

group.df <- group.df %>%
  mutate(group = row_number()) %>%
  arrange(desc(group.score)) %>%
  mutate(ranking = row_number())

student_data <- left_join(group.df, student.df, by = "group.name") %>%
  arrange(group) %>%
  select(group.name, group.score, individual.score, group_total, ranking)

sophia_algorithm_data <- student_data %>%
  mutate(adjustment_factor = individual.score / group_total,
         adjustment_score = 5 * adjustment_factor * group.score,
         final_score = 0.5 * group.score + 0.5 * adjustment_score)

bad_student <- sophia_algorithm_data$individual.score <= 2
sophia_algorithm_data$final_score[bad_student] <- sophia_algorithm_data$group.score[bad_student] * (sophia_algorithm_data$individual.score[bad_student] - 1) * 0.1
sophia_algorithm_data$final_score[sophia_algorithm_data$final_score >= 100] <- 100


yu_algorithm_data <- student_data %>%
  mutate(final_score = case_when(
    individual.score >= 1 & individual.score < 2 ~ (0.05 + (0.65 * (individual.score - 1))) * group.score,
    individual.score >= 2 & individual.score < 3 ~ (0.7 + (0.3 * (individual.score - 2))) * group.score,
    individual.score >= 3 ~ group.score + (individual.score - 3) * 6,
  ))

bad_student <- yu_algorithm_data$individual.score <= 2
yu_algorithm_data$final_score[bad_student] <- yu_algorithm_data$group.score[bad_student] * (yu_algorithm_data$individual.score[bad_student] - 1) * 0.1
yu_algorithm_data$final_score[yu_algorithm_data$final_score >= 100] <- 100


ggplot() +
  geom_density(data = sophia_algorithm_data, aes(x = final_score), fill = "blue", alpha = 0.5) +
  geom_density(data = yu_algorithm_data, aes(x = final_score), fill = "red", alpha = 0.5) +
  labs(title = "Density Plot of Final Scores",
       x = "Final Score",
       y = "Density") +
  theme_minimal()

ggplot() +
  geom_point(data = sophia_algorithm_data, aes(x = individual.score, y = final_score), color = "blue", alpha = 0.5) +
  geom_point(data = yu_algorithm_data, aes(x = individual.score, y = final_score), color = "red", alpha = 0.5) +
  labs(title = "Scatter Plot of Individual Scores vs. Final Scores",
       x = "Individual Score",
       y = "Final Score") +
  theme_minimal()

ggplot() +
  geom_boxplot(data = sophia_algorithm_data, aes(x = "", y = final_score), fill = "blue", alpha = 0.5) +
  geom_boxplot(data = yu_algorithm_data, aes(x = "", y = final_score), fill = "red", alpha = 0.5) +
  labs(title = "Boxplot of Final Scores",
       x = "",
       y = "Final Score") +
  theme_minimal() +
  theme(axis.text.x = element_blank())
