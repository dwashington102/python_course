# Comment section

# GLOBAL CONSTANTS
TUITION_INC = .05
TUITION_INC_YR2 = .04
TUITION_INC_PCT = .005
TOTAL_YEARS = 10
HEAD_FOOT = "-"


# Define Variables
tuition = 15000.0
set_year = 1

# Print Header
print(HEAD_FOOT * 70)
print('Hunterville College Projected Tuition Rate for Next 10 Years')
print(HEAD_FOOT * 70)

# Print the tuition for year #1
print('Tuition Year ', set_year, ': $', format(tuition, '.2f'), sep='', end='')
print('\tNext Year Expected Increase: {:.2%}'.format(TUITION_INC_YR2))

# Increment year counter
set_year += 1

# Increment tuitution increase percentage
next_year_inc = TUITION_INC_YR2

# WHILE loop prints the tuition for years 2 - 10
while set_year <= 10:
    # Print the tuition for year 2
    if set_year == 2:
        tuition = tuition + (tuition * TUITION_INC_YR2)
        print('Tuition Year ', set_year, ': $', format(tuition, '.2f'), sep='', end='')
        set_year += 1
        next_year_inc = next_year_inc + TUITION_INC_PCT
        print('\tNext Year Expected Increase: {:.2%}'.format(next_year_inc))
    else:
        # Print the tuition for years 3-10
        tuition = tuition + (tuition * next_year_inc)
        print('Tuition Year ', set_year, ': $', format(tuition, '.2f'), sep='', end='')
        set_year += 1
        next_year_inc = next_year_inc + TUITION_INC_PCT
        print('\tNext Year Expected Increase: {:.2%}'.format(next_year_inc))


# Print Footer
print(HEAD_FOOT * 70)
print("End of program")

