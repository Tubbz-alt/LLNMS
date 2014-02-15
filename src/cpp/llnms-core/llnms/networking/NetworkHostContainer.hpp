/**
 * @file    NetworkHostContainer.hpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#ifndef __SRC_CPP_LLNMSCORE_LLNMS_NETWORKING_NETWORKHOSTCONTAINER_HPP__
#define __SRC_CPP_LLNMSCORE_LLNMS_NETWORKING_NETWORKHOSTCONTAINER_HPP__

#include <list>
#include <string>
#include <vector>

#include "NetworkHost.hpp"

namespace LLNMS{
namespace NETWORK{

/**
 * @class NetworkHostContainer
*/
class NetworkHostContainer : public std::list<NetworkHost>{

    public:
        
        /**
         * Default Constructor
        */
        NetworkHostContainer();

        /**
         * Update
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
        
        /**
         * Get a list of scanned network hosts
        */
        std::vector<NetworkHost> scanned_network_hosts()const;

    private:
        
        /// LLNMS Home
        std::string m_LLNMS_HOME;

}; /// End of NetworkHostContainer class

} /// End of NETWORK Namespace
} /// End of LLNMS Namespace

#endif
