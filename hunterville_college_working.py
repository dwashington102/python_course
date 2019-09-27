# Comment section
# A program for Hunterville College that will display the projected tuition
# rate for the next 10 years. Display each year and the tuition for that year.


# GLOBAL CONSTANTS
TUITION_INC_YR2 = .04   # % of expected tuition increase in year #2
TUITION_INC_PCT = .005  # incremental % of expected tuition increase after year #1
TOTAL_YEARS = 10        # Total number of years covered in the projection
HEAD_FOOT = "-"         # Used for Header & Footer Formatting


# Define Variables
tuition = 15000.0       # Beginning tuition at year 1
current_yr = 1

# Print Header
print(HEAD_FOOT * 70)
print('Hunterville College Projected Tuition Rate for Next 10 Years')
print(HEAD_FOOT * 70)

# Print the tuition for year #1
print('Tuition Year ', current_yr, ': $', format(tuition, '.2f'), sep='', end='')

# Following line added for DEBUG purpose
print('\tNext Year Expected Increase: {:.2%}'.format(TUITION_INC_YR2))

current_yr += 1 # Increment year counter

# Increment tuitution increase percentage
next_year_inc = TUITION_INC_YR2

# WHILE loop prints the tuition for years 2 - 10
while current_yr <= 10:
    # Print the tuition for year 2
    if current_yr == 2:
        tuition = tuition + (tuition * TUITION_INC_YR2)
        print('Tuition Year ', current_yr, ': $', format(tuition, '.2f'), sep='', end='')
        current_yr += 1
        next_year_inc = next_year_inc + TUITION_INC_PCT
        # Following line added for DEBUG purpose
        print('\tNext Year Expected Increase: {:.2%}'.format(next_year_inc))
    else:
        # Print the tuition for years 3-10
        tuition = tuition + (tuition * next_year_inc)
        print('Tuition Year ', current_yr, ': $', format(tuition, '.2f'), sep='', end='')
        current_yr += 1
        next_year_inc = next_year_inc + TUITION_INC_PCT
        # Following line added for DEBUG purpose
        print('\tNext Year Expected Increase: {:.2%}'.format(next_year_inc))


# Print Footer
print(HEAD_FOOT * 70)
print("End of program")
