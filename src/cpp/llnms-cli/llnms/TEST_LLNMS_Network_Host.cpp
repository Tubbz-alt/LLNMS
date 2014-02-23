/**
 * @file    TEST_LLNMS_Network_Host.cpp
 * @author  Marvin Smith
 * @date    1/20/2014
 */
#include <gtest/gtest.h>

#include "LLNMS_Network_Host.hpp"


TEST( LLNMS_Network_Host, Constructors ){

    /// Create a network host using the default constructor
    LLNMS_Network_Host  nethost01;

    // make sure our defaults are expected
    ASSERT_EQ( nethost01.ip4_address(), "0.0.0.0" );
    ASSERT_EQ( nethost01.hostname()   , "none"    );
    ASSERT_EQ( nethost01.description(), "uninitialized");



}


