#!/usr/bin/env sh
# Version: 0.1.0


MAIN (){
    get_getUrl
    get_plugcontent
    clean_up
}


# Functions

# Gather the website URL from user input  
get_getUrl (){
    printf "\nWhich URL: "
    read getUrl
    IFS=$'\n'
    printf "DEBUG >>> ${getUrl}"
    # Pull index.html from URL
    wget ${getUrl}
}


# Extracts php URLs writing each to a file 
# example:
# <div class="plugcontent"><a href="https://www.rURL.com/out.php?id=3600" title="OOPS!" target="_blank"></div>
get_plugcontent (){
grep plugcontent index.html | awk -F"a href" '{print $2}' | awk -F'[""]' '{print $2}' > php_output.txt

# Cat the file performing a wget on each entry in the file.  May need error checking here
mkdir ./php
for myPhp in `cat php_output.txt`
    do
        wget -P ./php ${myPhp}
    done

# For each php  
for myFile in `ls -1 ./php | grep --color=NEVER php`
   do
        grep "source\ src=.*mp4" ./php/${myFile} | awk -F'[""]' '{print $2}' >> mylist.txt
    done

mkdir ./mp4
for get_Download in `cat mylist.txt`
    do
        wget -P ./mp4 ${get_Download}
    done
}

clean_up() {
    rm -rf php_output
    rm -rf index.html
    rm -rf mylist.txt
}

MAIN
exit 0


