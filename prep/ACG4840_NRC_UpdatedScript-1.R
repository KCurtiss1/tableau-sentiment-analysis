# Install and load the syuzhet package
install.packages("syuzhet")
library(syuzhet)

# Specify the directory where your risk factor text files are stored
risk_factor_directory <- "/Users/shornikold/Documents/44xx (Data Analytics)/RStudio/RiskFactors/Accenture/"

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
                               Anger = numeric(0),
                               Anticipation = numeric(0),
                               Disgust = numeric(0),
                               Fear = numeric(0),
                               Joy = numeric(0),
                               Sadness = numeric(0),
                               Surprise = numeric(0),
                               Trust = numeric(0))

# Analyze sentiment for each risk factor file
for (file in risk_factor_files) {
  risk_factor_text <- readLines(file, warn = FALSE)  # Read the entire file
  sentiment_scores <- get_nrc_sentiment(risk_factor_text)
  
  # Extract the risk factor name from the file path (customize as needed)
  risk_factor_name <- tools::file_path_sans_ext(basename(file))
  
  # Append results to the data frame
  sentiment_counts <- rbind(sentiment_counts,
                            data.frame(Risk_Factor = risk_factor_name,
                                       Positive = sum(sentiment_scores$positive),
                                       Negative = sum(sentiment_scores$negative),
                                       Anger = sum(sentiment_scores$anger),
                                       Anticipation = sum(sentiment_scores$anticipation),
                                       Disgust = sum(sentiment_scores$disgust),
                                       Fear = sum(sentiment_scores$fear),
                                       Joy = sum(sentiment_scores$joy),
                                       Sadness = sum(sentiment_scores$sadness),
                                       Surprise = sum(sentiment_scores$surprise),
                                       Trust = sum(sentiment_scores$trust)))
}

# Print the results
print(sentiment_counts)

# Write counts to a file (customize the file path as needed)
write.table(sentiment_counts, file = "/Users/shornikold/Documents/44xx (Data Analytics)/RStudio/RiskFactors/Accenture/Output/accentureRiskFactorSentimentCounts.txt", row.names = FALSE)
