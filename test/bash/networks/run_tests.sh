#!/bin/sh
#
#   File:    run_tests.sh
#   Author:  Marvin Smith
#   Date:    12/13/2013
#
#   Purpose:  Run unit tests for the network module
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
print_module_header "Networking"


#--------------------------------------------------#
#-              Test Create Network               -#
#--------------------------------------------------#
. test/bash/networks/TEST_llnms_create_network.sh
RESULT=`TEST_llnms_create_network_01`
print_test_result 'llnms-create-network'  'Create a Network'  "$RESULT"


#-------------------------------------------------#
#-              Test List Networks               -#
#-------------------------------------------------#
. test/bash/networks/TEST_llnms_list_networks.sh
RESULT=`TEST_llnms_list_networks_01`
print_test_result 'llnms-list-networks'  'List Networks'  "$RESULT"


#-------------------------------------------------#
#-            Test Print Network Info            -#
#-------------------------------------------------#
. test/bash/networks/TEST_llnms_print_network_info.sh
RESULT=`TEST_llnms_print_network_info_01`
print_test_result 'llnms-print-network-info' 'Print Network Info'  "$RESULT"


#-------------------------------------------------#
#-              Test Remove Network              -#
#-------------------------------------------------#
. test/bash/networks/TEST_llnms_remove_network.sh
RESULT=`TEST_llnms_remove_network_01`
print_test_result 'llnms-remove-network'  'Remove a Network'  "$RESULT"


#------------------------------------------------#
#-              Test Scan Networks              -#
#------------------------------------------------#
. test/bash/networks/TEST_llnms_scan_networks.sh
RESULT=`TEST_llnms_scan_networks_01`
print_test_result 'llnms-scan-networks'  'Scan Networks'   "$RESULT"


#------------------------------------------#
#-           Print our footer             -#
#------------------------------------------#
print_module_footer "Networking"


