#!/bin/sh
#
#    File:    llnms-scan-address.sh
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
    echo '        -n [filename]  :  Set network status file'
    echo ''
    echo '         --debug       :  Print debugging information'
    echo '         --quiet       :  Keep in quiet mode'
    echo '         --verbose     :  Print information'
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


#--------------------------------------------------#
#-        Create Empty Network Status File        -#
#--------------------------------------------------#
create_empty_network_status_file(){
    
    #  Create the lockfile for the status file
    $LLNMS_HOME/bin/llnms-locking-manager lock --lockdir $LLNMS_HOME/run/llnms-network-status.lock
    
    #  Create file
    touch $STAT_FILE

    echo '<llnms-network-status>' >   $STAT_FILE
    echo '</llnms-network-status>' >> $STAT_FILE
    
    #  Wipe out the lockfile
    $LLNMS_HOME/bin/llnms-locking-manager unlock --lockdir $LLNMS_HOME/run/llnms-network-status.lock

}

#------------------------------------------------------#
#-           Update the network status file           -#
#------------------------------------------------------#
update_network_status(){
    
    #  Create the lockfile for the status file
    $LLNMS_HOME/bin/llnms-locking-manager lock --lockdir $LLNMS_HOME/run/llnms-network-status.lock -w
    
    #  Get arguments
    ADDRESS=$1
    PING_RESULT=$2
    STAT_FILE=$3

    PING_STATE="true"
    if [ "$PING_RESULT" = '0' ]; then
        PING_STATE='true'
    else
        PING_STATE='false'
    fi
    
    #  As a failsafe, ensure llnms-network-status node exists
    if [ "`cat $STAT_FILE`" = '' ]; then
        rm $STAT_FILE
        create_empty_network_status_file
    fi
    
    #   Get a list of all hosts and their addresses
    HOST_ADDRESS_LIST="`xmlstarlet sel -t -m "//llnms-network-status/host" -v '@ip4-address' -n $STAT_FILE`"
    
    #  Check if the address is in the host address list
    HOST_LIST="`echo $HOST_ADDRESS_LIST | grep $ADDRESS`"
    
    #  If the host is not inside the address list, then create the nodes
    if [ "$HOST_LIST" = '' ]; then
        
        #  Create the host node
        xmlstarlet ed -L -s '/llnms-network-status' -t elem -n host -v ''  $STAT_FILE

        #  set the address attribute
        xmlstarlet ed -L -i '/llnms-network-status/host[not(@ip4-address)]' -t attr -n ip4-address -v "$ADDRESS" $STAT_FILE
        
        #  Add the status log node
        xmlstarlet ed -L -s "/llnms-network-status/host[@ip4-address=\"$ADDRESS\"]" -t elem -n 'status-log' -v '' $STAT_FILE
    fi

    #  Add the status entry
    xmlstarlet ed -L -s "/llnms-network-status/host[@ip4-address=\"$ADDRESS\"]/status-log" -t elem -n 'status' -v '' $STAT_FILE
    
    #  Set the responsiveness
    xmlstarlet ed -L -i "/llnms-network-status/host[@ip4-address=\"$ADDRESS\"]/status-log/status[not(@responsive)]" -t attr -n 'responsive' -v "$PING_STATE" $STAT_FILE
    
    #  Set the date
    xmlstarlet ed -L -i "/llnms-network-status/host[@ip4-address=\"$ADDRESS\"]/status-log/status[not(@timestamp)]" -t attr -n 'timestamp' -v `date +"%Y-%m-%d-%H:%M:%S"` $STAT_FILE
    
    #  Wipe out the lockfile
    $LLNMS_HOME/bin/llnms-locking-manager unlock --lockdir $LLNMS_HOME/run/llnms-network-status.lock

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
STAT_FILE="$LLNMS_HOME/run/llnms-network-status.xml"

#  Flag options
IP_FLAG=0
TRY_FLAG=0
STAT_FLAG=0

#  Printing options
PRINT_MODE='QUIET'

#    Iterate over command-line arguments
for OPTION in "$@"; do

    case $OPTION in 

        #  Set the IP Address to ping
        '-ip4')
            IP_FLAG=1
            ;;

        #  Set the max tries to ping
        '-c')
            TRY_FLAG=1
            ;;
        
        #  Set the network status filename
        '-n' )
            STAT_FLAG=1
            ;;
        
        #  Set debug mode
        '--debug' )
            PRINT_MODE='DEBUG'
            ;;

        #  Set quiet mode
        '--quiet' )
            PRINT_MODE='QUIET'
            ;;

        #  Set verbose mode
        '--verbose' )
            PRINT_MODE='VERBOSE'
            ;;

        #  Other instructions
        *)
            # if the previous option was -ip4, then set our address now
            if [ $IP_FLAG -ne 0 ]; then
                IP4_ADDRESS=$OPTION
                IP_FLAG=0

            # if the max count was the previous option, then set the max count
            elif [ $TRY_FLAG -ne 0 ]; then
                MAX_COUNT=$OPTION
                TRY_FLAG=0

            #  If the network status flag is set, grab the value
            elif [ $STAT_FLAG -ne 0 ]; then
                STAT_FILE=$OPTION
                STAT_FLAG=0

            #  Otherwise, we have an error
            else
                echo "error: Unknown option $OPTION"
                usage
                exit 1
            fi
            ;;
    
    esac
done


#  Create a status file for output
if [ "$PRINT_MODE" = 'DEBUG' ]; then
    echo "Address    : $IP4_ADDRESS"
    echo "Max Tries  : $MAX_COUNT"
    echo "Status File: $STAT_FILE"
fi


#  Run the ping command
ping -c $MAX_COUNT -q $IP4_ADDRESS > /dev/null
PING_RESULT=$?


#  If the network status file does not exist, then create one
if [ ! -e $STAT_FILE ]; then
    create_empty_network_status_file $STAT_FILE
fi

#  Update the network status
update_network_status "$IP4_ADDRESS"  "$PING_RESULT"  "$STAT_FILE"

if [   "$PRINT_MODE" = 'VERBOSE' -a "$PING_RESULT" = '0' ]; then
    echo "testing address: $IP4_ADDRESS, status: responsive"

elif [ "$PRINT_MODE"  ]; then
    echo "testing address: $IP4_ADDRESS, status: non-responsive"
    
fi

exit $PING_RESULT
