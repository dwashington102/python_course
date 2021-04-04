#!/usr/bin/env sh
# Version: 0.1.0


MAIN (){
    get_getUrl
    get_plugcontent
}

get_getUrl (){
    printf "\nWhich URL: "
    read getUrl
    IFS=$'\n'
    printf "DEBUG >>> ${getUrl}"
    wget ${getUrl}
}

get_plugcontent (){
grep plugcontent index.html | awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}' > php_output.txt
for myPhp in `cat php_output.txt`
    do
        wget ${myPhp}
    done

for myFile in `ls -1 | grep --color=NEVER php`
   do
        grep "source\ src=.*mp4" ${myFile} | awk -F'[""]' '{print $2}' >> mylist.txt
    done

for get_Download in `cat mylist.txt`
    do
        wget -P ./tmp ${get_Download}
    done
}

MAIN
exit 0


