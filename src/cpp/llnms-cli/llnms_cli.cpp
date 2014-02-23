/**
 * @file    llnms_cli.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/

/// CLI Libraries
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

/// Logging Utility
//Logger logger;

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
    
        /// set log file
        //logger.filename() = options.log_filename;
        //logger.priority() = options.log_priority;
    
        /// clear log file
        //logger.clear_log();
        
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


