# Load necessary libraries
library(stringr)

# Define the file path
file_path <- "/Users/christian/Desktop/UCF/Fall 2025/ACG4840 Analytics/Assignments/11 Sentiment/Main.txt"

# Read the file content
file_content <- readLines(file_path, warn = FALSE)

# Convert the content to a single string with newline characters
content <- paste(file_content, collapse = "\n")

# Extract risk factors based on the title ending with "Risks"
risk_factors <- str_match_all(content, "(?s)([A-Za-z ]+ Risks)\n(.*?)(?=(\n[A-Za-z ]+ Risks\n|$))")[[1]]

# Check if any risk factors were found
if (nrow(risk_factors) == 0) {
  cat("No risk factors found.\n")
} else {
  # Save each risk factor in a separate text file
  for (i in seq_len(nrow(risk_factors))) {
    # Clean the risk title for file naming
    risk_title <- str_trim(risk_factors[i, 1])
    risk_title <- gsub("[^A-Za-z0-9 ]", "", risk_title)
    risk_title <- gsub("\\s+", "_", risk_title)
    
    # Limit the length of the filename to avoid issues with very long names
    risk_title <- substr(risk_title, 1, 50)
    
    # Define the file path
    risk_file_path <- paste0("/Users/christian/Desktop/UCF/Fall 2025/ACG4840 Analytics/Assignments/11 Sentiment/", risk_title, ".txt")
    
    # Combine the title and the corresponding risk factor text
    risk_text <- paste(risk_factors[i, 1], risk_factors[i, 2], sep = "\n")
    
    # Write to a text file
    tryCatch({
      writeLines(risk_text, risk_file_path)
    }, error = function(e) {
      cat("Error writing file:", risk_file_path, "\n", conditionMessage(e), "\n")
    })
  }
  cat("Risk factors have been extracted and saved to separate text files.\n")
}
