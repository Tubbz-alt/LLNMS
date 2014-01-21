/**
 * @file    LLNMS_Network.hpp
 * @author  Marvin Smith
 * @date    1/17/2014
 */
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMSNETWORK_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMSNETWORK_HPP__

#include <string>

/**
 * @class LLNMS_Network
 */
class LLNMS_Network{

    public:
        
        /**
         * Default Network
         */
        LLNMS_Network();
    
        /**
         * Get the network name
         */
        std::string network_name()const;

        /**
         * Set the network name
         */
        std::string& network_name();

    
    private:
        
        /// Network Name
        std::string m_network_name;


}; /// End of LLNMS_Network

#endif
