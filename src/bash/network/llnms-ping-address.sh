#!/bin/sh
#
#    File:    llnms-ping-address.sh
#    Author:  Marvin Smith
#    Date:    2/9/2014
#
#    Purpose:  Test an address using ping
#


#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help     :  Print usage instructions'
    echo '        -v, --version  :  Print version information'
    echo ''
    echo '        -ip4 [address] :  Set the address to test.'
    echo '        -c [max-tries] :  Set the number of attempts to try.'
    echo '                          Note: default=1'
    echo ''

}


#-------------------------------------#
#-         Warning Function          -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
warning(){

    #  If the user only gives the warning message
    if [ $# -eq 1 ]; then
        echo "warning: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "warning: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "warning: $1.  Line: $2, File: $3"
    fi
}


#-------------------------------------#
#-            Error Function         -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
error(){

    #  If the user only gives the error message
    if [ $# -eq 1 ]; then
        echo "error: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "error: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "error: $1.  Line: $2, File: $3"
    fi
}


#-------------------------------------#
#           Version Function          #
#-------------------------------------#
version(){

    echo "`basename $0` Information"
    echo ''
    echo "   LLNMS Version ${LLNMS_MAJOR}.${LLNMS_MINOR}.${LLNMS_SUBMINOR}"

}



#--------------------------------#
#-       Main Function          -#
#--------------------------------#

#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi

#  Create options
IP4_ADDRESS=''
MAX_COUNT=1


IP_LOCK=0
TRY_LOCK=0

LOCK_FILE="$LLNMS_HOME/run/llnms-scan-networks.lock"


#    Iterate over command-line arguments
for OPTION in "$@"; do

    case $OPTION in 

        #  Set the IP Address to ping
        '-ip4')
            IP_LOCK=1
            ;;

        #  Set the max tries to ping
        '-c')
            TRY_LOCK=1
            ;;

        #  Other instructions
        *)
            # if the previous option was -ip4, then set our address now
            if [ $IP_LOCK -ne 0 ]; then
                IP4_ADDRESS=$OPTION
                IP_LOCK=0

            # if the max count was the previous option, then set the max count
            elif [ $TRY_LOCK -ne 0 ]; then
                MAX_COUNT=$OPTION
                TRY_LOCK=0

            #  Otherwise, we have an error
            else
                echo "error: Unknown option $OPTION"
                usage
                exit 1
            fi
            ;;
    
    esac
done


#  Ping the address and place the information in the status file
STAT_FILE=$LLNMS_HOME/run/llnms-network-status.txt
RESULT=1


#  Run the ping command
ping -c $MAX_COUNT -q $IP4_ADDRESS > /dev/null
PING_RESULT=$?

#  Pause while we are waiting on the lock file to disappear
while [ -e $LOCK_FILE ]; do
    sleep 1
done

#  Generate a new lock file
touch $LOCK_FILE


#  If the status file does not have the address
if [ "`cat $STAT_FILE | grep $IP4_ADDRESS`" = '' ]; then
    if [ "$PING_RESULT" = '0' ]; then
        echo "${IP4_ADDRESS} 1 `date +%Y-%m-%d-%H:%M:%S`" >> ${STAT_FILE}
        RESULT=0
    else
        echo "${IP4_ADDRESS} 0 `date +%Y-%m-%d-%H:%M:%S`" >> ${STAT_FILE}
        RESULT=1
    fi

#  If the status file does have the address
else
    if [ $PING_RESULT -eq 0 ]; then
        sed -e "s/${IP4_ADDRESS} [01].*/${IP4_ADDRESS} 1 $(date +"%Y-%m-%d-%H:%M:%S")/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
        RESULT=0
    else    
        sed -e "s/${IP4_ADDRESS} [01].*/${IP4_ADDRESS} 0 $(date +"%Y-%m-%d-%H:%M:%S")/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
        RESULT=1
    fi
fi

#  remove the lock file
rm $LOCK_FILE

exit $RESULT
