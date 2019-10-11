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

# Define GLOBAL CONSTANTS
DISPLAY_SPACER = "="


def main():
    display_menu()
    get_players()


def display_menu():
    print(DISPLAY_SPACER * 50)
    print('Rock Paper Scissor Game')
    print(DISPLAY_SPACER * 50)


def get_players():
    player_1 = input('Player 1 Name: ')
    player_2 = input('Player 2 Name: ')
    print()
    play_game(player_1, player_2)


def play_game(player_1, player_2):
    total_p1_wins = 0
    total_p2_wins = 0
    play_again = 'y'
    while play_again != 'n':
        p1_move = input('Player-1 enter rock, paper, or scissors: ')
        p2_move = input('Player-2 enter rock, paper, or scissors: ')

        if p1_move == p2_move:
            print("Player 1 Move", p1_move)
            print("Player 2 Move", p2_move)
            print('We have a tie')
        else:
            if p1_move == 'rock':
                if p2_move == 'paper':
                    print('Player 2 wins!')
                    total_p2_wins +=1
                else:
                    print('Player 1 wins!')
                    total_p1_wins +=1
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

            print('DEBUG >>> p1 wins', total_p1_wins)
            print('DEBUG >>> p2 wins', total_p2_wins)
            play_again = input('Do you want to play again (y/n): ')

    print()
    print('Player-1 {} '.format(player_1), 'Total Wins: ', total_p1_wins, '.', sep='')
    print('Player-2 {} '.format(player_2), 'Total Wins: ', total_p2_wins, '.', sep='')


main()
print()
print('end of program')


