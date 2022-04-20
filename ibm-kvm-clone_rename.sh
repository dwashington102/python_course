#!/usr/bin/bash

:<< 'COMMENT'
We have a list of RPMs with this naming convention
ibm-kvm-clone-win10-aw-20210715-1.x86_64.rpm
ibm-kvm-clone-win10-ax-20210715-1.x86_64.rpm
ibm-kvm-clone-win10-ay-20210715-1.x86_64.rpm
ibm-kvm-clone-win10-az-20210715-1.x86_64.rpm

We need to rename the rpms to use this naming convention due to locale issues when installing the packages
ibm-kvm-clone-win10-025-20210715-1.x86_64.rpm
ibm-kvm-clone-win10-026-20210715-1.x86_64.rpm
ibm-kvm-clone-win10-027-20210715-1.x86_64.rpm
COMMENT

count=1
pushd $HOME/tmp
get_pkg_names=( $(find . -type f -name '*.rpm' -exec basename {} \;) )

if [ ${#get_pkg_names[*]} -gt 0 ]; then
        for pkg_name in ${get_pkg_names[*]}
        do
            printf "\n%s - Pkg Name: %s"  "$count" "$pkg_name"
            name_count=`printf %03d%s ${count}`
            # This is CRITICAL. When using [[:alpha:]], [[:digit:]], etc the sed string replacement MUST be
            # in double quotes
            new_name=$(echo $pkg_name | sed "s/-a[[:alpha:]]-/-$name_count-/")
            printf "\n\t\t - New Name: %s\n" "$new_name"
            # mv "$pkg_name" "$new_name"    # <<<<----Uncomment this line in order to rename files
            count=$((count +1))
        done
        printf "\n"
fi

