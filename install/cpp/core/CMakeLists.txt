#    File:    CMakeLists.txt
#    Author:  Marvin Smith
#    Date:    2/15/2014
# 
#    Purpose: Build C++ components of the LLNMS Library
#

#   Set the minimum required CMake Version
cmake_minimum_required( VERSION 2.6 )


#   Define our project name
project (LLNMS)

#   Tell CMake where to put binaries and libs
set( EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/../bin/cpp)
set( LIBRARY_OUTPUT_PATH    ${PROJECT_BINARY_DIR}/../lib)

#   Create a macro for grabbing the date
MACRO (TODAY DATESTRING)
    IF (WIN32)
        EXECUTE_PROCESS(COMMAND "cmd" " /C date /T" OUTPUT_VARIABLE ${DATESTRING})
        string(REGEX REPLACE "(..)/(..)/..(..).*" "\\1/\\2/\\3" ${DATESTRING} ${${DATESTRING}})
    ELSEIF(UNIX)
        EXECUTE_PROCESS(COMMAND "date" "+%d/%m/%Y - %H:%M:%S" OUTPUT_VARIABLE ${DATESTRING})
        string(REGEX REPLACE "(..)/(..)/..(..) - (..):(..):(..).*" "\\1/\\2/\\3 - \\4:\\5:\\6" ${DATESTRING} ${${DATESTRING}})
    ELSE (WIN32)
        MESSAGE(SEND_ERROR "date not implemented")
        SET(${DATESTRING} 000000)
    ENDIF (WIN32)
ENDMACRO (TODAY)
TODAY(DATESTRING)

#   Define the version number
set( LLNMS_VERSION_MAJOR 1 )
set( LLNMS_VERSION_MINOR 0 )
set( LLNMS_VERSION_DATE  "\"${DATESTRING}\"")

message("VERSION DATE: ${LLNMS_VERSION_DATE}")

#   Configure our LLNMS Version Header File
configure_file (
  "${PROJECT_SOURCE_DIR}/../../../src/cpp/llnms-core/llnms/core/Version.hpp.in"
  "${PROJECT_SOURCE_DIR}/../../../src/cpp/llnms-core/llnms/core/Version.hpp"
)

#-------------------------------------#
#-       Import Boost Library        -#
#-------------------------------------#
set( Boost_USE_STATIC_LIBS ON)
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
    ../../../src/cpp/llnms-core/llnms/LLNMS_State.cpp
    ../../../src/cpp/llnms-core/llnms/networking/NetworkModule.cpp
    ../../../src/cpp/llnms-core/llnms/networking/NetworkDefinitionContainer.cpp
    ../../../src/cpp/llnms-core/llnms/networking/NetworkDefinition.cpp
    ../../../src/cpp/llnms-core/llnms/networking/NetworkHost.cpp
    ../../../src/cpp/llnms-core/llnms/networking/NetworkHostContainer.cpp
    ../../../src/cpp/llnms-core/llnms/thirdparty/tinyxml2/tinyxml2.cpp
    ../../../src/cpp/llnms-core/llnms/utilities/FilesystemUtilities.cpp
    ../../../src/cpp/llnms-core/llnms/utilities/StringUtilities.cpp
)
include_directories( ../../../src/cpp/llnms-core )

#-------------------------------------------------#
#-          Create the LLNMS Library             -#
#-------------------------------------------------#
add_library( LLNMS ${LLNMS_SOURCES} ${Boost_LIBRARIES})

#--------------------------------------------------------#
#-            Create the utility applications           -#
#--------------------------------------------------------#

#  llnms-list-hosts
add_executable( llnms-list-hosts    ../../../src/cpp/llnms-core/apps/llnms_list_hosts.cpp )
target_link_libraries( llnms-list-hosts LLNMS ${Boost_LIBRARIES} )

#  llnms-list-networks
add_executable( llnms-list-networks ../../../src/cpp/llnms-core/apps/llnms_list_networks.cpp )
target_link_libraries( llnms-list-networks LLNMS ${Boost_LIBRARIES} )


