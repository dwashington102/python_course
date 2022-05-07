#!/usr/bin/env bash

status=$(service "$besComp" status )
if [[ "$status" == *" is running."* ]]; then
    printf "\n%-20s is %10s" "$besComp" "${greenfg}running${alloff}"
else
    printf "\n%s is %10s${redfg}DOWN${alloff}" "$besComp"
fi

