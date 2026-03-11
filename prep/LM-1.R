# Install and load necessary packages
install.packages("tidyverse")
install.packages("tidytext")
install.packages("textdata")
library(tidyverse)
library(tidytext)
library(textdata)

# Specify the directory where your risk factor text files are stored
risk_factor_directory <- "/Users/shornikold/Documents/44xx (Data Analytics)/RStudio/RiskFactors/"

# Get a list of all text files in the directory
setwd(risk_factor_directory)
risk_factor_files <- list.files(risk_factor_directory, pattern = "\\.txt$", full.names = TRUE)

# Check if any files were found
if (length(risk_factor_files) == 0) {
  cat("No text files found in the specified directory.\n")
} else {
  cat("Found the following text files:\n")
  print(risk_factor_files)
}

# Initialize an empty data frame to store results
sentiment_counts <- data.frame(Risk_Factor = character(0),
                               Positive = numeric(0),
                               Negative = numeric(0),
                               Uncertainty = numeric(0),
                               Litigious = numeric(0),
                               Constraining = numeric(0),
                               Superfluous = numeric(0))

# Load the Loughran and McDonald sentiment lexicon
loughran_mcdonald <- get_sentiments("loughran")

# Analyze sentiment for each risk factor file
for (file in risk_factor_files) {
  risk_factor_text <- readLines(file, warn = FALSE)  # Read the entire file
  
  # Debug: Print a snippet of the text to ensure it's read correctly
  cat("Processing file:", file, "\n")
  cat("Sample text:", paste(head(risk_factor_text, 10), collapse = " "), "\n")
  
  risk_factor_df <- tibble(text = risk_factor_text) %>%
    unnest_tokens(word, text)
  
  # Debug: Print the first few tokenized words to ensure correct tokenization
  cat("Tokenized words:", paste(head(risk_factor_df$word, 10), collapse = ", "), "\n")
  
  sentiment_scores <- risk_factor_df %>%
    inner_join(loughran_mcdonald, by = "word", relationship = "many-to-many") %>%
    count(sentiment)
  
  # Debug: Print the sentiment scores to ensure correct joining and counting
  cat("Sentiment scores:\n")
  print(sentiment_scores)
  
  # Extract the risk factor name from the file path (customize as needed)
  risk_factor_name <- tools::file_path_sans_ext(basename(file))
  
  # Initialize a named vector to store sentiment counts
  sentiments <- c(Positive = 0, Negative = 0, Uncertainty = 0, Litigious = 0, Constraining = 0, Superfluous = 0)
  
  # Update the sentiment counts
  for (i in 1:nrow(sentiment_scores)) {
    sentiment <- sentiment_scores$sentiment[i]
    count <- sentiment_scores$n[i]
    sentiments[sentiment] <- count
  }
  
  # Append results to the data frame
  sentiment_counts <- rbind(sentiment_counts,
                            data.frame(Risk_Factor = risk_factor_name,
                                       Positive = sentiments["positive"],
                                       Negative = sentiments["negative"],
                                       Uncertainty = sentiments["uncertainty"],
                                       Litigious = sentiments["litigious"],
                                       Constraining = sentiments["constraining"],
                                       Superfluous = ifelse(is.na(sentiments["superfluous"]), 0, sentiments["superfluous"])))
}

# Print the results
print(sentiment_counts)

# Write counts to a file (customize the file path as needed)
write.table(sentiment_counts, file = "/Users/shornikold/Documents/44xx (Data Analytics)/RStudio/RiskFactors/Output/appleRiskFactorLM.txt", row.names = FALSE, sep = "\t")
