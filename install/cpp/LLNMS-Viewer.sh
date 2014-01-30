#!/bin/sh


#  Find out where the executable is
BASE_PATH=`dirname $0`

echo "LDPATH: $LD_LIBRARY_PATH"

#  Go to the directory
cd ${BASE_PATH}

./bin/LLNMS-Viewer.out $@

