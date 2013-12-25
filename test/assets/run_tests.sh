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

#  Print our header
$ECHO 'Running Asset Module Unit Tests'


#----------------------------------------------------------------#
#-                     Test Asset Creation                      -#
#----------------------------------------------------------------#
#  Test asset creation
$ECHO ''
. test/assets/TEST_llnms_create_asset.sh
RESULT=`TEST_llnms_create_asset_01`
print_test_result 'llnms-create-asset' 'Create Asset File' "$RESULT"
if [ -e "/var/tmp/cause.txt" ]; then rm /var/tmp/cause.txt; fi


#------------------------------------------------------------#
#-                    Test Asset Removal                    -#
#------------------------------------------------------------#
. test/assets/TEST_llnms_remove_asset.sh
RESULT=`TEST_llnms_remove_asset_01`
print_test_result 'llnms-remove-asset' 'Remove Asset File' "$RESULT"
if [ -e "/var/tmp/cause.txt" ]; then rm /var/tmp/cause.txt; fi


