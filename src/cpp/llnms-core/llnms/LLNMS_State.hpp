/**
 * @file    LLNMS_State.hpp
 * @author  Marvin Smith
 * @date    2/23/2014
 */
#ifndef __SRC_CPP_LLNMSCORE_LLNMS_LLNMSSTATE_HPP__
#define __SRC_CPP_LLNMSCORE_LLNMS_LLNMSSTATE_HPP__

#include <llnms/networking/NetworkModule.hpp>

#include <string>

namespace LLNMS{

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
         * Update the LLNMS State
         */
        void update();

        /**
         * Set LLNMS HOME
         */
        void set_LLNMS_HOME( const std::string& LLNMS_HOME );

        
        /// LLNMS HOME Variable
        std::string m_LLNMS_HOME;

        /// network module
        NETWORK::NetworkModule m_network_module;


}; /// End of LLNMS_State class

} /// End of LLNMS Namespace

#endif
