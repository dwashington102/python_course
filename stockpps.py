import colorama

# Variables
gcolor = colorama.Fore.GREEN
resetcolor = colorama.Fore.RESET


def stockpps(totstockprice):
    print("Cost of stocks: ${:.2f}".format(totstockprice))

    # Gather the number of shares purchased
    totalshares = float(input("How many shares were purchased: "))

    # Compute the price per share
    costpershare = float(totstockprice / totalshares)

    # Return the output to the user
    print(gcolor, "\n===================================")
    print("Total Price Paid for {:.2f} shares is ${:.2f}".format(totalshares, totstockprice))
    print("Cost per share: ${:.2f}".format(costpershare))
    print("===================================\n", resetcolor)

#    compute_totcost = float(totalshares * stockprice)
#    print("Total Cost of {:.2f}".format(totalshares)+" shares"+": ${:,.2f}".format(compute_totcost))
#    compute_pps = float(compute_totcost / totalshares)
#    print("Debug PPS:", compute_pps)
