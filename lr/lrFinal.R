library(ggplot2)

data <- read.csv("../data/data.csv")

#data$dStocks <- c(diff(data[["Stocks"]]), 0)
#data$logVolume <- c(diff(data[["Volume"]]), 0)

X = "Trump"
Y = "Volatility"

data$HML <- data[[Y]]

Y = "HML"
model <- lm(HML ~ Trump, data = data)

panels <- 1:3

for (i in panels) {
  png(sprintf("./plots/%s-%s_%d.png", X, "Volatility", i),            # file name
      width = 800, height = 600, res = 120)       # size & resolution

  plot(model, which = i)                            # draw the i-th panel

  dev.off()                                       # CLOSE the device – crucial!
}






