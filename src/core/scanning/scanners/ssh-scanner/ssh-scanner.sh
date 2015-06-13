#!/bin/bash
#
#   File:  ssh-scanner.bash
#   Author:  Marvin Smith
#   Date:    12/13/2013
#

#----------------------------#
#-     Global Variables     -#
#----------------------------#
VERBOSE=0
ADDRESS=''
ADDRESS_SET=0

#---------------------------------------#
#-     Print Usage Instructions        -#
#---------------------------------------#
Usage()
{
    echo ''
    echo "usage: $0 <ip-address> [options]"
    echo ''
    echo '-h | --help     : Print usage instructions and exit.'
    echo '-v | --verbose  : Print verbose output.'
    echo ''
    exit 0
}

#----------------------------------------#
#-     Parse Command-Line Arguments     -#
#----------------------------------------#
for ARG in "$@"; do
    case $ARG in

        #  Check if user requested help
        '-h'|'--help')
            Usage
            ;;

        #  Check if the user wants verbose output
        '-v'|'--verbose')
            VERBOSE=1
            ;;

        #  Otherwise, there was an error
        *)
            #If address not set, then set it
            if [ "$ADDRESS_SET" = '0' ]; then
                ADDRESS_SET=1
                ADDRESS=$ARG

            else
                echo "error: Unknown argument ($ARG)"
                Usage
            fi
            ;;
    esac
done

#  Declare the NC Options
NC_OPTIONS='-L 1 -v'

#  Run the command on the input address with ncat
OUTPUT=$(echo 'dummy' | nc $NC_OPTIONS $1 22 2>&1 )

if [ "${OUTPUT/SSH}" == "SSH" ]; then
    exit 0
else
    exit 1
fi

