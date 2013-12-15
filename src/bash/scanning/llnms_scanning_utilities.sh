#!/bin/sh
#
#  File:   llnms_scanning_utilities.sh
#  Author: Marvin Smith
#  Date:   12/13/2013
#


#-----------------------------------------------#
#-      Create a registered scanners file      -#
#-----------------------------------------------#
llnms_create_registered_scanners_file(){

    #  Create the output xml headers
    OUTPUT="<llnms-registered-scanners>\n"
    
    #  Create the output xml footers
    OUTPUT+="</llnms-registered-scanners>\n"

    #  Output to file
    OLDIFS=$IFS
    IFS=''
    echo -e $OUTPUT > "$LLNMS_HOME/run/llnms-registered-scanners.xml"
    IFS=$OLDIFS


}


#--------------------------------------------------#
#-      Print all registered scanner paths        -#
#--------------------------------------------------#
llnms_list_registered_scanner_paths(){
    xmlstarlet sel -t -m '//llnms-registered-scanners' -v 'llnms-scanner' -n "$LLNMS_HOME/run/llnms-registered-scanners.xml"
}


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

#------------------------------------------------------------#
#-     Add a scanner to the registered scanners xml file    -#
#-                                                          -#
#-     $1 - Path to add                                     -#
#------------------------------------------------------------#
llnms_add_scanner_to_registered_list(){
    XMLFILE='/var/tmp/llnms/run/llnms-registered-scanners.xml'
    xmlstarlet ed --subnode "/llnms-registered-scanners" --type elem -n 'llnms-scanner' -v $1 $XMLFILE
}



