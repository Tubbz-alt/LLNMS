/**
 * @file    Options.cpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#include "Options.hpp"

/// Curses Library
#include <ncurses.h>
 
/// C Standard Library
#include <cstdlib>
#include <fstream>
#include <iostream>
#include <vector>

/// Utilities
#include "FileUtilities.hpp"
#include "Parser.hpp"


/**
 * Default Constructor
 */
Options::Options(){

    // set default config file
    config_filename = getenv("HOME")+std::string("/.llnms-viewer.cfg");

    // set the log filename
    log_filename = "/var/tmp/llnms/log/llnms-viewer.log";

    // set the desired log priority
    log_priority = 0;

}

/**
 * Initialize Options Container
*/
void Options::init( int argc, char* argv[] ){
    
    // look for config file value
    for( int i=1; i<argc; i++ ){

        // look for config file value
        if( ( std::string(argv[i]).size() > 3 ) && ( std::string(argv[i]).substr(0,3) == "-c=" ) ){
            config_filename=std::string(argv[i]).substr(3);
        }
        else if( ( std::string(argv[i]).size() > 9 ) && ( std::string(argv[i]).substr(0,9) == "--config=" ) ){
            config_filename=std::string(argv[i]).substr(9);
        }

    }
    
    // if the config file does not exist, then create it
    if( file_exists( config_filename ) == false ){
        write_config_file();
    }

    // get max window size
    getmaxyx( stdscr, maxY, maxX );
    

    // create a parser
    PSR::Parser parser( argc, argv, config_filename );
    bool found;
    std::string tempString;

    // load the log file
    tempString = parser.getItem_string( "LOG_FILENAME", found ); 
    if( found == true ){
        log_filename = tempString;
    }


}

/**
 * Write the logfile
 */
void Options::write_config_file(){

    /**
     * Open the log file and insert all information
     */
    std::ofstream fout;
    fout.open( config_filename.c_str() );
    
    // write log file
    fout << "#  Log File to Write Data To" << std::endl;
    fout << "LOG_FILENAME=" << log_filename << std::endl;
    fout << std::endl;

    // close file
    fout.close();
    

}


