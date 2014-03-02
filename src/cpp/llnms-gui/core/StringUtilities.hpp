/**
 * @file    StringUtilities.hpp
 * @author  Marvin Smith
 * @date    3/1/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_CORE_STRINGUTILITIES_HPP__
#define __SRC_CPP_LLNMSGUI_CORE_STRINGUTILITIES_HPP__

#include <sstream>
#include <string>

/**
 * Convert a string into a number
 *
 * @param[in] value String value to convert
 * 
 * @return Numerical equivalent
 */
template <typename TP>
TP str2num( std::string const& value ){
    
    std::stringstream sin;
    TP result;
    sin << value;
    sin >> result;
    return result;
}

/**
 * Convert a number into a string
 *
 * @param[in] value Numerical value to convert
 *
 * @return String representation
 */
template <typename TP>
std::string num2str( TP const& value ){

    std::stringstream sin;
    sin << value;
    return sin.str();
}

#endif
