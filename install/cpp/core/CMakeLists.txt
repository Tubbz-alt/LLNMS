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

#   Create a macro for grabbing the date
MACRO (TODAY DATESTRING)
    IF (WIN32)
        EXECUTE_PROCESS(COMMAND "cmd" " /C date /T" OUTPUT_VARIABLE ${DATESTRING})
        string(REGEX REPLACE "(..)/(..)/..(..).*" "\\1/\\2/\\3" ${DATESTRING} ${${DATESTRING}})
    ELSEIF(UNIX)
        EXECUTE_PROCESS(COMMAND "date" "+%d/%m/%Y" OUTPUT_VARIABLE ${DATESTRING})
        string(REGEX REPLACE "(..)/(..)/..(..).*" "\\1/\\2/\\3" ${DATESTRING} ${${DATESTRING}})
    ELSE (WIN32)
        MESSAGE(SEND_ERROR "date not implemented")
        SET(${DATESTRING} 000000)
    ENDIF (WIN32)
ENDMACRO (TODAY)
TODAY(DATESTRING)

message("Date: ${DATESTRING}")

#   Define the version number
set( LLNMS_VERSION_MAJOR 1 )
set( LLNMS_VERSION_MINOR 0 )
set( LLNMS_VERSION_DATE  "\"${DATESTRING}\"")

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
    ../../../src/cpp/llnms-core/llnms/networking/NetworkModule.cpp
    ../../../src/cpp/llnms-core/llnms/networking/NetworkDefinitionContainer.cpp
    ../../../src/cpp/llnms-core/llnms/networking/NetworkDefinition.cpp
    ../../../src/cpp/llnms-core/llnms/thirdparty/tinyxml2/tinyxml2.cpp
    ../../../src/cpp/llnms-core/llnms/utilities/FilesystemUtilities.cpp
)
include_directories( ../../../src/cpp/llnms-core )

#-------------------------------------------------#
#-          Create the LLNMS Library             -#
#-------------------------------------------------#
add_library( LLNMS ${LLNMS_SOURCES} ${Boost_LIBRARIES})

#--------------------------------------------------------#
#-          Create the llnms-list-networks app          -#
#--------------------------------------------------------#
add_executable( llnms-list-networks ../../../src/cpp/llnms-core/apps/llnms_list_networks.cpp )
target_link_libraries( llnms-list-networks LLNMS ${Boost_LIBRARIES} )



