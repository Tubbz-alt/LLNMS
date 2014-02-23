/**
 * @file    LLNMS_State.cpp
 * @author  Marvin Smith
 * @date    2/23/2014
 */
#include "LLNMS_State.hpp"

namespace LLNMS{

/**
 * Default Constructor
 */
LLNMS_State::LLNMS_State(){


}

/**
 * Set LLNMS_HOME
 */
void LLNMS_State::set_LLNMS_HOME( const std::string& LLNMS_HOME ){
    
    // set llnms home
    m_LLNMS_HOME = LLNMS_HOME;

    // set LLNMS Home in network module
    m_network_module.set_LLNMS_HOME( LLNMS_HOME );

}

}

