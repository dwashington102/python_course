#!/usr/bin/bash
# Create Date: 2022-01-14
# Purpose: Script is used to call the git_pull_startup.sh script, which updates the local GIT repos on the computers
# Script is called from p340-raptor and ran against test machines in order to keep test machines GIT repos updated

# Changes:

K430USER=k430user
X1USER=x1user
WORKUSER=washingd

declare -a HostList=("k430-raptor" "x1-raptor" "192.168.122.226")
declare -a UserList=("k430user" "x1user" "washingd")

testConnection () {
    printf "\nTesting Connection to Computers..."
    printf "\n"
    userCount=0
    for myhost in "${HostList[@]}"
        do
            ping -c3 -i1 $myhost &>/dev/null
            if [ $? == 0 ]; then
                printf "\nSuccess --->\tHOST: "$myhost" User: ${UserList[$userCount]}" 
                ssh ${UserList[$userCount]}@$myhost '~/bin/git_pull_startup.sh'
            else
                printf "\nFailure --->\tHOST: "$myhost" User: ${UserList[$userCount]}" 
            fi
            userCount=$((userCount + 1))
        done
}

MAIN (){
    printf "\n"
    testConnection
    printf "\n"
}

MAIN
exit 0