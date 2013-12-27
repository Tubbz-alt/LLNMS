#!/bin/sh
#
#   File:    run_tests.sh
#   Author:  Marvin Smith
#   Date:    12/25/2013
#
#   Purpose:  Runs tests on the scanning module programs.
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
print_module_header "Scanning"

#----------------------------------------------------------------#
#-                  Test Print Scanner Info                     -#
#----------------------------------------------------------------#
#  Test Print Scanner Info
. test/scanning/TEST_llnms_print_scanner_info.sh
RESULT=`TEST_llnms_print_scanner_info_01`
print_test_result 'llnms-print-scanner-info' 'Print Scanner Information' "$RESULT"

#----------------------------------------------------------------#
#-                   Test Registering Scanners                  -#
#----------------------------------------------------------------#
#  Test Scanner Registration
. test/scanning/TEST_llnms_register_scanner.sh
RESULT=`TEST_llnms_register_scanner_01`
print_test_result 'llnms-register-scanner' 'Register Scanners' "$RESULT"

#----------------------------------------------------------------#
#-                     Test Scanning List                       -#
#----------------------------------------------------------------#
#  Test list scanners
. test/scanning/TEST_llnms_list_scanners.sh
RESULT=`TEST_llnms_list_scanners_01`
print_test_result 'llnms-list-scanners' 'List Registered Scanners' "$RESULT"


#------------------------------------------#
#-           Print our footer             -#
#------------------------------------------#
print_module_footer "Scanning"


