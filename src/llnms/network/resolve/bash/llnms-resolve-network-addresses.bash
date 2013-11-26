#!/bin/bash


#------------------------------------#
#-     Print Usage Instructions     -#
#------------------------------------#
usage(){
    
    echo "usage: $0 [options]"
    echo ''
    echo '    options:'
    echo ''
    echo "      -h | -help)  Print usage instructions"

}


#------------------------------------#
#-           Main Function          -#
#------------------------------------#

#  Parse Command-Line Options
for OPTION in $@; do

    case $OPTION in 
        
        #  Print Usage Instructions
        "-h" | "-help" )
            usage
            exit 1
            ;;

        #  Print Error
        *)
            echo "Error: unknown option $OPTION"
            usage
            exit 1
            ;;

    esac
done

