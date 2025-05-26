#!/usr/bin/env python3

# Prompt user for stock price
price = float(input("Enter the stock price per share: "))

# Calculate gains and loss
gain_2_percent = price * 1.02
gain_4_percent = price * 1.04
gain_5_percent = price * 1.05
loss_4_percent = price * 0.96

# Print table
print("=" * 65)
print("Price    |   2% gain    |   4% gain    |    5% gain    |    4% loss")
print("=" * 65)
print(f"${price:<14.2f}| ${gain_2_percent:<11.2f} | ${gain_4_percent:<11.2f} | ${gain_5_percent:<11.2f} | ${loss_4_percent:<11.2f}")
print("=" * 65)
