#!/usr/bin/bash
# Script confirms if the security solution is running on user machines

:<<COMMENT
Confirm if MDAPT

EXIT CODES:
1: hostnamectl command did not return Fedora, Red Hat, Alma, or CentOS
8: MDATP package not installed
127: hostnamectl command not found
COMMENT

func_get_os (){
    hostnamectl &>/dev/null
    if [ $? == "0" ]; then
        printf "\nEntered if"
        os_fedora=$(command hostnamectl | command grep -E 'Operating System' | command grep Fedora)
        if [ -z "${os_fedora}" ]; then
            os_redhat=$(command hostnamectl | command grep -E 'Operating System' | command grep -E 'Red Hat|Alma|Cent')
            if [ -z ${os_redhat} ]; then
            printf "\nInvalid Operating System: $(command hostnamectl | command grep -E 'Operating System')\n"
            exit 1
            fi
        fi
    elif [ "$?" -gt "0" ]; then
        printf "\nCommand hostnamectl NOT FOUND\n"
        exit 127
    else
        os_fedora=$(command cat /etc/os-release | command grep -E ^'NAME' | awk -F'[""]' '{print $2}')
        if [ -z $"{os_fedora}" ]; then
            os_redhat=$(command cat /etc/os-release | command grep -E ^'NAME' | awk -F'[""]' '{print $2}')
            if [ -z ${os_redhat} ]; then
            printf "\nInvalid Operating System: $(command grep -E ^'NAME' | awk -F'[""]' '{print $2}')\n"
            exit 1
            fi
        fi
    fi
}

func_check_rpm_installed (){
    if [ ! -z $"{os_fedora" ]; then
        command rpm --quiet -qi mdatp && echo "MDATP installed" || echo "MDATP NOT FOUND...exiting 8" ; exit 8
    fi
}

#func_is_service_enabled (){
    #systemctl is-enabled SERVICE -q
#}

#func_is_service_running (){
    #systemctl is-active SERVICE -q
#}

#func_install_service (){
#}


MAIN (){
    func_get_os
    func_check_rpm_installed
}


MAIN
