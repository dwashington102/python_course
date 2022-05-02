#!/usr/bin/bash

# Variables:

# Arrarys:
unset myFilesLocal
unset myFilesGlobal
declare -a myFilesLocal=()   # Declares a local array
declare -ga myFilesGlobal=()  # Declare a global arrary

func_BUILD_array (){
    myFilesLocal=( $(find . -mindepth 1 -maxdepth 1 -type f -exec basename {} \;))
    myFilesGlobal=( $(find $HOME/.config -mindepth 1 -maxdepth 1 -type f -exec basename {} \;))
    printf "\nDEBUG >>> Dump Array myList from within %s\n\t-%s\n" "${FUNCNAME}" "${myFilesLocal[*]}"
}

func_CALL_array (){
    myFilesGlocal=( $(find . -mindepth 1 -maxdepth 1 -type f -exec basename {} \;))
    printf "\nDEBUG >>> Dump Array myFilesLocal from within %s\n\t-%s\n" "${FUNCNAME}" "${myFilesLocal[*]}"
    printf "\nDEBUG >>> Dump Array myFilesGlobal from within %s\n\t-%s\n" "${FUNCNAME}" "${myFilesGlobal[*]}"
}



MAIN (){
     func_BUILD_array
     func_CALL_array
}


MAIN
