#!/bin/sh
#
#  Name:    install.sh
#  Author:  Marvin Smith
#  Date:    11/23/2013
#
#  Purpose:  LLNMS shell-script installer
#

#------------------------------#
#-     Usage Instructions     -#
#------------------------------#
usage(){

    echo "$0 [options]"
    echo ""
    echo "    options:"
    echo "      -help | -h)  Print usage instructions"
    echo ""
    echo "      -uninstall)  Uninstall LLNMS from LLNMS_HOME (Note: Should preserve user created data)"
    echo ""

}


#-----------------------------------------------------#
#-     Build and Verify the Filestructure Exists     -#
#-----------------------------------------------------#
build_and_verify_filestructure(){

    #  Verify LLNMS_HOME
    if [ ! -d "$DEFAULT_LLNMS_HOME" ]; then
        mkdir -p "$DEFAULT_LLNMS_HOME"
    fi

    #  Verify the binary path
    if [ ! -d "$DEFAULT_LLNMS_BIN_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_BIN_PATH"
    fi

    # Verify the network directory
    if [ ! -d "$DEFAULT_LLNMS_NETWORK_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_NETWORK_PATH"
    fi
    
    # Verify the temp directory
    if [ ! -d "$DEFAULT_LLNMS_TEMP_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_TEMP_PATH"
    fi
    
    # Verify the run directory
    if [ ! -d "$DEFAULT_LLNMS_RUN_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_RUN_PATH" 
    fi
    
    # Verify the log directory exists
    if [ ! -d "$DEFAULT_LLNMS_LOG_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_LOG_PATH"
    fi

}


#-----------------------------------------------#
#-     Install all tools to the filesystem     -#
#-----------------------------------------------#
install_to_filesystem(){
    
    #  Copy the add-network
    cp src/llnms/network/add/bash/llnms-add-network.bash $LLNMS_HOME/bin/

    #  Copy the list-networks
    cp src/llnms/network/list/bash/llnms-list-networks.bash $LLNMS_HOME/bin/
    
    #  Copy the xml starlet utils
    cp src/xmlstarlet/bash/llnms-xmlstarlet-functions.bash $LLNMS_HOME/bin/
    
    #  Copy the start and stop network scanning functions
    cp src/llnms/network/scan/bash/llnms-scan-networks.bash  $LLNMS_HOME/bin/
    
    #  Copy the network utility scripts
    cp src/llnms/network/utilities/bash/llnms-network-utilities.bash $LLNMS_HOME/bin/
    
    #  Copy the network resolve scripts
    cp src/llnms/network/resolve/bash/llnms-resolve-network-addresses.bash $LLNMS_HOME/bin/

    #  Copy the log utilities
    cp src/llnms/log/utilities/bash/llnms-log-utilities.bash $LLNMS_HOME/bin/

}

#----------------------------#
#-     Uninstall LLNMS      -#
#----------------------------#
uninstall_llnms( ){
    
    #  Print notice
    echo "Uninstalling LLNMS from $LLNMS_HOME"

    #  Remove scripts
    if [ $(ls $LLNMS_HOME/bin/llnms-* 2>/dev/null | wc -l) -ne 0 ]; then
        rm $LLNMS_HOME/bin/llnms-*
    fi

    #  Remove logs
    if [ $(ls $LLNMS_HOME/logs/llnms*.log 2>/dev/null | wc -l) -ne 0 ]; then
        rm $LLNMS_HOME/logs/llnms-*.log
    fi


}

#  import our default configuration
. install/bash/options.sh

#  Set the LLNMS Home Directory
export LLNMS_HOME=$DEFAULT_LLNMS_HOME

#  Parse Command-Line Options
for OPTION in $@; do
    
    #  Case for options
    case $OPTION in 

        #   Print the help instructions
        "-help" | "-h" )
            usage
            exit 0
            ;;
        
        #   Uninstall LLNMS
        "-uninstall" )
            
            uninstall_llnms
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
echo "LLNMS_HOME=$LLNMS_HOME"

#  build the baseline filestructure
build_and_verify_filestructure

#  copy the tools to the directory
install_to_filesystem


