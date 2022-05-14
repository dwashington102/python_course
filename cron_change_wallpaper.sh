#!/usr/bin/bash

:<<COMMENTS
Script gathers desktop variables in order to launch a cron job
that changes the user's background
COMMENTS

#Environment VARs to gather related to Desktop GUI
#declare -a getDesktopVars=("PATH=" "DISPLAY=" "DESKTOP_SESSION=" "DBUS_SESSION_BUS_ADDRESS")
get_curUser=env | command  grep -m1 -E '(USER=|LOGNAME=)' | awk -F"=" '{print substr ($2,1,6) }'
tStamp=$(date +%Y%m%d_%H%M)
scriptName=`basename "$0"`
logfile=$HOME/cronlogs/cron_run-"$scriptName"_"$tStamp".log



func_setDisplay (){
running_kde=$(pgrep 'kded[[:digit:]]')
running_gnome=$(pgrep 'gnome-session')
running_xfce=$(pgrep 'xfce[[:digit:]]-session')

if [ -n "$running_kde" ]; then
    get_xdisplay_var=$(w -h | command grep -m1 -E "^$get_curUser.*kded[[:digit:]]$" | awk '{print $2}')
    printf "\nCaptured KDE Xsession\n"
    DISPLAY=${get_xdisplay_var}
    printf "\nDISPLAY=$DISPLAY\n"
    #func_zenity
elif [ -n "$running_gnome" ]; then
    get_xdisplay_var=$(w -h | command grep -m1 -E "^$get_curUser.*session" | awk '{print $2}')
    printf "\nCaptured GNOME Xsession\n"
    DISPLAY=${get_xdisplay_var}
    printf "\nDISPLAY=$DISPLAY\n"
    #func_zenity
elif [ -n "$running_xfce" ]; then
    get_xdisplay_var=$(w -h | command grep -m1 -E "^$get_curUser.*xfce[[:digit:]]-session$" | awk '{print $2}')
    printf "\nCaptured XFCE Xsession\n"
    DISPLAY=${get_xdisplay_var}
    printf "\nDISPLAY=$DISPLAY\n"
    #func_zenity

else
    printf "\nFailed to capture Xsession"
    return 1
fi
}

# Function used only for testing.
# Function throws a zenity window to the user's desktop IF get_xdisplay_var is correctly set
func_zenity () {                                                                                                      
zenity --timeout=10 --warning --width=400 --height=200 --text '<b><span foreground="orange">***** THIS COMPUTER IS NOT REGISTERED *****\n</span></b>\nRegistration is required when accessing internal IBM resources.\n\nMinimize all windows and click OK button to launch Registration GUI.\n\nComplete the Registration GUI' &>/dev/null
}

func_changewallpaper (){
PYCMD=$(which python3)
if [ ! -z "$PYCMD" ]; then
    printf "Python command found."
    "$PYCMD" "$HOME"/GIT_REPO/python_course/change_wallpaper.py
else 
    printf "Python command NOT FOUND...exiting"
    exit 1
fi
}


MAIN (){
if [ -d $HOME/cronlogs ]; then
    touch $logfile
else
    mkdir $HOME/cronlogs
    touch $logfile
fi
(
    func_setDisplay
    func_changewallpaper
    printf "\n"
) >> $logfile
}

MAIN
