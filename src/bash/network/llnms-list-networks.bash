#!/bin/bash
#
#  file:    llnms-list-networks.bash
#  author:  Marvin Smith
#  date:    12/8/2013
#



#-------------------------------------#
#             Error Function          #
#-------------------------------------#
error(){
    echo "error $1"
    exit 1
}


#-------------------------------------#
#          Usage Instructions         #
#-------------------------------------#
usage(){
    echo "$0: [options]"
    echo ''
    echo '   options:'
    echo '      -h, --help    :  Print Usage Instructions'
    echo '      -v, --version :  Print Program Version Information'
    echo ''
    echo '      Formatting'
    echo '         -l, --list    :  Print in a list format'
    echo '         -x, --xml     :  Print in a XML format'
    echo '         -p, --pretty  :  Print in a human-readable format (DEFAULT)'

}

#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "$0 Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


#-------------------------------------#
#           Main Function            -#
#-------------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
source $LLNMS_HOME/config/llnms-info.sh

#  Import the network utilities
source $LLNMS_HOME/bin/llnms-xmlstarlet-functions.bash
source $LLNMS_HOME/bin/llnms-network-utilities.bash

#  Set the output format
OUTPUT_FORMAT="PRETTY"

#  parse command-line options
for OPTION in $@; do

    case $OPTION in

        #  Print Usage Instructions
        "-h" | "--help" )
            usage
            exit 1
            ;;
        
        #  Print Version Information
        "-v" | "--version" )
            version
            exit 1
            ;;

        #  Set format to list
        "-l" | "--list" )
            OUTPUT_FORMAT="LIST"
            ;;

        #  Set format to pretty
        "-p" | "--pretty" )
            OUTPUT_FORMAT="PRETTY"
            ;;

        #  Set format to xml
        "-x" | "--xml" )
            OUTPUT_FORMAT="XML"
            ;;

        #  Print Error
        *)
            error "Unknown option $OPTION"
            ;;

    esac
done


#   Iterate through each network file, printing information about each file
NETWORK_FILES=`ls $LLNMS_HOME/networks/*.llnms-network.xml 2> /dev/null`
for NETWORK_FILE in $NETWORK_FILES; do

    #  Print the name
    llnms-get-network-name $NETWORK_FILE
    

done

