# Define GLOBAL CONSTANT variables
annual_profit = 0.23

# Define variables
get_tot_sales = float(input('What is the total sales for the Quarter: '))

# Compute annual profit based on get_total_sales * annual_profit
compute_annual_profit = float((get_tot_sales * annual_profit))

# Print annual profit estimate
print("Based on ${:.2f}".format(get_tot_sales), end=' ')
print("We estimate a 23% annual profit based on total sales  ${:.2f}".format(compute_annual_profit))


