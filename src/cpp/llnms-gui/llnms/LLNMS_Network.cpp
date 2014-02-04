/**
 * @file    LLNMS_Network
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#include "LLNMS_Network.hpp"

#include "../core/FileUtilities.hpp"
#include "../thirdparty/tinyxml2/tinyxml2.h"

#include <fstream>
#include <iostream>

using namespace std;


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
 * Parameterized Container for the LLNMS Network
 */
LLNMS_Network::LLNMS_Network( const std::string& name,
                              const std::string& address_start,
                              const std::string& address_end ){

    m_name = name;
    m_address_start = address_start;
    m_address_end   = address_end;
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
    if( doc.FirstChildElement("llnms-network") == NULL ){ return; }

    tinyxml2::XMLElement* networkElement = doc.FirstChildElement("llnms-network");
    
    // get the name
    if( networkElement->FirstChildElement("name") != NULL ){
        m_name = networkElement->FirstChildElement("name")->GetText();
    }

    // get the starting address
    if( networkElement->FirstChildElement("address-start") != NULL ){
        m_address_start = networkElement->FirstChildElement("address-start")->GetText();
    }

    // get the ending address
    if( networkElement->FirstChildElement("address-end") != NULL ){
        m_address_end = networkElement->FirstChildElement("address-end")->GetText();
    }

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
 * Get the starting address
 */
std::string LLNMS_Network::address_start()const{
    return m_address_start;
}

/**
 * Set the starting address
 */
std::string& LLNMS_Network::address_start(){
    return m_address_start;
}

/**
 * Get the ending address
 */
std::string LLNMS_Network::address_end()const{
    return m_address_end;
}

/**
 * Set the ending address
 */
std::string& LLNMS_Network::address_end(){
    return m_address_end;
}


/**
 * Equivalent operator
 */
bool LLNMS_Network::operator == ( const LLNMS_Network& other ){
    
    // make sure names are the same
    if( name() != other.name() ){ return false; }
    
    // check the range
    if( m_address_start != other.m_address_start ){ return false; }
    if( m_address_end   != other.m_address_end   ){ return false; }

    return true;

}

/**
 * Write network to file
 */
void LLNMS_Network::write( const std::string& filename ) const{

    ofstream fout;
    fout.open(filename.c_str() );
    
    fout << "<llnms-network>" << endl;
    fout << "  <name>" << m_name << "</name>" << endl;
    fout << "  <address-start>" << m_address_start << "</address-start>" << endl;
    fout << "  <address-end>" << m_address_end << "</address-end>" << endl;
    fout << "</llnms-network>" << endl;

    fout.close();
}

