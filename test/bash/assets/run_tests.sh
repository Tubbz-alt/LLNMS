#!/bin/sh
#
#   File:    run_tests.sh
#   Author:  Marvin Smith
#   Date:    12/13/2013
#
#   Purpose:  Runs the unit tests for the asset module
#



#-----------------------------------#
#-          Main Function          -#
#-----------------------------------#

#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config

# Initialize ANSI
. test/bash/unit_test/unit_test_utilities.sh


#------------------------------------------#
#-           Print our header             -#
#------------------------------------------#
print_module_header "Asset"


#----------------------------------------------------------------#
#-                     Test Asset Creation                      -#
#----------------------------------------------------------------#
#  Test asset creation
. test/bash/assets/TEST_llnms_create_asset.sh
RESULT=`TEST_llnms_create_asset_01`
print_test_result 'llnms-create-asset' 'Create Asset File' "$RESULT"

#  Check for program halt
if [ -e /var/tmp/llnms-halt.txt ]; then
    echo 'llnms asset unit tests halted.'
    exit 1
fi

#-------------------------------------------------------------#
#-                Test Asset Scanner Registration            -#
#-------------------------------------------------------------#
#  Test Asset Scanner Registration
. test/bash/assets/TEST_llnms_register_asset_scanner.sh
RESULT=`TEST_llnms_register_asset_scanner_01`
print_test_result 'llnms-register-asset-scanner'  'Register Scanner to Asset' "$RESULT"

if [ -e /var/tmp/llnms-halt.txt ]; then
    echo 'llnms asset unit tests halted.'
    exit 1
fi

#------------------------------------------------------------#
#-                    Test Asset Removal                    -#
#------------------------------------------------------------#
. test/bash/assets/TEST_llnms_remove_asset.sh
RESULT=`TEST_llnms_remove_asset_01`
print_test_result 'llnms-remove-asset' 'Remove Asset File' "$RESULT"

if [ -e /var/tmp/llnms-halt.txt ]; then
    echo 'llnms asset unit tests halted.'
    exit 1
fi


#--------------------------------------------------#
#-              Test List Assets                  -#
#--------------------------------------------------#
. test/bash/assets/TEST_llnms_list_assets.sh
RESULT=`TEST_llnms_list_assets_01`
print_test_result 'llnms-list-assets'  'List assets in asset directory' "$RESULT"

if [ -e /var/tmp/llnms-halt.txt ]; then
    echo 'llnms asset unit tests halted.'
    exit 1
fi

#-----------------------------------------------------------#
#-              Test Print Asset Information               -#
#-----------------------------------------------------------#
. test/bash/assets/TEST_llnms_print_asset_info.sh
RESULT=`TEST_llnms_print_asset_info_01`
print_test_result 'llnms-print-asset-info' 'Print test asset file information.' "$RESULT"

if [ -e /var/tmp/llnms-halt.txt ]; then
    echo 'llnms asset unit tests halted.'
    exit 1
fi


#------------------------------------------#
#-           Print our footer             -#
#------------------------------------------#
print_module_footer "Asset"


