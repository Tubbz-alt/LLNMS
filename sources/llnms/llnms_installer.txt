.. _llnms_installer:

LLNMS Installer Script
======================

The LLNMS Installer script can be run with the following command from the base
directory.::

    ./llnms-installer.sh

An output of help is given below.::

    $>./llnms-installer.sh -h

    usage: ./llnms-installer.sh [options]

         required flags (at least one must be specified):

         -m, --make [system]  : Build the relevant system.
             systems:
             all [default]
             core       - LLNMS core scripts.

         -i, --install        : Install LLNMS Components
             NOTE: Anything that was installed with make commands
             will be installed.

         -t, --test  [system] : Run unit tests
             systems:
             all [default]
             core      - LLNMS core scripts

         -c, --clean          : Remove all existing builds.

         optional flags:
             --release            : Create release build
             --debug              : Create debugging build

             -j [int]             : Set number of threads.

             --PREFIX <new path>  : Set a new destination path.


