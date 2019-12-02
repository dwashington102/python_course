import os

# Import custom modules
#from .home.x1user.GIT_REPO.python_course.clear_screen import clear


# Define GLOBAL CONSTANTS


def main():
    #clear()
    monthly_budget()

def monthly_budget():
    user_choice = 'y'
    user_income = float(input('Total Income for the Month: '))
    expense_tot = 0.0
    expense_count = 1

    while user_choice == 'y':
        print('Enter expense: ', expense_count)
        u_exname = input('Expense Name: ')
        u_excost = float(input('Expense Cost: '))
        expense_tot = float(expense_tot + u_excost)
        print()
        try:
            user_choice = str(input('Enter another expense (y/n): '))
            if user_choice == 'y':
                expense_count += 1
            else:
                budget = float(user_income - expense_tot)
                if budget < 0:
                    print('')
                    print('Total Number of Expenses:', expense_count)
                    print('Total Income: ${:.2f}'.format(user_income))
                    print('Total Expenses: ${:.2f}'.format(expense_tot))
                    print('Running a deficit ${:.2f}'.format(budget))
                else:
                    print('')
                    print('Total Number of Expenses:', expense_count)
                    print('Total Income: ${:.2f}'.format(user_income))
                    print('Total Expenses: ${:.2f}'.format(expense_tot))
                    print('Surplus cash for the month: ${:.2f}'.format(budget))
        except TypeError:
            print('Invalid Selection')


if __name__ == '__main__':
    main()
