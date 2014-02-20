#!/bin/sh
#
#    File:    install.sh
#    Author:  Marvin Smith
#    Date:    2/19/2014
#
#    Purpose:  Unified installer script for the LLNMS suite
#


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


#---------------------------------------------------#
#-            Print Installation Banner            -#
#---------------------------------------------------#
print_banner(){
    
    echo ''
    echo 'LLNMS Installation Utility'
    echo '--------------------------'
    echo "LLNMS_HOME=$LLNMS_HOME"
    echo ''
}

#---------------------------------------------------#
#-            Print Usage Instructions             -#
#---------------------------------------------------#
usage(){

    echo ''
    echo "usage: $0 [options]"
    echo ''
    echo '    options:'
    echo ''
    echo '    -m, --make [system]  : Build the relevant system.'
    echo '        systems:'
    echo '            all [default]' 
    echo '            core       - OS-specific LLNMS core scripts.'
    echo '            cpp        - C++ Libraries'
    echo '            curses-gui - NCurses GUI'
    echo '            qt-gui - C++ Qt GUI'
    echo ''
    echo '    -i, --install        : Install LLNMS Components'
    echo ''
    echo '    -t, --test           : Run all unit tests'
    echo ''
    echo '    -c, --clean          : Remove all existing builds.'
    echo ''

}


#--------------------------------------------#
#-        Clean All Software Builds         -#
#--------------------------------------------#
clean_software(){
    
    echo '-> cleaning existing software builds.'

    #  check for release directory
    if [ -e 'release' ]; then
        echo '  -> removing release build'
        rm -rf 'release'
    fi

    #  check for debug directory
    if [ -e 'debug' ]; then
        echo '  -> removing debug build'
        rm -rf 'debug'
    fi


}

#----------------------------------------#
#-             Main Function            -#
#----------------------------------------#


#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#  Import the version info
. $LLNMS_HOME/config/llnms-info

#  Import the configuration info
. $LLNMS_HOME/config/llnms-config


#   Print Installation Banner
print_banner

#   Main Flags
MAKE_TEMP_FLAG=0
MAKE_FLAG=0
TEST_FLAG=0
CLEAN_FLAG=0

#   Type of make
#   all  : Everything
#   core : Bash components
#   cpp  : CPP Library
#
MAKE_BUILD_TYPE='all'


#   Parse command-line options
for OPTION in "$@"; do
    
    case $OPTION in
        
        #----------------------------#
        #-        Help/Usage        -#
        #----------------------------#
        '-h' | '--help' )
            usage
            exit 1
            ;;
        
        #----------------------------#
        #        Clean Software     -#
        #----------------------------#
        '-c' | '--clean' )
            CLEAN_FLAG=1
            MAKE_TEMP_FLAG=0
            ;;
        
        #-----------------------------#
        #-       Make Software       -#
        #-----------------------------#
        '-m' | '--make' )
            MAKE_FLAG=1
            MAKE_TEMP_FLAG=1
            ;;

        #--------------------------------------------------#
        #-      Grab the second value or throw flag       -#
        #--------------------------------------------------#
        *)
            #-    Check for the second make variable    -#
            if [ "$MAKE_TEMP_FLAG" = '1' ]; then
                MAKE_TEMP_FLAG=0
                MAKE_BUILD_TYPE=$OPTION

            #-    Otherwise there is an error for an unknown option   -#
            else
                error "Unknown option $OPTION" $LINENO
                usage
                exit 1
            fi
                
    esac

done


#---------------------------------------------------------#
#-       Make sure at least one main flag was given      -#
#---------------------------------------------------------#
if [ "$MAKE_FLAG" = '0' -a "$TEST_FLAG" = '0' -a "$CLEAN_FLAG" = '0' ]; then
    error "At least one flag must be given." $LINENO
    usage
    exit 1
fi


#-----------------------------------------------------------#
#-       If clean was set, then clean software builds      -#
#-----------------------------------------------------------#
if [ "$CLEAN_FLAG" = '1' ]; then
    clean_software
fi


#----------------------------------------------------------#
#-       If make was set, build the proper library        -#
#----------------------------------------------------------#
if [ "$MAKE_FLAG" = '1' ]; then

    #  install the bash components into llnms_home
    if [ "$MAKE_BUILD_TYPE" = 'all' -o "$MAKE_BUILD_TYPE" = 'core' ]; then
        error 'core not supported yet.' $LINENO
        exit 1
    fi

    #  build the C++ core library
    if [ "$MAKE_BUILD_TYPE" = 'all' -o "$MAKE_BUILD_TYPE" = 'cpp' ]; then
        error 'cpp not supported yet.' $LINENO
        exit 1
    fi

fi


#  Finish by printing a newline and exiting
echo '-> end of LLNMS Installation Utility'
exit 0

