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
    echo '          -h, --help     :  Print usage instructions'
    echo '          make  [system] :  Build C++ Software'
    echo ''
    echo '              system options:'
    echo '                  all = default : Build everything'
    echo '                  curses        : Build Curses GUI'
    echo '                  gui           : Build Qt GUI'
    echo ''
    echo '        install        :  Install C++ Software'
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
make_curses_software(){

    #  Print message
    echo '->  building curses LLNMS-Viewer'

    #  Make sure the release directory exists
    mkdir -p release

    #  Enter release directory
    cd release

    #  Create Makefile
    cmake ../install/cpp 

    #  Build software 
    make
    MAKE_RESULT="$?"

    #  Exit release directory
    cd ..
    
    if [ ! "$MAKE_RESULT" = "0" ]; then
        error "make failed" $LINENO 
        exit 1
    fi

}

#----------------------------------#
#-           Make Software        -#
#----------------------------------#
make_gui_software(){

    #  Print message
    echo '->  building Qt LLNMS-Viewer'

    #  Run QMake
    echo '  -> Running QMake'
    $QMAKE install/cpp/LLNMS-Viewer-GUI.pro

    #  Run Make
    echo '  -> Running Make'
    make 

    #  Create the release
    echo '  -> Building the release'
    mkdir -p release/share/llnms-viewer/bin
    mkdir -p release/share/llnms-viewer/icons
    cp -r src/cpp/llnms-gui/icons/* release/share/llnms-viewer/icons/
    cp  release/bin/LLNMS-Viewer     release/share/llnms-viewer/bin/LLNMS-Viewer.out
    cp  install/cpp/LLNMS-Viewer.sh  release/share/llnms-viewer/LLNMS-Viewer

}


#-----------------------------------#
#-        Install Software         -#
#-----------------------------------#
install_software(){

    #  Copy LLNMS-Viewer
    echo "->  installing llnms-viewer to $LLNMS_HOME/bin/llnms-viewer"
    cp "release/llnms-viewer"  "$LLNMS_HOME/bin/llnms-viewer"


}


#----------------------------------------#
#-       Set the QMake Variable         -#
#----------------------------------------#
set_qmake(){

    which qmake 2> /dev/null
    if [ "$?" = 0 ]; then 
        QMAKE='qmake'
        return
    fi

    which qmake-qt4 2> /dev/null
    if [ "$?" = 0 ]; then 
        QMAKE='qmake-qt4'
        return
    fi
    
    which qmake-qt5 2> /dev/null
    if [ "$?" = 0 ]; then 
        QMAKE='qmake-qt5'
        return
    fi

}


#-----------------------------#
#-       Main Function       -#
#-----------------------------#


#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info

#  Import the configuration info
. $LLNMS_HOME/config/llnms-config


#   Variables
RUN_MAKE=0
MAKE_FLAG=0
MAKE_VALUE="all"
RUN_INSTALL=0

# Figure out qmake
QMAKE='qmake'
set_qmake


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
            MAKE_FLAG=1
            ;;

        #----------------------------------#
        #-        Default Option          -#
        #----------------------------------#
        *)
            
            #  If make flag is set
            if [ "$MAKE_FLAG" = '1' ]; then
                MAKE_FLAG=0
               
                case $OPTION in
                    'all')
                        MAKE_VALUE='all'
                        ;;
                    'gui')
                        MAKE_VALUE='gui'
                        ;;
                    'curses')
                        MAKE_VALUE='curses'
                        ;;
                    *)
                        error "Unknown make option $OPTION" $LINENO
                        exit 1
                        ;;
                esac

            #  Otherwise throw an error for unknown option
            else
                error "Unknown option $OPTION"
                usage
                exit 1
            fi

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
    
    if [ "$MAKE_VALUE" = 'all' -o "$MAKE_VALUE" = 'curses' ]; then
        make_curses_software
    fi
    
    if [ "$MAKE_VALUE" = 'all' -o "$MAKE_VALUE" = 'gui' ]; then
        make_gui_software
    fi
    
    
fi


#-------------------------------#
#-       Install Software      -#
#-------------------------------#
if [ $RUN_INSTALL -ne 0 ]; then
    install_software
fi


