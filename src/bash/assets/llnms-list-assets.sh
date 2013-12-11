#!/bin/sh
#
#   File:    llnms-list-assets.sh
#   Author:  Marvin Smith
#   Date:    12/10/2013
#


#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '        -h | --help    :  Print usage instructions'
    echo '        -v | --version :  Print version information'
    echo ''
}


#-------------------------------------#
#             Error Function          #
#-------------------------------------#
error(){
    echo "error $1"
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

#  Import utilities
source $LLNMS_HOME/bin/llnms-asset-utilities.sh

#   Parse Command-Line Options
for OPTION in $@; do

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


        #  Print error message
        *)
            error "Unknown option $OPTION"
            usage
            exit 1
            ;;


    esac
done


