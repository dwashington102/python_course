#!/usr/bin/sh
:<<'COMMENTS'
Script copies file to the Production machines on the network


Exit Codes:
101 - check_copyfile(): $copyfile NOT FOUND
COMMENTS

check_copyfile (){
copyfile=$HOME/keydb_20190510.kdbxDEBUG
if [ ! -f $copyfile ]; then
    printf "$copyfile NOT FOUND...exit(1)\n"
    exit 101
fi
}


do_scp (){
declare -a raptors=("k430-raptor" "x1-raptor" "p50-raptor")
IFS=$'\n'
for target in ${raptors[@]}
do
     baseuserid=$(basename --suffix=-raptor "$target")
     userid="$baseuserid""user"

    ping -W2 -c1 -i1 ${target} &>/dev/null
    if [ "$?" == "0" ]; then 
        printf "scp to ${target}\n"
        scp ${copyfile} ${userid}@${target}:~/.
    else
        printf "Unable to reach ${target}\n"
    fi
done
}


main (){
    check_copyfile
    do_scp
}

main
