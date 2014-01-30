/**
 * @file    LLNMS_Network
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#include "LLNMS_Network.hpp"

#include "../core/FileUtilities.hpp"
#include "../thirdparty/tinyxml2/tinyxml2.h"


/**
 * Default Constructor for LLNMS_Network class
 */
LLNMS_Network::LLNMS_Network( ){

    // set default name
    m_name = "NONE";

    // set default starting address
    m_address_start = "0.0.0.0";
    
    // set default ending address
    m_address_end = "0.0.0.0";

}


/**
 * Constructor given the default filename
 */
LLNMS_Network::LLNMS_Network( std::string const& networkfilename ){

    // set the filename
    m_network_filename = networkfilename;

    // load the xml file if it exists
    if( path_exists( networkfilename ) == false ){
        throw std::string("Error: Network File does not exist: ")+networkfilename;
    }

    // create the xml document
    tinyxml2::XMLDocument doc;
    doc.LoadFile(networkfilename.c_str());

    // get the base element
    tinyxml2::XMLElement* networkElement = doc.FirstChildElement("llnms-network");
    
    // get the name
    m_name = networkElement->FirstChildElement("name")->GetText();


}

/**
 * Get the name
 */
std::string LLNMS_Network::name()const{
    return m_name;
}

/**
 * Set the name
 */
std::string& LLNMS_Network::name(){
    return m_name;
}

/**
 * Equivalent operator
 */
bool LLNMS_Network operator == ( const LLNMS_Network& other ){
    
    // make sure names are the same
    if( name() != other.name() ){ return false; }
    
    // check the range
    if( m_address_start != other.m_address_start ){ return false; }
    if( m_address_end   != other.m_address_end   ){ return false; }

    return true;

}

