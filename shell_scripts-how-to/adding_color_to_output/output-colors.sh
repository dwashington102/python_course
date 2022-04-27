#!/usr/bin/bash

:<<'TPUTDOC'
URL: https://www.linuxcommand.org/lc3_adv_tput.php

Capname	Description
bold	Start bold text
smul	Start underlined text
rmul	End underlined text
rev	Start reverse video
blink	Start blinking text
invis	Start invisible text
smso	Start “standout” mode
rmso	End “standout” mode
sgr0	Turn off all attributes
setaf <value>	Set foreground color
setab <value>	Set background color

Value	Color
0	Black
1	Red
2	Green
3	Yellow
4	Blue
5	Magenta
6	Cyan
7	White
8	Not used
9	Reset to default color

TPUTDOC

# Create a function that sets the desired colors
func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    alloff=$(tput sgr0)
    reverse=$(tput rev)
    redfg=$(tput setaf 1)
    greenfg=$(tput setaf 2)
    yellowbg=$(tput setab 3)
    cyanbg=$(tput setab 6)
    normal=$(tput setaf 9)
}



MAIN (){
    func_set_colors
    printf "\n${greenfg}Color GREEN${normal}"
    printf "\n${redfg}Color RED${normal}"
    printf "\n%sColor CYAN %s\n" "$cyanbg" "$normal"
}


MAIN
