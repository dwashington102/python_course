#!/usr/bin/env bash
# Script sets tags using the values in arr
# -- downloads index.html from Site 
# -- Locate docker image repo: getmp4
# -- Builds docker container using using existing volume (-v) and passing command: ${getUrl}/tags/${myTag}

# Where getUrl is site
# tags = secondary entry at site

# Site:
# w_ap

# Building Container Details
# Container is built using the following
# - On HOST create /data
#
# - On Host create volume w_ap mount to /data
# ---docker volume  create --driver local --opt type=none --opt device=/data/w_ap --opt o=bind w_ap
#
# - Create Ubuntu image naming "getmp4"
# - Copying ./get_mp4_proj from HOST to Image 
# When connecting to container start in this directory
# WORKDIR /data
# ENTRYPOINT [ "/bin/get_mp4_index.sh" ] 
# --- docker build -t getmp4:v1 --label v1 .

loopCount=1

MAIN() {
    func_test_index
    func_geturl
    func_set_dockercmd
    func_get_imageId
    func_run
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

func_set_dockercmd () {
    which docker > /dev/null 2>&1
    if [ "$?" == "0" ]; then
        DOCKERCMD='docker'
    else
        which podman > /dev/null 2>&1
        if [ "$?" == "0" ]; then
            DOCKERCMD='podman'
        else
            printf "docker nor pomand commands found on server"
            printf "Install the required packages...exiting"
            exit 2
        fi
    fi
}

func_get_imageId() {
    # Gather a list of docker images repo name "getmp4"
    # docker images getmp4 | grep -m1 -v ^REPO  > /dev/null 2>&1
    ${DOCKERCMD} images getmp4 | grep -m1 -v ^REPO  > /dev/null 2>&1
    if [ "$?"  == "0" ]; then
	# Added grep -m1 in order to restrict the number of images being returned
        get_imgId=`docker images | grep -v ^REPO | grep -m1 getmp4 | awk '{print $3}'`
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
    #read -p "Insert Tags separated by 'space': " tagList
    for searchtag in ${taglist[@]}
    do
        printf "\nBuilding container for ${searchtag}"
        printf "\n"
        sleep 1
        #printf "\nCreating Docker Container"
        # docker run statement is adding an arguement after the Image-ID
        #docker container run -d --env TERM=dumb --rm --name ${getUserUrl}v${loopCount} -w "/data/today/`date +%Y%m%d_%H%M%S`_${searchtag}" -v opendb:/data ${get_imgId} ${getUrl}/tags/${searchtag}
        ${DOCKERCMD} container run -d --env TERM=dumb --rm --name ${getUserUrl}v${loopCount} -w "/data/today/`date +%Y%m%d_%H%M%S`_${searchtag}" -v opendb:/data ${get_imgId} ${getUrl}/tags/${searchtag}
        #docker container run -d --env TERM=dumb --rm --name ${getUserUrl}v${loopCount} -w "/data/today/`date +%Y%m%d_%H%M%S`_${myTag}" -v opendb:/data ${get_imgId} ${getUrl}/tags/${myTag}
        loopCount=$((loopCount + 1))
        sleep 3
        printf "\n"
    done
    docker ps
    printf "\n"
}

MAIN
exit 0