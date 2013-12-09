#!/bin/bash

# Import default parameters
if [ "$LLNMS_HOME" == "" ]; then
    LLNMS_HOME=/var/tmp/llnms
fi

#  import the xmlstarlet function
source $LLNMS_HOME/bin/llnms-xmlstarlet-functions.bash


#------------------------------------------------------------#
#-         Query the number of network definitions          -#
#------------------------------------------------------------#
llnms-get-network-count(){
    ls $LLNMS_HOME/networks/*.llnms-network.xml | wc -l | tr -d ' '
}

#----------------------------------------------------------------------------------#
#-    Query an ip address against the network status table and add if necessary   -#
#-                                                                                -#
#-    $1 - IP Address to Query                                                    -#
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
#-                                                              -# 
#-      $1 - IP Address to Query                                -#
#----------------------------------------------------------------#
llnms-ping-network-address(){

    STAT_FILE=$LLNMS_HOME/run/llnms-network-status.txt
    RESULT=1

    #  Run the ping command
    ping -c 1 -q $1 > /dev/null

    if [ "$?" == "0" ]; then
        sed -e "s/${1} [01].*/${1} 1 $(date +"%Y-%m-%d-%H:%M:%S")/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
        RESULT=0
    else    
        sed -e "s/${1} [01].*/${1} 0 $(date +"%Y-%m-%d-%H:%M:%S")/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
        RESULT=1
    fi
    return $RESULT
}

#--------------------------------------------------#
#-       Create a clean network status file       -#
#--------------------------------------------------#
llnms-create-empty-network-status-file(){
   
    #  if the file exists, delete it
    if [ -f "$LLNMS_HOME/run/llnms-network-status.txt" ]; then
        rm "$LLNMS_HOME/run/llnms-network-status.txt"
    fi

    #  Create new network status file
    touch "$LLNMS_HOME/run/llnms-network-status.txt"

    #  echo the headers
    echo "#  IP Address    |   Network   |   Status (0-not found | 1-found)   |   Date  " >> "$LLNMS_HOME/run/llnms-network-status.txt"
    
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

#----------------------------------------#
#-        Resolve Single Hostname       -#
#----------------------------------------#
llnms-resolve-ip-address(){
    
    # use traceroute to get the item
    RES=$(traceroute $1 | tail -1 | sed 's/^ //' | sed 's/  */ /' | cut -d' ' -f2 )
    
    # make sure the hostname fits the regex
    PATTERN="$(echo "$RES" | grep '[a-zA-Z0-9-]')"
    if [ "$PATTERN" == "$RES" ]; then
        echo $PATTERN
    else
        echo ""
    fi
}


