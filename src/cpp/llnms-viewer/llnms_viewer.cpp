/**
 * @file    llnms_viewer.cpp
 * @author  Marvin Smith
 * @date    12/31/2013
*/

/// Curses Utilities
#include "utilities/CursesUtilities.hpp"

/// LLNMS Main Menu
#include "ui/main_menu.hpp"

/// Options
#include "utilities/Logger.hpp"
#include "utilities/Options.hpp"

/// LLNMS_State
#include "llnms/LLNMS_State.hpp"

/// Global Options
Options options;

/// Logging Utility
Logger logger;

/// LLNMS State Object
LLNMS_State llnms_state;

/**
 * Main Function
*/
int main( int argc, char* argv[] ){


    try{

        // initialize curses
        init_curses();

        // initialize options
        options.init();
    
        /// set log file
        logger.filename() = options.log_filename;
        logger.priority() = options.log_priority;
    
        /// clear log file
        logger.clear_log();
        
        // start main program
        main_menu();


    } catch(...){
        // do nothing
    } 

    // make sure to close up curses
    close_curses();

    return 0;
}


