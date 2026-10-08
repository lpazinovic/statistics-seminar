library(ggplot2)

data <- read.csv("../data/data.csv")


X = "Stocks"
Y = "Volume"

fit <- lm(as.formula(paste(Y, "~", X)), data = data)



beta_hat   <- coef(fit)[X]
sigma_hat  <- summary(fit)$sigma

# 3. Compute Sxx = Σ (xᵢ − x̄)²
x_vec <- data[[X]]
Sxx   <- sum((x_vec - mean(x_vec))^2)

n     <- length(residuals(fit))
dfree <- n - 2
t_val <- qt(0.975, dfree)

se_beta <- sigma_hat / sqrt(Sxx)

ci_lower <- beta_hat - t_val * se_beta
ci_upper <- beta_hat + t_val * se_beta

# 7. Display the interval
cat("95% CI for slope β: [", round(ci_lower, 4), ", ", round(ci_upper, 4), "]\n")


# 2. Extract the estimated intercept (α̂) and residual standard error (σ̂)
alpha_hat <- coef(fit)[["(Intercept)"]]
sigma_hat <- summary(fit)$sigma

# 3. Compute Sxx = Σ (x_i − x̄)² and x̄
x_vec <- data[[X]]
n     <- length(x_vec)
x_bar <- mean(x_vec)
Sxx   <- sum((x_vec - x_bar)^2)

# 4. Compute the standard error of α̂:
#    SE(α̂) = σ̂ * sqrt( 1/n + (x̄² / Sxx) )
se_alpha <- sigma_hat * sqrt( (1 / n) + (x_bar^2 / Sxx) )

# 5. Degrees of freedom and critical t‐value for 95% CI
dfree <- n - 2
t_val <- qt(0.975, dfree)   # two‐sided 95% ⇒ quantile at 0.975

# 6. Construct the 95% confidence interval
ci_lower <- alpha_hat - t_val * se_alpha
ci_upper <- alpha_hat + t_val * se_alpha

# 7. Print the result
cat("95% CI for intercept α:\n [",
    round(ci_lower, 4), ", ", round(ci_upper, 4), "]\n")









