sp500 <- read.csv("sp500.csv", header = TRUE)
trump <- read.csv("trump_usa.csv", skip = 5)
stocks <- read.csv("stocks_usa.csv", skip = 5)

sp500 <- sp500[, -c(3, 4)]

sp500$Promjena <- sp500$Close - sp500$Open
cor(sp500$Volume, sp500$Promjena, method = "pearson")

plot(sp500$Promjena, sp500$Volume,
     xlab = "Daily price change",
     ylab = "Trading volume",
     main = "Correlation between volume and price change")

names(stocks) <- c("Date", "stocks")
names(trump) <- c("Date", "trump")

stocks$Date <- as.Date(stocks$Date)
trump$Date <- as.Date(trump$Date)
sp500$Date <- as.Date(sp500$Date)

data <- merge(sp500, stocks, by = "Date")
data <- merge(data, trump, by = "Date")

cor(data$stocks, data$Volume, method = "pearson")
cor(data$stocks, data$Promjena, method = "pearson")
cor(data$trump, data$Volume, method = "pearson")
cor(data$trump, data$Promjena, method = "pearson")

plot(data$stocks, data$Volume,
     xlab = "Relative frequency of 'stocks'",
     ylab = "Trading volume",
     main = "Volume vs. 'stocks'")

plot(data$stocks, data$Promjena,
     xlab = "Relative frequency of 'stocks'",
     ylab = "Daily price change",
     main = "Price change vs. 'stocks'")

plot(data$trump, data$Volume,
     xlab = "Relative frequency of 'Trump'",
     ylab = "Trading volume",
     main = "Volume vs. 'Trump'")

plot(data$trump, data$Promjena,
     xlab = "Relative frequency of 'Trump'",
     ylab = "Daily price change",
     main = "Price change vs. 'Trump'")

