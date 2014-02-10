#!/bin/sh


#-----------------------#
#-        Usage        -#
#-----------------------#
usage(){

    echo "$0 [options]"
    echo ""
    echo '    options:'
    echo '        -ip4 [ip4-address]        : IP Address'
    echo '        -c [max tries, 1 default] : Max count for ping'
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


for OPTION in $@; do

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

if [ $PING_RESULT -eq 0 ]; then
    sed -e "s/${IP4_ADDRESS} [01].*/${IP4_ADDRESS} 1 $(date +"%Y-%m-%d-%H:%M:%S")/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
    RESULT=0
else    
    sed -e "s/${IP4_ADDRESS} [01].*/${IP4_ADDRESS} 0 $(date +"%Y-%m-%d-%H:%M:%S")/g" $STAT_FILE > ${STAT_FILE}.tmp && mv ${STAT_FILE}.tmp $STAT_FILE
    RESULT=1
fi

#  remove the lock file
rm $LOCK_FILE

exit $RESULT
