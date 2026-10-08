# Run from the project's root directory: Rscript R/lilliefors.R
# Requires the nortest package (1.0-4).
# Documentation: https://search.r-project.org/CRAN/refmans/nortest/html/lillie.test.html

if (!requireNamespace("nortest", quietly = TRUE)) {
  stop("Install the nortest package: install.packages('nortest')")
}

podaci <- read.csv("pavic_r/data.csv")
stopifnot(nrow(podaci) == 143L, all(is.finite(podaci$hml)),
          all(podaci$hml > 0), all(is.finite(podaci$promjena)))

rezultati <- list(
  log_hml = nortest::lillie.test(log(podaci$hml)),
  promjena = nortest::lillie.test(podaci$promjena)
)

for (naziv in names(rezultati)) {
  test <- rezultati[[naziv]]
  cat(sprintf("%s: n = %d, D = %.12f, p = %.12g\n",
              if (naziv == "promjena") "change" else naziv,
              nrow(podaci), unname(test$statistic), test$p.value))
}

# Results used in the text:
# log_hml: n = 143, D = 0.058492650937, p = 0.270113768390
# promjena: n = 143, D = 0.114827540569, p = 8.73854588117e-05
