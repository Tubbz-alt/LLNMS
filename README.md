LLNMS
=====

Low-Level Network Management System

Overview
--------
A network management system designed to operate as an independent collection
of utilities merged into a cohesive NMS solution.

Commands
--------

LLNMS does everything through a set of command-line tools.  Commands to run the LLNMS suite
are generally defined as llnms-**action**-**target**.  

###  Network Management




###  Asset Management

To create an asset, 

    llnms-create-asset

To remove an asset,

    llnms-remove-asset
 


###  LLNMS-Viewer

LLNMS-Viewer is a command-line application designed to make using LLNMS easier.  It is
designed with ncurses to allow for use when logged via ssh or another network protocol. To
run, type

    llnms-viewer



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

### Windows (PowerShell)
Windows 7 and later ship with Windows PowerShell.



