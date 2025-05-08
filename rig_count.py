#!/usr/bin/env python3

import matplotlib.pyplot as plt
import pandas as pd

# Data
data = {
    'Date': ['2025-02-07', '2025-02-14', '2025-02-21', '2025-02-28', '2025-03-07',
             '2025-03-14', '2025-03-21', '2025-03-28', '2025-04-04', '2025-04-11',
             '2025-04-18', '2025-04-25', '2025-05-02'],
    'Total Rigs': [590, 589, 588, 588, 587, 587, 586, 586, 589, 588, 587, 587, 584]
}

df = pd.DataFrame(data)
df['Date'] = pd.to_datetime(df['Date'])

# Plot
plt.figure(figsize=(10, 6))
plt.plot(df['Date'], df['Total Rigs'], marker='o', linestyle='-', color='blue', label='Total Rigs')
plt.title('Baker Hughes U.S. Total Rig Count: February 7 – May 2, 2025')
plt.xlabel('Date')
plt.ylabel('Number of Active Rigs')
plt.grid(True)
plt.xticks(df['Date'], df['Date'].dt.strftime('%Y-%m-%d'), rotation=45)
plt.ylim(580, 595)
plt.legend()
plt.tight_layout()
plt.show()
