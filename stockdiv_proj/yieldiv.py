# Importing colorama module
import colorama

gcolor = colorama.Fore.GREEN
rcolor = colorama.Fore.RED
ycolor = colorama.Fore.YELLOW
resetcolor = colorama.Fore.RESET


def compute_yield(stockprice):
    ''' print("Debug stockprice: {:.2f}".format(stockprice))
    Gather user input dividend payout per share (divamount) and
    payout frequency per year (yrdist)
    '''
    divamount = float(input("What is the dividend amount per share "
                            + "per payout: "))
    yrdist = int(input("How many times per year is the dividend paid: "))

    # Compute dividend percent
    divtotal = float(divamount * yrdist)
    divyield = ((100 * divtotal) / stockprice)
    if divyield < 2.0:
        print_yellow()
        print("\n===================================")
        print("Yearly Dividend Total ${:.2f}".format(divtotal), "per share.")
        print("Dividend Percent: {:.2f}".format(divyield) + '%')
        print("===================================\n")
        reset_text()
    elif divyield > 7.0:
        print_red()
        print("\n===================================")
        print("Yearly Dividend Total ${:.2f}".format(divtotal), "per share.")
        print("Dividend Percent: {:.2f}".format(divyield) + '%')
        print("===================================\n")
        reset_text()
    else:
        print_green()
        print("\n===================================")
        print("Yearly Dividend Total ${:.2f}".format(divtotal), "per share.")
        print("Dividend Percent: {:.2f}".format(divyield) + '%')
        print("===================================\n")
        reset_text()


def print_red():
    print(rcolor)


def reset_text():
    print(resetcolor)


def print_yellow():
    print(ycolor)


def print_green():
    print(gcolor)
