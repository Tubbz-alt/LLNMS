/**
 * @file    NetworkHostContainer.cpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#include "NetworkHostContainer.hpp"

#include "../thirdparty/tinyxml2/tinyxml2.h"
#include "../utilities/FilesystemUtilities.hpp"

#include <iterator>

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
    
    /// identify the network status file to load
    std::string network_status_filename = LLNMS_HOME() + "/run/llnms-network-status.xml";

    // make sure the file exists
    if( LLNMS::UTILITIES::exists( network_status_filename ) == false ){
        return;
    }

    // open the xml file
    tinyxml2::XMLDocument doc;
    doc.LoadFile( network_status_filename.c_str());

    // make sure the llnms-network-status tag is present
    tinyxml2::XMLElement* baseElement = doc.FirstChildElement("llnms-network-status");
    if( baseElement == NULL ){
        return;
    }

    // start iterating through hosts
    tinyxml2::XMLNode*  hostElement = baseElement->FirstChildElement("host");
    while( hostElement != NULL ){
        
        // get the ip4-address
        if( hostElement->ToElement()->Attribute("ip4-address") == NULL ){
            hostElement = hostElement->NextSibling();
            continue;
        }

        // get the next host
        hostElement = hostElement->NextSibling();
    }

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

    NetworkHostContainer::const_iterator  it = this->begin();
    NetworkHostContainer::const_iterator eit = this->end();
    for( ; it != eit; it++ ){
        
        output.push_back( (*it));

    }

    return output;
}

} /// End of NETWORK Namespace
} /// End of LLNMS Namespace

