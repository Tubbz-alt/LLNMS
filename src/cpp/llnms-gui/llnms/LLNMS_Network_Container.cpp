/**
 * @file    LLNMS_Network_Container.cpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#include "../core/FileUtilities.hpp"
#include "LLNMS_Network_Container.hpp"

#include <iostream>

using namespace std;

/**
 * Default Constructor for LLNMS Network Container
 */
LLNMS_Network_Container::LLNMS_Network_Container(){

    // clear the network list
    m_network_list.clear();


}

/**
 * Refresh the LLNMS Network List
 */
void LLNMS_Network_Container::update(){


    /// get a list of llnms network files
    vector<string> file_list =  path_ls( settings.gui_settings.LLNMS_HOME + string("/networks"));
    vector<string> netfile_list;    
    for( size_t i=0; i<file_list.size(); i++ ){
        if( file_list[i].size() > 18 && file_list[i].substr( file_list[i].size()-18) == ".llnms-network.xml" ){
            netfile_list.push_back( file_list[i] );
        }
    }


    // load each network file
    for( size_t i=0; i<netfile_list.size(); i++ ){
        
        LLNMS_Network tmpNetwork( netfile_list[i] );

        // look for an existing match in the current list
        bool network_match = false;
        for( size_t j=0; j<m_network_list.size(); j++ ){
        
            // check if names match
            if( m_network_list[j] == tmpNetwork ){
                network_match = true;
                break;
            }
        }
        
        if( network_match == false ){
            m_network_list.push_back( tmpNetwork );
        }
    }

}

/**
 * Get the network list
 */
std::vector<LLNMS_Network> LLNMS_Network_Container::network_list()const{
    return m_network_list;
}


