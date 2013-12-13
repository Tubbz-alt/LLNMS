#!/bin/bash
#
#   File:  ssh-scanner.bash
#   Author:  Marvin Smith
#   Date:    12/13/2013
#


#  Run the command on the input address with ncat
OUTPUT=$(echo 'dummy' | nc -v $1 22 2>&1 )

if [ "${OUTPUT/SSH}" == "SSH" ]; then
    exit 1
else
    exit 0
fi

