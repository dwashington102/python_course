#!/usr/bin/env python3
import colorama
import yieldiv as yield_mod
import stockpps as stockpps_mod
from clear_screen import clear

# Variables
gcolor = colorama.Fore.GREEN
resetcolor = colorama.Fore.RESET

def display_menu():
    clear()
    print(gcolor, "Provide Stock Dividend Yield or Price-per-Share\n", resetcolor)
    u_choice = input('Input "d" in order to Compute Dividend Yield OR "p" for the Price-Per-Share: ')
    u_choice = u_choice.lower()

    if u_choice == "d":
        compute_div()
    elif u_choice == 'p':
        compute_pps()
    else:
        print('\nPlease insert a valid character.  Input only accepts "d" or "p"')
        exit(1)


def compute_div():
    stockprice = float(input("\nStock Price per share at time of purchase:\t"))
    passprice = yield_mod.compute_yield(stockprice)
    #print("Debug Stock Price: ", stockprice)


def compute_pps():
    totstockcost = float(input("\nTotal Cost of all Shares: "))
    #stockprice = float(input("Stock Price at time of purchase:\t"))
    value = stockpps_mod.stockpps(totstockcost)


def main():
    choice = "y"
    while choice.lower() == "y":
        display_menu()
        print("\n")
        choice = input('Do you wish to continue (y/n): ')
        choice = choice.lower()
        print("\n")


if __name__ == "__main__":
    main()
    print("Leaving...")
exit(0)
