DISPLAY_SPACER = "="
TAX_HOLDING_10 =  .10    # Tax withholding rate  10%
TAX_HOLDING_13 =  .13    # Tax withholding rate  13%
TAX_HOLDING_16 =  .16    # Tax withholding rate  16%
TAX_HOLDING_20 =  .20    # Tax withholding rate 20%

def main():
    display_menu()
    get_emp_info()


def display_menu():
    print(DISPLAY_SPACER * 50)
    print('Payroll Program')
    print(DISPLAY_SPACER * 50)

def get_emp_info():
    user_choice = 'AAAA'
    total_payroll = 0
    total_payroll_tax = 0

    while user_choice != 'ZZZZ':
        get_emp_hour_pay = 0
        get_emp_fname = input('Enter First Name:\t ')   # Employee First Name
        get_emp_lname = input('Enter Last Name:\t ')    # Employee Last Name

        while get_emp_hour_pay <= 0:
            get_emp_hour_pay = float(input('Enter Hourly pay:\t '))  # Employee pay / hr.
            get_emp_hour_worked = float(input('Enter Hours Worked:\t '))

            if get_emp_hour_pay <=0 or get_emp_hour_worked <=0:
                print('Invalid values entered')
                print('Hourly pay and Hours Worked must be greater than 0')
                print('Enter values again')
                get_emp_hour_pay = 0
            else:
                print('Valid values inserted')
                gross_emp_pay = get_emp_hour_pay * get_emp_hour_worked

                # Compute tax holdings when gross pay >= $800.01
                if gross_emp_pay >= 800.01:
                    emp_tax_holding = gross_emp_pay * TAX_HOLDING_20
                    net_emp_pay = gross_emp_pay - emp_tax_holding
                    print()

                # Compute tax holdings when gross pay between $550.01 and $800.00
                elif gross_emp_pay >= 550.01 and gross_emp_pay <= 800:
                    emp_tax_holding = gross_emp_pay * TAX_HOLDING_16
                    net_emp_pay = gross_emp_pay - emp_tax_holding

                # Compute tax holdings when gross pay between $300.01 and $550.00
                elif gross_emp_pay >= 300.01 and gross_emp_pay <= 550:
                     emp_tax_holding = gross_emp_pay * TAX_HOLDING_13
                     net_emp_pay = gross_emp_pay - emp_tax_holding

                # Compute tax holding when gross pay <= $300.00
                else:
                    emp_tax_holding = gross_emp_pay * TAX_HOLDING_10
                    net_emp_pay = gross_emp_pay - emp_tax_holding
                    print()
                    print('Gross Pay: ${:,.2f}'.format(gross_emp_pay))
                    print('Tax Holding: ${:,.2f}'.format(emp_tax_holding))
                    print('Net Pay: ${:,.2f}'.format(net_emp_pay))

                # Print the output
                print()
                print('Paycheck Information for {0} {1}'.format(get_emp_fname, get_emp_lname))
                print('Gross Pay: ${:,.2f}'.format(gross_emp_pay))
                print('Net Pay: ${:,.2f}'.format(net_emp_pay))
                print('Tax FICA: ${:,.2f}'.format(emp_tax_holding))
                print()

        total_payroll = total_payroll + gross_emp_pay
        total_payroll_tax = total_payroll_tax + emp_tax_holding
        user_choice = input(("To STOP type 'zzzz' or hit ENTER to continue: ")).upper()

    print()
    print('Total Payroll Gross Pay:\t${:,.2f}'.format(total_payroll))
    print('Total Payroll Tax:\t${:,.2f}'.format(total_payroll_tax))

main()
print()
print('end of program')