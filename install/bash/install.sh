#!/bin/sh


#------------------------------#
#-     Usage Instructions     -#
#------------------------------#
usage(){

    echo "$0 [options]"
    echo ""
    echo "    options:"
    echo "      -help | -h)  Print usage instructions"


}


#  Set the LLNMS Home Directory
LLNMS_HOME=/var/tmp/llnms


#  Parse Command-Line Options
for OPTION in $@; do
    
    #  Case for options
    case $OPTION in 

        #   Print the help instructions
        "-help" | "-h" )
            usage
            exit 0
            ;;
        
        #   Default Parameter.  Usually an error
        "*" )
            echo "Error: Unknown option $OPTION"
            usage
            exit 0
            ;;

    esac

done

#  If no options are present, then do a default install


#  make sure the path exists
if [ ! -d $LLNMS_HOME ]; then
    mkdir $LLNMS_HOME
fi


