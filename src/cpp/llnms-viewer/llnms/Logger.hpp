/**
 *  @file    Logger.hpp
 *  @author  Marvin Smith
 *  @date    1/3/2014
 */
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMS_LOGGER_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMS_LOGGER_HPP__

#include <string>

/**
 *  @class Logger
*/
class Logger{

    public:
        
        /**
         *  Default Constructor
         */
        Logger();

        /**
         *  Parameterized Constructor
         */
        Logger( const std::string& logfile_name );
        

        /// Name of log file
        std::string log_filename;

};


#endif

