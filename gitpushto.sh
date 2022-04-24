# Create Date: 2022-01-14
# Purpose: Script is used to call the git_pull_startup.sh script, which updates the local GIT repos on the computers
# Script is called from p340-raptor and ran against test machines in order to keep test machines GIT repos updated

# Changes:
# Date: Description of change
# 2022-03-23 - Added p50-raptor to @HostList
# 2022-02-04 - Updated MAIN() in order to tee to LOGFILE

tstamp=$(date +%Y%m%d_%H%M%S)
mkdir -p $HOME/logs
LOGFILE=git_pushto_${tstamp}
touch $HOME/logs/$LOGILE
declare -a HostList=("k430-raptor" "x1-raptor" "p340-dove-docker" "p340-dove-fed35" "p50-raptor")
declare -a UserList=("k430user" "x1user" "washingd" "washingd" "p50user")

func_set_colors () {
    bold=$(tput bold)
    blink=$(tput blink)
    offall=$(tput sgr0)
    reverse=$(tput rev)
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    cyan=$(tput setaf 6)
    normal=$(tput setaf 9)
}

func_print_spacer (){
	printf "${normal}"
	printf "\n\n\n"
}

func_testConnection () {
#(
    printf "\nTesting Connection to Computers..."
    printf "\n"
    userCount=0
    for myhost in "${HostList[@]}"
        do
            ping -c3 -i1 $myhost &>/dev/null
            if [ $? == 0 ]; then
                printf "\n${green}Success --->\tHOST: "$myhost" User: ${UserList[$userCount]}"
                func_print_spacer
                ssh ${UserList[$userCount]}@$myhost '~/bin/git_pull_startup.sh'

            else
                printf "\n${red}Failure --->\tHOST: "$myhost" User: ${UserList[$userCount]}" 
                sleep 5
                func_print_spacer
            fi
            userCount=$((userCount + 1))
        done
#) |tee $HOME/logs/$LOGFILE
}

MAIN (){
    (
    func_set_colors
    func_print_spacer
    func_testConnection
    func_print_spacer
    ) | tee $HOME/logs/$LOGFILE
}

MAIN
