e!/bin/sh
# 
# Script checks the BigFix servers for the following:
: <<'COMMENTS'
TIMEZONE
/etc/opt/BESClient/actionsite.afxm
BES rpm packages installed
COMMENTS


func_get_server (){
    for get_bigfix_server in $(command grep bigfix_ssh ~/.zshenv | awk -F"@" '{print $2}' | awk -F"\\'" '{print $1}' 2>/dev/null)
    do
        printf "\nInformation for ${get_bigfix_server}:\t"
        ssh -q mesadmin@${get_bigfix_server} 2>/dev/null 'printf "\nTimezone:\t" ; timedatectl | command grep Time\ zone | grep -v TMOUT && ls -l /etc/opt/BESClient | grep -v ^total && printf "RPM info:\n" && rpm -qa | grep ^BES && printf "\nUptime:\t" ; uptime'
    done
}

MAIN (){
    func_get_server
}

MAIN
