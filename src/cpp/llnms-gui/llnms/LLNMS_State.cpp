/**
 * @file    LLNMS_State.cpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#include "LLNMS_State.hpp"


/**
 * Default Constructor
 */
LLNMS_State::LLNMS_State(){



}

/**
 * Update function
 */
void LLNMS_State::update(){
   network_container.update(); 
}

