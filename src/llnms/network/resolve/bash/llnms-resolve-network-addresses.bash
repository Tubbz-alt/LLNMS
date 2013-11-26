#!/bin/bash


#------------------------------------#
#-     Print Usage Instructions     -#
#------------------------------------#
usage(){
    
    echo "usage: $0 [options]"
    echo ''
    echo '    options:'
    echo ''
    echo "      -h | -help)  Print usage instructions"

}


#------------------------------------#
#-           Main Function          -#
#------------------------------------#

# Import default parameters
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME=/var/tmp/llnms
fi

#  Import the utility script
. $LLNMS_HOME/bin/llnms-xmlstarlet-functions.bash
. $LLNMS_HOME/bin/llnms-network-utilities.bash


#  Parse Command-Line Options
for OPTION in $@; do

    case $OPTION in 
        
        #  Print Usage Instructions
        "-h" | "-help" )
            usage
            exit 1
            ;;

        #  Print Error
        *)
            echo "Error: unknown option $OPTION"
            usage
            exit 1
            ;;

    esac
done


#  Recover the IP to hostname mapping
if [ ! -f "$LLNMS_HOME/run/llnms-network-host-map.txt" ]; then
    llnms-create-empty-network-host-map
fi

#  Create an array to load containers
ACTIVE_IP_ADDRESSES=()

#  Find all network assets which already have hostnames
while read line; do
    
    # parse each line, looking for ip addresses which have a 1
    ADDR=$(echo $line | egrep '[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3}\.[[:digit:]]{1,3} 1' | cut -d ' ' -f 1)
    
    if [ ! "$ADDR" == "" ]; then
        ACTIVE_IP_ADDRESSES+=($ADDR)
    fi
done < $LLNMS_HOME/run/llnms-network-status.txt

# For all addresses in the list, query the hostname
for x in `seq 0 $((${#ACTIVE_IP_ADDRESSES[@]}-1))`; do
    
    echo "${ACTIVE_IP_ADDRESSES[$x]} $(llnms-resolve-ip-address ${ACTIVE_IP_ADDRESSES[$x]})"

done

