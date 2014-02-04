/**
 * @file    LLNMS_Network_Container.hpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_LLNMS_LLNMSNETWORKCONTAINER_HPP__
#define __SRC_CPP_LLNMSGUI_LLNMS_LLNMSNETWORKCONTAINER_HPP__

#include <vector>

#include "../core/DataContainer.hpp"
#include "LLNMS_Network.hpp"

extern DataContainer settings;

/**
 * @class LLNMS_Network_Container
 */
class LLNMS_Network_Container{

    public:

        /**
         * LLNMS_Network_Container Default Constructor
         */
        LLNMS_Network_Container();
        
        /**
         * Refresh the network list
         */
        void update();
    
        /**
         * Create a LLNMS Network
         */
        void llnms_create_network( const std::string& name, 
                                   const std::string& address_start,
                                   const std::string& address_end
                                 );
        /**
         * Get the network list
         */
        std::vector<LLNMS_Network> network_list()const;

    private:
        
        /// List of Networks
        std::vector<LLNMS_Network> m_network_list;


}; /// End of LLNMS_Network_Container

#endif

