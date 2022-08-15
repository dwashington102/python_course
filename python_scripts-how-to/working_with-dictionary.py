#!/usr/bin/python3

product = {'Book': 39.99,
           'Ticket': 19.1,
           'Glass': 9.20,
           }

for item in product:
    print(f"Item: {item}\tCost: {product[item]:.2f}")
