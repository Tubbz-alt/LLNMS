/**
 * @file    LLNMS_Network_Container.hpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_LLNMS_LLNMSNETWORKCONTAINER_HPP__
#define __SRC_CPP_LLNMSGUI_LLNMS_LLNMSNETWORKCONTAINER_HPP__

#include <vector>

#include "LLNMS_Network.hpp"


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
        void refresh();
    
    private:
        
        /// List of Networks
        std::vector<LLNMS_Network> m_network_list;


}; /// End of LLNMS_Network_Container

#endif

