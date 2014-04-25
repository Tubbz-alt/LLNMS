#!/bin/bash
#
#    File:     llnms-scan-networks.sh
#    Author:   Marvin Smith
#    Date:     2/9/2014
#
#    Purpose:  Scan networks for assets.
#

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
#          Usage Instructions         #
#-------------------------------------#
usage(){
    echo "`basename $0` [options]"
    echo ''
    echo '   options:'
    echo '      -h, --help    :  Print Usage Instructions'
    echo '      -v, --version :  Print Program Version Information'
    echo ''
    echo '      --verbose     :  Print program output to stdout (DEFAULT)'
    echo '      --quiet       :  Do not print program output to stdout'
    echo ''

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
#         Main Functions          #
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info

#  output state
OUTPUT_STATE='VERBOSE'

#  parse command-line options
for OPTION in "$@"; do

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

        #  Print output to stdout
        '--verbose' )
            OUTPUT_STATE='VERBOSE'
            ;;

        #  Do not print output to stdout
        '--quiet' )
            OUTPUT_STATE='QUIET'
            ;;

        #  Print Error
        *)
            error "Unknown option $OPTION"
            ;;

    esac
done



#-------------------------------------------#
#      Get a list of networks to scan       #
#-------------------------------------------#

#  Get the network count
LLNMS_NETWORK_FILES=$(ls $LLNMS_HOME/networks/*.llnms-network.xml 2> /dev/null )

MAX_PIDS=1

#  For each network
for NETWORK in $LLNMS_NETWORK_FILES; do

    #  Get the full path of the network file
    NETWORK_FILE="$NETWORK"

    #  Get the network address range
    ADDR_BEG="`$LLNMS_HOME/bin/llnms-print-network-info -f $NETWORK_FILE -s`"
    ADDR_END=`$LLNMS_HOME/bin/llnms-print-network-info -f $NETWORK_FILE -e`
    
    #  Split the address into 4 part
    ADDR_BEG_1=`echo $ADDR_BEG | cut -d '.' -f 1`
    ADDR_BEG_2=`echo $ADDR_BEG | cut -d '.' -f 2`
    ADDR_BEG_3=`echo $ADDR_BEG | cut -d '.' -f 3`
    ADDR_BEG_4=`echo $ADDR_BEG | cut -d '.' -f 4`
    
    ADDR_END_1=`echo $ADDR_END | cut -d '.' -f 1`
    ADDR_END_2=`echo $ADDR_END | cut -d '.' -f 2`
    ADDR_END_3=`echo $ADDR_END | cut -d '.' -f 3`
    ADDR_END_4=`echo $ADDR_END | cut -d '.' -f 4`
    
    #  Iterate over each address range        
    for (( a=$ADDR_BEG_1; a<=$ADDR_END_1; a++ )); do
    for (( b=$ADDR_BEG_2; b<=$ADDR_END_2; b++ )); do
    for (( c=$ADDR_BEG_3; c<=$ADDR_END_3; c++ )); do
    for (( d=$ADDR_BEG_4; d<=$ADDR_END_4; d++ )); do

        #  create address
        TEST_ADDRESS="${a}.${b}.${c}.${d}"
        
        #  Prevent no more than x processes from running
        $LLNMS_HOME/bin/llnms-locking-manager lock -w -l /tmp/llnms-lock -m 2 -p $$
        
        #  Run ping on the address
        if [ "$OUTPUT_STATE" = 'QUIET' ]; then
            $LLNMS_HOME/bin/llnms-scan-address -ip4 ${TEST_ADDRESS} -c 1 --quiet &
        
        elif [ "$OUTPUT_STATE" = 'VERBOSE' ]; then
            $LLNMS_HOME/bin/llnms-scan-address -ip4 ${TEST_ADDRESS} -c 1 --verbose &

        elif [ "$OUTPUT_STATE" = 'DEBUG' ]; then
            $LLNMS_HOME/bin/llnms-scan-address -ip4 ${TEST_ADDRESS} -c 1 --debug & 

        fi


    done
    done
    done
    done


done

wait
echo "End of scan networks"

