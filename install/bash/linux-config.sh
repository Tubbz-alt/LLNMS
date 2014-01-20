#!/bin/sh

#  Set LLNMS_HOME
LLNMS_HOME="$1"

#  Creating Darwin-specific options
echo "-> Building the Linux-specific llnms configuration file in $LLNMS_HOME/config/llnms-config"

#  Set echo
echo "ECHO=echo" >> $LLNMS_HOME/config/llnms-config


