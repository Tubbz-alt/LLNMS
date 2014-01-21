/**
 * @file    TEST_LLNMS_Network.cpp
 * @author  Marvin Smith
 * @date    1/20/2014
 */
#include <gtest/gtest.h>

#include "LLNMS_Network.hpp"


/**
 * Test LLNMS_Network Constructors
 */
TEST( LLNMS_Network, Constructors ){

    // create an empty llnms network
    LLNMS_Network network01;

    ASSERT_EQ( network01.network_name(), "NONE");
    ASSERT_EQ( network01.network_type(), LLNMS_Network::SINGLE );
    if( network01.network_type() == LLNMS_Network::SINGLE ){
        ASSERT_EQ( network01.address(), "0.0.0.0" );
    }
    else{
        FAIL();
    }


}

