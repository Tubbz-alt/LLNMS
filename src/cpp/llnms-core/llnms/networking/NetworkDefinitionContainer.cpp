/**
 * @file    NetworkDefinitionContainer.cpp
 * @author  Marvin Smith
 * @date    2/14/2014
*/
#include "NetworkDefinitionContainer.hpp"

#include "../utilities/FilesystemUtilities.hpp"

#include <algorithm>
#include <iostream>
#include <vector>


namespace LLNMS{
namespace NETWORK{

/*
 * Constructor for NetworkDefinitionContainer
*/
NetworkDefinitionContainer::NetworkDefinitionContainer() : list(){
    m_LLNMS_HOME="/var/tmp/llnms";
}

void NetworkDefinitionContainer::update(){

    /// get a list of files in the network directory
    std::vector<std::string> network_files = LLNMS::UTILITIES::list_contents(m_LLNMS_HOME + "/networks", ".*\\.llnms-network.xml");
    for( size_t i=0; i<network_files.size(); i++ ){
        
        // load each file into the network container
        NetworkDefinition tempNetwork( network_files[i] );
        
        // make sure the network loaded properly
        if( tempNetwork.load() == true ){
        
            // check if we already have the network inside the container
            NetworkDefinitionContainer::iterator it = std::find( this->begin(),
                                                                 this->end(),
                                                                 tempNetwork
                                                               );
            
            // if it wasn't found then add it
            if( it == this->end() ){
                this->push_back( tempNetwork );
                this->sort();
            }
        }
    }
}


/**
 * Get llnms home
*/
std::string NetworkDefinitionContainer::LLNMS_HOME()const{
    return m_LLNMS_HOME;
}

/** 
 * Set LLNMS_HOME
*/
std::string& NetworkDefinitionContainer::LLNMS_HOME(){
    return m_LLNMS_HOME;
}

} /// End of NETWORK Namespace
} /// End of LLNMS Namespace 

