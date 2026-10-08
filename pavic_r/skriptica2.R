# ======= Load Libraries =======
library(readr)
library(dplyr)
library(ggcorrplot)

# ======= Settings =======
csv_file <- "data.csv"  # <-- Change this to your file path

# ======= Read and Prepare Data =======
data <- read_csv(csv_file)

# Convert 'datum' column to Date
data$datum <- as.Date(data$datum)

# Remove 'datum' from analysis and keep only numeric columns
numeric_data <- data %>%
  select(-datum) %>%
  select(-apsolutna_promjena) %>%
  select(where(is.numeric))

# ======= Compute Pearson Correlation =======
cor_matrix <- cor(numeric_data, use = "pairwise.complete.obs", method = "pearson")

# ======= Output as Colored Table =======
# Plot with ggcorrplot
p <- ggcorrplot(
  cor_matrix,
  method = "square",
  type = "full",
  lab = TRUE,
  lab_size = 5,
  colors = c("red", "white", "blue"),
  title = "",
  ggtheme = theme_minimal()
) +
  ggplot2::scale_x_discrete(labels = c(volumen = "volume", promjena = "change",
                                     hml = "hml", Trump = "Trump", Stocks = "Stocks")) +
  ggplot2::scale_y_discrete(labels = c(volumen = "volume", promjena = "change",
                                     hml = "hml", Trump = "Trump", Stocks = "Stocks"))

# Save the plot
ggsave("correlation_matrix.png", plot = p, width = 8, height = 6)

# Also print to screen
print(p)
