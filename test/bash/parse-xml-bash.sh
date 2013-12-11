#!/bin/sh


xmlstarlet sel -t -m '//llnms-asset' -v 'ip4-address' -n $1
