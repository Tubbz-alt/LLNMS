#!/bin/sh
#
#   File:    install.sh
#   Author:  Marvin Smith
#   Date:    12/31/2013
#
#   Purpose:  Builds and installs the llnms-viewer application.
#



#  Make sure the release directory exists
mkdir -p release/tmp/llnms
mkdir -p release/tmp/ui
mkdir -p release/bin

make -f install/cpp/Makefile 

