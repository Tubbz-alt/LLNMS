#!/bin/sh

#  Get the current network list
NETWORK_LIST=`llnms-list-networks --name-only`


#  Make sure the network list is not empty
if [ "$NETWORK_LIST" = '' ]; then
    echo 'error: No networks found.  Please create new LLNMS networks.'
    exit 1
fi


#  Scan each network
for NETWORK in $NETWORK_LIST; do
    llnms-scan-network -n $NETWORK -s ping-scanner -l
done

