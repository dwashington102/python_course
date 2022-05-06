#!/usr/bin/bash


<<'COMMENTS'
Script checks the status of installed BigFix Components
COMMENTS


initDir='/etc/init.d'
declare -a besList=("")

get_components (){
        besList=($ (find . -maxdepth 1 -name "bes*" -type f -exec basename {} \;) )
        if [ ${#besList[@]} -eq 0 ]; then
            printf "No BigFix Componets found in %s\n" "$initDir"
            exit 1
        fi
}

check_status (){

}

MAIN (){
    pushd "$initDir"
    get_components
}

MAIN


