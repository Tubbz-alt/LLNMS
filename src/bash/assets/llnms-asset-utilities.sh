#!/bin/sh
#
#   File:   llnms-asset-utilities.sh
#   Author: Marvin Smith
#   Date:   12/10/2013
#
#   Purpose:  This provides some helpful utilities to
#             read and manipulate llnms assets
#


#-----------------------------------------------------------------#
#-          Get the hostname from an llnms asset file            -#
#-                                                               -#
#-          $1 - Asset file to process                           -#
#-----------------------------------------------------------------#
llnms_get_asset_hostname(){

    xmlstarlet sel -t -m '//llnms-asset' -v 'hostname' -n $1
}

#-----------------------------------------------------------------#
#-         Get the IP4 Address from an llnms asset file          -#
#-
#-         $1 - Asset File to Process
#-----------------------------------------------------------------#
llnms_get_asset_ip4_address(){

    # use xml starlet to query the ip4 address
    xmlstarlet sel -t -m '//llnms-asset' -v 'ip4-address' -n $1
}

#--------------------------------------------------#
#-   Get a list of scanners for the asset         -#
#-                                                -#
#-   $1 - Asset file to process                   -#
#--------------------------------------------------#
llnms_list_asset_registered_scanners(){
    xmlstarlet sel -t -m '//llnms-asset/scanners/scanner' -v 'id' -n $1
}


#-------------------------------------#
#-   Add a scanner to the asset      -#
#-                                   -#
#-   $1 - Asset path to update.      -#
#-   $2 - Scanner path to register.  -#
#-------------------------------------#
llnms_add_registered_scanner_to_asset(){

    # set some helper variables
    ASSET_PATH=$1
    SCANNER_PATH=$2

    #  Make sure asset exists
    if [ ! -e $ASSET_PATH ]; then
        return
    fi

    #  Make sure scanner exists
    if [ ! -e $SCANNER_PATH ]; then
        return
    fi

    #  Make sure the asset has the scanners xml element
    SCANNERS_OUTPUT=$(xmlstarlet sel -t -m '//llnms-asset' -v 'scanners' -n $ASSET_PATH | sed 's/ *//g')
    if [ "$SCANNERS_OUTPUT" == '' ]; then
        xmlstarlet ed -L --subnode "/llnms-asset" --type elem -n 'scanners' $ASSET_PATH 
    fi

    # Add the scanner
    xmlstarlet ed -L --subnode "/llnms-asset/scanners" --type elem -n 'scanner' $ASSET_PATH
    
    # Add the id
    xmlstarlet ed -L --subnode "/llnms-asset/scanners/scanner" --type elem -n 'id' -v "$(llnms_print_registered_scanner_id $SCANNER_PATH)" $ASSET_PATH

    
    echo ''
    echo 'OUTPUT'
    cat $ASSET_PATH
}


#------------------------------------------------#
#-        Create a discovered asset file        -#
#------------------------------------------------#
llnms_create_discovered_asset(){

    #  generate a filename for the asset
    FILENAME="/var/tmp/llnms/assets/discovered/$(date +"%Y%m%d_%H%M%S_%N").llnms-asset.xml"
    
    if [ ! -e "$FILENAME" ]; then
        touch $FILENAME
    else
        echo "Warning: $FILENAME already exists"
        rm $FILENAME
        touch $FILENAME
    fi

    # start writing the file
    echo "<llnms-asset>" >> $FILENAME
    echo "   <ip4-address>$1</ip4-address>" >> $FILENAME
    echo "   <hostname></hostname>" >> $FILENAME
    echo "</llnms-asset>" >> $FILENAME


}


