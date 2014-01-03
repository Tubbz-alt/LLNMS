/**
 * @file   LLNMS_State.hpp
 * @author Marvin Smith
 * @date   12/31/2013
*/
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMSSTATE_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMSSTATE_HPP__

#include "LLNMS_Asset_Manager.hpp"

/**
 * @class  LLNMS_State
*/
class LLNMS_State{

    public:
        
        /**
         * Default Constructor
        */
        LLNMS_State();

        /// LLNMS Asset Container
        LLNMS_Asset_Manager asset_manager;


}; // End of LLNMS_State class


#endif

