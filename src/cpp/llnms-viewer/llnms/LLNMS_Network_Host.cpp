/**
 * @file    LLNMS_Network_Host.cpp
 * @author  Marvin Smith
 * @date    1/20/2014
 */
#include "LLNMS_Network_Host.hpp"


/**
 * Default Constructor
 */
LLNMS_Network_Host::LLNMS_Network_Host(){

    m_ip4_address = "0.0.0.0";
    m_hostname    = "none";
    m_description = "uninitialized";

}

/**
 * Parameterized Constructor
 */
LLNMS_Network_Host::LLNMS_Network_Host(  const std::string& ip4_address,
                                         const std::string& hostname,
                                         const std::string& description ){

    m_ip4_address = ip4_address;
    m_hostname = hostname;
    m_description = description;

}

/**
 * Get ip4 address
 */
std::string LLNMS_Network_Host::ip4_address()const{
    return m_ip4_address;
}

/**
 * Set ip4 address
 */
std::string& LLNMS_Network_Host::ip4_address(){
    return m_ip4_address;
}

/**
 * Get hostname
 */
std::string LLNMS_Network_Host::hostname()const{
    return m_hostname;
}

/**
 * Set hostname
 */
std::string& LLNMS_Network_Host::hostname(){
    return m_hostname;
}

/**
 * Get description
 */
std::string LLNMS_Network_Host::description()const{
    return m_description;
}

/**
 * Set description
 */
std::string& LLNMS_Network_Host::description(){
    return m_description;
}

