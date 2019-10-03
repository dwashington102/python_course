# Comment section
# A program for Hunterville College that will display the projected tuition
# rate for the next 10 years. Display each year and the tuition for that year.


# GLOBAL CONSTANTS
TUITION_INC_YR2 = .04    # % of expected tuition increase in year #2
TUITION_INC_PCT = .005   # incremental % of expected tuition increase after year #1
TOTAL_YEARS = 10         # Total number of years covered in the projection
HEAD_FOOT = "-"          # Used for Header & Footer Formatting




def main():
    tuition = 15000.0
    current_yr = int(float(input('Input First Year: ')))
    display_header()
    #Print 1st year tuition and % of increase for year 2
    print('Tuition Year ', current_yr, ': $', format(tuition, '.2f'), sep='', end='')
    print('\tNext Year Expected Increase: {:.2%}'.format(TUITION_INC_YR2))
    # Calling function that will print the projected tuition cost along with following year's pct of increase
    tuition_cost(current_yr, tuition)
    display_footer()

# Compute and print remaining years
def tuition_cost(current_yr, tuition):
    next_year_inc_pct = TUITION_INC_YR2 + TUITION_INC_PCT
    current_yr += 1
    current_yr_max = current_yr + 9
    for current_yr in range(current_yr,current_yr_max):
        tuition = tuition * (1 + next_year_inc_pct)
        print('Tuition Year ', current_yr, ': $', format(tuition, '.2f'), sep='', end='')
        print('\tNext Year Expected Increase: {:.2%}'.format(next_year_inc_pct))
        next_year_inc_pct = next_year_inc_pct + TUITION_INC_PCT
        current_yr += 1


# Print Header
def display_header():
    print(HEAD_FOOT * 70)
    print('Hunterville College Projected Tuition Rate for Next 10 Years')
    print(HEAD_FOOT * 70)

# Print Footer
def display_footer():
    print('\n', HEAD_FOOT * 70)
    print("End of program")


# Call Main
main()
