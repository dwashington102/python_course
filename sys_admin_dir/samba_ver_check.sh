#!/usr/bin/bash



<< COMMENT
set_smbd_flag() sets the options based on if the user is running samba 4.14.x or 4.15.x
Starting at 4.15 the "-S" option is no longer valid.

See: https://www.samba.org/samba/history/samba-4.15.0.html

Options removed:
-e|--encrypt
-C removed from --use-winbind-ccache
-i removed from --netbios-scope
-S|--signing
COMMENT

set_smbd_flags (){
command -v /usr/sbin/smbd &>/dev/null
if [ $? == 0 ]; then
	sambaVer=$(/usr/sbin/smbd -V | awk -F"Version " '{ print substr ($2,1,4) }')
	if [ 1 -eq $(echo "4.15 > $sambaVer" | bc -l) ]; then
	    printf "\nSamba Version: $sambaVer is less than 4.15"
	    printf "\nDEBUG >>> Full Version of Samba $(/usr/sbin/smbd -V)"
	    SMBFLAGS="-DFS"
	    printf "\nCommand: $smbcmd\n"
	else
	    printf "\nSamba Version: $sambaVer is at 4.15 or greater"
	    printf "\nDEBUG >>> Full Version of Samba $(/usr/sbin/smbd -V)"
	    SMBFLAGS="-DF --debug-stdout"
	    printf "\nCommand: $smbcmd\n"
	fi
else
	printf "\nSamba is not installed\n"
	exit 1
fi   
}

MAIN (){
	set_smbd_flags
}


MAIN
exit 0
