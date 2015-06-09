#!/bin/sh

#  Add the sphinx to python code
export PYTHONPATH=$PYTHONPATH:sphinxtogithub

#  Run the make
make html

#  Copy the code
rsync -av build/html/* $1

