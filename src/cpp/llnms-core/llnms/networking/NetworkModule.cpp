/**
 * @file    NetworkModule.cpp
 * @author  Marvin Smith
 * @date    2/14/2014
*/
#include "NetworkModule.hpp"
#include "../utilities/FilesystemUtilities.hpp"

#include <algorithm>
#include <iostream>

namespace LLNMS{
namespace NETWORK{

/*
 * Constructor for Network Module
*/
NetworkModule::NetworkModule(){

    /// Set the default LLNMS_HOME
    m_LLNMS_HOME = "/var/tmp/llnms";


}

/**
 * Parameterized Constructor
*/
NetworkModule::NetworkModule( const std::string& LLNMS_HOME ){

    /// Set the new llnms_home
    m_LLNMS_HOME = LLNMS_HOME;

}

/**
 * Get the LLNMS Home
*/
std::string NetworkModule::LLNMS_HOME()const{
    return m_LLNMS_HOME;
}

/**
 * Set the LLNMS Module
*/
std::string& NetworkModule::LLNMS_HOME(){
    return m_LLNMS_HOME;
}

/**
 * Grab the network definitions
*/
std::deque<NetworkDefinition> NetworkModule::network_definitions()const{

    /// create output
    std::deque<NetworkDefinition> output;

    /// load the output
    NetworkDefinitionContainer::const_iterator it = m_network_definitions.cbegin();
    NetworkDefinitionContainer::const_iterator eit = m_network_definitions.cend();
    for( ; it != eit; it++ ){
        output.push_back( (*it) );
    }

    /// return the container
    return output;
}

/**
 * Retrieve a list of scanned network hosts
*/
std::vector<NetworkHost> NetworkModule::scanned_network_hosts()const{

    /// just call the network host module 
    return m_network_hosts.scanned_network_hosts();
}

/**
 * Update the network list
 */
void NetworkModule::update(){
    
    /// Update the Network Definition Container
    m_network_definitions.update();

    /// Update the Network Host Container
    m_network_hosts.update();

}


} /// End of NETWORK Namespace
} /// End of LLNMS Namespace
