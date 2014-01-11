#!/bin/sh
#
#   File:    install.sh
#   Author:  Marvin Smith
#   Date:    12/31/2013
#
#   Purpose:  Builds and installs the llnms-viewer application.
#

#----------------------------------------#
#-       Print Usage Instructions       -#
#----------------------------------------#
usage(){

    echo "`basename $0` [options]"
    echo ''
    echo '    options:'
    echo '        -h, --help    :  Print usage instructions'
    echo '        make          :  Build C++ Software'
    echo '        install       :  Install C++ Software'
    echo ''
}


#-------------------------------------#
#-         Warning Function          -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
warning(){

    #  If the user only gives the warning message
    if [ $# -eq 1 ]; then
        echo "warning: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "warning: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "warning: $1.  Line: $2, File: $3"
    fi
}

#-------------------------------------#
#-            Error Function         -#
#-                                   -#
#-   $1 -  Error Message             -#
#-   $2 -  Line Number (Optional).   -#
#-   $3 -  File Name (Optional).     -$
#-------------------------------------#
error(){

    #  If the user only gives the error message
    if [ $# -eq 1 ]; then
        echo "error: $1."

    #  If the user only gives the line number
    elif [ $# -eq 2 ]; then
        echo "error: $1.  Line: $2,  File: `basename $0`"

    #  If the user gives the line number and file
    else
        echo "error: $1.  Line: $2, File: $3"
    fi
}


#----------------------------------#
#-           Make Software        -#
#----------------------------------#
make_software(){

    #  Print message
    echo '->  building c++ software'

    #  Make sure the release directory exists
    mkdir -p release

    cd release

    cmake ../install/cpp 

    make

}


#-----------------------------------#
#-        Install Software         -#
#-----------------------------------#
install_software(){

    #  Copy LLNMS-Viewer
    echo "->  installing llnms-viewer to $LLNMS_HOME/bin/llnms-viewer"
    cp "release/llnms-viewer"  "$LLNMS_HOME/bin/llnms-viewer"


}


#-----------------------------#
#-       Main Function       -#
#-----------------------------#


#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info.sh

#  Import the configuration info
. $LLNMS_HOME/config/llnms-config.sh


#   Variables
RUN_MAKE=0
RUN_INSTALL=0



#   Parse command-line options
for OPTION in "$@"; do

    case $OPTION in

        #----------------------------------#
        #-    Print Usage Instructions    -#
        #----------------------------------#
        '-h' | '--help' )
            usage
            exit 1
            ;;
        
        #----------------------------------#
        #-          Make Software         -#
        #----------------------------------#
        'install' )
            RUN_INSTALL=1
            ;;

        #----------------------------------#
        #-        Install Software        -#
        #----------------------------------#
        'make' )
            RUN_MAKE=1
            ;;

        #----------------------------------#
        #-        Default Option          -#
        #----------------------------------#
        *)
            
            #else
                error "Unknown option $OPTION"
                usage
                exit 1
            #fi

            ;;

    esac

done


#-------------------------------------------------#
#      Check if at least one option was set      -#
#-------------------------------------------------#
if [ $RUN_MAKE -eq 0 -a $RUN_INSTALL -eq 0 ]; then
    error "Must run at least one option in the install script"  "$LINENO"
fi

#---------------------------#
#-      Make Software      -#
#---------------------------#
if [ $RUN_MAKE -ne 0 ]; then
    make_software
fi


#-------------------------------#
#-       Install Software      -#
#-------------------------------#
if [ $RUN_INSTALL -ne 0 ]; then
    install_software
fi


