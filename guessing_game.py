#Guessing Game (Guess the Number)
#Generate a random number between 1 and 21 (including 1 and 21).
#Provide instructions to the user, and then ask the user to guess the number.
#Tell the user whether they guessed too low, too high, or exactly right.
#Keeps the game going until the user guesses correctly or types “exit”.
#Keep track of how many guesses the user has taken.   When the game ends,
#congratulate the user and tell the user how many guesses where used to win.
#
#Additional functionality:
# 1) Let the user select the maximum number for the range in the game.
# 2) Ask if the user wants to play again, and print the average number of guesses used for all game rounds

# Import required modules
from clear_screen import clear
import random
from colorama import Fore, Back, Style

#Define GLOBAL_CONSTANTS
DISPLAY_SPACER = "="

def main():
    clear()
    display_menu()
    do_work()


# Display a header for the program
def display_menu():
    print(DISPLAY_SPACER * 50)
    print('Guessing the Number Game')
    print(DISPLAY_SPACER * 50)


def do_work():
    end_user_choice = 'Y'
    increment_guess_count = 0
    tot_guess_count = 0
    increment_num_games = 0

    while end_user_choice != 'N':
        # Ask the user for the maximum random number
        try:
            max_rand_value = int(float(input('\nInsert a number that will be used as the maximum guess range: ')))
        except ValueError:
            print(Style.BRIGHT)
            print(Fore.CYAN)
            print('Invalid Value Received')
            print(Style.RESET_ALL)
            continue

        # Set the random number range
        a_random = random.randint(1,max_rand_value)

        # Print game rules
        print('The random number can be any from 1 to {}'.format(max_rand_value))
        print('User now has 5 guesses to determine the random number\n')

        loopcount = 1
        #print('prewhile: DEBUG tot_guess_count {}'.format(tot_guess_count))
        while loopcount <= 5:
            increment_guess_count += 1
            try:
                s_loopcount = str(loopcount)
                print('Attempt #'+ s_loopcount+ ': ', end='')
                get_user_guess = int(float(input('Guess a Number: ')))
            except ValueError:
                print(Style.BRIGHT)
                print(Fore.CYAN)
                print('Invalid Value Received')
                print(Style.RESET_ALL)
                continue

            if get_user_guess == a_random:
                print(Fore.GREEN)
                print('Congratulations!')
                print('You correctly guessed the random number {}'.format(a_random))
                print(Style.RESET_ALL)
                loopcount = 10
            elif get_user_guess > a_random:
                print(Fore.RED)
                print('The guess is too high try again')
                print(Style.RESET_ALL)
            else:
                #get_user_guess < a_random:
                print(Fore.BLUE) 
                print('The guess is too low try again')
                print(Style.RESET_ALL)
            loopcount += 1

        print(Fore.YELLOW)
        print('You reached the guess limit')
        print('The number was: ', a_random)
        end_user_choice = input('\nDo you wish to play again (y/n): ').upper()
        print(Style.RESET_ALL)
        increment_num_games += 1
        tot_guess_count = increment_guess_count

        # If the user decides not to play again add the total number of games played, total number of guesses,
        # and avg. guesses per game
        if end_user_choice != 'Y':
            #print('DEBUG tot_guess_count', tot_guess_count)
            #print('DEBUG increment_num_games', increment_num_games)
            avg_guess = tot_guess_count / increment_num_games
            print(DISPLAY_SPACER * 50)
            print('Total Number of Games Played: {}'.format(increment_num_games))
            print('Total Number of Guess for all Games {}'.format(tot_guess_count))
            print('Avg. number of guesses per game {:.4f}'.format(avg_guess))
            print(DISPLAY_SPACER * 50)

if __name__ ==  "__main__":
    main()

print('End of Game')
