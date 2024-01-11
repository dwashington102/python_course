#!/bin/bash
'''
Script will take a list of RPM files returned in pkglist[@] and then confirm if the 
pkgname is installed on the device.

Format for the list of RPM files in the yum directory:
xorg-x11-xauth-1.0.9-12.el8.x86_64.rpm
xorg-x11-xinit-1.3.4-18.el8.x86_64.rpm
xorg-x11-xkb-utils-7.7-28.el8.x86_64.rpm
yajl-2.1.0-12.el8.x86_64.rpm
zenity-3.28.1-2.el8.x86_64.rpm

'''

echo 'Installing required packages'
rpm -e ibm-dnf-plugins --nodeps --noscripts > /dev/null 2>&1 ||:
yum -y localinstall yum/*.rpm --disablerepo=* > /dev/null 2>&1 ||:
IFS=$'\n'
pkglist=( $(find ./yum -type f -name '*.rpm' -exec basename {} \; | awk -F'-[[:digit:]]' '{print $1}') )
for pkg in ${pkglist[*]}
do
    if /usr/bin/rpm -qi --quiet $pkg &>/dev/null; then
        printf "Install for $pkg: ✅\n"
    else
        printf "Install for $pkg: ❌\n"
    fi
done
