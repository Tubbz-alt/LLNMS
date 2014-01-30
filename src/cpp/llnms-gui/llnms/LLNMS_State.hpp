/**
 * @file    LLNMS_State.hpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_LLNMS_LLNMSSTATE_HPP__
#define __SRC_CPP_LLNMSGUI_LLNMS_LLNMSSTATE_HPP__

#include "LLNMS_Network_Container.hpp"

/**
 * @class LLNMS_State
 */
class LLNMS_State{

    public:
        
        /**
         * Default Constructor
         */
        LLNMS_State();
        
        /**
         * Update Function
         */
        void update();

        /// Container with the LLNMS Network Definitions
        LLNMS_Network_Container  network_container;



}; /// End of LLNMS_State class


#endif
