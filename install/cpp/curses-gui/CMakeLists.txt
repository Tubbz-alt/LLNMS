#    File:    CMakeLists.txt
#    Author:  Marvin Smith
#    Date:    1/1/2014
# 
#    Purpose: Build C++ components of the LLNMS Library
#

#   Set the minimum required CMake Version
cmake_minimum_required( VERSION 2.6 )


#   Define our project name
project (LLNMS)


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
set( LLNMS_SOURCES
    src/cpp/llnms-core/networking/NetworkModule.cpp
    src/cpp/llnms-core/networking/NetworkDefinitionContainer.cpp
    src/cpp/llnms-core/networking/NetworkDefinition.cpp
    src/cpp/llnms-core/thirdparty/tinyxml2/tinyxml2.cpp
)

set( LLNMS_HEADERS
    src/cpp/llnms-core/networking/NetworkModule.hpp
    src/cpp/llnms-core/networking/NetworkDefinitionContainer.hpp
    src/cpp/llnms-core/networking/NetworkDefinition.hpp
    src/cpp/llnms-core/thirdparty/tinyxml2/tinyxml2.h
)

#-------------------------------------------------#
#-          Create the LLNMS Library             -#
#-------------------------------------------------#
add_library( LLNMS ${LLNMS_SOURCES} ${LLNMS_HEADERS} )


#--------------------------------------------------------#
#-          Create the llnms-list-networks app          -#
#--------------------------------------------------------#
add_executable( llnms-list-networks src/cpp/llnms-core/apps/llnms_list_networks.cpp )
target_link_libraries( llnms-list-networks ${LLNMS} )


#-----------------------------------------------------#
#-      Define a list of LLNMS-Viewer Sources        -#
#-----------------------------------------------------#
set( LLNMS_VIEWER_SOURCES
        ../../src/cpp/llnms-viewer/llnms_viewer.cpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Asset.cpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Asset_Manager.cpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Network.cpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Network_Host.cpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Network_Host_Update.cpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Network_Manager.cpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_State.cpp
        ../../src/cpp/llnms-viewer/llnms/tinyxml2.cpp
        ../../src/cpp/llnms-viewer/ui/asset_ui.cpp
        ../../src/cpp/llnms-viewer/ui/asset_information_ui.cpp
        ../../src/cpp/llnms-viewer/ui/asset_status_ui.cpp
        ../../src/cpp/llnms-viewer/ui/configure_ui.cpp
        ../../src/cpp/llnms-viewer/ui/create_llnms_asset_ui.cpp
        ../../src/cpp/llnms-viewer/ui/network_manager_ui.cpp
        ../../src/cpp/llnms-viewer/ui/network_status_ui.cpp
        ../../src/cpp/llnms-viewer/ui/error_ui.cpp
        ../../src/cpp/llnms-viewer/ui/main_menu.cpp
        ../../src/cpp/llnms-viewer/utilities/CursesUtilities.cpp
        ../../src/cpp/llnms-viewer/utilities/Logger.cpp
        ../../src/cpp/llnms-viewer/utilities/FileUtilities.cpp
        ../../src/cpp/llnms-viewer/utilities/NetworkUtilities.cpp
        ../../src/cpp/llnms-viewer/utilities/Options.cpp
        ../../src/cpp/llnms-viewer/utilities/Parser.cpp
        ../../src/cpp/llnms-viewer/utilities/Table.cpp
)

set( LLNMS_VIEWER_HEADERS
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Asset.hpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Asset_Manager.hpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Network.hpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Network_Host.hpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Network_Host_Update.hpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_Network_Manager.hpp
        ../../src/cpp/llnms-viewer/llnms/LLNMS_State.hpp
        ../../src/cpp/llnms-viewer/llnms/tinyxml2.h
        ../../src/cpp/llnms-viewer/ui/asset_ui.hpp
        ../../src/cpp/llnms-viewer/ui/asset_status_ui.hpp
        ../../src/cpp/llnms-viewer/ui/asset_information_ui.hpp
        ../../src/cpp/llnms-viewer/ui/configure_ui.hpp
        ../../src/cpp/llnms-viewer/ui/create_llnms_asset_ui.hpp
        ../../src/cpp/llnms-viewer/ui/error_ui.hpp
        ../../src/cpp/llnms-viewer/ui/main_menu.hpp
        ../../src/cpp/llnms-viewer/ui/network_manager_ui.hpp
        ../../src/cpp/llnms-viewer/ui/network_status_ui.hpp
        ../../src/cpp/llnms-viewer/utilities/CursesUtilities.hpp
        ../../src/cpp/llnms-viewer/utilities/FileUtilities.hpp
        ../../src/cpp/llnms-viewer/utilities/Logger.hpp
        ../../src/cpp/llnms-viewer/utilities/NetworkUtilities.hpp
        ../../src/cpp/llnms-viewer/utilities/Options.hpp
        ../../src/cpp/llnms-viewer/utilities/Parser.hpp
        ../../src/cpp/llnms-viewer/utilities/Table.hpp
)


#--------------------------------------------------#
#-      Create the LLNMS-Viewer Executable        -#
#--------------------------------------------------#
add_executable( llnms-viewer 
    ${LLNMS_VIEWER_SOURCES}
    ${LLNMS_VIEWER_HEADERS}
)
target_link_libraries( llnms-viewer
                        ${CURSES_NCURSES_LIBRARY}
                        ${Boost_LIBRARIES}
)


#--------------------------------------------#
#-      Create the unit test library        -#
#--------------------------------------------#
set( GOOGLE_TEST_SOURCES
    ../../test/cpp/gtest/src/gtest-all.cc
    ../../test/cpp/gtest/src/gtest_main.cc
)

set( GOOGLE_TEST_HEADERS
    ../../test/cpp/gtest/include/gtest/gtest.h
)

set( LLNMS_UNIT_TEST_SOURCES 
    ../../src/cpp/llnms-viewer/llnms/TEST_LLNMS_Network.cpp
    ../../src/cpp/llnms-viewer/llnms/TEST_LLNMS_Network_Host.cpp
)

set( LLNMS_SOURCES 
    ../../src/cpp/llnms-viewer/llnms/LLNMS_Network.cpp
    ../../src/cpp/llnms-viewer/llnms/LLNMS_Network_Host.cpp
)

set( LLNMS_HEADERS
    ../../src/cpp/llnms-viewer/llnms/LLNMS_Network.hpp
    ../../src/cpp/llnms-viewer/llnms/LLNMS_Network_Host.hpp
)

include_directories( ../../test/cpp/gtest/include )
include_directories( ../../test/cpp/gtest )

add_executable( llnms-viewer-unit-test
    ${GOOGLE_TEST_SOURCES}
    ${GOOGLE_TEST_HEADERS}
    ${LLNMS_SOURCES}
    ${LLNMS_HEADERS}
    ${LLNMS_UNIT_TEST_SOURCES}
)
target_link_libraries( llnms-viewer-unit-test
                        ${CURSES_NCURSES_LIBRARY}
                        ${Boost_LIBRARIES}
)


