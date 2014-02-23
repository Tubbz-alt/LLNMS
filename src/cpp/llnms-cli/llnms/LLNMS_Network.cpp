/**
 * @file    LLNMS_Network.cpp
 * @author  Marvin Smith
 * @date    1/17/2014
 */
#include "LLNMS_Network.hpp"


/**
 * Default Constructor
 */
LLNMS_Network::LLNMS_Network(){
    m_network_name = "NONE";
    m_network_type  = LLNMS_Network::SINGLE;
    m_address_start = "0.0.0.0";
    m_address_end   = "0.0.0.0";
}

/**
 * Get the network name
 */
std::string LLNMS_Network::network_name()const{
    return m_network_name;
}

/**
 * Set the network name
 */
std::string& LLNMS_Network::network_name(){
    return m_network_name;
}


/**
 * Get the network type
 */
int LLNMS_Network::network_type()const{
    return m_network_type;
}

/**
 * Set the network type
 */
int& LLNMS_Network::network_type(){
    return m_network_type;
}

/**
 * Get the network address
 */
std::string LLNMS_Network::address()const{
    return m_address_start;
}

/**
 * Set the address
 */
std::string& LLNMS_Network::address(){
    return m_address_start;
}

/**
 * Get the starting address
 */
std::string LLNMS_Network::address_start()const{
    return m_address_start;
}

/**
 * Set the starting address
 */
std::string& LLNMS_Network::address_start(){
    return m_address_start;
}

/**
 * Get the ending address
 */
std::string LLNMS_Network::address_end()const{
    return m_address_end;
}

/**
 * Set the ending address
 */
std::string& LLNMS_Network::address_end(){
    return m_address_end;
}



