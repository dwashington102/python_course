#!/usr/bin/bash

#Script gathers a list of all gsettings schemas and key values
# This is to compare the changes between RHEL8 and RHEL9

LOGFILE=$HOME/gsettings_keys.log

do_work (){
for gschema in $(gsettings list-schemas)
do
    printf "\nSchema: %s" "${gschema}"
    for gkey in $(gsettings list-keys ${gschema})
    do
        printf "\n%s\t%s" "---- Key: ${gkey}" "---> Value: $(gsettings get ${gschema} ${gkey})"
    done
    printf "\n"
done
}


MAIN (){
    printf "\nGathering gsettings keys...\n"
    (
        do_work
    ) > $LOGFILE

}


MAIN
printf "\nGenerated output file: %s\n"  "${LOGFILE}"
printf "\nhead of %s\n\n" "${LOGFILE}"
head -5 "${LOGFILE}"
