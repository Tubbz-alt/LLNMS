/**
 * @file    Options.hpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UTILITIES_OPTIONS_HPP__
#define __SRC_CPP_LLNMSVIEWER_UTILITIES_OPTIONS_HPP__

/// LLNMS CLI Libraries
#include <core/Logger.hpp>

/// C++ Standard Library
#include <string>
#include <vector>

/// Logger
extern Logger logger;

/**
 * @class Options
*/
class Options{


    public:
        
        /**
         * Color Definitions
         */
        enum {
            PRIMARY_COLOR_PAIR              = 1,
            BUTTON_UNCOVERED_COLOR_PAIR     = 2,
            BUTTON_COVERED_COLOR_PAIR       = 3,
            LABEL_VALID_COLOR_PAIR          = 4,
            LABEL_INVALID_COLOR_PAIR        = 5,
            MULTILINE_UNCOVERED_COLOR_PAIR  = 6,
            ERROR_TEXT_COLOR_PAIR           = 7
        };
        
        /**
         * Default Constructor
         */
        Options();

        /**
         * Initialize Window
        */
        void init( int argc, char* argv[] );
        
        /**
         * Initialize the string for the about pane
         */
        void init_about_pane_data();

        /**
         * Write Configuration File
         */
        void write_config_file();
    
        /**
         * Print Logger
         */
        void printToLogger()const;

        /// Configuration File
        std::string config_filename;

        /// Max Window Width
        int maxX;

        /// Max Window Height
        int maxY;

        /// Log Priority
        int log_priority;
        
        /// LLNMS Home
        std::string m_LLNMS_HOME;
        
        /// Help Pane Screen
        std::vector<std::string> aboutPaneData;

}; /// End of Options class




#endif
