LLNMS
=====

Low-Level Network Management System

Overview
--------
A network management system designed to operate as an independent collection
of utilities merged into a cohesive NMS solution.

Commands
--------

LLNMS does everything through a set of tools.  Commands to run the LLNMS suite
are generally defined as llnms-**action**-**target**.  

###  Scanning and configuring networks
    
    llnms-add-network

Create a new network file and add it to `$LLNMS_HOME/networks/`.  Use `-h` to print
usage instructions.

    llnms-list-networks

Print the details of all networks registered in LLNMS. Use `-h` to print usage instructions.


    llnms-start-network-scan

Command LLNMS to start scanning the network.  Use `-h` to print usage instructions.


Installation
------------

### Linux (shell)
Most Linux systems contain a basic shell system.  For 
most this will be Bash or Dash (Ubuntu).  To install, 
run the script from the base directory.

    ./install/bash/install.sh

run with -h or -help for more options.

The primary installation option is the destination for `LLNMS_HOME` which 
should be defaulted to `/var/tmp/llnms`.  Given this installation destination,
all components will be installed there. 

