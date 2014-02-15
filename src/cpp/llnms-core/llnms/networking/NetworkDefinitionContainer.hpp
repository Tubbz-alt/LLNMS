/**
 * @file    NetworkDefinitionContainer.hpp
 * @author  Marvin Smith
 * @date    2/14/2014
 */
#ifndef __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKDEFINITIONCONTAINER_HPP__
#define __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKDEFINITIONCONTAINER_HPP__

#include "NetworkDefinition.hpp"

#include <list>
#include <string>

namespace LLNMS{
namespace NETWORK{

/**
 * @class NetworkDefinitionContainer
*/
class NetworkDefinitionContainer : public std::list<NetworkDefinition>{

    public:
        
        /**
         * Default Constructor
        */
        NetworkDefinitionContainer( );

        /**
         * Update the network definitions
        */
        void update();

        /**
         * Get LLNMS_Home
        */
        std::string LLNMS_HOME()const;

        /**
         * Set LLNMS_Home
        */
        std::string& LLNMS_HOME();

    private:

        /// LLNMS Home
        std::string m_LLNMS_HOME;

}; /// End of NetworkDefinitionContainer Class


} /// End of NETWORK Namespace 
} /// End of LLNMS Namespace



#endif
