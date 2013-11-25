#!/bin/bash




#-----------------------------------#
#-    Print usage instructions     -#
#-----------------------------------#
usage(){
    
    echo "Purpose: Add a network to be monitored by LLNMS."
    echo ""
    echo "usage: $0 [options]"
    echo ""
    echo "   options:"
    echo ""
    echo "       -h | -help) Show usage instructions"
    echo ""
    echo "       -name ) Name of the network"
    echo "       -start ) Start processing a network"
    echo "         -type ) Type of network"
    echo "         -start ) Starting address"
    echo "         -end ) Ending address."


}


#-------------------------#
#-     Main Function     -#
#-------------------------#

#  Output data we want to find
NAME=""

#  Flags for internal use
NAME_FLAG=0

#  Parse command-line options
for OPTION in $@; do

    case $OPTION in 
        

        #  Print Usage Instructions
        "-h" | "-help" )
            usage
            exit 1
            ;;
        
        #  Name of the network
        "-name" | "-n" )
            NAME_FLAG=1
            ;;
        
        #  Check for flags, otherwise error
        *)
            
            # Check for name flag
            if [ "$NAME_FLAG" == "1" ]; then
                NAME_FLAG=0
                NAME=$OPTION

            #  Otherwise we have an error
            else
                echo "Error: unknown option $OPTION"
                exit 1
            fi
            ;;
    esac
done


#  Print the network stats
echo "NAME: $NAME"

