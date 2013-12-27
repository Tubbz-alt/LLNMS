#!/bin/sh

#  Set LLNMS_HOME
LLNMS_HOME="$1"

#  Creating Darwin-specific options
echo "-> Building the Darwin-specific llnms configuration file in $LLNMS_HOME/config/llnms-config.sh"

#  Set echo
echo "ECHO=echo" >> $LLNMS_HOME/config/llnms-config.sh

#  Set echo with escape
echo "ECHO_ESC=echo -e" >> $LLNMS_HOME/config/llnms-config.sh

