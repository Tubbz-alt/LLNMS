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

