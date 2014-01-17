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


