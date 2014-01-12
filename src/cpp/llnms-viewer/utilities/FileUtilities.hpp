/**
 * @file    FileUtilities.hpp
 * @author  Marvin Smith
 * @date    1/11/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UTILITIES_FILEUTILITIES_HPP__
#define __SRC_CPP_LLNMSVIEWER_UTILITIES_FILEUTILITIES_HPP__

#include <string> 

/**
 * Run a standard system command and grab output.
*/
bool run_command( const std::string& command, std::string& message );


#endif
