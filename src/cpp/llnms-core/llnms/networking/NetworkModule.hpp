/**
 * @file    NetworkModule.hpp
 * @author  Marvin Smith
 * @date    2/15/2014
 */
#ifndef __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKMODULE_HPP__
#define __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKMODULE_HPP__

#include "NetworkDefinition.hpp"
#include "NetworkDefinitionContainer.hpp"
#include "NetworkHost.hpp"
#include "NetworkHostContainer.hpp"

#include <deque>
#include <iterator>
#include <string>
#include <vector>

namespace LLNMS{
namespace NETWORK{

/**
 * @class NetworkModule 
 */
class NetworkModule{
    
    public:

        /**
         * Default Constructor
        */
        NetworkModule();

        /**
         * Constructor given the LLNMS_HOME
        */
        NetworkModule( const std::string& LLNMS_HOME );
        
        /**
         * Get llnms home
        */
        std::string get_LLNMS_HOME()const;

        /**
         * Set llnms home
        */
        void set_LLNMS_HOME( const std::string& LLNMS_HOME );

        /**
         * Get a list of network definitions
        */
        std::deque<NetworkDefinition> network_definitions()const;

        /**
         * Get a list of network hosts
        */
        std::vector<NetworkHost> scanned_network_hosts()const;
        
        /**
         * Start a network scan
         */
        void start_scan( );

        /**
         * Update the network list
        */
        void update();

        /**
         * Create a new network
         */
        std::string create_network( const std::string& network_name,
                                    const std::string& address_start,
                                    const std::string& address_end );
        
        /**
         * Delete a Network
         */
        void delete_network( const int& network_index, std::string& message_output );


    private:
        
        /// Network Definition Container
        NetworkDefinitionContainer  m_network_definitions;

        /// Network Host Container
        NetworkHostContainer        m_network_hosts;

        /// LLNMS Home
        std::string m_LLNMS_HOME;


}; /// End of NetworkModule Class

} /// End of NETWORK Namespace
} /// End of LLNMS Namespace

#endif

