/**
 * @file    Options.hpp
 * @author  Marvin Smith
 * @date    1/2/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UTILITIES_OPTIONS_HPP__
#define __SRC_CPP_LLNMSVIEWER_UTILITIES_OPTIONS_HPP__

#include <string>

/**
 * @class Options
*/
class Options{

    public:
        
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
         * Initialize Window
        */
        void init();

        /// Max Window Width
        int maxX;

        /// Max Window Height
        int maxY;

        /// Log filename
        std::string log_filename;

        /// Log Priority
        int log_priority;
        

}; /// End of Options class




#endif
