#!/bin/sh
#
#   File:    run_tests.sh
#   Author:  Marvin Smith
#   Date:    12/13/2013
#
#   Purpose:  Runs the unit tests for the asset module
#

#-------------------------------------#
#-   TEST_llnms_create_asset_01      -#
#-                                   -#
#-   Test the created file output    -#
#-   from llnms-create-asset         -#
#-------------------------------------#
TEST_llnms_create_asset_01(){

    #  Create an asset using the create asset command
    llnms-create-asset.sh  -host 'temp-asset' -ip4 '192.168.0.1' -d 'hello world'

    #  make sure the file was properly created
    if [ ! -e '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml' ]; then
        $ECHO "temp-asset.llnms-asset.xml does not exist after creation" > /var/tmp/cause.txt
        echo "1"
        return
    fi
    
    #  make sure that the file validates properly
    xmlstarlet val -q '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml'
    if [ $? -ne 0 ]; then
        $ECHO "temp-asset.llnms-asset.xml does not validate as proper xml" > /var/tmp/cause.txt
        echo '1'
        return
    fi

    #  check the name
    if [ ! "$(xmlstarlet sel -t -m '//llnms-asset' -v 'hostname' -n '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml')" = 'temp-asset' ]; then
        echo '1'
        $ECHO "hostname is not equal to temp-asset, at Line 37, test/assets/run_tests.sh" > /var/tmp/cause.txt
        return
    fi

    #  check the ip address
    if [ ! "$(xmlstarlet sel -t -m '//llnms-asset' -v 'ip4-address' -n '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml')" = '192.168.0.1' ]; then
        echo "ip4-address is not equal to 192.168.0.1, at Line 44, test/assets/run_tests.sh" > /var/tmp/cause.txt
        echo '1'
        return 
    fi

    echo '0'
}



#-----------------------------------#
#-          Main Function          -#
#-----------------------------------#

#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config.sh

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh

#  Print our header
$ECHO 'Running Asset Module Unit Tests'


#  CAUSE VARIABLE
export CAUSE="Unknown"

#  Test asset creation
$ECHO ''

RESULT=`TEST_llnms_create_asset_01`
print_test_result 'llnms-create-asset' 'Create Asset File' "$RESULT"
if [ -e "/var/tmp/cause.txt" ]; then rm /var/tmp/cause.txt; fi


