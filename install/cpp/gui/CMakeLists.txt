#    File:    CMakeLists.txt
#    Author:  Marvin Smith
#    Date:    3/1/2014
#
#    Purpose: Build system for the LLNMS GUI
#

#   Set the minimum required CMake Version
cmake_minimum_required( VERSION 2.6 )

#   Define our project name
project (LLNMS_GUI)

#   Tell CMake where to put binaries and libs
set( EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/../share/llnms/bin)
set( LIBRARY_OUTPUT_PATH    ${PROJECT_BINARY_DIR}/../share/llnms/lib)

#----------------------------------#
#-       Find QT5 Libraries       -#
#----------------------------------#
find_package( Qt5Widgets )
find_package( QtDeclarative )

#  Tell CMake to run moc when necessary
set( CMAKE_AUTOMOC ON )

#  Tell CMake to always look for includes in the MOC path
set( CMAKE_INCLUDE_CURRENT_DIR ON )

#  Include Qt5
include_directories(${Qt5Widgets_INCLUDES})


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



#---------------------------------------#
#-        Find Boost Libraries         -#
#---------------------------------------#
find_package( Boost
                COMPONENTS
                    regex
                    filesystem
                    system 
                REQUIRED
)

#----------------------------------------#
#-       Define our source files        -#
#----------------------------------------#
set( LLNMS_GUI_MAIN
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/llnms_gui.cpp
)

set( LLNMS_GUI_SOURCES
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/DataContainer.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/FileUtilities.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/GUI_Settings.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/Parser.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/AssetPane.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/ConfigPane.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/CreateNetworkDialog.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/MainWindow.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/ModifyNetworkDialog.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/NavigationBar.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/NetworkPane.cpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/SummaryPane.cpp
)

set( LLNMS_GUI_HEADERS
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/DataContainer.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/FileUtilities.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/GUI_Settings.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/Parser.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/core/MessagingService.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/AssetPane.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/ConfigPane.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/CreateNetworkDialog.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/MainWindow.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/ModifyNetworkDialog.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/NavigationBar.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/NetworkPane.hpp
    ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui/gui/SummaryPane.hpp
)

include_directories( ${CMAKE_BINARY_DIR}/../../src/cpp/llnms-gui )


#-----------------------------------------#
#-        Start Building Software        -#
#-----------------------------------------#
add_executable( llnms-gui.out 
                ${LLNMS_GUI_MAIN}
                ${LLNMS_GUI_SOURCES}
                ${LLNMS_GUI_HEADERS}
)

target_link_libraries( llnms-gui.out
                ${Qt5Widgets_LIBRARIES}
                ${Boost_LIBRARIES}
                ${LLNMS_LIBRARY}
)


