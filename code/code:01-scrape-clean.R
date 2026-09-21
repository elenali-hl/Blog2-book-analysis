# ============================================================
# Blog Post 2
# Web Scraping and Data Cleaning
# ============================================================


# Load packages --------------------------------------------------------

library(rvest)
library(dplyr)
library(readr)


# Read the main webpage -----------------------------------------------

base_url <- "https://books.toscrape.com/"

page <- read_html(base_url)


# Extract book categories ---------------------------------------------

# Get category names
category_names <- page %>%
  html_elements(".side_categories ul li ul li a") %>%
  html_text2()

# Get category links
category_links <- page %>%
  html_elements(".side_categories ul li ul li a") %>%
  html_attr("href")

# Combine category names and links
categories <- data.frame(
  category = category_names,
  link = category_links
)


# Create a function to scrape each category ---------------------------

scrape_category <- function(category_name, category_link) {
  
  # Create the URL for the first page of the category
  current_url <- paste0(
    base_url,
    category_link
  )
  
  # Empty data frame for storing books
  all_books <- data.frame()
  
  repeat {
    
    # Read the current category page
    category_page <- read_html(current_url)
    
    # Find all books on the page
    books <- category_page %>%
      html_elements(".product_pod")
    
    # Extract book information
    page_data <- data.frame(
      
      title = books %>%
        html_element("h3 a") %>%
        html_attr("title"),
      
      price = books %>%
        html_element(".price_color") %>%
        html_text2(),
      
      rating = books %>%
        html_element(".star-rating") %>%
        html_attr("class"),
      
      category = category_name
    )
    
    # Add the current page to the results
    all_books <- bind_rows(
      all_books,
      page_data
    )
    
    # Find the link to the next page
    next_link <- category_page %>%
      html_element("li.next a") %>%
      html_attr("href")
    
    # Stop if there is no next page
    if (is.na(next_link)) {
      break
    }
    
    # Create the absolute URL for the next page
    current_url <- url_absolute(
      next_link,
      current_url
    )
    
    # Pause between requests
    Sys.sleep(0.5)
  }
  
  return(all_books)
}


# Scrape all categories -----------------------------------------------

books_all <- data.frame()

for (i in 1:nrow(categories)) {
  
  # Scrape one category
  category_data <- scrape_category(
    categories$category[i],
    categories$link[i]
  )
  
  # Add the category data to the complete dataset
  books_all <- bind_rows(
    books_all,
    category_data
  )
  
  # Display progress
  print(
    paste(
      "Finished:",
      categories$category[i]
    )
  )
  
  # Pause between categories
  Sys.sleep(0.5)
}


# Check the raw data ---------------------------------------------------

nrow(books_all)

head(books_all)

table(books_all$category)

sum(duplicated(books_all$title))


# Save the raw data ----------------------------------------------------

write_csv(
  books_all,
  "data/books_raw.csv"
)


# Clean the data -------------------------------------------------------

books_clean <- books_all %>%
  mutate(
    
    # Convert price from text to numeric
    price = parse_number(price),
    
    # Convert star ratings to numeric values
    rating = case_when(
      rating == "star-rating One" ~ 1,
      rating == "star-rating Two" ~ 2,
      rating == "star-rating Three" ~ 3,
      rating == "star-rating Four" ~ 4,
      rating == "star-rating Five" ~ 5,
      TRUE ~ NA_real_
    )
  )


# Check the cleaned data ----------------------------------------------

head(books_clean)

str(books_clean)

colSums(is.na(books_clean))

summary(books_clean)


# Save the cleaned data ----------------------------------------------

write_csv(
  books_clean,
  "data/books_clean.csv"
)
