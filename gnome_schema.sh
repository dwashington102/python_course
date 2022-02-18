#!/usr/bin/bash

#Script gathers a list of all gsettings schemas and key values
# This is to compare the changes between RHEL8 and RHEL9

LOGFILE=$HOME/gsettings_keys.log

do_work (){
for gschema in $(gsettings list-schemas)
do
    printf "\nSchema: ${gschema}"
    for gkey in $(gsettings list-keys ${gschema})
    do
        printf "\n%s\t%s" "---- Key: ${gkey}" "---> Value: $(gsettings get ${gschema} ${gkey})"
        #printf "\n\tKey: ${gkey}\t\t---> Value: $(gsettings get ${gschema} ${gkey})"
    done
    printf "\n"
done
}


MAIN (){
    (
        do_work
    ) | tee $LOGFILE

}


MAIN
exit 0
