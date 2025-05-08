#!/usr/bin/env python3

import matplotlib.pyplot as plt
import pandas as pd

# Data
data = {
    'Date': ['2025-02-07', '2025-02-14', '2025-02-21', '2025-02-28', '2025-03-07',
             '2025-03-14', '2025-03-21', '2025-03-28', '2025-04-04', '2025-04-11',
             '2025-04-18', '2025-04-25', '2025-05-02'],
    'Total Rigs': [590, 589, 588, 588, 587, 587, 586, 586, 589, 588, 587, 587, 584],
    'WTI Price': [73.00, 72.50, 72.00, 71.50, 69.00, 68.00, 67.00, 66.00, 65.00, 59.00, 58.50, 58.40, 58.29]
}

df = pd.DataFrame(data)
df['Date'] = pd.to_datetime(df['Date'])

# Dual-axis plot
fig, ax1 = plt.subplots(figsize=(12, 6))

# Plot rigs
ax1.set_xlabel('Date')
ax1.set_ylabel('Total Rigs', color='blue')
ax1.plot(df['Date'], df['Total Rigs'], marker='o', linestyle='-', color='blue', label='Total Rigs')
ax1.tick_params(axis='y', labelcolor='blue')
ax1.set_ylim(580, 595)

# Plot WTI price
ax2 = ax1.twinx()
ax2.set_ylabel('WTI Price per Barrel (USD)', color='red')
ax2.plot(df['Date'], df['WTI Price'], marker='s', linestyle='--', color='red', label='WTI Price')
ax2.tick_params(axis='y', labelcolor='red')
ax2.set_ylim(55, 75)

# Title and grid
plt.title('U.S. Baker Hughes Rig Count and WTI Crude Oil Price: February 7 – May 2, 2025')
fig.tight_layout()
fig.autofmt_xdate(rotation=45)
ax1.grid(True)

# Legend
lines1, labels1 = ax1.get_legend_handles_labels()
lines2, labels2 = ax2.get_legend_handles_labels()
ax1.legend(lines1 + lines2, labels1 + labels2, loc='upper center')

plt.show()
