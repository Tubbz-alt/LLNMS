#!/bin/bash
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
        echo "1"
        return
    fi
    
    #  make sure that the file validates properly
    xmlstarlet val -q '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml'
    if [ $? -ne 0 ]; then
        echo '1'
        return
    fi

    #  check the name
    if [ ! "$(xmlstarlet sel -t -m '//llnms-asset' -v 'hostname' -n '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml')" = 'temp-asset' ]; then
        echo '1'
        return
    fi

    #  check the ip address
    if [ ! "$(xmlstarlet sel -t -m '//llnms-asset' -v 'ip4-address' -n '/var/tmp/llnms/assets/temp-asset.llnms-asset.xml')" = '192.168.0.1' ]; then
        echo '1'
        return 
    fi

    echo '0'
}



#-----------------------------------#
#-          Main Function          -#
#-----------------------------------#

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh

#  Print our header
echo -e 'Running Asset Module Unit Tests'

#  CAUSE VARIABLE

#  Test asset creation
echo -e ''
print_test_result 'llnms-create-asset' 'Create Asset File' "$(TEST_llnms_create_asset_01)"



