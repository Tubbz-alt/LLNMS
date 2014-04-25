#!/bin/bash
#
#    File:    llnms-locking-manager.sh
#    Author:  Marvin Smith
#    Date:    4/24/2014
#
#    Purpose: Lock and unlock llnms files
#
#    References: http://wiki.grzegorz.wierzowiecki.pl/code:mutex-in-bash
#

#-----------------------------#
#-           Usage           -#
#-----------------------------#
usage(){

    echo "usage: $0 [lock|unlock] [options]"
    echo ""
    echo "    lock   : Set the lock"
    echo "    unlock : Remove the lock"
    echo ""
    echo '    Options:'
    echo '    -h, --help              : Print usage instructions.'
    echo '    -l, --lockdir [dirname] : Directory for lockfile.'
    echo "                 DEFAULT=$LOCKDIR"
    echo '    -w, --wait              : Wait until lock is available.'
    echo ''

}


#------------------------------#
#-     Create the Lockfile    -#
#------------------------------#
run_lock(){
    
    #  set the lock directory
    local LOCKDIR_LOCAL=$LOCKDIR
    if mkdir "${LOCKDIR_LOCAL}" &> /dev/null; then
        return 0;
    
    #  The lock failed, wait
    elif [ "$WAIT_FLAG" = '1' ]; then
        
        while [ "`run_lock`" = '1' ]; do
            sleep 0.2
        done

    #  The lock failed
    else
        echo 'lock failed'
        return 1;
    fi
        

}

#-------------------------------#
#-     Remove the lockfile     -#
#-------------------------------#
run_unlock(){
    
    #  Get rid of the lock directory
    rm -r "$LOCKDIR" &> /dev/null
    return $?
}

#----------------------------#
#-     Parse Command-Line   -#
#----------------------------#

#   Default Locking Directory
LOCKDIR='/var/tmp/llnms/run/llnms-locking-manager.lock'
LOCKDIR_FLAG=0

#   Wait Flag
WAIT_FLAG=0

#   Parse Command-Line
for ARG in "$@"; do
    case $ARG in

        #  Print usage instructions
        '-h' | '--help')
            usage
            exit 1
            ;;

        #  Wait Flag
        '-w' | '--wait' )
            WAIT_FLAG=1
            ;;

        #  Establish the lockfile
        'lock' )
            RUN_LOCK=1
            ;;

        #  Remove the lockfile
        'unlock' )
            RUN_UNLOCK=1
            ;;

        #  Set the desired lock directory
        '-l' | '--lockdir' )
            LOCKDIR_FLAG=1
            ;;
        
        #  Otherwise check values or print an error message
        *)
            # If we need to grab the lock name
            if [ "$LOCKDIR_FLAG" = '1' ]; then
                LOCKDIR_FLAG=0
                LOCKDIR=$ARG

            # Otherwise, there is an error and we need to exit
            else
                echo "Unknown argument: $ARG" 1>&2
                exit 1
            fi
            ;;
    esac
done


#------------------------------------------------------#
#-      Make sure that we don't lock and unlock       -#
#------------------------------------------------------#
if [ "$RUN_LOCK" = '1' -a "$RUN_UNLOCK" = '1' ]; then
    echo 'You may only run one command.' 1>&2
    usage
    exit 1

#--------------------------------#
#-           Run Lock           -#
#--------------------------------#
elif [ "$RUN_LOCK" = '1' ]; then
    run_lock
    exit $?

#--------------------------------#
#-          Run Unlock          -#
#--------------------------------#
elif [ "$RUN_UNLOCK" = '1' ]; then
    run_unlock
    exit $?

#---------------------------------------#
#-       Otherwise throw an error      -#
#---------------------------------------#
else
    echo 'You must run either lock or unlock' 1>&2
    usage
    exit 1
fi

