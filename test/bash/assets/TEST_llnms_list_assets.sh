#!/bin/sh
#
#  File:    TEST_llnms_list_assets.sh
#  Author:  Marvin Smith
#  Date:    12/26/2013
#
#  Purpose:  Performs all unit tests on the llnms-list-assets.sh script.
#

#  Make sure LLNMS has been installed
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

# Initialize ANSI
. test/bash/unit_test/unit_test_utilities.sh


#---------------------------------------------#
#-     TEST_llnms_list_assets_01             -#
#-                                           -#
#-     First unit test of the llnms list     -#
#-     assets function.                      -#
#---------------------------------------------#
TEST_llnms_list_assets_01(){

    #  Make sure no assets exist in the directory
    rm $LLNMS_HOME/assets/*.llnms-asset.xml 2> /dev/null

    #  Create an asset using the create asset command
    $LLNMS_HOME/bin/llnms-create-asset  -host 'temp-asset1' -ip4 '192.168.0.1' -d 'hello world'
    $LLNMS_HOME/bin/llnms-create-asset  -host 'temp-asset2' -ip4 '10.2.18.200' -d 'other test file'
    $LLNMS_HOME/bin/llnms-create-asset  -host 'temp-asset3' -ip4 '172.2.18.200' -d 'final test file'
    
    #   Get a list of assets by name 
    ASSETS="`$LLNMS_HOME/bin/llnms-list-assets -l -path`"
    A1=0
    A2=0
    A3=0
    for ASSET in $ASSETS; do
        case $ASSET in 
            "$LLNMS_HOME/assets/temp-asset1.llnms-asset.xml" )
                A1=1
                ;;
            "$LLNMS_HOME/assets/temp-asset2.llnms-asset.xml" )
                A2=1
                ;;
            "$LLNMS_HOME/assets/temp-asset3.llnms-asset.xml" )
                A3=1
                ;;
            *)
                echo "Unknown Asset ($ASSET) found which does not match created assets.  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
                echo '1'
                return;
                ;;

            esac
    done
    if [ "$A1" = '0' ]; then echo "temp-asset1 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi
    if [ "$A2" = '0' ]; then echo "temp-asset2 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi
    if [ "$A3" = '0' ]; then echo "temp-asset3 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi
    
    #   Get a list of assets by name 
    ASSETS="`$LLNMS_HOME/bin/llnms-list-assets -l -host`"
    A1=0
    A2=0
    A3=0
    for ASSET in $ASSETS; do
        case $ASSET in 
            "temp-asset1" )
                A1=1
                ;;
            "temp-asset2" )
                A2=1
                ;;
            "temp-asset3" )
                A3=1
                ;;
            *)
                echo "Unknown Asset $ASSET found which does not match created assets.  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
                echo '1'
                return;
            esac
    done
    if [ "$A1" = '0' ]; then echo "temp-asset1 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi
    if [ "$A2" = '0' ]; then echo "temp-asset2 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi
    if [ "$A3" = '0' ]; then echo "temp-asset3 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi

    #   Get a list of assets by name 
    ASSETS="`$LLNMS_HOME/bin/llnms-list-assets -l -ip4`"
    A1=0
    A2=0
    A3=0
    for ASSET in $ASSETS; do
        case $ASSET in 
            "192.168.0.1" )
                A1=1
                ;;
            "10.2.18.200" )
                A2=1
                ;;
            "172.2.18.200" )
                A3=1
                ;;
            *)
                echo "Unknown Asset $ASSET found which does not match created assets.  File: `basename $0`, Line: $LINENO." > /var/tmp/cause.txt
                echo '1'
                return;
            esac
    done
    if [ "$A1" = '0' ]; then echo "temp-asset1 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi
    if [ "$A2" = '0' ]; then echo "temp-asset2 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi
    if [ "$A3" = '0' ]; then echo "temp-asset3 was not listed when it should be. File `basename $0`, Line $LINENO." > /var/tmp/cause.txt; echo 1; return; fi



    #  Remove all files
    $LLNMS_HOME/bin/llnms-remove-asset -host 'temp-asset1'
    $LLNMS_HOME/bin/llnms-remove-asset -host 'temp-asset2'
    $LLNMS_HOME/bin/llnms-remove-asset -host 'temp-asset3'

    #  Successful Operation 
    echo '0'

}

