trump <- read.csv("trump_usa.csv", skip = 5)
stocks <- read.csv("stocks_usa.csv", skip = 5)

colnames(trump) <- c("Date", "Searches")
colnames(stocks) <- c("Date", "Searches")
trump$Date <- as.Date(trump$Date)
stocks$Date <- as.Date(stocks$Date)


trump$Date <- as.Date(trump$Date, format = "%Y-%m-%d")
stocks$Date <- as.Date(stocks$Date, format = "%Y-%m-%d")

summary(trump$Searches)
summary(stocks$Searches)

hist(trump$Searches,
     main = "Histogram: Google searches for 'Trump'",
     xlab = "Normalized Search Interest (0-100)",
     col = "lightblue",
     border = "darkblue")

hist(stocks$Searches,
     main = "Histogram: Google searches for 'stocks'",
     xlab = "Normalized Search Interest (0-100)",
     col = "lightblue",
     border = "darkblue")

library(ggplot2)
library(scales)

line_trump <- ggplot(trump, aes(x = Date, y = Searches)) +
  geom_line(color = "blue") +
  scale_x_date(
    date_breaks = "15 days",
    date_labels = "%d.%m."
  ) +
  labs(title = "Google searches: 'Trump'",
       x = "Date", y = "Normalized Search Interest") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


line_stocks <- ggplot(stocks, aes(x = Date, y = Searches)) +
  geom_line(color = "red") +
  scale_x_date(
    date_breaks = "15 days",
    date_labels = "%d.%m."
  ) +
  labs(title = "Google searches: 'Stocks'",
       x = "Date", y = "Normalized Search Interest") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

trump$Keyword <- "Trump"
stocks$Keyword <- "Stocks"

combined <- rbind(trump, stocks)

line_combined <- ggplot(combined, aes(x = Date, y = Searches, color = Keyword)) +
  geom_line(size = 1) +
  scale_x_date(
    date_breaks = "15 days",
    date_labels = "%d.%m."
  ) +
  labs(title = "Google searches: Trump vs Stocks",
       x = "Date", y = "Normalized Search Interest") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_color_manual(values = c("Trump" = "blue", "Stocks" = "red"))

line_combined
line_stocks
line_trump

