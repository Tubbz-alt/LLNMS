#!/bin/bash

install_llnms_python_viewer(){
    
    # print message
    echo "installing llnms python viewer to $LLNMS_HOME/bin/python"

    #  Make sure the python dir exists
    if [ ! -d "$LLNMS_HOME/bin/python" ]; then
        mkdir -p "$LLNMS_HOME/bin/python"
    fi

    #  Copy all script to the directory
    cp -r src/python/*  "$LLNMS_HOME/bin/python/"

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


LLNMS_HOME='/var/tmp/llnms'

# Set the default install mode action
INSTALL_MODE="INSTALL"

#  Parse command-line options
for OPTION in $@; do 

    case $OPTION in

        "-i" )
            INSTALL_MODE="INSTALL"
            ;;

        "-u" )
            INSTALL_MODE="UNINSTALL"
            ;;
        *)
            echo "error: unknown option $OPTION"
            exit 1

    esac
done

if [ "$INSTALL_MODE" == "INSTALL" ]; then
    install_llnms_python_viewer
elif [ "$INSTALL_MODE" == "UNINSTALL" ]; then
    uninstall_llnms_python_viewer
fi


