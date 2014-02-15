/**
 * @file    NetworkDefinitionContainer.hpp
 * @author  Marvin Smith
 * @date    2/14/2014
 */
#ifndef __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKDEFINITIONCONTAINER_HPP__
#define __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKDEFINITIONCONTAINER_HPP__

#include "NetworkDefinition.hpp"

#include <list>

namespace LLNMS{

/**
 * @class NetworkDefinitionContainer
*/
class NetworkDefinitionContainer : public std::list<NetworkDefinition>{

    public:
        
        /**
         * Default Constructor
        */
        NetworkDefinitionContainer( );

        



}; /// End of NetworkDefinitionContainer Class


} /// End of LLNMS Namespace



#endif
