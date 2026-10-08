
library(ggplot2)

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# 1. Load & transform
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
data <- read.csv("../data/data.csv")

dependent_var   <- "Volume"
independent_var <- "Stocks"

data$log_y <- (data[[dependent_var]])
data$log_x <- (data[[independent_var]])


pA <- ggplot(data, aes(x = log_x, y = log_y)) +
  geom_point(color = "black", size = 1.5) +
  geom_smooth(method = "loess",
              se     = FALSE,
              color  = "red",
              size   = 1) +
  labs(title = "Residuals vs Fitted",
       x     = "Fitted values",
       y     = "Residuals") +
  theme_minimal()

ggsave("plots/gf.png",
       plot   = pA,
       width  = 6,
       height = 4,
       dpi    = 300)

