#!/bin/bash


#-------------------------------------------------------------------#
#-   Count the number of network definitions for a network file    -#
#-                                                                 -#
#-   Parameters:                                                   -#
#-       $1 - Network File To Count                                -#
#-------------------------------------------------------------------#
llnms-count-network-definitions(){
    
    # use xml starlet select
    echo $(xmlstarlet sel -t -v "count(/llnms-network/networks/network)" $1)
}


#----------------------------------------------------#
#-    Get the name of a network definition file     -#
#----------------------------------------------------#
llnms-get-network-name(){

    echo "$(xmlstarlet sel -t  -v '/llnms-network/name' $1)"
}


#-------------------------------------------------------#
#-    Get the network type from the specified file     -#
#-                                                     -#
#-    $1 - Network File To Decompose                   -#
#-    $2 - Network Definition to Review Starting at 1  -#
#-------------------------------------------------------#
llnms-get-network-type(){
    
    XMLDATA="$(xmlstarlet sel -t -m //network -v type -n $1)"
    
    num=1
    for TYPE in $XMLDATA; do
        if [ "$num" = "$2" ]; then
            echo $TYPE
        fi
        num=$(($num + 1))
    done

}

#-----------------------------------------------------------------#
#-     Get the network address start from the specified file     -#
#-                                                               -#
#-     $1 - LLNMS Network File To Process                        -#
#-     $2 - Address Property to Query                            -#
#-----------------------------------------------------------------#
llnms-get-network-address-start(){
    XMLDATA=$(xmlstarlet sel -t -m //network -v address-start -n $1)
    
    num=1
    for TYPE in $XMLDATA; do
        if [ "$num" == "$2" ]; then
            echo $TYPE
        fi
        num=$(($num+1))
    done
}

#---------------------------------------------------------------#
#-     Get the network address end from the specified file     -#
#-                                                             -#
#-     $1 - LLNMS Network File To Process                      -#
#-     $2 - Address Property to Query                          -#
#---------------------------------------------------------------#
llnms-get-network-address-end(){
    XMLDATA=$(xmlstarlet sel -t -m //network -v address-end -n $1)
    
    num=1
    for TYPE in $XMLDATA; do
        if [ "$num" == "$2" ]; then
            echo $TYPE
        fi
        num=$(($num+1))
    done
}

#-----------------------------------------------------------#
#-     Get the network address from the specified file     -#
#-                                                         -#
#-     $1 - LLNMS Network File To Process                  -#
#-     $2 - Address Property to Query                      -#
#-----------------------------------------------------------#
llnms-get-network-address(){
    
    XMLDATA=$(xmlstarlet sel -t -m //network -v address -n $1)
    
    num=1
    for TYPE in $XMLDATA; do
        if [ "$num" == "$2" ]; then
            echo $TYPE
        fi
        num=$(($num+1))
    done
}


