#    File:    CMakeLists.txt
#    Author:  Marvin Smith
#    Date:    1/1/2014
# 
#    Purpose: Build C++ CLI Application
#

#   Set the minimum required CMake Version
cmake_minimum_required( VERSION 2.6 )


#   Define our project name
project (LLNMS-CPP-CLI)


#------------------------------------#
#-      Import NCurses Library      -#
#------------------------------------#
SET(CURSES_NEED_NCURSES TRUE)
FIND_PACKAGE(Curses)

#-------------------------------------#
#-       Import Boost Library        -#
#-------------------------------------#
find_package( Boost  
                COMPONENTS
                    system
                    filesystem
                    regex
                    date_time
)
include_directories( ${Boost_INCLUDE_DIR} )


#----------------------------------------------------------#
#-      Define the list of LLNMS Sources and Headers      -#
#----------------------------------------------------------#
set( LLNMS_CLI_MAIN

)

set( LLNMS_CLI_SOURCES

)

set( LLNMS_CLI_HEADERS

)

#--------------------------------------------------#
#-      Create the LLNMS-CLI Executable        -#
#--------------------------------------------------#
add_executable( llnms-cli
    ${LLNMS_CLI_MAIN}
    ${LLNMS_CLI_SOURCES}
    ${LLNMS_CLI_HEADERS}
)
target_link_libraries( llnms-cli
                        ${CURSES_NCURSES_LIBRARY}
                        ${Boost_LIBRARIES}
)


