#!/usr/bin/env bash


get_ext () {
    printf "Input Ext.:\t"
    read ext_type

}

get_files() {
IFS=$'\n'
ls -1 *.${ext_type} > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    printf "\nNo ${ext_type} files found in current directory.\n"
else
    file_count=1
    for get_fileName in `ls -1 *.${ext_type} `
	do
        if [[ $? -eq 1 ]]; then
		   printf "\nls command failed after initially running successfully."
		   exit 1
        else
            printf "\nFile Number: (${file_count})\t File Name: ${get_fileName}"
            printf "\nRename actions: mv ${get_fileName} ${file_count}.${ext_type}"
            mv ${get_fileName} ${file_count}.${ext_type}
            printf "\n"
            sleep 3
            file_count=$((file_count+1))
        fi
    done
fi        
}


MAIN (){
    get_ext
    get_files
}


MAIN