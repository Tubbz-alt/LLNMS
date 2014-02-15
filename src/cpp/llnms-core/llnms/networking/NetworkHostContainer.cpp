/**
 * @file    NetworkHostContainer.cpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#include "NetworkHostContainer.hpp"


namespace LLNMS{
namespace NETWORK{

/**
 * Default Constructor
*/
NetworkHostContainer::NetworkHostContainer():list(){

}

/**
 * Update
*/
void NetworkHostContainer::update(){

}

/**
 * Get llnms home
*/
std::string NetworkHostContainer::LLNMS_HOME()const{
    return m_LLNMS_HOME;
}

/** 
 * Set LLNMS_HOME
*/
std::string& NetworkHostContainer::LLNMS_HOME(){
    return m_LLNMS_HOME;
}

/**
 * Get a subset of the network hosts
*/
std::vector<NetworkHost> NetworkHostContainer::scanned_network_hosts()const{
    
    /// create an output container
    std::vector<NetworkHost> output;

    return output;
}

} /// End of NETWORK Namespace
} /// End of LLNMS Namespace

