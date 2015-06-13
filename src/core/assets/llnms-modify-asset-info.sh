#!/bin/sh
#
#   File:    llnms-modify-asset-info.sh
#   Author:  Marvin Smith
#   Date:    12/29/2013
#
#   Purpose:  Allows you to modify the contents of an llnms asset.
#

#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help    :  Print usage instructions'
    echo '        -v, --version :  Print version information'
    echo ''
    echo '        -sr, --scanner-result [scanner id] [exit code] [timestamp]'
    echo '           Update the scanner result given the scanner id and exit code.'
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
. $LLNMS_HOME/config/llnms-info.sh

#  Import the configuration info
. $LLNMS_HOME/config/llnms-config.sh

#  Flags
SCANNER_RESULT_FLAG=0
SCANNER_RESULT_ID=''
SCANNER_RESULT_ID_FLAG=0
SCANNER_RESULT_TIME=''
SCANNER_RESULT_TIME_FLAG=0
SCANNER_RESULT_VALUE=''
SCANNER_RESULT_VALUE_FLAG=0

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

        #  Scanner Result Flag
        '-sr' | '--scanner-result' )
            SCANNER_RESULT_FLAG=1
            ;;
        
        #  Process flag values or print error message
        *)
            
            if [ "$SCANNER_RESULT_FLAG" = '1' -a "$SCANNER_RESULT_ID_FLAG" = '0' ]; then
                SCANNER_RESULT_ID_FLAG=1
                SCANNER_RESULT_ID=$OPTION

            elif [ "$SCANNER_RESULT_ID_FLAG" = '1' -a "$SCANNER_RESULT_VALUE_FLAG" = '0' ]; then
                SCANNER_RESULT_VALUE_FLAG=1
                SCANNER_RESULT_VALUE=$OPTION

            elif [ "$SCANNER_RESULT_VALUE_FLAG" = '1' -a "$SCANNER_RESULT_TIMESTAMP_FLAG" = '0' ]; then
                SCANNER_RESULT_TIMESTAMP_FLAG=0
                SCANNER_RESULT_TIMESTAMP=$OPTION

            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi

            ;;


    esac
done

echo "ID   : $SCANNER_RESULT_ID"
echo "Value: $SCANNER_RESULT_VALUE"
echo "Time : $SCANNER_RESULT_TIMESTAMP"

