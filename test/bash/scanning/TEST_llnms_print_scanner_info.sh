#!/bin/sh
#
#   File:    TEST_llnms_print_scanner_info.sh
#   Author:  Marvin Smith
#   Date:    12/26/2013
#
#   Purpose:  This contains all tests related to the llnms-print-scanner-info script.
#


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config

# Initialize ANSI
. test/bash/unit_test/unit_test_utilities.sh


#---------------------------------------#
#-   TEST_llnms_print_scanner_info_01  -#
#-                                     -#
#-   Test the created file output      -#
#-   from llnms-print-scanner-info.    -#
#---------------------------------------#
TEST_llnms_print_scanner_info_01(){
    
    #  make sure the scanner file exists
    if [ ! -e $LLNMS_HOME/scanning/ping-scanner.llnms-scanner.xml ]; then
        echo '1'
        echo "Demo scanner at $LLNMS_HOME/scanning/ping-scanner.llnms-scanner.xml does not exist."
        return
    fi
    SCANFILE="$LLNMS_HOME/scanning/ping-scanner.llnms-scanner.xml"
    
    #  Query info about the scanner
    OUT="`llnms-print-scanner-info -f $SCANFILE -i`"
    if [ ! "$OUT" = "ping-scanner" ]; then echo '1'; echo "ID of scanner should be 'ping-scanner', actual answer was $OUT,  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt; fi
    
    OUT="`llnms-print-scanner-info -f $SCANFILE -n`"
    if [ ! "$OUT" = "Ping Scanner" ]; then echo '1'; echo "Name of scanner should be 'Ping Scanner', actual answer was $OUT,  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt; fi
    
    OUT="`llnms-print-scanner-info -f $SCANFILE -c`"
    if [ ! "$OUT" = "ping-scanner.sh" ]; then echo '1'; echo "Command for scanner should be 'ping-scanner.sh', actual answer was $OUT,  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt; fi

    echo '0'
}


