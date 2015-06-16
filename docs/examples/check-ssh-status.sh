#!/usr/bin/env bash
#    File:    check-ssh-status.sh
#    Author:  Marvin Smith
#    Date:    6/13/2015
#
#    Purpose: Check if SSH is running on the designated systems.
#

#  Define LLNMS Home for good measure
LLNMS_HOME=/var/tmp/llnms

#  Get the current network list
echo 'Fetching Network List'
NETWORK_LIST=`llnms-list-networks --name-only`


#  Make sure the network list is not empty
if [ "$NETWORK_LIST" = '' ]; then
    echo 'error: No networks found.  Please create new LLNMS networks.'
    exit 1
fi


#  Scan each network
echo 'Scanning Networks'
for NETWORK in $NETWORK_LIST; do
    echo "    Scanning Network: $NETWORK"
    llnms-scan-network -n $NETWORK -s ping-scanner &> $LLNMS_HOME/temp/llnms-scan-results-temp.txt
done


#   Compare the list against assets
DETECTED_NETWORK_ASSETS=`cat $LLNMS_HOME/temp/llnms-scan-results-temp.txt | grep 'PASSED' | awk '{ print $1; }'`


#   Compare against asset list
ASSET_LIST=`llnms-list-assets -l -ip4`


#  Compute New Item List
NEW_ASSETS=`comm -23  <(cat $LLNMS_HOME/temp/llnms-scan-results-temp.txt | grep PASSED | awk '{print $1;}' | sort) <(llnms-list-assets -l -ip4 | sort)`


#  Print New Assets
printf "\nNew Assets\n"
echo "$NEW_ASSETS"

