/**
 * @file     error_ui.hpp
 * @author   Marvin Smith
 * @date     1/11/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UI_ERRORUI_HPP__
#define __SRC_CPP_LLNMSVIEWER_UI_ERRORUI_HPP__

#include <string>

#include "../utilities/Options.hpp"

extern Options options;

/**
 * Print an error message for the user to acknowledge
 * 
 * @param[in] message Message to print
*/
void error_prompt( const std::string& message );


#endif

