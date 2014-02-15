/**
 * @file    NetworkDefinition.hpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#ifndef __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKDEFINITION_HPP__
#define __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKDEFINITION_HPP__

#include <string>

namespace LLNMS{

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


    private:
        
        /// Name of the network
        std::string m_name;

        /// Starting address
        std::string m_address_start;

        /// Ending address
        std::string m_address_end;

}; /// End of NetworkDefinition class


} /// End of LLNMS Namespace

#endif

