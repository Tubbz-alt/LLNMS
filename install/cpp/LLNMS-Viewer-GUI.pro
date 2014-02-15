######################################################################
#  Marvin Smith
#  LLNMS-Viewer-GUI Project File
######################################################################

QT += core gui widgets
TARGET = bin/LLNMS-Viewer

#  Add Console Support to allow cout statements to propogate to the terminal
CONFIG += console

#  Create as application
TEMPLATE = app


#  Set the destination paths
debug:BUILD_BASE=debug
release:BUILD_BASE=release

#  Set the library destination paths
DESTDIR=$$BUILD_BASE

#  Set the build paths
OBJECTS_DIR   = $$BUILD_BASE/build
MOC_DIR       = $$BUILD_BASE/build


#  Unix-Specific Dependencies and Configuration Options
unix:!macx{
	message("using unix")
    
    # Boost Library
    LIBS += -lboost_system -lboost_filesystem -lboost_regex

}

#  Mac specific choices
unix:macx{
    message("using MacOSX")

    #  Add Path for Boost
    LIBS += -L/opt/local/lib -lboost_system-mt -lboost_filesystem-mt -lboost_regex-mt
    INCLUDEPATH += /opt/local/include
    
}

#  Windows-Specific Dependencies and Configuration Options
win32{
	message("using win32")
	
	#  Icon File
	RC_FILE = src\GIS-Viewer.rc 
	
	#  Include code for boost
	LIBS += -LC:/opt/local/lib -lboost_filesystem-vc110-1_55 -lboost_system-vc110-mt-1_55
	INCLUDEPATH += /opt/local/include
	
    #  Include the GIS-Library Material
    LIBS += -LC:/opt/local/lib -lGIS_Library
    INCLUDEPATH += /opt/local/include
	
	#  Include the gdal Material
	INCLUDEPATH += /opt/local/include/gdal
	LIBS += /opt/local/lib -lgdal_i
	
	#  Include OpenCV Material
	INCLUDEPATH += /opt/local/include
	LIBS += -L/opt/local/lib -lopencv_core246 -lopencv_imgproc246 -lopencv_highgui246
	

}


DEPENDPATH += src/cpp/llnms-gui
			 

INCLUDEPATH += src/cpp/llnms-gui
			  

# Input
HEADERS += \
            src/cpp/llnms-gui/core/DataContainer.hpp \
            src/cpp/llnms-gui/core/FileUtilities.hpp \
            src/cpp/llnms-gui/core/GUI_Settings.hpp \
            src/cpp/llnms-gui/core/MessagingService.hpp \
            src/cpp/llnms-gui/core/Parser.hpp \
            src/cpp/llnms-gui/gui/AssetPane.hpp \
            src/cpp/llnms-gui/gui/ConfigPane.hpp \
            src/cpp/llnms-gui/gui/CreateNetworkDialog.hpp \
            src/cpp/llnms-gui/gui/NetworkPane.hpp \
            src/cpp/llnms-gui/gui/SummaryPane.hpp \
            src/cpp/llnms-gui/gui/NavigationBar.hpp \
            src/cpp/llnms-gui/gui/MainWindow.hpp \
            src/cpp/llnms-gui/thirdparty/tinyxml2/tinyxml2.h


SOURCES += \
            src/cpp/llnms-gui/llnms_gui.cpp \
            src/cpp/llnms-gui/core/DataContainer.cpp \
            src/cpp/llnms-gui/core/FileUtilities.cpp \
            src/cpp/llnms-gui/core/GUI_Settings.cpp \
            src/cpp/llnms-gui/core/Parser.cpp \
            src/cpp/llnms-gui/gui/AssetPane.cpp \
            src/cpp/llnms-gui/gui/ConfigPane.cpp \
            src/cpp/llnms-gui/gui/CreateNetworkDialog.cpp \
            src/cpp/llnms-gui/gui/NetworkPane.cpp \
            src/cpp/llnms-gui/gui/SummaryPane.cpp \
            src/cpp/llnms-gui/gui/NavigationBar.cpp \
            src/cpp/llnms-gui/gui/MainWindow.cpp


