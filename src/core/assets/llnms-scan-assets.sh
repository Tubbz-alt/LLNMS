#!/bin/bash
#
#  File:   llnms-scan-assets.sh
#  Author: Marvin Smith
#  Date:   12/10/2013
#
#  Purpose:  This script does a scan of all discovered and defined assets. 
#


#--------------------------------------------------#
#-       Validate llnms asset filestructure       -#
#   Steps:
#     1.  Make sure each defined asset is located within the discovered assets
#     2.  Make sure each ip address in the status file which is responding to pings is in the discovered assets
#--------------------------------------------------#
llnms_validate_asset_structure(){

    #  Get a list of all asset files
    DEFINED_ASSET_FILES=`ls $LLNMS_HOME/assets/defined/*.llnms-asset.xml 2> /dev/null`
    DISCOVERED_ASSET_FILES=`ls $LLNMS_HOME/assets/discovered/*.llnms-asset.xml 2> /dev/null`
    
    #-     Make sure all defined assets exist in the discovered assets    -#
    #  Iterate through each defined asset file
    for DEFINED_ASSET_FILE in $DEFINED_ASSET_FILES; do

        #  retrieve the ip4 address
        IP4_ADDR_0=`llnms_get_asset_ip4_address $DEFINED_ASSET_FILE`
        ASSET_FOUND=0

        # Iterate through each discovered asset file
        for DISCOVERED_ASSET_FILE in $DISCOVERED_ASSET_FILES; do
            IP4_ADDR_1=`llnms_get_asset_ip4_address $DISCOVERED_ASSET_FILE`
            
            # Check if the ip addresses are the same
            if [ "$IP4_ADDR_0" = "$IP4_ADDR_1" ]; then
                ASSET_FOUND=1
            fi

        done
        
        #  If the asset has not been found, then create a discovery asset
        if [ "$ASSET_FOUND" = "0" ]; then
            cp $DEFINED_ASSET_FILE $LLNMS_HOME/assets/discovered/
        fi

    done


    #-     Make sure all network hosts in the status file which are responding    -#
    #-     have a corresponding asset file                                        -#
    STATUS_LIST=`cat $LLNMS_HOME/run/llnms-network-status.txt | sed '/ *#.*/d' | sed '/[0-9]*\.[0-9]*\.[0-9]*\.[0-9]* 0 .*/d' | cut -d ' ' -f 1`
    for ADDRESS in $STATUS_LIST; do
        
        ASSET_FOUND=0
        for DISCOVERED_ASSET_FILE in $DISCOVERED_ASSET_FILES; do
            DISC_ADDRESS=`llnms_get_asset_ip4_address $DISCOVERED_ASSET_FILE`
            
            if [ "$DISC_ADDRESS" = "$ADDRESS" ]; then
                ASSET_FOUND=1
            fi

        done

        # if the asset was not found, then generate an asset file
        if [ $ASSET_FOUND -eq 0 ]; then
            llnms_create_discovered_asset $ADDRESS 
        fi

    done

}


#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '        -h | --help    :  Print usage instructions'
    echo '        -v | --version :  Print version information'
    echo ''
}


#-------------------------------------#
#             Error Function          #
#-------------------------------------#
error(){
    echo "error $1"
}


#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "$0 Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}


#---------------------------------#
#-         Main Function         -#
#---------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
source $LLNMS_HOME/config/llnms-info.sh

#  Import utilities
source $LLNMS_HOME/bin/llnms-asset-utilities.sh

#   Parse Command-Line Options
for OPTION in $@; do

    case $OPTION in

        #  Print usage instructions
        '-h' | '--help' )
            usage
            exit 1
            ;;


        #  Print version information
        '-v' | '--version' )
            version
            exit 1
            ;;


        #  Print error message
        *)
            error "Unknown option $OPTION"
            usage
            exit 1
            ;;


    esac
done


#---------------------------------------------------------#
#-    Validate the structure of the asset filesystem     -#
#---------------------------------------------------------#
llnms_validate_asset_structure

#----------------------------------------------------------#
#-    Iterate through each asset file, querying through   -#
#-    registered scanner.                                 -#
#----------------------------------------------------------#
DISCOVERED_ASSET_FILES=`ls $LLNMS_HOME/assets/discovered/*.llnms-asset.xml 2> /dev/null`
for DISCOVERED_ASSET_FILE in $DISCOVERED_ASSET_FILES; do
    
    #  Get a list of scanners
    #SCANNER_LIST=`llnms_list_asset_scanners

done



