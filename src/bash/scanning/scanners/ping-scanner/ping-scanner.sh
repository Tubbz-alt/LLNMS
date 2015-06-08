#!/bin/sh
#
#  File:    ping-scanner.sh
#  Author:  Marvin Smith
#  Date:    12/29/2013
#
#  Purpose:  Performs the ping scan on the system
#

#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    Information Flags:'
    echo '        -h, --help    :  Print usage instructions'
    echo '        -v, --version :  Print version information'
    echo ''
    echo '    Required Flags:'
    echo '        -ip4, --ip4-address [address] : Set the ip4-address'
    echo ''
    echo '    Optional Flags:'
    echo '        -m, --max-tries [integer > 0] : Max number of failures before quitting.'
    echo ''
}


#-------------------------------------#
#-         Warning Function          -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
warning(){

    #  If the user only gives the warning message
    if [ $# -eq 1 ]; then
        echo "warning: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "warning: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "warning: $1.  Line: $2, File: $3"
    fi
}

#-------------------------------------#
#-            Error Function         -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
error(){

    #  If the user only gives the error message
    if [ $# -eq 1 ]; then
        echo "error: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "error: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "error: $1.  Line: $2, File: $3"
    fi
}


#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "`basename $0` Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


#---------------------------------#
#-         Main Function         -#
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info

#  Import the configuration info
. $LLNMS_HOME/config/llnms-config

#  Flags
IP4ADDRESS_FLAG=0
IP4ADDRESS_VALUE=''

MAX_TRIES_FLAG=0
IP4ADDRESS_VALUE='3'

#   Parse Command-Line Options
for OPTION in "$@"; do

    case $OPTION in

        #  Print usage instructions
        '-h' | '--help' )
            usage
            exit 1
            ;;


        #  Print version information
        '-v' | '--version' )
            version
            exit 1
            ;;

        #  Print verbose output
        '-V' | '--verbose' )
            VERBOSE=1
            ;;

        #  Max Tries flag
        '-m' | '--max-tries')
            MAX_TRIES_FLAG=1
            ;;

        #  IP4 Address Flag
        '-ip4' | '--ip4-address' )
            IP4ADDRESS_FLAG=1
            ;;

        #  Process flag values or print error message
        *)
            
            if [ "$MAX_TRIES_FLAG" = '1' ]; then
                MAX_TRIES_FLAG=0
                MAX_TRIES_VALUE="$OPTION"
            
            elif [ "$IP4ADDRESS_FLAG" = '1' ]; then
                IP4ADDRESS_FLAG=0
                IP4ADDRESS_VALUE=$OPTION

            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi

            ;;


    esac
done


#  Build the Ping Command
CMD="ping -c $MAX_TRIES_VALUE $IP4ADDRESS_VALUE"

$CMD

#  Check result
if [ "$?" = '0' ]; then
    exit 0
else
    exit 1
fi


