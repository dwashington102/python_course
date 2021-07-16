# Make a two player Rock-Paper-Scissors game.  Ask for the players’ names. On each play, have
# the players enter their move choice (rock, paper, or scissors). Then compare the moves,
# and print out the players’ moves, a message of congratulations to the winner,
# and ask if the players want to play again.
#
# Keep a running total of the wins/losses for each player, and when the players end the game,
# print out the final wins / losses results for the players.
# Remember the game rules:
# - Rock beats scissors
# - Scissors beats paper
# - Paper beats rock

# Import required modules
import random


# Define GLOBAL CONSTANTS
DISPLAY_SPACER = "="                            # Set character "=" used for header


# Print the banner header
def display_menu():
    print(DISPLAY_SPACER * 50)
    print('Rock Paper Scissor Game')
    print(DISPLAY_SPACER * 50)


# start_game() gathers the user name(s) and calls get_*_players functions
def start_game():
    stop_game = 'start'
    while stop_game != 'y':
        print()
        print('How many players for the game?')
        print('Choices')
        print('Player-1 vs. Computer::\t<  Select 1  > ')
        print('Player-1 vs. Player-2::\t<  Select 2  > ')
        print()

        try:
            num_of_players = int(float(input('Enter # of player(s): ')))
        except ValueError:
            print('Value entered must be an integer')
            continue

        if num_of_players == 1:
            get_one_player()
        elif num_of_players == 2:
            get_two_player()
        else:
            print('\nInvalid Entry...try again!')
        print()
        stop_game = input('Do you want to end game (y/n): ').lower()
        print()


# get_one_player function takes user input for Player_1 while setting player_2 to Computer passing to play_game_1p()
def get_one_player():
    player_1 = input('Player 1 Name: ').capitalize()
    player_2 = "Computer"
    print()
    play_game_1p(player_1, player_2)


# get_two_player function takes user input for player_1  and player_2 and passes to play_game_2p ()
def get_two_player():
    player_1 = input('Player 1 Name: ').capitalize()
    player_2 = input('Player 2 Name: ').capitalize()
    print()
    play_game_2p(player_1, player_2)


# play_game_1p() requests player_1 variable, sets total wins for each user to 0,
# creates options_list[], sets play_again sentinel value, and plays rock-paper-scissors
def play_game_1p(player_1, player_2):
    total_p1_wins = 0
    total_p2_wins = 0
    total_games = 0
    options_list = ['rock', 'paper', 'scissors']
    play_again = 'y'

    while play_again == 'y':
        print()
        p1_move = input('Player-1 {}: rock, paper, or scissors  : '.format(player_1)).lower()

        # Confirm p1_move is valid before continuing program
        if p1_move != 'rock' and p1_move != 'paper' and p1_move != 'scissors':
            print('Invalid selection')
            print('Try again')
            continue
        else:
            pass

        #  Setting random_play to a random integer (0-2) and calling items in options_list based on
        #  random integer
        random_play = random.randint(0, 2)
        p2_move = options_list[random_play]

        # Using random item selected from the options_list, set Player-2 move
        print('Player-2 move = ', p2_move)
        print()

        if p1_move == p2_move:
            print("Player 1 Move", p1_move)
            print("Player 2 Move", p2_move)
            print('We have a tie')
        elif p1_move == 'rock':
            if p2_move == 'paper':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1
        elif p1_move == 'scissors':
            if p2_move == 'rock':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1
        else:
            #p1_move == 'paper'
            if p2_move == 'scissors':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1
        #else:
            #print('Invalid entry received.  Try again')

        print()
        total_games += 1
        play_again = input('Do you want to play again? (y/n): ').lower()
    final_results(player_1, player_2, total_p1_wins, total_p2_wins, total_games)


# play_game_2p accepts player_1 and player_2 variables sets total wins for each user to 0,
# creates options_list[], sets play_again sentinel value, and plays rock-paper-scissors
def play_game_2p(player_1, player_2):
    total_p1_wins = 0
    total_p2_wins = 0
    total_games = 0
    play_again = 'y'

    while play_again == 'y':
        print()
        p1_move = input('Player-1 {}: rock, paper, or scissors: '.format(player_1)).lower()
        if p1_move != 'rock' and p1_move != 'paper' and p1_move != 'scissors':
            print('Invalid selection')
            print('Try again')
            continue
        else:
            pass
        p2_move = input('Player-2 {}: rock, paper, or scissors: '.format(player_2)).lower()
        if p2_move != 'rock' and p2_move != 'paper' and p2_move != 'scissors':
            print('Invalid selection')
            print('Try again')
            continue
        else:
            pass
        print()

        if p1_move == p2_move:
            print("Player 1 Move", p1_move)
            print("Player 2 Move", p2_move)
            print('We have a tie')
        elif p1_move == 'rock':
            if p2_move == 'paper':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1

        elif p1_move == 'scissors':
            if p2_move == 'rock':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1

        elif p1_move == 'paper':
            if p2_move == 'scissors':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1
        else:
            print('Invalid entry received.  Try again')

        print()
        total_games += 1
        play_again = input('Do you want to play again? (y/n): ').lower()
    final_results(player_1, player_2, total_p1_wins, total_p2_wins, total_games)


def do_battle(player_1, player_2, p1_move, p2_move):
    total_p1_wins = 0
    total_p2_wins = 0
    total_games = 0
    loop_count = 1

    while loop_count <= 7:
        if p1_move == p2_move:
            print("Player 1 Move", p1_move)
            print("Player 2 Move", p2_move)
            print('We have a tie')
        elif p1_move == 'rock':
            if p2_move == 'paper':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1
        elif p1_move == 'scissors':
            if p2_move == 'rock':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1
        elif p1_move == 'paper':
            if p2_move == 'scissors':
                print('Player 2 wins!')
                total_p2_wins += 1
            else:
                print('Player 1 wins!')
                total_p1_wins += 1
        else:
            print('Invalid entry received.  Try again')
        print('End of loop: ', loop_count)
        loop_count += 1
        total_games += 1
    play_again = input('Do you want to play again? (y/n): ').lower()
    final_results(player_1, player_2, total_p1_wins, total_p2_wins, total_games)


def final_results(player_1, player_2, total_p1_wins, total_p2_wins, total_games):
    print()
    print(DISPLAY_SPACER * 50)
    print('Total Games Played: {}'.format(total_games))
    print('Player-1 {} '.format(player_1), 'Total Wins: ', total_p1_wins, sep='')
    print('Player-2 {} '.format(player_2), 'Total Wins: ', total_p2_wins, sep='')
    print(DISPLAY_SPACER * 50)
    print()


def main():
    display_menu()
    start_game()
    #final_results(player_1, player_2, total_p1_wins, total_p2_wins)

main()
print('end of program')

