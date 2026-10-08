# Load required libraries
library(ggplot2)
library(readr)
library(scales)

Sys.setlocale("LC_TIME", "C")

# Translate display labels while retaining the original column names.
display_label <- function(column) {
  switch(column, datum = "Date", volumen = "volume", promjena = "change",
         apsolutna_promjena = "absolute change",
         volumen_skalirano = "scaled volume", column)
}

# ======= Settings =======
csv_file <- "data.csv"       # Replace with your file
value_column <- "volumen_skalirano"      # Replace with the column name you want to analyze

# ======= Read and Prepare Data =======
data <- read_csv(csv_file)

# Convert "Date" to Date class
data$datum <- as.Date(data$datum)

data$volumen_skalirano <- data$volumen / 1e9
# Remove NA values from selected column
data <- data[!is.na(data[[value_column]]), ]

print(data)

# ======= Plot: Time Series =======
p1 <- ggplot(data, aes(x = datum, y = .data[[value_column]])) +
  geom_line(color = "steelblue") +
  labs(title = "",
       x = "Date", y = display_label(value_column)) +
  theme_minimal()

# Save time series plot
ggsave(filename = paste0(value_column, "_timeseries.png"), plot = p1, width = 8, height = 5)

# ======= Plot: Histogram =======

mean<- -0.9113
sd <- 4675.9851 ^ 0.5

scalar <- (max(data[[value_column]]) - min(data[[value_column]])) / 30 * 143

scaled_norm <- function(x, mean, sd) {
	dnorm(x, mean, sd) * scalar
}

p2 <- ggplot(data, aes(x = .data[[value_column]])) +
  geom_histogram(fill = "darkorange", color = "white", bins = 30) +
   stat_function(fun = scaled_norm , args = list(mean = mean, sd = sd), color = "blue", size = 1) +
  labs(title = "",
       x = display_label(value_column), y = "frequency") +
  theme_minimal()

# Save histogram
ggsave(filename = paste0(value_column, "_histogram2.png"), plot = p2, width = 8, height = 5)



# ======= Plot: Log Histogram =======
p3 <- ggplot(data, aes(x = log(data[[value_column]]))) +
  geom_histogram(fill = "seagreen", color = "white", bins = 30) +
  labs(title = "",
       x = paste("log(", display_label(value_column), ")"), y = "frequency") +
  theme_minimal()


# Save log histogram
ggsave(filename = paste0(value_column, "_loghistogram2.png"), plot = p3, width = 8, height = 5)

# ======= Plot: Box Plot =======
p4 <- ggplot(data, aes(y = .data[[value_column]])) +
  geom_boxplot(fill = "plum", color = "black") +
  labs(title = "",
       x = "", y = display_label(value_column)) +
  theme_minimal()

# ======= Plot: Filtered Histogram =======

lower_bound <- quantile(data[[value_column]], 0.05, na.rm = TRUE)
upper_bound <- quantile(data[[value_column]], 0.95, na.rm = TRUE)

fdata <- data[data[[value_column]] >= lower_bound & data[[value_column]] <= upper_bound, ]

p5 <- ggplot(fdata, aes(x = .data[[value_column]])) +
  geom_histogram(fill = "red", color = "white", bins = 30) +
  labs(title = "",
       x = display_label(value_column), y = "frequency") +
  theme_minimal()
  
ggsave(filename=paste0(value_column, "_filtrirani_histogram.png"), plot = p5, width = 8, height = 5)


# Save box plot
ggsave(filename = paste0(value_column, "_boxplot.png"), plot = p4, width = 5, height = 6)

# ======= Describe Distribution =======
summary_stats <- summary(data[[value_column]])
five_num <- fivenum(data[[value_column]])

# Print to console
cat("\nDescriptive Summary of", display_label(value_column), ":\n")
print(summary_stats)

cat("\nFive Number Summary:\n")
names(five_num) <- c("Minimum", "Q1", "Median", "Q3", "Maximum")
print(five_num)

# Save to a text file
summary_file <- paste0(value_column, "_summary.txt")
sink(summary_file)
cat("Descriptive Summary of", display_label(value_column), ":\n")
print(summary_stats)

cat("\nFive Number Summary:\n")
print(five_num)
sink()
