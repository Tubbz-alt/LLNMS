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
HEADERS=src/cpp/llnms-viewer/curses_utils.hpp \
        src/cpp/llnms-viewer/LLNMS_Asset_Manager.hpp \
		src/cpp/llnms-viewer/LLNMS_State.hpp \
		src/cpp/llnms-viewer/main_menu.hpp

OBJECTS=$(OBJ)/curses_utils.o \
        $(OBJ)/LLNMS_State.o \
		$(OBJ)/LLNMS_Asset_Manager.o \
		$(OBJ)/main_menu.o \
	    $(OBJ)/llnms_viewer.o

$(BIN): $(OBJECTS)
	g++ -o $@ $(OBJECTS) $(LIBS)

$(OBJ)/llnms_viewer.o: src/cpp/llnms-viewer/llnms_viewer.cpp $(HEADERS)
	g++ -o $@ $< -c 

$(OBJ)/curses_utils.o: src/cpp/llnms-viewer/curses_utils.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/LLNMS_State.o: src/cpp/llnms-viewer/LLNMS_State.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/LLNMS_Asset_Manager.o: src/cpp/llnms-viewer/LLNMS_Asset_Manager.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

$(OBJ)/main_menu.o: src/cpp/llnms-viewer/main_menu.cpp $(HEADERS)
	g++ -o $@ $< -c $(INCL)

