#!/usr/bin/bash
# Script confirms if the security solution is running on user machines


func_get_os (){
    command -v hostnamectl
    if [ $? == "0" ]; then
        os_fedora=$(command hostnamectl | command grep -E 'Operating System' | command grep Fedora)
    if [ -z "${os_fedora}" ]; then
            os_redhat=$(command hostnamectl | command grep -E 'Operating System' | command grep -E 'Red Hat|Alma|Cent')
            if [ -z ${os_redhat} ]; then
            printf "\nInvalid Operating System: $(command hostnamectl | command grep -E 'Operating System')\n"
        exit 1
        fi
    fi
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
    systemctl is-enabled SERVICE -q
#}

#func_is_service_running (){
    systemctl is-active SERVICE -q
#}

#func_install_service (){
#}


MAIN (){
    func_get_os
}


MAIN
