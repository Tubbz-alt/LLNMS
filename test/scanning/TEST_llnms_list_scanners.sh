#!/bin/sh
#
#   File:    TEST_llnms_list_scanners.sh
#   Author:  Marvin Smith
#   Date:    12/25/2013
#
#   Purpose:  This contains all tests related to the llnms-list-scanners script.
#


#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Import llnms configuration
. $LLNMS_HOME/config/llnms-config.sh

# Initialize ANSI
. test/unit_test/unit_test_utilities.sh


#-------------------------------------#
#-   TEST_llnms_list_scanners_01     -#
#-                                   -#
#-   Test the llnms-list-scanners    -#
#-      output.                      -#
#-------------------------------------#
TEST_llnms_list_scanners_01(){
    
    #  make sure the scanner file exists
    SCANFILE1="$LLNMS_HOME/scanning/ping-scanner.llnms-scanner.xml"
    SCANFILE2="$LLNMS_HOME/scanning/ssh-scanner.llnms-scanner.xml"
    if [ ! -e "$SCANFILE1" ]; then
        echo '1'
        echo "Demo scanner at $SCANFILE1 does not exist."
        return
    fi
    if [ ! -e "$SCANFILE2" ]; then
        echo '1'
        echo "Demo scanner at $SCANFILE2 does not exist."
        return
    fi

    #  Delete the registered scanner list if it exists
    if [ -e "$LLNMS_HOME/run/llnms-registered-scanners.xml" ]; then
        rm $LLNMS_HOME/run/llnms-registered-scanners.xml
    fi

    #  Register the two scanners
    llnms-register-scanner.sh -s $SCANFILE1
    llnms-register-scanner.sh -s $SCANFILE2
    
    #  Run the llnms-list-scanner command
    OUTPUT=`llnms-list-scanners.sh -l -i`
    OUT1=0
    OUT2=0
    for SCANNER in $OUTPUT; do
        case $SCANNER in 
            'ping-scanner' )
                OUT1=1
                ;;
            'ssh-scanner' )
                OUT2=1
                ;;
            *)
                echo '1'
                echo "Unknown scanner ($SCANNER) in output.  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
                return
                ;;
        esac
    done
    if [ ! "$OUT1" = '1' ]; then
        echo '1'
        echo "Ping Scanner did not show up in the output. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        return
    fi
    if [ ! "$OUT2" = '1' ]; then
        echo '1'
        echo "SSH Scanner did not show up in the output. File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
        return
    fi



    #  Successful operation
    echo '0'
}


