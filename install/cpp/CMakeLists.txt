

#   Set the minimum required CMake Version
cmake_minimum_required( VERSION 2.6 )

#   Define our project name
project (LLNMS-Viewer)


#------------------------------------#
#-      Import NCurses Library      -#
#------------------------------------#

SET(CURSES_NEED_NCURSES TRUE)
FIND_PACKAGE(Curses)
include_directories( ${CURSES_NCURSES_INCLUDE_PATH} )



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
    ../../test/gtest/src/gtest-all.cc
    ../../test/gtest/src/gtest_main.cc
)

set( GOOGLE_TEST_HEADERS
    ../../test/gtest/include/gtest/gtest.h
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

include_directories( ../../test/gtest/include )
include_directories( ../../test/gtest )

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


