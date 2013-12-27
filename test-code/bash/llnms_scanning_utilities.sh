#!/bin/sh
#
#  File:   llnms_scanning_utilities.sh
#  Author: Marvin Smith
#  Date:   12/13/2013
#



#--------------------------------------------------------------#
#-      Print the name of the registered scanner's name       -#
#--------------------------------------------------------------#
llnms_print_registered_scanner_name(){
    xmlstarlet sel -t -m '//llnms-scanner' -v 'name' -n "$1"
}


#------------------------------------------------------------#
#-     Print the description of the registered scanner      -#
#------------------------------------------------------------#
llnms_print_registered_scanner_description(){
    xmlstarlet sel -t -m '//llnms-scanner' -v 'description' -n "$1"
}


#------------------------------------------------------------------#
#-     Print the execution command of the registered scanner      -#
#------------------------------------------------------------------#
llnms_print_registered_scanner_command(){
    xmlstarlet sel -t -m '//llnms-scanner/configuration/linux' -v 'command' -n "$1"
}


#-----------------------------------------------------#
#-     Print the registered scanner's id string      -#
#-----------------------------------------------------#
llnms_print_registered_scanner_id(){
    xmlstarlet sel -t -m '//llnms-scanner' -v 'id' -n "$1"
}



#-------------------------------------------------#
#-    Get the scanner path given a scanner id    -#
#-                                               -#
#-    $1 - Scanner ID                            -#
#-------------------------------------------------#
llnms_get_scanner_path_from_id(){
    
    #  Get list of scanners
    SCANNER_LIST=$(ls $LLNMS_HOME/scanning/scanners/*.llnms-scanner.xml 2> /dev/null)

    # iterate through scanners
    for SCANNER_FILE in $SCANNER_LIST; do
        
        #  get id from scanner file
        SCANNER_ID=$(llnms_print_registered_scanner_id $SCANNER_FILE)

        # check if they match
        if [ "$SCANNER_ID" = "$1" ]; then
            echo $SCANNER_FILE
        fi
    done
}


