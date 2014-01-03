#   File:    Makefile
#   Author:  Marvin Smith
#   Date:    12/31/2013
#
#   CPP Makefile for the LLNMS-Viewer
#

#  NCurses Library
NCURSES_LIBS=-lncurses

#  Libraries
LIBS=$(NCURSES_LIBS)

#  Includes
INCL=-Isrc/cpp/llnms-viewer


#  Release directory
RELEASE=release

#  Binary Executable
BIN=$(RELEASE)/bin/llnms-viewer

#  Object file path
OBJ=$(RELEASE)/tmp

#  Header list
HEADERS=src/cpp/llnms-viewer/llnms/LLNMS_Asset_Manager.hpp \
		src/cpp/llnms-viewer/llnms/LLNMS_State.hpp \
		src/cpp/llnms-viewer/llnms/Options.hpp \
		src/cpp/llnms-viewer/ui/asset_ui.hpp \
		src/cpp/llnms-viewer/ui/curses_utils.hpp \
		src/cpp/llnms-viewer/ui/Table.hpp \
		src/cpp/llnms-viewer/ui/main_menu.hpp 


OBJECTS=$(OBJ)/llnms_viewer.o \
        $(OBJ)/llnms/LLNMS_State.o \
		$(OBJ)/llnms/LLNMS_Asset_Manager.o \
		$(OBJ)/llnms/Options.o \
		$(OBJ)/ui/asset_ui.o \
		$(OBJ)/ui/main_menu.o \
		$(OBJ)/ui/Table.o \
		$(OBJ)/ui/curses_utils.o 

$(BIN): $(OBJECTS)
	g++ -o $@ $(OBJECTS) $(LIBS)

$(OBJ)/llnms_viewer.o: src/cpp/llnms-viewer/llnms_viewer.cpp $(HEADERS)
	g++ -o $@ $< -c 

$(OBJ)/llnms/LLNMS_State.o: src/cpp/llnms-viewer/llnms/LLNMS_State.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/llnms/LLNMS_Asset_Manager.o: src/cpp/llnms-viewer/llnms/LLNMS_Asset_Manager.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/llnms/Options.o: src/cpp/llnms-viewer/llnms/Options.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/ui/main_menu.o: src/cpp/llnms-viewer/ui/main_menu.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/ui/asset_ui.o: src/cpp/llnms-viewer/ui/asset_ui.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/ui/curses_utils.o: src/cpp/llnms-viewer/ui/curses_utils.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/ui/Table.o: src/cpp/llnms-viewer/ui/Table.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

