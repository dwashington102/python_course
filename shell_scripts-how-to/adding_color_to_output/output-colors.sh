#!/usr/bin/bash

# Create a function that sets the desired colors
func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    alloff=$(tput sgr0)
    reverse=$(tput rev)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
}



MAIN (){
    func_set_colors
    printf "\n${green}Color GREEN${normal}"
    printf "\n${red}Color RED${normal}"
    printf "\n%sColor CYAN %s\n" "$cyan" "$normal"
}


MAIN
