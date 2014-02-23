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
    echo '    required flags (at least one must be specified):'
    echo ''
    echo '    -m, --make [system]  : Build the relevant system.'
    echo '        systems:'
    echo '            all [default]' 
    echo '            core       - LLNMS core scripts.'
    echo '            cpp        - C++ Libraries'
    echo '            cli        - NCurses CLI'
    echo '            qt-gui     - Qt GUI'
    echo ''
    echo '    -i, --install        : Install LLNMS Components'
    echo '            NOTE: Anything that was installed with make commands'
    echo '                  will be installed.'
    echo ''
    echo '    -t, --test  [system] : Run unit tests'
    echo '         systems:'
    echo '             all [default]'
    echo '             core      - LLNMS core scripts'
    echo '             cpp       - C++ Libraries'
    echo '             cli       - C++ CLI Application'
    echo ''
    echo '    -c, --clean          : Remove all existing builds.'
    echo ''
    echo '   optional flags:'
    echo '    --release            : Create release build'
    echo '    --debug              : Create debugging build'
    echo ''
    echo '    -j [int]             : Set number of threads.'
    echo ''
    echo '    --PREFIX <new path>  : Set a new destination path.'
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


#-------------------------------------#
#-        Make Core Software         -#
#-------------------------------------#
make_core_software(){

    #  Set the make build type
    MAKE_BUILD_TYPE=$1

    #  print message
    echo '-> building core software'
    echo "   -> build type: $MAKE_BUILD_TYPE"

    #  set destination
    MAKE_PATH='release/llnms'
    if [ "$MAKE_BUILD_TYPE" = 'debug' ]; then
        MAKE_PATH='debug/llnms'
    fi
    
    #  Call the installer for bash
    ./install/bash/install.sh "-n" "--PREFIX" "$MAKE_PATH" 

}

#------------------------------------#
#-       Make CPP Core Library      -#
#------------------------------------#
make_cpp_core_software(){

    #  Set the make build type
    MAKE_BUILD_TYPE=$1

    #  Set the number of threads
    NUM_THREADS=$2

    #  Print message
    echo '-> building c++ core library'
    echo "   -> build type    : $MAKE_BUILD_TYPE"
    echo "   -> number threads: $NUM_THREADS"

    #  Set the make flag
    MAKE_PARAMETER='--release'
    if [ "$MAKE_BUILD_TYPE" == 'debug' ]; then
        MAKE_PARAMETER='--debug'
    fi

    #  Run installer
    ./install/cpp/install.sh "--make" "core" "$MAKE_PARAMETER" "-j" "$NUM_THREADS"
    if [ ! "$?" = '0' ]; then
        error "C++ Core Library install failed." $LINENO
        exit 1
    fi

}

#----------------------------------------#
#-       Make CPP CLI Application       -#
#----------------------------------------#
make_cpp_cli_software(){

    #  Set the make build type
    MAKE_BUILD_TYPE=$1

    #  Set the number of threads
    NUM_THREADS=$2

    #  Print message
    echo '-> building c++ cli application'
    echo "   -> build type    : $MAKE_BUILD_TYPE"
    echo "   -> number threads: $NUM_THREADS"

    #  Set the make flag
    MAKE_PARAMETER='--release'
    if [ "$MAKE_BUILD_TYPE" == 'debug' ]; then
        MAKE_PARAMETER='--debug'
    fi

    #  Run installer
    ./install/cpp/install.sh "--make" "cli" "$MAKE_PARAMETER" "-j" "$NUM_THREADS"
    if [ ! "$?" = '0' ]; then
        error "C++ CLI install failed." $LINENO
        exit 1
    fi

}

#----------------------------------------#
#-             Main Function            -#
#----------------------------------------#


#  Source llnms home
if [ "$LLNMS_HOME" = "" ]; then
    LLNMS_HOME="/var/tmp/llnms"
fi


#   Main Flags
MAKE_COMPONENT_FLAG=0
TEST_COMPONENT_FLAG=0
MAKE_FLAG=0
TEST_FLAG=0
CLEAN_FLAG=0

#  Thread flags
THREAD_FLAG=0
NUM_THREADS=1

#   Type of make/test components
#   all  : Everything
#   core : Bash components
#   cpp  : CPP Library
#
MAKE_COMPONENTS='all'
TEST_COMPONENTS='all'


#   Type of builds
#   release
#   debug
#
MAKE_BUILD_TYPE='release'

#   Set the prefix
PREFIX='/var/tmp/llnms'
PREFIX_FLAG=0

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
            MAKE_COMPONENT_FLAG=1
            ;;
        
        #------------------------------#
        #-       Test Software        -#
        #------------------------------#
        '-t' | '--test' )
            TEST_FLAG=1
            TEST_COMPONENT_FLAG=1
            ;;

        #--------------------------------#
        #-      Make Release Build      -#
        #--------------------------------#
        '--release')
            MAKE_BUILD_TYPE='release'
            ;;

        #---------------------------------#
        #-       Make Debug Build        -#
        #---------------------------------#
        '--debug' )
            MAKE_BUILD_TYPE='debug'
            ;;
        
        #-----------------------------#
        #-       Set the prefix      -#
        #-----------------------------#
        '--PREFIX' )
            PREFIX_FLAG=1
            ;;

        #------------------------------------#
        #-      Set number of threads       -#
        #------------------------------------#
        '-j' )
            THREAD_FLAG=1
            ;;

        #--------------------------------------------------#
        #-      Grab the second value or throw flag       -#
        #--------------------------------------------------#
        *)
            #-    Check for the second make variable    -#
            if [ "$MAKE_COMPONENT_FLAG" = '1' ]; then
                MAKE_COMPONENT_FLAG=0
                MAKE_COMPONENTS=$OPTION
            
            #-    Check for the second test variable    -#
            elif [ "$TEST_COMPONENT_FLAG" = '1' ]; then
                TEST_COMPONENT_FLAG=0
                TEST_COMPONENTS=$OPTION

            #-     Get the prefix     -#
            elif [ "$PREFIX_FLAG" = '1' ]; then
                PREFIX=$OPTION
                PREFIX_FLAG=0

            #-    Set the number of threads   -#
            elif [ "$THREAD_FLAG" = '1' ]; then
                NUM_THREADS=$OPTION
                THREAD_FLAG=0
            
            #-    Otherwise there is an error for an unknown option   -#
            else
                error "Unknown option $OPTION" $LINENO
                usage
                exit 1
            fi
                
    esac

done


#   Print Installation Banner
print_banner

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
    if [ "$MAKE_COMPONENTS" = 'all' -o "$MAKE_COMPONENTS" = 'core' ]; then
        make_core_software  $MAKE_BUILD_TYPE
    fi

    #  build the C++ core library
    if [ "$MAKE_COMPONENTS" = 'all' -o "$MAKE_COMPONENTS" = 'cpp' ]; then
        make_cpp_core_software $MAKE_BUILD_TYPE $NUM_THREADS
    fi

    #  build the C++ CLI Application
    if [ "$MAKE_COMPONENTS" = 'all' -o "$MAKE_COMPONENTS" = 'cli' ]; then
        make_cpp_cli_software $MAKE_BUILD_TYPE $NUM_THREADS
    fi


fi

#-------------------------------------------------------------------------#
#-      If test flag was set, build and release the proper library.      -#
#-------------------------------------------------------------------------#
if [ "$TEST_FLAG" = '1' ]; then

    #  Set LLNMS Home depending on the build type
    if [ "$MAKE_BUILD_TYPE" = 'release' ]; then
        export LLNMS_HOME='release/llnms'
    elif [ "$MAKE_BUILD_TYPE" = 'debug' ]; then
        export LLNMS_HOME='debug/llnms'
    fi

    #  If the core library was set, then run the test script there.
    if [ "$TEST_COMPONENTS" = 'all' -o "$TEST_COMPONENTS" = 'core' ]; then
        
        #  Make sure the paths exist or else build them
        if [ "$MAKE_BUILD_TYPE" = 'release' ]; then
            if [ ! -d 'release/llnms/bin' ]; then
                error "No release build exists, please run make first." $LINENO
                usage
                exit 1
            fi
        elif [ "$MAKE_BUILD_TYPE" = 'debug' ]; then
            if [ ! -d 'debug/llnms/bin' ]; then
                error "No debug build exists, please run make first." $LINENO
                usage
                exit 1
            fi
        else
            error "Unknown build type ($MAKE_BUILD_TYPE)" $LINENO
            usage
            exit 1
        fi
        
        #  Run the command
        ./test/bash/run-tests.sh 
    fi

fi


#  Finish by printing a newline and exiting
echo '-> end of LLNMS Installation Utility'
exit 0

