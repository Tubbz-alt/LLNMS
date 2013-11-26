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
        sed -e "s/${1} [01].*/${1} 1 $(date +"%Y-%m-%d-%H:%M:%S")/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
    else    
        sed -e "s/${1} [01].*/${1} 0 $(date +"%Y-%m-%d-%H:%M:%S")/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
    fi

}

#--------------------------------------------------#
#-       Create a clean network status file       -#
#--------------------------------------------------#
llnms-create-empty-network-status-file(){
    
    #  Create new network status file
    touch "$LLNMS_HOME/run/llnms-network-status.txt"

    #  echo the headers
    echo "#  IP Address    |    Status (0-not found | 1-found)   |   Date  " >> "$LLNMS_HOME/run/llnms-network-status.txt"

}

#-----------------------------------------------#
#-       Create empty network host map         -#
#-----------------------------------------------#
llnms-create-empty-network-host-map(){

    #  Check if file exists and delete it
    if [ -f "$LLNMS_HOME/run/llnms-network-host-map.txt" ]; then
        rm "$LLNMS_HOME/run/llnms-network-host-map.txt"
    fi

    # Create empty host map
    touch "$LLNMS_HOME/run/llnms-network-host-map.txt"

    #  Load the headers
    echo "#  IP Address   |   Hostname" >> "$LLNMS_HOME/run/llnms-network-host-map.txt"
  


}


