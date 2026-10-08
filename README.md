# S&P 500 and Google Search Interest

A statistics seminar project exploring relationships between S&P 500 indicators and U.S. Google search interest in the terms "stocks" and "Trump". The analysis covers 3 October 2024–30 April 2025, using market data from Yahoo Finance and search data from Google Trends.

This was originally a final project for a class on statistics. It was created in a group of four people; I worked on the inferential statistics part, i.e. the linear regressions and the Kolmogorov-Smirnov test. It has been AI-translated into English, so it might contain minor translational errors.

## Contents

- Data preparation: aligning market and search data and constructing price-based indicators in Python.
- Exploratory analysis: time series, histograms, boxplots, five-number summaries, and Pearson correlations.
- Regression: simple and multiple linear regression, confidence intervals, residual diagnostics, and logarithmic transformations.
- Distribution testing: the Lilliefors version of the Kolmogorov–Smirnov test, applied to log(HML) and daily price change.

## Files and folders

| File/Folder | Description |
| --- | --- |
| [main.pdf](main.pdf) | Compiled English seminar report. |
| [main.tex](main.tex), [preamble.tex](preamble.tex), [sections/](sections/) | LaTeX source. |
| [data/](data/) | Datasets and Python data preparation script. |
| [R/](R/), [lr/](lr/), [pavic_r/](pavic_r/) | R analysis scripts and supporting outputs. |
| [plots/](plots/), [plots_pavic/](plots_pavic/), [lr/plots/](lr/plots/), [pavic_r/](pavic_r/) | Figures from the analysis. |

## Tools

R, ggplot2, nortest, Python, pandas, NumPy, Matplotlib, seaborn and LaTeX.

The PDF has already been compiled.

## Running locally

To rebuild the full report, you can compile [main.tex](main.tex).