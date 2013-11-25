#!/bin/bash

# Import default parameters
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME=/var/tmp/llnms
fi

#----------------------------------------------------------------------------------#
#-    Query an ip address against the network status table and add if necessary   -#
#----------------------------------------------------------------------------------#
llnms-check-network-status-and-add-ip-entry(){
    
    #  Query the status table
    ENTRY_DATA=`cat $LLNMS_HOME/run/llnms-network-status.txt | grep $1`

    #  If an entry was not found, then add it
    if [ "$ENTRY_DATA" == "" ]; then
        echo "$1 0" >> $LLNMS_HOME/run/llnms-network-status.txt
    
    #  If an entry is found, ignore
   
   fi

}

#----------------------------------------------------------------#
#-      Ping a network asset and write to the status table      -#
#----------------------------------------------------------------#
llnms-ping-network-address(){

    STAT_FILE=$LLNMS_HOME/run/llnms-network-status.txt

    #  Run the ping command
    ping -c 1 -q $1 > /dev/null

    if [ "$?" == "0" ]; then
        sed -e "s/${1} [01]/${1} 1/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
    else    
        sed -e "s/${1} [01]/${1} 0/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
    fi

}


