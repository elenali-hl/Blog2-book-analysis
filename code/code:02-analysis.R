# ============================================================
# Blog Post 2
# Data Analysis
# ============================================================


# Load packages --------------------------------------------------------

library(dplyr)
library(readr)
library(ggplot2)
install.packages("ggplot2")
library(ggplot2)
library(ggrepel)

# Load cleaned data ----------------------------------------------------

books_clean <- read_csv(
  "data/books_clean.csv"
)


# Check the data -------------------------------------------------------

head(books_clean)

str(books_clean)

summary(books_clean)

# Summarize books by category -----------------------------------------

category_summary <- books_clean %>%
  group_by(category) %>%
  summarise(
    number_of_books = n(),
    average_price = mean(price, na.rm = TRUE),
    median_price = median(price, na.rm = TRUE),
    average_rating = mean(rating, na.rm = TRUE),
    .groups = "drop"
  )

category_summary

# Examine category sample sizes ---------------------------------------

category_summary %>%
  arrange(desc(number_of_books)) %>%
  select(
    category,
    number_of_books
  )

summary(category_summary$number_of_books)

# Check categories with at least 10 books -----------------------------

category_summary %>%
  filter(number_of_books >= 10) %>%
  arrange(desc(number_of_books))
category_summary %>%
  filter(number_of_books >= 10) %>%
  nrow()

# Calculate overall benchmarks ----------------------------------------

overall_avg_price <- mean(
  books_clean$price,
  na.rm = TRUE
)

overall_avg_rating <- mean(
  books_clean$rating,
  na.rm = TRUE
)

overall_avg_price
overall_avg_rating

# Keep categories with sufficient observations -----------------------

reliable_categories <- category_summary %>%
  filter(number_of_books >= 10)

nrow(reliable_categories)

# Identify good-value categories --------------------------------------

good_value_categories <- reliable_categories %>%
  filter(
    average_price < overall_avg_price,
    average_rating > overall_avg_rating
  ) %>%
  arrange(desc(average_rating))

good_value_categories

# Visualize price and rating by category -----------------------------

value_plot <- ggplot(
  reliable_categories,
  aes(
    x = average_price,
    y = average_rating
  )
) +
  geom_point(
    aes(size = number_of_books),
    alpha = 0.6
  ) +
  geom_vline(
    xintercept = overall_avg_price,
    linetype = "dashed"
  ) +
  geom_hline(
    yintercept = overall_avg_rating,
    linetype = "dashed"
  ) +
  geom_point(
    data = good_value_categories,
    aes(
      x = average_price,
      y = average_rating,
      size = number_of_books
    )
  ) +
  geom_text_repel(
    data = good_value_categories,
    aes(
      x = average_price,
      y = average_rating,
      label = category
    ),
    show.legend = FALSE
  ) +
  labs(
    title = "Average Price and Rating by Book Category",
    subtitle = "Categories with at least 10 books",
    x = "Average Price (£)",
    y = "Average Rating",
    size = "Number of Books",
    caption = "Dashed lines represent overall average price and rating."
  ) +
  theme_minimal()

value_plot