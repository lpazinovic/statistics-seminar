library(ggplot2)

data <- read.csv("../data/data.csv")

#data$Trump <- log1p(data[["Trump"]])
#data$Volatility <- log1p(data[["Volatility"]])

X = "Stocks"
Y = "Volume"

model <- lm(as.formula(paste(Y, "~", X)), data = data)

#plot(model, which = 1)
summary(model)

ci <- confint(model, level = 0.95)
print(ci)







