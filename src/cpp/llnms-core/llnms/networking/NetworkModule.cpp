/**
 * @file    NetworkModule.cpp
 * @author  Marvin Smith
 * @date    2/14/2014
*/
#include "NetworkModule.hpp"
#include "../utilities/FilesystemUtilities.hpp"
#include "../utilities/StringUtilities.hpp"

#include <algorithm>
#include <exception>
#include <fstream>
#include <iostream>

namespace LLNMS{
namespace NETWORK{

/*
 * Constructor for Network Module
*/
NetworkModule::NetworkModule(){

    /// Set the default LLNMS_HOME
    m_LLNMS_HOME = "/var/tmp/llnms";
    
    // look for an LLNMS_HOME Environment variable
    if( getenv("LLNMS_HOME") != NULL ){
        m_LLNMS_HOME = getenv("LLNMS_HOME");
    }

    // set LLNMS_Home in the different modules
    m_network_hosts.LLNMS_HOME() = m_LLNMS_HOME;
    m_network_definitions.LLNMS_HOME() = m_LLNMS_HOME;

}

/**
 * Parameterized Constructor
*/
NetworkModule::NetworkModule( const std::string& LLNMS_HOME ){

    /// Set the new llnms_home
    m_LLNMS_HOME = LLNMS_HOME;
    
    /// set LLNMS_Home in each of the containers
    m_network_hosts.LLNMS_HOME()       = LLNMS_HOME;
    m_network_definitions.LLNMS_HOME() = LLNMS_HOME;
}

/**
 * Get the LLNMS Home
*/
std::string NetworkModule::get_LLNMS_HOME()const{
    return m_LLNMS_HOME;
}

/**
 * Set the LLNMS Module
*/
void NetworkModule::set_LLNMS_HOME( const std::string& LLNMS_HOME ){
    m_LLNMS_HOME = LLNMS_HOME;
    
    // update the llnms home variable in each of the container
    m_network_definitions.LLNMS_HOME() = m_LLNMS_HOME;
    m_network_hosts.LLNMS_HOME() = m_LLNMS_HOME;
}

/**
 * Grab the network definitions
*/
std::deque<NetworkDefinition> NetworkModule::network_definitions()const{

    /// create output
    std::deque<NetworkDefinition> output;

    /// load the output
    NetworkDefinitionContainer::const_iterator it = m_network_definitions.begin();
    NetworkDefinitionContainer::const_iterator eit = m_network_definitions.end();
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
 * Start a network scan
 */
void NetworkModule::start_scan(){

    // create the command
    std::string command = m_LLNMS_HOME + std::string("/bin/llnms-scan-networks") + std::string(" &");
    
    std::string message_output;
    LLNMS::UTILITIES::run_command( command, message_output  );

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

/**
 * Create a new network
 */
std::string NetworkModule::create_network( const std::string& network_name,
                                           const std::string& address_start,
                                           const std::string& address_end ){


    // create a new filename
    std::string header = string_toLower(network_name);
    for( size_t i=0; i<header.size(); i++ ){
        if( header[i] == ' ' ){
            header[i] = '_';
        }
    }

    // if the solo path does not exist, then create it, otherwise create a unique name
    std::string filename = m_LLNMS_HOME + std::string("/networks/") + header + ".llnms-network.xml";
    if( boost::filesystem::exists( filename ) != false ){
        
        int index = 1;
        std::string tempFilename;

        while( true ){

            tempFilename = m_LLNMS_HOME + std::string("/networks/") + header + num2str(index) + ".llnms-network.xml";
            if( boost::filesystem::exists( tempFilename ) == true ){
                index++;
            }
            else{
                filename = tempFilename;
                break;
            }
        }
    }


    // open and write out the file 
    std::ofstream fout;
    fout.open(filename.c_str());
    fout << "<llnms-network>" << std::endl;
    fout << "    <name>" << network_name << "</name>" << std::endl;
    fout << "    <address-start>" << address_start << "</address-start>" << std::endl;
    fout << "    <address-end>" << address_end << "</address-end>" << std::endl;
    fout << "</llnms-network>" << std::endl;
    fout.close();

    return filename;
}

/**
 * Delete a network
 */
void NetworkModule::delete_network( const int& index, std::string& message_output ){
    
    // make sure the bounds are correct
    if( index < 0 || index >= m_network_definitions.size() ){
        throw std::runtime_error("Referenced network module does not exist.");
    }

    // delete the file
    std::string command = m_LLNMS_HOME + std::string("/bin/llnms-remove-network -n \"") + (*(m_network_definitions.begin()+index)).name() + std::string("\"");
    
    // run the system command
    LLNMS::UTILITIES::run_command(command, message_output);

    // erase the entry
    m_network_definitions.erase( m_network_definitions.begin() + index );

}



} /// End of NETWORK Namespace
} /// End of LLNMS Namespace
