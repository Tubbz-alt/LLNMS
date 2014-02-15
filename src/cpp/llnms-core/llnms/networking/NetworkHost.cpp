/**
 * @file    NetworkHost.cpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#include "NetworkHost.hpp"

namespace LLNMS{
namespace NETWORK{

/**
 * Default Constructor
*/
NetworkHost::NetworkHost( ){
    m_valid = false;
    m_ip4_address = "0.0.0.0";
}

/**
 * Parameterized constructor
*/
NetworkHost::NetworkHost( const std::string& ip4_address ){

    m_ip4_address = ip4_address;
}

/**
 * Return the ip4 address
*/
std::string NetworkHost::ip4_address()const{
    return m_ip4_address;
}

/**
 * Check validity
*/
bool NetworkHost::isValid()const{
    return m_valid;
}

} /// End of NETWORK Namespace
} /// End of LLNMS Namespace

