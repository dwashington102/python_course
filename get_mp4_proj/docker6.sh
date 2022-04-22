#!/usr/bin/env bash
# Sets the container name (ex: TESTDB_v1, TESTDB_v2....)
loopCount=$((RANDOM % 50 +1))
trap func_cleanup EXIT

#declare -a my_arrlist=("tag1" "tag2" "tag3" "tag4" "tag5")

MAIN() {
    trap func_cleanup EXIT
    func_set_dockercmd
    func_test_index
    func_geturl
    func_get_imageId
    func_run
}

func_cleanup() {
    rm -rf ./url.txt
    rm -rf ./index.html
}

func_set_dockercmd () {
    which docker > /dev/null 2>&1
    if [ "$?" == "0" ]; then
        DOCKERCMD='docker'
    else
        which podman > /dev/null 2>&1                                                                                                                                       
        if [ "$?" == "0" ]; then
            DOCKERCMD='podman'
        else
            printf "docker nor podmand commands found on server"
            printf "Install the required packages...exiting"
            exit 2
        fi
    fi
}


# test_index() renames ./index.html existing in current directory
func_test_index() { 
    if [ -f "./index.html" ]; then
        printf "index.html exists"
	    mv index.html index.html_`date +%Y%m%d_%H%M`
    else
	    printf "index.html does not exists..."
    fi
}

# Prompts user for URL input using GUI
func_diag_box() {
    dialog --inputbox "Which URL:" 10 50 2>./url.txt
    getUrl=`cat ./url.txt`
    rm -rf ./url.txt
    clear
}

# Prompts user for URL 
func_geturl() {
    type dialog > /dev/null 2>&1
    if [ $? == 0 ]; then
        func_diag_box
    else
    # Prompts user for URL using console text
        printf "\nWhich URL: "
        read getUrl
    fi
    #IFS= will cause problems for taglist array
    #IFS=$'\n' <-----See line above!
    wget --no-check-certificate ${getUrl} -O index.html
    if [ $? -eq 0 ]; then
        ls -1 index.html > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            printf "\nDownload file name is not index.html"
            printf "\n"
	    exit 2
        else
            printf "\nDownload file name is index.html...beginning to process"
            printf "\n"
        fi
    else
        printf "\nwget failed to pull index file"
        printf "\nConfirm the correct URL...exiting."
        printf "\n"
        exit 148
    fi
}


func_get_imageId() {
    # Gather a list of docker images repo name "getmp4"
    $DOCKERCMD images getmp4 | grep -m1 -v ^REPO  > /dev/null 2>&1
    if [ "$?"  == "0" ]; then
	# Added grep -m1 in order to restrict the number of images being returned
        get_imgId=`$DOCKERCMD images | grep -v ^REPO | grep -m1 getmp4 | awk '{print $3}'`
        printf "\nContainer being built with image: ${get_imgId}"
	    printf "\n"
    else
	    printf "\nUnable to locate Image Repository '${get_ImgId}'"
	    exit 1
    fi
}


func_run() {
    declare -a taglist
    read -p "Insert Tags: " taglist
    read -p "Insert Category: "  get_category
    #read -p "Insert Tags separated by 'space': " tagList
    for searchtag in ${taglist[@]}
    do
        printf "\nBuilding container for ${searchtag}"
        printf "\n"
        sleep 1
        #printf "\nCreating Docker Container"
        # docker run statement is adding an arguement after the Image-ID
        $DOCKERCMD container run -d --env TERM=dumb --rm --name ${getUserUrl}v${loopCount} -w "/data/today/`date +%Y%m%d_%H%M%S`_${searchtag}" -v opendb:/data ${get_imgId} ${getUrl}/${get_category}/${searchtag}
        # Line below is working as designed
        #docker container run -d --env TERM=dumb --rm --name ${getUserUrl}v${loopCount} -w "/data/today/`date +%Y%m%d_%H%M%S`_${searchtag}" -v opendb:/data ${get_imgId} ${getUrl}/tags/${searchtag}
        loopCount=$((loopCount + 1))
        sleep 3
        printf "\n"
    done
    $DOCKERCMD ps
    printf "\n"
}

MAIN
exit 0
