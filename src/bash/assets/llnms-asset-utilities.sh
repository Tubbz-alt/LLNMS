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
#-         Get the IP4 Address from an llnms asset file          -#
#-
#-         $1 - Asset File to Process
#-----------------------------------------------------------------#
llnms_get_asset_ip4_address(){

    # use xml starlet to query the ip4 address
    xmlstarlet sel -t -m '//llnms-asset' -v 'ip4-address' -n $1
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

