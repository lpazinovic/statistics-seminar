
df <- read.csv("close_volume.csv", skip = 2, header = FALSE)
colnames(df) <- c("Date", "Close", "Volume")

summary(df$Volume)[c("Min.", "1st Qu.", "Median", "3rd Qu.", "Max.")]
summary(df$Close)[c("Min.", "1st Qu.", "Median", "3rd Qu.", "Max.")]

library(patchwork) 
library(ggplot2)

p1 <- ggplot(df, aes(y = Close)) +
  geom_boxplot(fill = "lightblue", color = "darkblue") +
  labs(title = "Boxplot - Close", y = "Close")

p2 <- ggplot(df, aes(y = Volume)) +
  geom_boxplot(fill = "lightgreen", color = "darkgreen") +
  labs(title = "Boxplot - Volume", y = "Volume") 

df$LogVolume <- log10(df$Volume)

p2_log <- ggplot(df, aes(y = LogVolume)) +
  geom_boxplot(fill = "lightgreen", color = "darkgreen") +
  labs(title = "Boxplot - Log10(Volume)", y = "Log10 Volume")
 
p1
p2
p2_log

library(ggplot2)
library(scales)

df$Date <- as.Date(df$Date)

line_close <- ggplot(df, aes(x = Date, y = Close)) +
  geom_line(color = "steelblue") +
  scale_x_date(
    date_breaks = "15 days",
    date_labels = "%d.%m."
  ) +
  labs(title = "Close",
       x = "Date", y = "Close") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

line_volume <- ggplot(df, aes(x = Date, y = Volume)) +
  geom_line(color = "darkgreen") +
  scale_x_date(
    date_breaks = "15 days",
    date_labels = "%d.%m."
  ) +
  scale_y_continuous(labels = comma) +
  labs(title = "Volume",
       x = "Date", y = "Volume") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

line_close
line_volume



