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
    echo "      -h,  -help       :  Print usage instructions"
    echo "      -u,  -uninstall  :  Uninstall LLNMS from LLNMS_HOME (Note: Should preserve user created data)"
    echo '      -s,  --samples   :  Install LLNMS Sample Configuration Files'
    echo '      -n,  --no-update :  Skip updating the version file.'
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
    
    # Verify the config path exists
    if [ ! -d "$DEFAULT_LLNMS_CONFIG_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_CONFIG_PATH"
    fi
    
    # Verify the asset paths exist
    if [ ! -d "$DEFAULT_LLNMS_ASSET_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_ASSET_PATH"
    fi

    # Verify the scanner path exists
    if [ ! -d "$DEFAULT_LLNMS_SCAN_PATH" ]; then
        mkdir -p "$DEFAULT_LLNMS_SCAN_PATH"
        mkdir -p "$DEFAULT_LLNMS_SCAN_PATH/scanners"
    fi


}


#-----------------------------------------------#
#-     Install all tools to the filesystem     -#
#-----------------------------------------------#
install_to_filesystem(){
    
    # llnms assets
    echo ''
    echo '-> Copying asset module scripts'
    
    echo '   -> llnms-create-asset.sh'
    cp 'src/bash/assets/llnms-create-asset.sh'            $LLNMS_HOME/bin/
    
    echo '   -> llnms-remove-asset.sh'
    cp 'src/bash/assets/llnms-remove-asset.sh'            $LLNMS_HOME/bin/
    
    echo '   -> llnms-list-assets.sh'
    cp 'src/bash/assets/llnms-list-assets.sh'             $LLNMS_HOME/bin/
    
    echo '   -> llnms-print-asset-info.sh'
    cp 'src/bash/assets/llnms-print-asset-info.sh'        $LLNMS_HOME/bin/
    
    echo '   -> llnms-register-asset-scanner.sh'   
    cp 'src/bash/assets/llnms-register-asset-scanner.sh'  $LLNMS_HOME/bin/

    # networks
    #cp src/bash/network/*.bash   $LLNMS_HOME/bin/

    #  llnms utilities
    #cp src/bash/utilities/*.bash $LLNMS_HOME/bin/
    #cp src/bash/utilities/*.sh     $LLNMS_HOME/bin/

    #  Scanning utilities
    echo ''
    echo '-> Copying scanning module scripts'
    
    echo '   -> llnms-list-scanners.sh'
    cp 'src/bash/scanning/llnms-list-scanners.sh'      $LLNMS_HOME/bin/

    echo '   -> llnms-register-scanner.sh'
    cp 'src/bash/scanning/llnms-register-scanner.sh'   $LLNMS_HOME/bin/
    
    echo '   -> llnms-print-scanner-info.sh' 
    cp 'src/bash/scanning/llnms-print-scanner-info.sh' $LLNMS_HOME/bin/
    
    echo '   -> llnms scanner scripts'
    cp -r  src/bash/scanning/scanners/*                $LLNMS_HOME/scanning/

    #  config utilities
    cp src/bash/llnms-info.sh    $LLNMS_HOME/config/

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


#----------------------------------------#
#-       Install LLNMS Samples          -#
#----------------------------------------#
install_samples(){
    
    #  Copy networks
    cp data/samples/networks/*.llnms-network.xml     $LLNMS_HOME/networks/

    #  Copy assets
    cp data/samples/assets/defined/*.llnms-asset.xml $LLNMS_HOME/assets/defined/

}


#-------------------------#
#-    Check xmlstarlet   -#
#-------------------------#
check_xmlstarlet(){
    
    #  Look for xmlstarlet on the main path
    which 'xmlstarlet' &> /dev/null
    if [ $? -eq 0 ]; then
        return 0
    fi

    #   Look for the actual file
    XMLSTARLET_BIN=`find / -name 'xmlstarlet' 2> /dev/null`
    if [ "$XMLSTARLET_BIN" = '' ]; then
        return 1
    else
        return 0
    fi
    
    return 1
}

#------------------------------------------------------#
#-    Check LLNMS Pre-Requisites for installation     -#
#------------------------------------------------------#
check_prerequisites(){

    echo '-> checking LLNMS installation pre-requisites'

    #  Check for xmlstarlet
    echo "   -> checking xmlstarlet : \c"
    check_xmlstarlet
    if [ $? -eq 0 ]; then
        echo 'found'
    else
        echo 'not found'
        echo 'error: xmlstarlet not found, please install'
        exit 1
    fi

}


#----------------------------------------------------------------#
#-     Build the installation-specific configuration file       -#
#----------------------------------------------------------------#
create_configuration_file(){

    echo ''
    #  Create the file
    if [ -e "$LLNMS_HOME/config/llnms-config.sh" ]; then
        rm -r $LLNMS_HOME/config/llnms-config.sh
    fi

    #  If we are using Darwin, then build the Darwin-specific options
    if [ "`uname`" = "Darwin" ]; then
        ./install/bash/darwin-config.sh "$LLNMS_HOME"

    #  If we are using Linux, add the -e to the echo
    else
        echo "ECHO=echo -e" >> $LLNMS_HOME/config/llnms-config.sh
    fi


}

#-----------------------------#
#-      Main Function        -#
#-----------------------------#
# clear the screen
clear

#  Pick header
echo ''
echo 'LLNMS Installer'
echo '---------------'

#  import our default configuration
. install/bash/options.sh

#  Set the LLNMS Home Directory
export LLNMS_HOME=$DEFAULT_LLNMS_HOME


#  Parse Command-Line Options
INSTALL_SAMPLES=0
UPDATE_LLNMS=1

for OPTION in $@; do
    
    #  Case for options
    case $OPTION in 

        #   Print the help instructions
        "-help" | "-h" )
            usage
            exit 0
            ;;
        
        #   Uninstall LLNMS
        "-u" | "-uninstall" )
            
            uninstall_llnms
            exit 0
            ;;
        
        #   Install LLNMS Samples
        '-s' | '--samples' )
            install_samples
            exit 1
            ;;

        #   Skip update of llnms version file
        '-n' | '--no-update' )
            UPDATE_LLNMS=0
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
echo "-> Configuration information"
echo "   -> LLNMS_HOME=$LLNMS_HOME"
echo ''

#  build the baseline filestructure
build_and_verify_filestructure

#  Check prerequisites
check_prerequisites

#  Increment the version file
echo ''
if [ $UPDATE_LLNMS -eq 1 ]; then
    echo "-> Updating LLNMS Version Information in $LLNMS_HOME/config/llnms-info.sh"
    ./install/bash/version.sh -i subminor
else
    echo "-> Skipping update of LLNMS Version Information in $LLNMS_HOME/config/llnms-info.sh"
fi

#  copy the tools to the directory
install_to_filesystem

#  Create the configuration file
create_configuration_file

#  Install samples
if [ $INSTALL_SAMPLES -eq 1 ]; then
    install_samples
fi

echo ''
echo 'End of LLNMS Installer'
echo '----------------------'

