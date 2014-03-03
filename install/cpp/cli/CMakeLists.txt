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

#   Tell CMake where to put binaries and libs
set( EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/../bin)
set( LIBRARY_OUTPUT_PATH    ${PROJECT_BINARY_DIR}/../lib)

#   Add the LLNMS CMake Module Path
set( CMAKE_MODULE_PATH "${CMAKE_MODULE_PATH}" ${PROJECT_SOURCE_DIR}/../cmake )

#------------------------------------#
#-      Import NCurses Library      -#
#------------------------------------#
SET(CURSES_NEED_NCURSES TRUE)
FIND_PACKAGE(Curses REQUIRED)

#-----------------------------------#
#-      Import LLNMS Library       -#
#-----------------------------------#
FIND_LIBRARY( LLNMS_LIBRARY 
                REQUIRED
                NAMES 
                    LLNMS
                    libLLNMS.a
                HINTS
                    ${PROJECT_BINARY_DIR}/../lib
)
include_directories( ${PROJECT_BINARY_DIR}/../include )

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
    ../../src/cpp/llnms-cli/llnms_cli.cpp
)

set( LLNMS_CLI_SOURCES
    ../../src/cpp/llnms-cli/core/Options.cpp
    ../../src/cpp/llnms-cli/core/Parser.cpp
    ../../src/cpp/llnms-cli/ui/AboutUI.cpp
    ../../src/cpp/llnms-cli/ui/ConfigurationUI.cpp
    ../../src/cpp/llnms-cli/ui/CreateNetworkDefinitionUI.cpp
    ../../src/cpp/llnms-cli/ui/MainMenu.cpp
    ../../src/cpp/llnms-cli/ui/MessageDialog.cpp
    ../../src/cpp/llnms-cli/ui/NetworkManagerUI.cpp
    ../../src/cpp/llnms-cli/utilities/CursesUtilities.cpp
    ../../src/cpp/llnms-cli/utilities/FilesystemUtilities.cpp
    ../../src/cpp/llnms-cli/utilities/Table.cpp
)

set( LLNMS_CLI_HEADERS
    ../../src/cpp/llnms-cli/core/Options.hpp
    ../../src/cpp/llnms-cli/core/Parser.hpp
    ../../src/cpp/llnms-cli/ui/AboutUI.hpp
    ../../src/cpp/llnms-cli/ui/ConfigurationUI.hpp
    ../../src/cpp/llnms-cli/ui/CreateNetworkDefinitionUI.hpp
    ../../src/cpp/llnms-cli/ui/MainMenu.hpp
    ../../src/cpp/llnms-cli/ui/MessageDialog.hpp
    ../../src/cpp/llnms-cli/ui/NetworkManagerUI.hpp
    ../../src/cpp/llnms-cli/utilities/CursesUtilities.hpp
    ../../src/cpp/llnms-cli/utilities/FilesystemUtilities.hpp
    ../../src/cpp/llnms-cli/utilities/Table.hpp
)

#--------------------------------------------------#
#-      Create the LLNMS-CLI Executable        -#
#--------------------------------------------------#
include_directories( ../../../src/cpp/llnms-cli )

add_executable( llnms-cli
    ${LLNMS_CLI_MAIN}
    ${LLNMS_CLI_SOURCES}
    ${LLNMS_CLI_HEADERS}
)
target_link_libraries( llnms-cli
                        ${LLNMS_LIBRARY}
                        ${CURSES_NCURSES_LIBRARY}
                        ${Boost_LIBRARIES}
)


