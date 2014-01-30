/**
 * @file    LLNMS_Network
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#include "LLNMS_Network.hpp"



/**
 * Default Constructor for LLNMS_Network class
 */
LLNMS_Network::LLNMS_Network( ){

    // set default name
    m_name = "NONE";

    // set default type
    m_type = SINGLE;

    // set default starting address
    m_address_start = "0.0.0.0";
    
    // set default ending address
    m_address_end = "0.0.0.0";

}



