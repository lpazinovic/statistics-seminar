
library(ggplot2)

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# 1. Load & transform
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
data <- read.csv("../data/data.csv")

dependent_var   <- "Volatility"
independent_var <- "Trump"

data$log_y <- log(data[[dependent_var]])
data$log_x <- log(data[[independent_var]])



#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# 2. Fit model & compute diagnostics
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
model <- lm(log_y ~ log_x, data = data)
plot(model)

# 2a. R^2
r2 <- summary(model)$r.squared
cat(sprintf("R-squared: %.4f\n", r2))

# 2b. 95% confidence intervals for intercept & slope
ci <- confint(model, level = 0.95)
print(ci)

# add diagnostic columns for plots A–C
data$fitted        <- fitted(model)
data$residuals     <- resid(model)
data$std_residuals <- rstandard(model)
data$sqrt_abs_std  <- sqrt(abs(data$std_residuals))

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# 3. Plot A: Residuals vs Fitted + LOESS expectation curve
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
pA <- ggplot(data, aes(x = fitted, y = residuals)) +
  geom_point(color = "black", size = 1.5) +
  geom_hline(yintercept = 0,
             linetype    = "dashed",
             size        = 0.8,
             color       = "blue") +
  geom_smooth(method = "loess",
              se     = FALSE,
              color  = "red",
              size   = 1) +
  labs(title = "Residuals vs Fitted",
       x     = "Fitted values",
       y     = "Residuals") +
  theme_minimal()

ggsave("plots/residuals_vs_fitted.png",
       plot   = pA,
       width  = 6,
       height = 4,
       dpi    = 300)

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# 4. Plot B: Normal Q–Q of residuals
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
pB <- ggplot(data, aes(sample = residuals)) +
  stat_qq(color = "black", size = 1.5) +
  stat_qq_line(linetype = "dashed",
               size     = 1,
               color    = "blue") +
  labs(title = "Normal Q–Q Plot",
       x     = "Theoretical quantiles",
       y     = "Sample quantiles") +
  theme_minimal()

ggsave("plots/qq_plot.png",
       plot   = pB,
       width  = 6,
       height = 4,
       dpi    = 300)

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# 5. Plot C: Scale–Location (sqrt|standardized residuals| vs fitted)
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
pC <- ggplot(data, aes(x = fitted, y = sqrt_abs_std)) +
  geom_point(color = "black", size = 1.5) +
  geom_smooth(method = "loess",
              se     = FALSE,
              color  = "blue",
              size   = 1) +
  labs(title = "Scale–Location",
       x     = "Fitted values",
       y     = expression(sqrt("|Standardized residuals|"))) +
  theme_minimal()

ggsave("plots/scale_location.png",
       plot   = pC,
       width  = 6,
       height = 4,
       dpi    = 300)

#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# 6. Plot D: log–log + both 95% bands (CI in blue, PI in red)
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
# 6a. Create grid for predictions
new_data <- data.frame(
  log_x = seq(min(data$log_x),
              max(data$log_x),
              length.out = 200)
)

# 6b. Compute confidence interval for mean response
pred_ci <- predict(model,
                  newdata  = new_data,
                  interval = "confidence",
                  level    = 0.95)
df_ci <- cbind(new_data, as.data.frame(pred_ci))

# 6c. Compute prediction interval for new observations
pred_pi <- predict(model,
                  newdata  = new_data,
                  interval = "prediction",
                  level    = 0.95)
df_pi <- cbind(new_data, as.data.frame(pred_pi))

# 6d. Build the ggplot
pD <- ggplot() +
  # prediction band (wider, red, behind)
  geom_ribbon(data = df_pi,
              aes(x = log_x, ymin = lwr, ymax = upr),
              fill  = "red",
              alpha = 0.2) +
  # points
  geom_point(data = data,
             aes(x = log_x, y = log_y),
             color = "black",
             size  = 1.5) +
  # fitted line
  geom_line(data = df_ci,
            aes(x = log_x, y = fit),
            color = "purple",
            size  = 1) +
  labs(
       x = "log(X+1)",
       y = "log(Y+1)") +
  theme_minimal()

ggsave("plots/log_Trump-log_Volatility_4.png",
       plot   = pD,
       width  = 6,
       height = 4,
       dpi    = 300)

