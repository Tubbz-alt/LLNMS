/**
 * @file    NetworkUtilities.hpp
 * @author  Marvin Smith
 * @date    1/11/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UTILITIES_NETWORKUTILITIES_HPP__
#define __SRC_CPP_LLNMSVIEWER_UTILITIES_NETWORKUTILITIES_HPP__

#include <string>

/**
 * Check if string is a valid ip4 address
*/
bool isValidIP4AddressFormat( std::string const& ip4_address );

/**
 * Check if string is a valid hostname format
*/
bool isValidHostnameFormat( std::string const& hostname );

#endif

