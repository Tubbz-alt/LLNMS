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

Create a new network file and add it to `$LLNMS_HOME/networks/scanners/`

Installation
------------

### Linux (shell)
Most Linux systems contain a basic shell system.  For 
most this will be Bash or Dash (Ubuntu).  To install, 
run the script from the base directory.

    ./install/bash/install.sh

run with -h or -help for more options.

