/**
 * @file    NetworkDefinition.cpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#include "NetworkDefinition.hpp"

namespace LLNMS{

/*
 * Default Constructor
*/
NetworkDefinition::NetworkDefinition(){


}

/*
 * Parameterized Constructor
*/
NetworkDefinition::NetworkDefinition(  std::string const& name, 
                                       std::string const& address_start,
                                       std::string const& address_end
                                     ){


    m_name          = name;
    m_address_start = address_start;
    m_address_end   = address_end;
}

} /// End of LLNMS Namespace

