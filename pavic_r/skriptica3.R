# ======= Load Required Libraries =======
library(readr)
library(ggplot2)

# Translate display labels while retaining the original column names.
display_label <- function(column) {
  switch(column, datum = "Date", volumen = "volume", promjena = "change",
         apsolutna_promjena = "absolute change",
         volumen_skalirano = "scaled volume", column)
}

# ======= Settings =======
csv_file <- "data.csv"        # Path to your CSV file
column_x <- "Trump"            # Replace with your x-axis column name
column_y <- "hml"            # Replace with your y-axis column name

# ======= Read and Prepare Data =======
data <- read_csv(csv_file)

# Convert datum column if needed
if ("datum" %in% names(data)) {
  data$datum <- as.Date(data$datum)
}

# Check if specified columns exist
if (!(column_x %in% names(data)) || !(column_y %in% names(data))) {
  stop("One or both specified columns do not exist in the dataset.")
}

# ======= Plot: Scatterplot =======
p <- ggplot(data, aes(x = .data[[column_x]], y = .data[[column_y]])) +
  geom_point(color = "green", size = 2, alpha = 0.7) +
  labs(title = "",
       x = display_label(column_x),
       y = display_label(column_y)) +
  theme_minimal()

# Save plot
output_file <- paste0("scatterplot_", column_x, "_vs_", column_y, ".png")
ggsave(output_file, plot = p, width = 8, height = 5)

# Show plot in viewer
print(p)
