#!/bin/sh
#
#   File:    llnms-debug.sh
#   Author:  Marvin Smith
#   Date:    12/10/2013
# 
#   Purpose:  This script acts as a debugging tool to give you information
#             about the host system which may be relevant.  This will check 
#             critical dependencies and ensure that all of the required tools
#             are installed.
#



#------------------------------------------#
#-       Print Usage Instructions         -#
#------------------------------------------#
usage(){
    
    echo "$0 [options]"
    echo ''
    echo '    options:'
    echo '        -h | --help : Print usage instructions'
    echo ''

}


#-------------------------------------------------#
#-      Verify that xmlstarlet is installed      -#
#-------------------------------------------------#
verify-xmlstarlet(){



}

#-----------------------------------#
#-          Main Function          -#
#-----------------------------------#



#   Parse command-line options
for OPTION in $@; do

    case OPTION in 

        #   Print help usage instructions
        "-h" | "--help" )
            usage
            exit 1
            ;;

        #   As default, print error instruction
        *) 
            echo "error: Unknown flag $OPTION"
            usage
            exit 1
            ;;


    esac
done



#   Check that we have xmlstarlet installed
verify-xmlstarlet

