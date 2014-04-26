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

1.  Qt5
2.  xmlstarlet 

### Windows (PowerShell)
Windows 7 and later ship with Windows PowerShell.


Building and Unit-Testing
-------------------------

###  Linux (shell)
LLNMS comes with a full unit-test suite for both LLNMS and LLNMS-Viewer.  To do a complete setup and build, read the documentation at docs/overview/overview.pdf.

In general, this is the recommended process. 

First, install LLNMS

    ./install/bash/install -n

Next, build LLNMS-Viewer and install

    ./install/cpp/install make install

Next, run the llnms unit test suite.  You should have complete passes or else there is a bug.

    ./test/bash/run_tests.sh

Finally, run the llnms-viewer unit-test suite.  You should have complete passes or else there is a bug.
    
    ./release/llnms-viewer-unit-test


