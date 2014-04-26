/**
 * @file    NetworkDefinition.hpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#ifndef __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKDEFINITION_HPP__
#define __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKDEFINITION_HPP__

#include <string>

namespace LLNMS{
namespace NETWORK{


/**
 * @class NetworkDefinition
*/
class NetworkDefinition{

    public:
        
        /**
         * Default Constructor
        */
        NetworkDefinition();
        
        /**
         * Parameterized Constructor given filename to load
        */
        NetworkDefinition( const std::string& filename );


        /**
         * Parameterized Constructor
         *
         * @param[in] name Name of the network
         * @param[in] address_start Starting address for the network
         * @param[in] address_end   Ending address for the network
        */
        NetworkDefinition( std::string const& name, 
                           std::string const& address_start, 
                           std::string const& address_end 
                         );

        /**
         * Get network name
        */
        std::string name()const;
        
        /**
         * Set the network name
        */
        std::string& name();

        /**
         * Get address start
        */
        std::string address_start()const;
        
        /**
         * Set the address start
        */
        std::string& address_start();

        /**
         * Get address end
        */
        std::string address_end()const;
        
        /**
         * Set the address end
        */
        std::string& address_end();
        
        /**
         * Update the file contents
        */
        void updateFile();

        /** 
         * Load the network from file
        */
        bool load();
        
        /**
         * Load the network from file
        */
        bool load( const std::string& filename );

        /** 
         * Check if item is valid
        */
        bool isValid()const;
        
        /**
         * Check equivalency
        */
        bool operator == ( const NetworkDefinition& rhs )const;

        /**
         * Check if not equal
         *
         * Network Definitions should be not equal if their names are different.
        */
        bool operator != ( const NetworkDefinition& rhs )const;
        
        /**
         * Less than
        */
        bool operator < ( const NetworkDefinition& rhs )const;
        
        /**
         * Greater than
        */
        bool operator > ( const NetworkDefinition& rhs )const;
        

    private:

        /// Name of the network
        std::string m_name;

        /// Starting address
        std::string m_address_start;

        /// Ending address
        std::string m_address_end;
        
        /// Location of file
        std::string m_filename;

        /// Validity flag
        bool m_valid;

}; /// End of NetworkDefinition class


} /// End of NETWORK Namespace
} /// End of LLNMS Namespace

#endif

