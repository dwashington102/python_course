#!/usr/bin/sh

:<<'COMMENTS'
Script prompts user to select a Virtual Manager Session ("user" or "system"),
gathers a list of XML files associated with the session, and prompts user to
select which XML file to parse.

Using the select XML file, the script pulls a list of XML tags from the XML file,
prompts the user to select a tag, and then pulls tag information from the file,
and displays tag info to the console

Exit Codes:
1 - func_get_session(): Attempt to run script as root
2 - func_get_session(): Invalid session name received
3 - func_select_xml():  Invalid selection of XML files
4 - func_ls_vms():  vmdir does not exists
5 - func_ls_vms():  vmdir does not contain XML files
7 - func_get_tags(): No tags found in XML file
8 - func_tag_select(): Invalid selection of tag name
COMMENTS


func_get_session (){
    # Function requests user input and confirms userid
    shopt -s nocasematch
    printf '\nIs Virtual Machine a "User" or "System" Session\n'
    printf 'Type "user" or "system"\t'
    read get_session

    if [[ "$get_session" == "system" ]]; then
        if [[ $(id -u) != 0 ]]; then
            printf "To view System Virtual Machines\n"
            printf "Script must be ran as root...exit (1)\n"
            exit 1
        fi
        vmdir="/etc/libvirt/qemu"
    elif [[ "$get_session"  == "user" ]]; then
        vmdir="$HOME/.config/libvirt/qemu"
    else
        printf "Invalid session entered...exit(2)\n"
        exit 2
    fi
}


func_ls_vms (){
    if [[ ! -d ${vmdir} ]]; then
        printf "${get_session} - ${vmdir} does not exists...exit(4)\n"
        exit 4
    fi

    if ! pushd ${vmdir} &>/dev/null; then
        printf "Unable to cd to ${vmdir}...exit(100)"
        exit 100
    fi

    printf "\nList of Virtual Machines for userid $(id -un)"
    printf "\n=========================================="
    listFiles=( $(command ls -1 ${PWD} | command grep --regexp='.*.xml$')) 
    if [[ ${#listFiles[*]} -eq 0 ]]; then
        printf "\nNo XML files found in ${vmdir}...exit(5)\n"
        exit 5
    fi

    xmlloopCount=0
    for eachxml in ${listFiles[@]}
    do
        xmlloopCount=$((xmlloopCount+1))
        printf "\n${xmlloopCount}: ${eachxml}"
    done
}


func_select_xml (){
    printf "\n"
    printf "\nSelect number associated with XML file:\t"
    read xmlnum
    if [[ "$xmlnum" -lt 1 || "$xmlnum" -gt "$xmlloopCount" ]]; then
        printf "\nInvalid selection...exit(3)"
        exit 3
    fi
    arraynum=$((xmlnum-1))
    xmlname=${listFiles[arraynum]}
}


func_get_tags (){
# Loops through the XML file pulling the tags
# Example of "cpu" tag in XML file
#      <cpu mode='host-model' check='partial'/>
#        <clock offset='utc'>
#         <timer name='rtc' tickpolicy='catchup'/>
#         <timer name='pit' tickpolicy='delay'/>
#         <timer name='hpet' present='no'/>

    IFS=$'\n'
    taglist=( $(command grep -E ^"\s{2}<" ${domainxml} | command grep -v -E "\s{2}</") )
    lentaglist=${#taglist[@]}
    if [[ "$lentaglist" == "0" ]]; then
        printf "\nNo tags found in ${domainxml}...exit(7)\n"
        exit 7
    fi

    printf "Available XML Tags in ${domainxml}:"
    tagloopCount=0
    for tagraw in ${taglist[@]}
    do
    tagloopCount=$((tagloopCount+1))
        if echo "${tagraw}" | command grep -E "</" &>/dev/null; then
            taglabel=$(echo "${tagraw}" | awk -F'[<>]' '{print $2}' | awk '{print $1}')
        else
            taglabel=$(echo "${tagraw}" | awk -F'[<>]' '{print $2}' | awk '{print $1}')
        fi
    printf "\n${tagloopCount}: ${taglabel}"
    done
    printf "\n"
}


func_select_tag (){
    printf "\n"
    printf "\nSelect number associated with TAGNAME:\t"
    read tagnum
    if [[ "$tagnum" -lt 1 || "$tagnum" -gt "$tagloopCount" ]]; then
        printf "\nInvalid selection...exit(8)"
        exit 8
    fi
    arraytag=$((tagnum-1))
    tagname=${taglist[arraytag]}
}


main (){
    if [[ -f "${domainxml}" ]]; then
        export get_session="Custom"
        func_get_tags
        func_select_tag
    else
        if [[ $(id -u) != "0" ]]; then
            func_get_session
        else
            vmdir="/etc/libvirt/qemu"
            get_session="System"
        fi

        func_ls_vms
        func_select_xml

        # Set the absolute path to the VM XML file
        domainxml="${vmdir}/${xmlname}"


        func_get_tags
        func_select_tag
    fi

    printf "\nSession Type:\t${get_session}"
    printf "\nXML Filename:\t${domainxml}"
    printf "\n-----------------------\n"
    printf "XML Tag Info:\n"
    finaltag=$(echo ${tagname} | awk -F'[<>]' '{print $2}' | awk '{print $1}')
    echo "${tagname}" | command grep -E "\/" &>/dev/null
    if [[ "$?" == "0" ]]; then
        printf "Single Line Output for tag: ${finaltag}\n"
        grep "${tagname}" "${domainxml}"
    else
        printf "Multi Line Output for tag: ${finaltag}\n"
        sed -n "/<${finaltag}.*>/,/<\/${finaltag}.*>/p" "${domainxml}"
    fi
    printf "\n\n"
}

if [[ ! -z "$1" ]]; then
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
            printf "Program parses Virtual Machine XML File."
            printf "\nRunning the script without -f flag prompts for the XML filename"
            printf "\n\nUsage : vm_parse_xmlfile.sh [options] XMLFILENAME"
            printf "\n  -h, --help   Print this help text"
            printf "\n  -f, --file   XML File name\n"
            exit 0
    elif [[ "$1" == "--file" || "$1" == "-f" ]]; then
            domainxml=("$2")
            if [[ -z "${domainxml}" ]]; then
                 printf "Missing filename"
                 printf "\n  -f  --file   XML File name\n"
                 exit 0
            fi
    else
            printf "$0: Invalid option -- '${1}'\n"
            printf "Try '$0 --help'\n"
            exit 0
    fi
fi

main
