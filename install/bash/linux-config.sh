#!/bin/sh

#  Set LLNMS_HOME
LLNMS_HOME="$1"

#  Set echo
echo "ECHO=echo" >> $LLNMS_HOME/config/llnms-config

#  Set the number of threads
echo "export LLNMS_THREAD_COUNT=`nproc`" >> $LLNMS_HOME/config/llnms-config

