#!/bin/bash


#---------------------------------------------#
#-    Add a log entry to the specified log   -#
#-    $1 - Location of log file              -#
#-    $2 - Log entry data                    -#
#---------------------------------------------#
llnms-add-log-entry(){
    
    echo "$(date +"%Y-%m-%d-%H:%M:%S") $2" >> $1
}
