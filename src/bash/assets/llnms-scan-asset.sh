#!/bin/sh
#
#   File:    llnms-scan-asset.sh
#   Author:  Marvin Smith
#   Date:    12/13/2013
#
#   Purpose: Runs the scanners on the specified asset.

#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help    :  Print usage instructions'
    echo '        -v, --version :  Print version information'
    echo ''
    echo '        -a, --asset [asset hostname] : Asset to run with'
    echo ''
}


#-------------------------------------#
#             Error Function          #
#-------------------------------------#
error(){
    echo "error: $1"
}


#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "$0 Information"
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
source $LLNMS_HOME/config/llnms-info.sh


#  Import asset utilities
source $LLNMS_HOME/bin/llnms-asset-utilities.sh

#  Asset name and path
ASSET_HOSTNAME=''
ASSET_PATH=''
ASSET_FLAG=0


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
        
        #  Set the asset flag
        '-a' | '--asset' )
            ASSET_FLAG=1
            ;;

        #  Process flag values or print error message
        *)
            
            #  Grab the asset hostname
            if [ $ASSET_FLAG -eq 1 ]; then
                ASSET_FLAG=0
                ASSET_HOSTNAME=$OPTION

            # otherwise, throw the error for an unknown option
            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi
            ;;


    esac
done




