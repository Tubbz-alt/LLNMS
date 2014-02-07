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

/**
 * Create a network
 */
void LLNMS_Network_Container::llnms_create_network( const std::string& LLNMS_HOME,
                                                    const std::string& name, 
                                                    const std::string& address_start,
                                                    const std::string& address_end 
                                                  ){
    
    /// create a network file
    LLNMS_Network new_network( name, address_start, address_end );
    
    /// Create filename using name substited of periods
    std::string new_filename = name;
    for( size_t i=0; i<new_filename.size(); i++ ){
        if( new_filename[i] == '.' || new_filename[i] == ' ' ){
            new_filename[i] = '_';
        }
    }
    
    new_filename = LLNMS_HOME + std::string("/networks/") + new_filename + std::string(".llnms-network.xml");

    cout << "NEW FILENAME: " << new_filename << endl;
    //new_network.write( new_filename + std::string(".llnms-network.xml"));

}

