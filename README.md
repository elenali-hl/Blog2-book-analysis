# Blog Post 2: Finding the Best-Value Book Categories

## Overview

This project uses web scraping and data analysis to explore book prices and ratings across different categories. The goal is to identify book categories that may offer better value for budget-conscious readers.

The analysis addresses the following research question:

**Which book categories offer relatively highly rated books at lower prices?**

## Data Source

The data were collected from [Books to Scrape](https://books.toscrape.com/), a website designed for practicing web scraping.

Using the `rvest` package in R, I collected information on:

- Book title
- Category
- Price
- Star rating

The scraping process also handles pagination across category pages and includes pauses between requests to limit request frequency.

## Analysis

The raw scraped data were cleaned by converting book prices to numeric values and star ratings to a 1–5 numeric scale.

Books were then summarized by category using:

- Number of books
- Average price
- Median price
- Average rating

Because some categories contain very few books, the main comparison focuses on categories with at least 10 books. This cutoff is approximately the median category size in the dataset and reduces the influence of categories with very small sample sizes.

A category is classified as meeting the **good-value criteria** if:

1. Its average price is below the overall average book price.
2. Its average rating is above the overall average book rating.

## Results

Five categories meet the good-value criteria:

- Humor
- Historical Fiction
- Sequential Art
- Mystery
- Science

Among these categories, Humor has the highest average rating, while Mystery has the lowest average price.

The scatter plot in `results-figures/` visualizes the relationship between average price and average rating across categories. The dashed lines represent the overall average price and rating.

## Repository Structure

```text
Blog2/
├── code/
│   ├── 01-scrape-clean.R
│   └── 02-analysis.R
│
├── data/
│   ├── books_raw.csv
│   └── books_clean.csv
│
├── results-figures/
│   └── value_categories.png
│
├── results-tables/
│   └── good_value_categories.csv
│
└── README.md