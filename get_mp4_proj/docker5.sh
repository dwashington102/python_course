#!/usr/bin/env bash

:<<'COMMENTS'
Script sets tags using the values in arr
-- downloads index.html from Site 
-- Locate docker image repo: getmp4
-- Builds docker container using using existing volume (-v) and passing command: ${getUrl}/tags/${myTag}
-- Moves TEMPDIR to /data/{timestamp}

Where getUrl is site
tags = secondary entry at site
myTag is arr value

Requirements:
- Install podman (docker may work, but podman should be used)
- Create podman volume "mydb": podman volume create mydb

EXIT CODES:
   1: Container image "getmp4" NOT FOUND
   2: podman nor docker is installed 
   3: Name of download file is not index.html 
   148: wget failed to pull index file


# Site:
# m_ot
COMMENTS

#Changes
# 2022-05-02; Added search_item()
# 2022-04-24: Updated docker run command changing "tags" to "term"

loopCount=$((RANDOM % 10 + 1))
declare -ag ar_search=()

MAIN() {
    loginit=1
    create_log
    loginit=1 && log_message
    func_set_dockercmd
    func_getUserUrl
    func_search_items
    func_get_imageId
    func_run
    loginit=99 && log_message
}

create_log() {
    if [[ "$(id -u)" == 0 ]]; then
        logdir="/var/log/custom"
    else
        logdir="/var/tmp/custom"
    fi

    dts=$(date +"%Y%m%d_%H%M%S")

    if [ ! -d ${logdir} ]; then
        /usr/bin/mkdir -p ${logdir} &>/dev/null
    fi

    if [ -d "${logdir}" ]; then
        logfile="${logdir}/runtime_${dts}.log"
    else
        logfile="$HOME/runtime_${dts}.log" # Fall back location
    fi

    # Create log file
    if ! /usr/bin/truncate -s0 "${logfile}"; then
        printf "Unable to create log file %s...exit(102)" "${logfile}"
        exit 102
    fi
}


log_message(){
    local message
    if [ ${loginit} == 1 ]; then
        message="Starting application"
        loginit=$((loginit + 1))
    elif [ ${loginit} == 99 ]; then
        message="Completed application"
    else
        message="$1"
    fi

    printf "%s: $message\n" "$(date --rfc-3339=seconds)" >> "${logfile}"
}
# End Common functions

func_set_dockercmd () {
    log_message "${FUNCNAME[0]}()"
    if which docker &> /dev/null; then
        DOCKERCMD='docker'
    elif which podman &>/dev/null; then
        DOCKERCMD='podman'
    else
        log_message "docker nor podman command found on server"
        log_message "Install the required packages...exit 2"
        printf "docker nor podman command found...exit 2"
        printf "see log %s" "${logfile}"
        exit 2
    fi
    log_message "\tpkg name: ${DOCKERCMD}"
}

func_search_items (){
    log_message "${FUNCNAME[0]}()"
    unset itemCount
    unset loopCount
    local itemCount=0 # sets search to be a min. of 1 item
    local loopCount=1

    read -p "Provide number of search items (1-9): " itemCount
    re='^[1-9]+$'
    if ! [[ $itemCount =~ $re ]] ; then
        log_message "itemCount: (${itemCount}) -> invalid -> exit 101" 
        printf "Entered value (%s) is not valid...exit 101\n" "${itemCount}" 
        exit 101
    fi


    while [ $loopCount -le $itemCount ]
    do
        read -p "Enter search item number($loopCount): " searchString
        ar_search+=("$searchString")
        ((loopCount++))
    done
    log_message "\tSearch items: ${ar_search[*]}"
}


func_getUserUrl () {
    log_message "${FUNCNAME[0]}()"

    # Storage for Prod
    # dbStorage="$HOME/.local/share/containers/storage/volumes/mydb/_data"

    # Storage for Test
    dbStorage="/tmp/testenv"

    topDir=$(mktemp -p $dbStorage -d)
    if [ -d "${topDir}" ]; then
        pushd "${topDir}" &>/dev/null 
    else
        log_message "Unable to open ${topDir}...exit 106"
        printf "unable to open %s...exit 106\n" "${topDir}"
        exit 106
    fi
    log_message "\tstorage loc: ${topDir}"
    # printf "\nEnter URL: "
    read -rp "Enter URL: " getUrl
    IFS=$'\n'
    if wget --no-check-certificate ${getUrl} -O index.html &>/dev/null; then
        if ! ls -1 index.html > /dev/null 2>&1; then
            log_message "\tDownload file name is not index.html...exit 3"
	    exit 3
        else
            log_message "\tDownload file name is index.html...beginning to process"
        fi
    else
        log_message "\twget failed to pull index from ${getUrl}"
        log_message "\tConfirm the correct URL...exit 148"
        printf "wget failed to pull index from ${getUrl}...exit 148\n"
        printf "\u26d4 see log: %s \u26d4\n" "${logfile}"
        exit 148
    fi
    log_message "\tindex.html from target url: (${getUrl})"
}


func_get_imageId() {
    log_message "${FUNCNAME[0]}()"
    # Gather a list of docker images repo name "getmp4"
    if $DOCKERCMD images -n | grep -m1 getmp4  &>/dev/null; then
	# Added grep -m1 in order to restrict the number of images being returned
        get_imgId=$($DOCKERCMD images -n | grep -m1 getmp4  | awk '{print $3}')
        log_message "\tContainer being built with image: ${get_imgId}"
        log_message "\tCurrent running containers:"
        ps_result=$($DOCKERCMD ps)
        log_message "\t$ps_result"
    else
	    log_message "\tUnable to locate required Container Image...exit 105"
	    exit 105
    fi
}


func_run() {
    log_message "${FUNCNAME[0]}()"
    unset podCount
    podCount=1
    for myTag in "${ar_search[@]}"
    do
        log_message "\tRetrieving: ${myTag}"
        log_message "\tCreating Docker Container"
        # docker run statement is adding an arguement after the Image-ID
        if podman ps | command grep -E " v${podCount}$" &>/dev/null; then
            # Using randopod allows startup of multiple docker5 procs
            randopod=$((RANDOM % 100 + 1))
            log_message "\tSelecting random number for container: ${randopod}\n"
            mkdir_result00=$(mkdir -vp "$topDir/$randopod/$myTag")
            log_message "\tmkdir_00: $mkdir_result00"
            $DOCKERCMD container run -d -m 512M --env TERM=dumb --rm --name ${getUrl}v${randopod} -w "/data" -v $topDir/$randopod/$myTag:/data ${get_imgId} ${getUrl}/term/${myTag}
        else
            mkdir_result01=$(mkdir -vp "$topDir/$podCount/$myTag")
            log_message "\tmkdir_01: $mkdir_result01"
            log_message "\tSelecting podcount number for container: ${podCount}\n"
            $DOCKERCMD container run -d -m 512M --env TERM=dumb --rm --name ${getUrl}v${podCount} -w "/data" -v $topDir/$podCount/$myTag:/data ${get_imgId} ${getUrl}/term/${myTag}
        fi
        podCount=$((podCount + 1))
        sleep 3
    done
    $DOCKERCMD ps
}

MAIN
