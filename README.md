LLNMS
=====

Low-Level Network Management System

Disclaimers
-----------
This is mostly a tool for me to learn and practice on the Linux
command-line. This is not meant to be used in a production environment or 
in anything which you hold dear to your heart as I have a unique ability
to render mostly anything completely unusable...

Recommended for Fedora/RHEL Systems.  Ubuntu's Dash is far to rigid for my bashisms
and is still very much having issues dealing with my shell scripts.  I am trying to 
convert it though and hopefully will have it working soon.

Thanks and please feel free to let me know what you think or how I can improve it!


Overview
--------
A network management system designed to operate as an independent collection
of utilities merged into a _someday_ cohesive NMS solution.  

The primary objective is to provide the bare essential structure such that the entire package can be installed 
in a non-root locations, and provide minimal functionality.  Expanded functionality can 
then be added on through additional extensions.  Most core utilities are written in Bash
with the `llnms-viewer` application written in Python.  The C++ api will most likely be removed as it is
like pounding a nail in with a screwdriver.

Commands
--------

LLNMS does everything through a set of command-line tools.  Commands to run the LLNMS suite
are generally defined as llnms-**action**-**item**.  

###  Network Management

In LLNMS, networks are a ranges of IP addresses.  A network has a start and end address.  For a single
address, just set the two to the same address. For example, a home router network may look like

    192.168.0.1 to 192.168.0.254
    
If you just need to hit Google, then target

    8.8.8.8 to 8.8.8.8

Networks can be scanned to locate endpoints and other hosts.

To create a new network, run 

    llnms-create-network -n <name> -as <start-address> -ae <end-address>
    
To list available networks

    llnms-list-networks
    
To print information about a network

    llnms-print-network-info -f $LLNMS_HOME/network/<file>.llnms-network.xml
    
To delete a network

    llnms-remove-network
    
To scan a network

    llnms-scan-network

This is a very slow operation currently.  I basically just do ping here, but with multiple threads.  I 
need to clean this implementation up and replace it with a better concept.  The good part is that
the bash script is now thread safe when writing to the config file.

###  Asset Management

LLNMS assets serve to represent single endpoints on a network.  They are known artifacts that will
not raise red flags if detected during a network scan.

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

LLNMS Uses a single shell script to manage its build system.

To get assistance with the installer

    ./llnms-installer.sh -h

To build the full LLNMS system

    ./llnms-installer.sh -m all

To install LLNMS

    ./llnms-installer.sh -i --PREFIX /var/tmp/llnms

To run unit tests

    ./llnms-installer.sh -t

Here is a list of packages you will need to build everything

1.  xmlstarlet 

### Windows (PowerShell)
Windows 7 and later ship with Windows PowerShell.


Building and Unit-Testing
-------------------------

###  Linux (shell)
LLNMS comes with a full unit-test suite for both LLNMS and LLNMS-Viewer.  To do a complete setup and build, read the documentation at docs/overview/overview.pdf.

In general, this is the recommended process. 

First, install LLNMS

    ./install/bash/install -n

Next, run the llnms unit test suite.  You should have complete passes or else there is a bug.

    ./test/bash/run_tests.sh


