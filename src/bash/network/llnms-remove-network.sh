#!/bin/sh
#
#   File:    llnms-remove-network.sh
#   Author:  Marvin Smith
#   Date:    1/20/2014
#
#   Purpose:  Remove a created LLNMS Network file. 
#


#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help        :  Print usage instructions'
    echo '        -v, --version     :  Print version information'
    echo '        -i, --interactive : Run in interactive mode'
    echo ''
    echo '        -n, --name  [Network Name]     : Search by network name'
    echo '        -a, --address  [address]       : Search by a network address.'
    echo '           Note: If duplicate networks cover a single address, then all will be removed.'
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


INTERACTIVE_MODE=0
SEARCH_NAME=0
SEARCH_NAME_FLAG=0
SEARCH_NAME_VALUE=""
SEARCH_ADDR=0
SEARCH_ADDR_FLAG=0
SEARCH_ADDR_VALUE=""

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
        
        #  Set interactive mode
        '-i' | '--interactive' )
            INTERACTIVE_MODE=1
            ;;
        
        #  Set flag for search name
        '-n' | '--name' )
            SEARCH_NAME_FLAG=1
            ;;

        #  Set flag for search address
        '-a' | '--address' )
            SEARCH_ADDR_FLAG=1
            ;;

        #  Process flag values or print error message
        *)
            
            #  If search name flag is thrown, get value
            if [ "$SEARCH_NAME_FLAG" = "1" ]; then
                SEARCH_NAME=1
                SEARCH_NAME_FLAG=0
                SEARCH_NAME_VALUE=$OPTION

            #  If search addr flag is thrown, get value
            elif [ "$SEARCH_ADDR_FLAG" = "1" ]; then
                SEARCH_ADDR=1
                SEARCH_ADDR_FLAG=0
                SEARCH_ADDR_VALUE=$OPTION

            # Otherwise throw error for unknown option
            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi

            ;;


    esac
done


#--------------------------------------------#
#-          Get a list of networks          -#
#--------------------------------------------#
NETWORK_FILES="`llnms-list-networks --file-only`"
for NETWORK_FILE in $NETWORK_FILES; do
    
    #  Get name
    NAME="`llnms-print-network-info -n -f $NETWORK_FILE`"

    #  Get Address Range
    ADDRESS_START="`llnms-print-network-info -s -f $NETWORK_FILE`"
    ADDRESS_END="`llnms-print-network-info   -e -f $NETWORK_FILE`"
    
    # if network name matches, delete it
    if [ "$SEARCH_NAME" = '1' -a "$NAME" = "$SEARCH_NAME_VALUE" ]; then
        rm $NETWORK_FILE
    fi

    if [ "$SEARCH_ADDR" = '1' ]; then
        error "Not implemented Yet." $LINENO
        exit 1
    fi

done



