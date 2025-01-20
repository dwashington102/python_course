# Compute compound monthly interest

# Forumula to compound monthly interest when total number of months is known
# fut_value = Principal * (1 + rate/12) ** num_of_mths

# Forumula to compound monthly interest when total number of years is known
# fut_value = Principal * (1 + rate/12) ** (12 * num_of_years)

from clear_screen import clear

# Define GLOBAL CONSTANTS
DISPLAY_SPACER = "="
MONTHS = 12


def display_header():
    # Function used to display header/banner
    print(DISPLAY_SPACER * 50)
    print('Future Value')
    print(DISPLAY_SPACER * 50)


def user_principal():
    '''Function used to gather user input for current balance
    interest rate, and duration.'''
    user_choice = 'y'
    while user_choice == 'y':
        print()
        try:
            u_principal = float(input('What is the current account balance: '))
        except ValueError:
            print('Invalid value received.  Try again')
            exit(1)
        try:
            u_rate = float(input('What is the monthly interest rate: '))
        except ValueError:
            print('Invalid value received.  Try again')
            exit(2)
        try:
            u_months = int(float(input('How many months will the money be left in the account: ')))
        except ValueError:
            print('Invalid value received.  Try again')
            exit(3)
        compute_future_value(u_principal, u_rate, u_months)
        print()
        user_choice = input('Would you like to compute anoter future value (y/n): ')


def compute_future_value(u_principal, u_rate, u_months):
    ''' Function used to compute future value based on values passed from
    user_principal()'''
    # fut_value = u_principal * (1 + (u_rate/u_months) ** u_months
    convert_rate = u_rate / 100
    print()
    print('Current Value: ${:,.2f}'.format(u_principal))
    print('Current Rate: {:.4f}%'.format(convert_rate))
    print('Number of months: ', u_months)
    print()

    fut_value = u_principal * (1 + convert_rate/12) ** u_months
    chg_value = fut_value - u_principal
    print(DISPLAY_SPACER * 50)

    print('Future Value: ${:,.2f}'.format(fut_value))
    print('Profit/Loss: ${:,.2f}'.format(chg_value))


def main():
    clear()
    display_header()
    user_principal()
    print('All actions completed')


if __name__ == '__main__':
    main()
