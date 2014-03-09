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

/// LLNMS Core Library
#include <LLNMS.hpp>

/// Utilities
#include <core/Parser.hpp>
#include <utilities/FilesystemUtilities.hpp>
#include <utilities/StringUtilities.hpp>


/**
 * Default Constructor
 */
Options::Options(){
    
    // set default config file
    config_filename = getenv("HOME")+std::string("/.llnms/cli/options.cfg");
    
    // set the default LLNMS Home
    if( getenv("LLNMS_HOME") != NULL ){
        m_LLNMS_HOME=getenv("LLNMS_HOME");
    } else {
        m_LLNMS_HOME="/var/tmp/llnms";
    }
}

/**
 * Initialize Options Container
*/
void Options::init( int argc, char* argv[] ){
    
    // set the log filename
    logger.setLogFilename( std::string(getenv("HOME"))+std::string("/.llnms/cli/llnms-cli.log"));
    logger.setLoggingLevel( LOG_INFO );
    logger.setLoggingMode( LOG_MODE_LOGFILE );

    
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
    int tempInt;

    // load the log file
    tempString = parser.getItem_string( "LOG_FILENAME", found ); 
    if( found == true ){
        logger.setLogFilename( tempString );
    }

    // load the log priority
    tempString = parser.getItem_string( "LOG_PRIORITY", found );
    if( found == true ){
        if( tempString == "LOG_MAJOR" ){
            logger.setLoggingLevel( LOG_MAJOR );
        } else if( tempString == "LOG_MINOR" ){
            logger.setLoggingLevel( LOG_MINOR );
        } else if( tempString == "LOG_WARNING" ){
            logger.setLoggingLevel( LOG_WARNING );
        } else if( tempString == "LOG_INFO" ){
            logger.setLoggingLevel( LOG_INFO );
        } else if( tempString == "LOG_DEBUG" ){
            logger.setLoggingLevel( LOG_DEBUG );
        } else {
            logger.setLoggingLevel( LOG_NONE );
        }
    }
    
    // set the llnms home
    tempString = parser.getItem_string("LLNMS_HOME", found );
    if( found == true ){
        m_LLNMS_HOME=tempString;
    }

    // check if the LLNMS Home is already set
    if( getenv("LLNMS_HOME") != NULL ){
        m_LLNMS_HOME = getenv("LLNMS_HOME");
    }
    
    // initialize the about pane data
    init_about_pane_data();

}

/**
 * Write the logfile
 */
void Options::write_config_file(){
    
    /// make sure the directory structure exists
    boost::filesystem::create_directories( boost::filesystem::path( config_filename ).parent_path() );

    /**
     * Open the log file and insert all information
     */
    std::ofstream fout;
    fout.open( config_filename.c_str() );
    
    // write log file
    fout << "#  Desired LLNMS_HOME path" << std::endl;
    fout << "LLNMS_HOME=" << m_LLNMS_HOME << std::endl;
    fout << std::endl;

    fout << "#  Log File to Write Data To" << std::endl;
    fout << "LOG_FILENAME=" << logger.getLogFilename() << std::endl;
    fout << std::endl;

    // write log priority
    fout << "#  Max Log Priority to Output" << std::endl;
    fout << "#" << std::endl;
    fout << "#  Available Options:" << std::endl;
    fout << "#  LOG_NONE" << std::endl;
    fout << "#  LOG_MAJOR" << std::endl;
    fout << "#  LOG_MINOR" << std::endl;
    fout << "#  LOG_INFO" << std::endl;
    fout << "#  LOG_DEBUG" << std::endl;
    fout << "LOG_PRIORITY=" << logger.getLoggingLevelAsString() << std::endl;
    fout << std::endl;

    // close file
    fout.close();
    

}

/**
 * Initialize about pane data
 */
void Options::init_about_pane_data(){

    // create empty string
    aboutPaneData.push_back("");

    // show build data
    aboutPaneData.push_back("\n");
    aboutPaneData.push_back(std::string("Version   : ") + num2str(LLNMS_VERSION_MAJOR) + std::string(".") + num2str(LLNMS_VERSION_MINOR) + "\n");
    aboutPaneData.push_back(std::string("Build Date: ") + LLNMS_VERSION_DATE);

}

/**
 * Print Logger
 */
void Options::printToLogger()const{

    // print the header
    logger.add_message(std::string("LLNMS Command-Line Utility\n               --------------------------"), LOG_INFO);
    logger.add_message("Configuration:", LOG_INFO);
    logger.add_message(std::string(" -> LLNMS_HOME=")+m_LLNMS_HOME, LOG_INFO );
    logger.add_message(std::string(" -> LLNMS Version: ") + num2str(LLNMS_VERSION_MAJOR) + std::string(".") + num2str(LLNMS_VERSION_MINOR), LOG_INFO);
    logger.add_message(std::string(" -> LLNMS Build Date: ")+LLNMS_VERSION_DATE);
    logger.add_message("", LOG_INFO);

}

