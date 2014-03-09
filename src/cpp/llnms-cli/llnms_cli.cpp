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

/// Options
//#include "utilities/Logger.hpp"

/// C Standard Library
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
        
        // initialize options
        options.init( argc, argv );

        // clear the current logfile
        logger.clearLogfile();

        // print configuration to logger
        options.printToLogger();

        // initialize curses
        init_curses();
        
        // set LLNMS Home in the state module
        state.set_LLNMS_HOME( options.m_LLNMS_HOME );
        
        // update llnms
        state.update();

        // start main program
        main_menu();


    } catch( std::string e ){
        cout << e << endl;
        //logger.add_message( Message( std::string("String exception thrown. Exiting program. Message: ")+e, Logger::LOG_MAJOR ));
    //} catch(...){
    //    logger.add_message( Message( std::string("Unknown exception thrown. Exiting program."), Logger::LOG_MAJOR ));
    } 

    // make sure to close up curses
    close_curses();

    return 0;
}


