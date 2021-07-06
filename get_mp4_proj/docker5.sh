#!/usr/bin/env bash
# Purpose: Create a docker container runs get_mp4_index.sh
# The URL being passed on the 'docker container run...' line should include a valid URL followed by "/tags/"
# 
# Updated: Mon 05 Jul 2021 07:46:47 PM CDT
# 

loopCount=1

declare -a arr=("tag1" "tag2" "tag3")

for myTag in "${arr[@]}"
do
    printf "\nCreating Docker Container"
    docker container run -d --rm --name TESTDB_${loopCount} -w "/data/today/`date +%Y%m%d_%H%M%S`" -v opendb:/data IMAGE-ID www.URL.com/tags/${myTag}
    loopCount=$((loopCount + 1))
    sleep 3
done
docker ps

exit 0
