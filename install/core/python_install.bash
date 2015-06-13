#!/bin/bash
#
#    File:    python_install.bash
#    Author:  Marvin Smith
#    Date:    11/12/2013
#
#    Purpose:  Install the required Python Modules
#


#------------------------------------------#
#-       Install the Python Library       -#
#------------------------------------------#
install_llnms_python_library(){

    #  Copy the python library
    echo "installing llnms python library to $LLNMS_HOME/lib/llnms"

    #  Create destination
    mkdir -p $LLNMS_HOME/lib

    #  Copy all files
    cp -r src/core/python/llnms $LLNMS_HOME/lib/

}


#------------------------------------------#
#-       Install the Python Viewer        -#
#------------------------------------------#
install_llnms_python_viewer(){
    
    # print message
    echo "installing llnms python viewer to $LLNMS_HOME/bin/python"

    #  Make sure the python dir exists
    if [ ! -d "$LLNMS_HOME/bin/python" ]; then
        mkdir -p "$LLNMS_HOME/bin/python"
    fi

    #  Copy all script to the directory
    cp -r src/core/viewer/*  "$LLNMS_HOME/bin/python/"

    #  Create symbolic link
    if [ -f "$LLNMS_HOME/bin/python/llnms-viewer" ]; then
        rm "$LLNMS_HOME/bin/python/llnms-viewer"
    fi
    ln -s $LLNMS_HOME/bin/python/llnms_viewer.py $LLNMS_HOME/bin/python/llnms-viewer
    
    
}

uninstall_llnms_python_viewer(){

    #  print message
    echo "uninstalling llnms python viewer"

    #  Remove the python directory
    rm -r $LLNMS_HOME/bin/python/*



}

usage(){

    echo "$0 : [options]"
    echo ''
    echo '   options:'
    echo '       -h : Print usage instructions'
    echo '       -i : Install LLNMS (Default)'
    echo '       -u : Uninstall LLNMS'
    echo ''

}

LLNMS_HOME='/var/tmp/llnms'

# Set the default install mode action
INSTALL_MODE="INSTALL"
INSTALL_SAMPLES=0

#  Parse command-line options
for OPTION in $@; do 

    case $OPTION in

        "-i" )
            INSTALL_MODE="INSTALL"
            ;;

        "-u" )
            INSTALL_MODE="UNINSTALL"
            ;;
        
        #   Print usage instructions and exit
        "-h" )
            usage
            exit 1
            ;;

        *)
            echo "error: unknown option $OPTION"
            usage
            exit 1

    esac
done

if [ "$INSTALL_MODE" == "INSTALL" ]; then
    install_llnms_python_viewer
    install_llnms_python_library

elif [ "$INSTALL_MODE" == "UNINSTALL" ]; then
    uninstall_llnms_python_viewer
fi

