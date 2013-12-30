#!/bin/sh
#
#  File:    TEST_llnms_print_asset_info.sh
#  Author:  Marvin Smith
#  Date:    12/26/2013
#
#  Purpose:  Performs all unit tests on the llnms-print-asset-info.sh script.
#

#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config.sh

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh


#---------------------------------------------#
#-     TEST_llnms_print_asset_info_01        -#
#-                                           -#
#-     First unit test of the llnms print    -#
#-     asset info function.  Specifically,   -#
#-     this tests the output given various   -#
#-     input configurations.                 -#
#---------------------------------------------#
TEST_llnms_print_asset_info_01(){

    #  Delete all assets
    rm $LLNMS_HOME/assets/*.llnms-asset.xml 2> /dev/null

    #  Create an asset using the create asset command
    llnms-create-asset.sh  -host 'temp-asset' -ip4 '192.168.0.1' -d 'hello world'
    TEMP_FILENAME="$LLNMS_HOME/assets/temp-asset.llnms-asset.xml"

    #  Test the print function for hostname
    TEST_HOSTNAME="`llnms-print-asset-info.sh -f "$TEMP_FILENAME" -host`"
    if [ ! "$TEST_HOSTNAME" = "temp-asset" ]; then
        echo "Hostname of temporary asset is not 'temp-asset'. Hostname returned was $TEST_HOSTNAME" > /var/tmp/cause.txt
        echo '1'
        return
    fi

    #  Test the print function for ip4-address
    TEST_IP4ADDRESS="`llnms-print-asset-info.sh -f "$TEMP_FILENAME" -ip4`"
    if [ ! "$TEST_IP4ADDRESS" = "192.168.0.1" ]; then
        echo "IP4 Address of temp asset is not '192.168.0.1'. Address returned was $TEST_IP4ADDRESS" > /var/tmp/cause.txt
        echo '1'
        return
    fi
    
    #  register a scanner with the asset
    llnms-register-asset-scanner.sh -a temp-asset -s ssh-scanner > /dev/null

    #  Make sure the print function works
    ASSET_SCANNER_LIST=`llnms-print-asset-info.sh -f "$TEMP_FILENAME" -s`
    if [ ! "$ASSET_SCANNER_LIST" = 'ssh-scanner' ]; then
        echo "ssh-scanner did not show up in the output for scanners. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi
    
    #  Check the default arguments

    # Otherwise, success
    echo '0'

}

