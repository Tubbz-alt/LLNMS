/**
 * @file    NetworkModule.hpp
 * @author  Marvin Smith
 * @date    2/15/2014
 */
#ifndef __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKMODULE_HPP__
#define __SRC_CPP_LLNMSCORE_NETWORKING_NETWORKMODULE_HPP__

#include "NetworkDefinitionContainer.hpp"

namespace LLNMS{

/**
 * @class NetworkModule 
 */
class NetworkModule{
    
    public:

        /**
         * Default Constructor
        */
        NetworkModule();


    private:
        
        /// Network Definition Container
        NetworkDefinitionContainer  m_network_definitions;


}; /// End of NetworkModule Class

} /// End of LLNMS Class

#endif

