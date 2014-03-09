/**
 * @file    llnms_cli.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/

/// LLNMS Core Library
#include <LLNMS.hpp>

/// CLI Libraries
#include <core/Logger.hpp>
#include <core/Options.hpp>
#include <ui/MainMenu.hpp>
#include <utilities/CursesUtilities.hpp>

/// C Standard Library
#include <exception>
#include <iostream>
#include <string>

/// Global Options
Options options;

/// Logger
Logger logger;

/// Global LLNMS State
LLNMS::LLNMS_State state;

using namespace std;

/**
 * Main Function
*/
int main( int argc, char* argv[] ){

    try{
        
        // initialize curses
        init_curses();
        
        // initialize options
        options.init( argc, argv );

        // clear the current logfile
        logger.clearLogfile();

        // print configuration to logger
        options.printToLogger();
        
        // set LLNMS Home in the state module
        logger.add_message("Setting LLNMS_HOME in LLNMS Core.", LOG_DEBUG );
        state.set_LLNMS_HOME( options.m_LLNMS_HOME );
        
        // update llnms
        logger.add_message("Updating LLNMS Core.", LOG_DEBUG );
        state.update();

        // start main program
        main_menu();


    } catch( exception& e ){
        logger.add_message( e.what(), LOG_MAJOR );
        cout << e.what() << endl;
    } 

    // make sure to close up curses
    close_curses();

    return 0;
}


