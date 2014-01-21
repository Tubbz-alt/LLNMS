#!/bin/sh
#
#   File:   TEST_llnms_register_asset_scanner.sh
#   Author: Marvin Smith
#   Date:   12/29/2013
#
#   Purpose:  Runs unit tests on programs associated with the LLNMS Register
#             Asset Scanner Script.
#

#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh

# Filename variable
FILENAME="TEST_llnms_register_asset_scanner.sh"

#---------------------------------------------------------------------#
#-   Utility function to tell you how many scanners are in an asset  -#
#-                                                                   -#
#-     $1 - Asset File To Process                                    -#
#---------------------------------------------------------------------#
TMP_number_asset_scanners(){
    echo `xmlstarlet el $1 | grep '^llnms-asset/scanners/scanner$' | wc -l`
}

#-------------------------------------#
#-   TEST_llnms_register_scanner_01  -#
#-                                   -#
#-   Test the created file output    -#
#-   from llnms-register_scanner.    -#
#-------------------------------------#
TEST_llnms_register_asset_scanner_01(){

    #   Remove all assets
    rm "$LLNMS_HOME/assets/*.llnms-asset.xml" 2> /dev/null
    
    #   Verify proper scanners exist
    if [ ! -e "$LLNMS_HOME/scanning/ping-scanner.llnms-scanner.xml" ]; then
        echo '1'
        echo "ping-scanner.llnms-scanner.xml does not exist in $LLNMS_HOME/scanning/" > /var/tmp/cause.txt
        return
    fi
    if [ ! -e "$LLNMS_HOME/scanning/ssh-scanner.llnms-scanner.xml" ]; then
        echo '1'
        echo "ssh-scanner.llnms-scanner.xml does not exist in $LLNMS_HOME/scanning/" > /var/tmp/cause.txt
        return
    fi

    #   Create demo assets
    llnms-create-asset  -host 'temp-asset1' -ip4 '192.168.0.1' -d 'hello world'
    llnms-create-asset  -host 'temp-asset2' -ip4 '172.16.0.1'

    ASSET1="$LLNMS_HOME/assets/temp-asset1.llnms-asset.xml"
    ASSET2="$LLNMS_HOME/assets/temp-asset2.llnms-asset.xml"

    #-----------------------------------------#
    #              test temp-asset 1         -#
    #-----------------------------------------#
    llnms-register-asset-scanner -a temp-asset1 -s ping-scanner > /dev/null

    #touch /var/tmp/llnms-halt.txt

    #  Make sure the asset is still valid xml
    xmlstarlet val "$LLNMS_HOME/assets/temp-asset1.llnms-asset.xml" > /dev/null
    if [ ! "$?" = '0' ]; then
        echo "temp-asset1 did not validate properly. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    #  Make sure the scanner is inside of the asset
    AS2CNT="`TMP_number_asset_scanners $ASSET1`"
    if [ ! "$AS2CNT" = '1' ]; then
        echo "temp-asset1 list $AS2CNT registered scanner(s). It should have 1. File: $FILENAME, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi
    
    #  Make sure the scanner is the ping-scanner
    if [ ! "`xmlstarlet sel -t -v '//llnms-asset/scanners/scanner/id' $ASSET1`" = "ping-scanner" ]; then
        echo "temp-asset1 does not have the ping-scanner as it should. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    #  Register the ssh scanner
    llnms-register-asset-scanner -a temp-asset1 -s ssh-scanner > /dev/null

    #  Make sure the asset is still valid
    xmlstarlet val "$LLNMS_HOME/assets/temp-asset1.llnms-asset.xml" > /dev/null
    if [ ! "$?" = '0' ]; then
        echo "temp-asset1 did not validate properly. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    # make sure there are two scanners now
    SCANNER_CNT=`TMP_number_asset_scanners $ASSET1`
    if [ ! "$SCANNER_CNT" = '2' ]; then
        echo "temp-asset1 should have 2 registered scanners rather than $SCANNER_CNT. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi
    
    
    #-----------------------------------------#
    #              test temp-asset 2         -#
    #-----------------------------------------#
    llnms-register-asset-scanner -a temp-asset2 -s ping-scanner > /dev/null

    #  Make sure the asset is still valid xml
    xmlstarlet val "$LLNMS_HOME/assets/temp-asset2.llnms-asset.xml" > /dev/null
    if [ ! "$?" = '0' ]; then
        echo "temp-asset2 did not validate properly. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    #  Make sure the scanner is inside of the asset
    if [ ! "`TMP_number_asset_scanners $ASSET2`" = '1' ]; then
        echo "temp-asset2 should have one and only one registered scanner. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi
    
    #  Make sure the scanner is the ping-scanner
    if [ ! "`xmlstarlet sel -t -v '//llnms-asset/scanners/scanner/id' $ASSET2`" = "ping-scanner" ]; then
        echo "temp-asset2 does not have the ping-scanner as it should. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    #  Register the ssh scanner
    llnms-register-asset-scanner -a temp-asset2 -s ssh-scanner > /dev/null

    #  Make sure the asset is still valid
    xmlstarlet val "$LLNMS_HOME/assets/temp-asset2.llnms-asset.xml" > /dev/null
    if [ ! "$?" = '0' ]; then
        echo "temp-asset2 did not validate properly. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    # make sure there are two scanners now
    SCANNER_CNT=`TMP_number_asset_scanners $ASSET2`
    if [ ! "$SCANNER_CNT" = '2' ]; then
        echo "temp-asset2 should have 2 registered scanners rather than $SCANNER_CNT. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        echo '1'
        return
    fi

    echo 0
}


