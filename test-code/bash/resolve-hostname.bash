#!/bin/bash 

IP_LIST=('192.168.0.10')
IP_LIST+=('192.168.0.13')
IP_LIST+=('192.168.0.17')
IP_LIST+=('192.168.0.18')
IP_LIST+=('192.168.0.19')


for i in ${IP_LIST[@]}; do

    #Given an ip address, try to find its hostname
    #nslookup $1

    #smbclient -L $1

    #  Test Traceroute
    h=$(traceroute $i | tail -1 | sed 's/^ //' | sed 's/  */ /' | cut -d' ' -f2 )

    echo "Address: $i, Hostname: $h"
done

