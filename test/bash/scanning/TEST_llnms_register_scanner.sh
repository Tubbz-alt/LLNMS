#!/bin/sh
#
#   File:    TEST_llnms_register_scanner.sh
#   Author:  Marvin Smith
#   Date:    12/25/2013
#
#   Purpose:  This contains all tests related to the llnms-register-scanner script.
#


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

# Initialize ANSI
. test/bash/unit_test/unit_test_utilities.sh


#-------------------------------------#
#-   TEST_llnms_register_scanner_01  -#
#-                                   -#
#-   Test the created file output    -#
#-   from llnms-register_scanner.    -#
#-------------------------------------#
TEST_llnms_register_scanner_01(){
    
    #  make sure the scanner file exists
    if [ ! -e $LLNMS_HOME/scanning/ping-scanner.llnms-scanner.xml ]; then
        echo '1'
        echo "Demo scanner at $LLNMS_HOME/scanning/ping-scanner.llnms-scanner.xml does not exist."
        return
    fi
    SCANFILE1="$LLNMS_HOME/scanning/ping-scanner.llnms-scanner.xml"
    
    #  make sure the second scanner file exists
    if [ ! -e $LLNMS_HOME/scanning/ssh-scanner.llnms-scanner.xml ]; then
        echo '1'
        echo "Demo scanner at $LLNMS_HOME/scanning/ssh-scanner.llnms-scanner.xml does not exist."
        return
    fi
    SCANFILE2="$LLNMS_HOME/scanning/ssh-scanner.llnms-scanner.xml"
    

    #  clear the list of registered scanners
    if [ -e "$LLNMS_HOME/run/llnms-registered-scanners.xml" ]; then
        rm "$LLNMS_HOME/run/llnms-registered-scanners.xml"
    fi

    #  Register a new scanner
    $LLNMS_HOME/bin/llnms-register-scanner -s $SCANFILE1 > /dev/null
    OUT="$?"

    #  Make sure the item was registered successfully
    if [ ! "$OUT" = "0" ]; then echo '1'; echo "Exit code was not 0, but $OUT. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt; return; fi

    #  Make sure the registered scan list exists
    if [ ! -e "$LLNMS_HOME/run/llnms-registered-scanners.xml" ]; then
        echo '1'; echo "The registered scanner list does not exist.  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        return;
    fi

    #  Make sure the scanner list contains the registered file only once
    RESULT="`xmlstarlet sel -t -m '//llnms-registered-scanners' -v 'llnms-scanner' -n $LLNMS_HOME/run/llnms-registered-scanners.xml`"
    if [ ! "`echo $RESULT | grep $SCANFILE1`" =  "$SCANFILE1" ]; then
        echo '1'
        echo "\n        The registered scanner is not correctly registered.\n        The output is...\n        $RESULT" > /var/tmp/cause.txt
        return
    fi

    #  Re-register the same file
    $LLNMS_HOME/bin/llnms-register-scanner -s $SCANFILE1 > /dev/null
    
    OUT="$?"
    #  Make sure an error is returned for already being registered
    if [ ! "$OUT" = "2" ]; then echo '1'; echo "Exit code was not 2, but $OUT. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt; return; fi
    
    #  Make sure the scanner list contains the registered file only once
    RESULT="`xmlstarlet sel -t -m '//llnms-registered-scanners' -v 'llnms-scanner' -n $LLNMS_HOME/run/llnms-registered-scanners.xml`"
    if [ ! "`echo $RESULT | grep $SCANFILE1`" =  "$SCANFILE1" ]; then
        echo '1'
        echo "\n        The registered scanner is not correctly registered.\n        The output is...\n        $RESULT" > /var/tmp/cause.txt
        return
    fi

    #  register another scanner
    OUT=0
    $LLNMS_HOME/bin/llnms-register-scanner -s $SCANFILE2 > /dev/null
    OUT="$?"

    #  Make sure the item was registered successfully
    if [ ! "$OUT" = "0" ]; then echo '1'; echo "Exit code was not 0, but $OUT. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt; return; fi
    
    #  Make sure the scanner list contains the registered file only once
    RESULT="`xmlstarlet sel -t -m '//llnms-registered-scanners' -v 'llnms-scanner' -n $LLNMS_HOME/run/llnms-registered-scanners.xml`"
    if [ ! "`echo $RESULT | grep ${SCANFILE1}${SCANFILE2}`" =  "${SCANFILE1}${SCANFILE2}" ]; then
        echo '1'
        echo "\n        The registered scanner is not correctly registered.\n        The output is...\n        $RESULT" > /var/tmp/cause.txt
        return
    fi



    echo '0'
}


