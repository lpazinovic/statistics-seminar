stocks <- read.csv("../data/stocks_usa.csv", skip = 5)
colnames(stocks) <- c("Date", "Searches")
sp500 <- read.csv("../data/sp500.csv", skip = 2, header = FALSE)

colnames(sp500) <- c("Date", "O
#summary(sp500)[c("Min.", "1st Qu.", "Median", "3rd Qu.", "Max.")]

sp500
stocks
