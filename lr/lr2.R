# ────────────────────────────────────────────────────────────────────────
# 0. Setup
# ────────────────────────────────────────────────────────────────────────

library(ggplot2)

# ────────────────────────────────────────────────────────────────────────
# 1. Load data and create response
# ────────────────────────────────────────────────────────────────────────
dat <- read.csv("../data/data.csv")
dat$log_Volume <- log(dat$Volume)

# ────────────────────────────────────────────────────────────────────────
# 2. Candidate transforms of Trump
# ────────────────────────────────────────────────────────────────────────
dat$Trump_raw   <- dat$Trump
dat$Trump_log1p <- log1p(dat$Trump)
dat$Trump_sqrt  <- sqrt(dat$Trump)

candidates <- list(
  raw   = lm(log_Volume ~ Trump_raw,   data = dat),
  log1p = lm(log_Volume ~ Trump_log1p, data = dat),
  sqrt  = lm(log_Volume ~ Trump_sqrt,  data = dat)
)

# select best by AIC
aic_vals   <- sapply(candidates, AIC)
best_name  <- names(which.min(aic_vals))
best_model <- candidates[[best_name]]

cat("Best transformation (by AIC):", best_name, "\n")
cat("AIC values:\n"); print(aic_vals)

# ────────────────────────────────────────────────────────────────────────
# 3. Summary of chosen model
# ────────────────────────────────────────────────────────────────────────
summary(best_model)
confint(best_model, level = 0.95)

# ────────────────────────────────────────────────────────────────────────
# 4. Prepare diagnostics
# ────────────────────────────────────────────────────────────────────────
diag_data <- data.frame(
  fitted    = fitted(best_model),
  residuals = resid(best_model),
  std_resid = rstandard(best_model)
)
diag_data$sqrt_abs <- sqrt(abs(diag_data$std_resid))

# ────────────────────────────────────────────────────────────────────────
# 5. Plot A: Residuals vs Fitted + LOESS expectation curve
# ────────────────────────────────────────────────────────────────────────
p1 <- ggplot(diag_data, aes(fitted, residuals)) +
  geom_point(size = 1.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "blue") +
  geom_smooth(method = "loess", se = FALSE, color = "red") +
  labs(title = "Residuals vs Fitted", x = "Fitted", y = "Residuals") +
  theme_minimal()

ggsave("plots/residuals_vs_fitted.png",
       plot   = p1,
       width  = 6,
       height = 4,
       dpi    = 300)

# ────────────────────────────────────────────────────────────────────────
# 6. Plot B: Normal Q–Q
# ────────────────────────────────────────────────────────────────────────
p2 <- ggplot(diag_data, aes(sample = residuals)) +
  stat_qq(size = 1.5) +
  stat_qq_line(linetype = "dashed", color = "blue") +
  labs(title = "Normal Q–Q Plot", x = "Theoretical quantiles", y = "Sample quantiles") +
  theme_minimal()

ggsave("plots/qq_plot.png",
       plot   = p2,
       width  = 6,
       height = 4,
       dpi    = 300)

# ────────────────────────────────────────────────────────────────────────
# 7. Plot C: Scale–Location
# ────────────────────────────────────────────────────────────────────────
p3 <- ggplot(diag_data, aes(fitted, sqrt_abs)) +
  geom_point(size = 1.5) +
  geom_smooth(method = "loess", se = FALSE, color = "blue") +
  labs(title = "Scale–Location", 
       x = "Fitted", 
       y = expression(sqrt("|standardized residuals|)"))) +
  theme_minimal()

ggsave("plots/scale_location.png",
       plot   = p3,
       width  = 6,
       height = 4,
       dpi    = 300)

# ────────────────────────────────────────────────────────────────────────
# 8. Plot D: Final fit with both 95% CI & PI
# ────────────────────────────────────────────────────────────────────────
grid_x <- switch(best_name,
                 raw   = seq(min(dat$Trump_raw),   max(dat$Trump_raw),   length = 200),
                 log1p = seq(min(dat$Trump_log1p), max(dat$Trump_log1p), length = 200),
                 sqrt  = seq(min(dat$Trump_sqrt),  max(dat$Trump_sqrt),  length = 200))

newdata <- setNames(data.frame(grid_x), paste0("Trump_", best_name))

ci_df <- predict(best_model, newdata = newdata, interval = "confidence")
pi_df <- predict(best_model, newdata = newdata, interval = "prediction")

plot_df <- cbind(newdata, as.data.frame(ci_df), 
                 pi_lwr = pi_df[,"lwr"], pi_upr = pi_df[,"upr"])

p4 <- ggplot() +
  geom_ribbon(data = plot_df, aes(x = grid_x, ymin = pi_lwr, ymax = pi_upr),
              fill = "red", alpha = 0.2) +
  geom_ribbon(data = plot_df, aes(x = grid_x, ymin = lwr, ymax = upr),
              fill = "blue", alpha = 0.4) +
  geom_point(data = dat, aes_string(x = paste0("Trump_", best_name), y = "log_Volume"), size = 1.5) +
  geom_line(data = plot_df, aes(x = grid_x, y = fit), color = "purple") +
  labs(title = sprintf("Best fit (%s): log(Volume) ~ %s(Trump)", best_name, best_name),
       x = sprintf("%s(Trump)", best_name),
       y = "log(Volume)") +
  theme_minimal()

ggsave("plots/final_fit.png",
       plot   = p4,
       width  = 6,
       height = 4,
       dpi    = 300)

