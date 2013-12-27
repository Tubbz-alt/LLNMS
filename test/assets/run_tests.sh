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
. $LLNMS_HOME/config/llnms-config.sh

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh


#------------------------------------------#
#-           Print our header             -#
#------------------------------------------#
print_module_header "Asset"


#----------------------------------------------------------------#
#-                     Test Asset Creation                      -#
#----------------------------------------------------------------#
#  Test asset creation
. test/assets/TEST_llnms_create_asset.sh
RESULT=`TEST_llnms_create_asset_01`
print_test_result 'llnms-create-asset' 'Create Asset File' "$RESULT"


#------------------------------------------------------------#
#-                    Test Asset Removal                    -#
#------------------------------------------------------------#
. test/assets/TEST_llnms_remove_asset.sh
RESULT=`TEST_llnms_remove_asset_01`
print_test_result 'llnms-remove-asset' 'Remove Asset File' "$RESULT"


#--------------------------------------------------#
#-              Test List Assets                  -#
#--------------------------------------------------#
. test/assets/TEST_llnms_list_assets.sh
RESULT=`TEST_llnms_list_assets_01`
print_test_result 'llnms-list-assets'  'List assets in asset directory' "$RESULT"

#-----------------------------------------------------------#
#-              Test Print Asset Information               -#
#-----------------------------------------------------------#
. test/assets/TEST_llnms_print_asset_info.sh
RESULT=`TEST_llnms_print_asset_info_01`
print_test_result 'llnms-print-asset-info' 'Print test asset file information.' "$RESULT"


#------------------------------------------#
#-           Print our footer             -#
#------------------------------------------#
print_module_footer "Asset"


