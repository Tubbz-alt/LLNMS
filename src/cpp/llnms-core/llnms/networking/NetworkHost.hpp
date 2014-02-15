/**
 * @file    NetworkHost.hpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#ifndef __SRC_CPP_LLNMSCORE_LLNMS_NETWORK_NETWORKHOST_HPP__
#define __SRC_CPP_LLNMSCORE_LLNMS_NETWORK_NETWORKHOST_HPP__

#include <string>

namespace LLNMS{
namespace NETWORK{

/**
 * @class NetworkHost
*/
class NetworkHost{

    public:

        /**
         * Default Constructor
        */
        NetworkHost();

        /**
         * Constructor given all information
        */
        NetworkHost( const std::string& ip4_address );
        
        /**
         * Return the network ip4-address
        */
        std::string ip4_address()const;

        /**
         * Validity check
        */
        bool isValid()const;

    private:
        
        /// ip4-address
        std::string m_ip4_address;

        /// Validity flag
        bool m_valid;

}; /// End of NetworkHost class

} /// End of NETWORK Namespace
} /// End of LLNMS Namespace

#endif
