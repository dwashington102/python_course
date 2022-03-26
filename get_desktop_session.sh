#!/bin/bash 

func_get_xdisplay (){
	   # bes_userid=$(env | command grep -m1 -E '(USER.*=|LOGNAME=)' | awk -F'=' '{print $2}')
       # Set bes_userid to only use first 6 characters of the USERNAME or LOGNAME due to 'w -h' command truncating user names
	   bes_userid=$(env | command grep -m1 -E '(USER.*=|LOGNAME=)' | awk -F"=" '{ print substr ($2,1,6) }')
	   running_kde=$(pgrep plasma)
	   if [ -n "$running_kde" ]; then
               get_xdisplay_var=$(w -h | command grep -m1 -E "^$bes_userid.*plasm*" | awk '{print $2}')
               printf "\nCaptured Xsession\n"
               DISPLAY=${get_xdisplay_var}
	       printf "\nDISPLAY=$DISPLAY\n"
	       func_check_zenity
	   else 
               get_xdisplay_var=$(w -h | command grep -m1 -E "^$bes_userid.*session" | awk '{print $2}')
	           if [ ! -z "$get_xdisplay_var" ]; then
                       printf "\nCaptured Xsession\n"
                       DISPLAY=${get_xdisplay_var}
		       printf "\nDISPLAY=$DISPLAY\n"
		       func_check_zenity
		   fi
           fi
}


func_check_gnome (){
    GDESKTOP=""
    ps -u $USER | command grep -E '^.*gnome-session.*$' &>/dev/null
    #ps aux | command grep -E '^.*gnome-session.*$' &>/dev/null
    if [ $? == "0" ]; then
        GDESKTOP="GNOME"
        printf "\nGDESKTOP: $GDESKTOP"
    else
	 return 1
    fi
}

func_check_kde (){
    KDESKTOP=""
    printf "\nDEBUG >>> entered check_kde()\n"
    #ps aux | command grep -E '^.*kded[[:digit:]]$' &>/dev/null
    ps -u $USER | command grep -E '^.*kded[[:digit:]].*$' &>/dev/null
    if [ $? == "0" ]; then
        KDESKTOP="KDE"
        printf "\nKDESKTOP: $KDESKTOP"
    else
	return 1
    fi

}

func_check_xfce (){
    XDESKTOP=""
    ps aux  | command grep -E '^.* xfce[[:digit:]]-session$' &>/dev/null
    if [ $? == "0" ]; then
        XDESKTOP="XFCE"
        printf "\nXDESKTOP: $XDESKTOP"
    else
	return 1
    fi
}

func_check_cinn (){
    CDESKTOP=""
    ps aux | command grep -E '^.* cinnamon-session' | command grep -v grep &>/dev/null
    if [ $? == "0" ]; then
        CDESKTOP="CINNAMON"
        printf "\nCDESKTOP: $CDESKTOP"
    else
	return 1
    fi
}


MAIN (){
   
   func_check_kde
   if [ $? != "0" ]; then
       func_check_cinn
       if [ $? != "0" ]; then
           func_check_xfce
           if [ $? != "0" ]; then
               func_check_gnome
           fi
	fi
   else
         printf "\nKDE DESKTOP FOUND"
   fi
}

MAIN
printf "\n"
exit 0
