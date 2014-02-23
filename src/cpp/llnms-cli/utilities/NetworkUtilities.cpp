/**
 * @file    NetworkUtilities.cpp
 * @author  Marvin Smith
 * @date    1/11/2014
*/
#include "NetworkUtilities.hpp"

#include <boost/regex.hpp>

/**
 * Check if a network address is a valid ip4 address format
*/
bool isValidIP4AddressFormat( const std::string& ip4_address ){

    boost::regex expression("(\\d{1,3}(\\.\\d{1,3}){3})");
    return boost::regex_match( ip4_address, expression );  
}


/**
 * Check if string is in the proper format for a network hostname
*/
bool isValidHostnameFormat( std::string const& hostname ){

    boost::regex expression("[a-zA-Z]+([\\-\\.]*[a-zA-Z]+)*");
    return boost::regex_match( hostname, expression );

}

