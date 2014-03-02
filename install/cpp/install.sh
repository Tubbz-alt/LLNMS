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
    echo '    required flags (at least one must be specified): '
    echo ''
    echo '          -h, --help           :  Print usage instructions'
    echo ''
    echo '          -m, --make [system]  :  Build C++ Software'
    echo ''
    echo '              system options:'
    echo '                  all = default : Build everything'
    echo '                  core          : Build LLNMS Core Library'
    echo '                  cli           : Build NCurses CLI'
    echo '                  gui           : Build Qt GUI'
    echo ''
    echo '    optional flags:'
    echo '          -j [int]              :  Build software with the specified number of threads.'
    echo ''
    echo '          --debug               : Create debug build'
    echo '          --release             : Create release build'
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
make_core_software(){

    #  Set number of threads
    NUM_THREADS=$1

    #  Set the build type
    BUILD_TYPE=$2

    #  Print message
    echo '   ->  building core LLNMS library'
    
    #  Make sure the release directory exists
    if [ "$BUILD_TYPE" = 'release' ]; then
        
        #  Create directory
        echo '      -> ensuring release directory exists'
        mkdir -p release/core

        echo '      -> entering release directory'
        cd release/core

        echo '      -> running CMake'
        cmake ../../install/cpp/core 

    elif [ "$BUILD_TYPE" = 'debug' ]; then
        
        #  Create directory
        echo '      -> ensuring debug directory exists'
        mkdir -p debug/core

        echo '      -> entering debug directory'
        cd debug/core

        # run cmake
        echo '      -> running CMake'
        cmake -DCMAKE_BUILD_TYPE=debug ../../install/cpp/core
    fi


    #  Build software 
    make -j$NUM_THREADS
    MAKE_RESULT="$?"

    #  Exit release directory
    cd ../..
    
    if [ ! "$MAKE_RESULT" = "0" ]; then
        error "make failed" $LINENO 
        exit 1
    fi
    
}

#----------------------------------#
#-           Make Software        -#
#----------------------------------#
make_curses_software(){

    #  Get the number of threads
    NUM_THREADS=$1

    #  Get the build type
    BUILD_TYPE=$2

    #  Print message
    echo '   ->  building c++ cli application'

    if [ "$BUILD_TYPE" = 'release' ]; then
    
        #  Make sure the release directory exists
        mkdir -p release/cli

        #  Enter release directory
        cd release/cli

        #  run cmake
        cmake -DLLNMS_LIB_PATH=../lib ../../install/cpp/cli

    elif [ "$BUILD_TYPE" = 'debug' ]; then
        
        #  Make sure the debug directory exists
        mkdir -p debug/cli

        #  Enter debug directory
        cd debug/cli

        #  run cmake 
        cmake -DCMAKE_BUILD_TYPE=debug -DLLNMS_LIB_PATH=../lib  ../../install/cpp/cli

    else 
        echo "error: invalid build type: $BUILD_TYPE"
        exit 1
    fi

    #  Build software 
    make -j$NUM_THREADS
    MAKE_RESULT="$?"

    #  Exit release directory
    cd ../..
    
    if [ ! "$MAKE_RESULT" = "0" ]; then
        error "make failed" $LINENO 
        exit 1
    fi

}

#----------------------------------#
#-           Make Software        -#
#----------------------------------#
make_gui_software(){
    
    #  Get Number of Threads
    NUM_THREADS=$1

    #  Get build type
    MAKE_BUILD_TYPE=$2

    #  Create structure
    if [ ! -d "$MAKE_BUILD_TYPE/gui" ]; then
        mkdir -p "$MAKE_BUILD_TYPE/gui" 
    fi

    #  Entering structure
    cd $MAKE_BUILD_TYPE/gui

    #  Run CMake
    if [ "$MAKE_BUILD_TYPE" = 'release' ]; then
        cmake ../../install/cpp/gui
    fi

    #  Run Make
    make -j$NUM_THREADS
    
    #  Exit make directory
    cd ../..
    
    #  Copy the Start Script
    cp install/cpp/gui/llnms-gui.sh  $MAKE_BUILD_TYPE/share/llnms/llnms-gui

    #  Copy the icon directory
    mkdir -p $MAKE_BUILD_TYPE/share/llnms/icons
    cp -r src/cpp/llnms-gui/icons/*  $MAKE_BUILD_TYPE/share/llnms/icons/

}   

#----------------------------------------#
#-       Build Include Directory        -#
#----------------------------------------#
build_include_dir(){

    # Set build type
    BUILD_TYPE=$1
    
    #  Create the Release Include Directories
    BASE_INCLUDE_PATH='release'

    if [ "$BUILD_TYPE" = 'debug' ]; then
        BASE_INCLUDE_PATH='debug'
    fi
   
    #  Make the include directory
    mkdir -p $BASE_INCLUDE_PATH/include/llnms/core
    mkdir -p $BASE_INCLUDE_PATH/include/llnms/networking
    mkdir -p $BASE_INCLUDE_PATH/include/llnms/utilities

    #  Copy header files
    cp src/cpp/llnms-core/LLNMS.hpp               $BASE_INCLUDE_PATH/include/
    cp src/cpp/llnms-core/llnms/*.hpp             $BASE_INCLUDE_PATH/include/llnms/
    cp src/cpp/llnms-core/llnms/core/*.hpp        $BASE_INCLUDE_PATH/include/llnms/core/
    cp src/cpp/llnms-core/llnms/networking/*.hpp  $BASE_INCLUDE_PATH/include/llnms/networking/
    cp src/cpp/llnms-core/llnms/utilities/*.hpp   $BASE_INCLUDE_PATH/include/llnms/utilities/
    

}


#-----------------------------#
#-       Main Function       -#
#-----------------------------#


#   Variables
RUN_MAKE=0
MAKE_FLAG=0
MAKE_VALUE="all"
NUM_THREADS=1
THREAD_FLAG=0

#   Set the type of build
BUILD_TYPE='release'

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
        #-    Specify number of threads   -#
        #----------------------------------#
        '-j' )
            THREAD_FLAG=1
            ;;

        #----------------------------------#
        #-           Make Software        -#
        #----------------------------------#
        '-m' | '--make' )
            RUN_MAKE=1
            MAKE_FLAG=1
            ;;

        #--------------------------------------#
        #-        Set Release Build Type      -#
        #--------------------------------------#
        '--release' )
            BUILD_TYPE='release'
            ;;

        #--------------------------------------#
        #-        Set Debug Build Type        -#
        #--------------------------------------#
        '--debug' )
            BUILD_TYPE='debug'
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
                    'core')
                        MAKE_VALUE='core'
                        ;;
                    'gui')
                        MAKE_VALUE='gui'
                        ;;
                    'cli')
                        MAKE_VALUE='cli'
                        ;;
                    *)
                        error "Unknown make option $OPTION" $LINENO
                        exit 1
                        ;;
                esac
            
            #  Look for the thread flag
            elif [ "$THREAD_FLAG" = '1' ]; then
                NUM_THREADS=$OPTION
                THREAD_FLAG=0

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
if [ $RUN_MAKE -eq 0 ]; then
    error "Must run at least one option in the install script"  "$LINENO"
fi

#---------------------------#
#-      Make Software      -#
#---------------------------#
if [ $RUN_MAKE -ne 0 ]; then
    
    if [ "$MAKE_VALUE" = 'all' -o "$MAKE_VALUE" = 'core'  ]; then
        make_core_software $NUM_THREADS $BUILD_TYPE
        build_include_dir $BUILD_TYPE
    fi

    if [ "$MAKE_VALUE" = 'all' -o "$MAKE_VALUE" = 'cli' ]; then
        make_curses_software $NUM_THREADS $BUILD_TYPE
    fi
    
    if [ "$MAKE_VALUE" = 'all' -o "$MAKE_VALUE" = 'gui' ]; then
        make_gui_software $NUM_THREADS $BUILD_TYPE
    fi
        
fi

