import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np
from sklearn.feature_selection import mutual_info_regression

# Set seaborn style
sns.set(style="darkgrid")

# Create output directory
output_dir = "../plots_pavic"
os.makedirs(output_dir, exist_ok=True)

# Read CSV files
sp_data = pd.read_csv('sp500.csv', index_col=0, parse_dates=True)
trump_data = pd.read_csv('trump_usa.csv', index_col=0, parse_dates=True)
stocks_data = pd.read_csv('stocks_usa.csv', index_col=0, parse_dates=True)

# Feature engineering on S&P 500
sp_data['Change'] = sp_data['Close'] - sp_data['Open']
sp_data['Volatility'] = sp_data['High'] - sp_data['Low']
sp_data['AbsChange'] = sp_data['Change'].abs()
sp_data = sp_data.drop(['Open', 'High', 'Low', 'Close'], axis=1)

# Merge DataFrames
X = sp_data.join(trump_data, how='inner').join(stocks_data, how='inner')
X.to_csv('data.csv')

# Reset index for plotting
X_reset = X.reset_index().rename(columns={'index': 'Date'})

### TIME SERIES PLOTS ###
for column in X.columns:
    plt.figure(figsize=(12, 6))
    sns.lineplot(data=X_reset, x='Date', y=column)
    plt.title(f"Time Series of {column}")
    plt.xlabel("Date")
    plt.ylabel(column)
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, f"{column}_timeseries.png"))
    plt.close()

### HISTOGRAMS ###
for column in X.columns:
    plt.figure(figsize=(8, 6))
    sns.histplot(X[column].dropna(), bins=50, kde=True)
    plt.title(f"Histogram of {column}")
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, f"{column}_hist.png"))
    plt.close()

# Columns to include log-histograms for
log_columns = ['Change', 'AbsChange', 'Volatility', 'Volume']
for column in log_columns:
    if column in X.columns:
        log_values = X[column].apply(lambda x: np.log1p(x) if x > 0 else np.nan).dropna()
        plt.figure(figsize=(8, 6))
        sns.histplot(log_values, bins=50, kde=True)
        plt.title(f"Log-Histogram of {column}")
        plt.tight_layout()
        plt.savefig(os.path.join(output_dir, f"{column}_loghist.png"))
        plt.close()

### MUTUAL INFORMATION HEATMAP ###
# Drop rows with NaNs

# Compute mutual information between each pair
mi_matrix = pd.DataFrame(index=X.columns, columns=X.columns)

for target in X.columns:
    mi = mutual_info_regression(X, X[target])
    mi_matrix[target] = mi

# Convert values to float and plot
mi_matrix = mi_matrix.astype(float)

plt.figure(figsize=(14, 10))
sns.heatmap(mi_matrix, annot=True, fmt=".2f", cmap="viridis")
plt.title("Mutual Information Matrix")
plt.tight_layout()
plt.savefig(os.path.join(output_dir, "mutual_information_heatmap.png"))
plt.close()

