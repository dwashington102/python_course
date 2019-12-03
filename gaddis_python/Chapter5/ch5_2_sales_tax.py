'''
Program calculates and displays the county and state sales tax on a purchase
'''

import os

# Import custom modules

# Define GLOBAL CONSTANTS
TAX_RATE_COUNTY = .02
TAX_RATE_STATE =  .0625


def main():
    item_cost()


def item_cost():
    get_item_cost = float(input('Enter the cost of item: '))
    county_sales_tax =  get_item_cost * TAX_RATE_COUNTY
    state_sales_tax =  get_item_cost *  TAX_RATE_STATE
    total_cost = get_item_cost + county_sales_tax + state_sales_tax
    print('County Tax ${:,.2f}'.format(county_sales_tax))
    print('State Tax ${:,.2f}'.format(state_sales_tax))
    print('Total Cost ${:,.2f}'.format(total_cost))


if __name__ == '__main__':
    main()
