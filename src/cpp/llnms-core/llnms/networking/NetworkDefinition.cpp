/**
 * @file    NetworkDefinition.cpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#include "NetworkDefinition.hpp"

#include "../thirdparty/tinyxml2/tinyxml2.h"
#include "../utilities/FilesystemUtilities.hpp"

#include <fstream>

namespace LLNMS{
namespace NETWORK{


/*
 * Default Constructor
*/
NetworkDefinition::NetworkDefinition(){

    m_valid = false;
}

/**
 * Parameterized Constructor
*/
NetworkDefinition::NetworkDefinition( const std::string& filename ){
    m_filename = filename;
    m_valid = false;
    load();
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
    m_valid = true;
}

/**
 * Get name
*/
std::string NetworkDefinition::name()const{
    return m_name;
}

/**
 * Set name
*/
std::string& NetworkDefinition::name(){
    return m_name;
}

/**
 * Get address start
*/
std::string NetworkDefinition::address_start()const{
    return m_address_start;
}

/**
 * Set the address start
*/
std::string& NetworkDefinition::address_start(){
    return m_address_start;
}

/**
 * Get address end
*/
std::string NetworkDefinition::address_end()const{
    return m_address_end;
}

/**
 * Set the address end
*/
std::string& NetworkDefinition::address_end(){
    return m_address_end;
}

/**
 * Update the network file
*/
void NetworkDefinition::updateFile(){

    // open the file
    std::ofstream fout;
    fout.open(m_filename.c_str());

    fout << "<llnms-network>" << std::endl;
    fout << "    <name>" << m_name << "</name>" << std::endl;
    fout << "    <address-start>" << m_address_start << "</address-start>" << std::endl;
    fout << "    <address-end>" << m_address_end << "</address-end>" << std::endl;
    fout << "</llnms-network>" << std::endl;

    fout.close();

}

/**
 * Load the network file given a filename
*/
bool NetworkDefinition::load( const std::string& filename ){
    m_filename = filename;
    return load();
}

/**
 * Load the network from file
*/
bool NetworkDefinition::load(){
    
    /// make sure the network filename exists
    if( LLNMS::UTILITIES::exists( m_filename ) == false ){
        return false;
    }

    // open the file
    tinyxml2::XMLDocument doc;
    doc.LoadFile( m_filename.c_str());
    
    // make sure the llnms-network tag exists
    tinyxml2::XMLElement* baseElement = doc.FirstChildElement("llnms-network");
    if( baseElement == NULL ){ return false; }

    // grab the name
    tinyxml2::XMLElement* nameElement = baseElement->FirstChildElement("name");
    if( nameElement == NULL ){ return false; }
    m_name = nameElement->GetText();

    // grab the starting address
    tinyxml2::XMLElement* addressStartElement = baseElement->FirstChildElement("address-start");
    if( addressStartElement == NULL ){ return false; }
    m_address_start = addressStartElement->GetText();

    // grab the ending address
    tinyxml2::XMLElement* addressEndElement   = baseElement->FirstChildElement("address-end");
    if( addressEndElement == NULL ){ return false; }
    m_address_end = addressEndElement->GetText();

    m_valid = true;
    return true;
}

/**
 * Check valid flag
*/
bool NetworkDefinition::isValid()const{
    return m_valid;
}

/**
 * Check equivalency
*/
bool NetworkDefinition::operator == ( const NetworkDefinition& rhs )const{
    
    if( rhs.name() != name() ){
        return false;
    }
    if( rhs.address_start() != address_start() ){
        return false;
    }
    if( rhs.address_end() != address_end() ){
        return false;
    }
    return true;
}

/**
 * Check non-equivalency
*/
bool NetworkDefinition::operator != ( const NetworkDefinition& rhs )const{
    
    if( rhs.name() == name() ){
        return false;
    }
    if( rhs.address_start() == address_start() ){
        return false;
    }
    if( rhs.address_end() == address_end() ){
        return false;
    }

    return true;
}

/**
 * Check if less than
*/
bool NetworkDefinition::operator < ( const NetworkDefinition& rhs )const{

    if( name() == rhs.name() ){
        if( address_start() == rhs.address_start() ){
            return (address_end() < rhs.address_end());
        }
        return (address_start() < rhs.address_start());
    }
    return (name() < rhs.name());
}

bool NetworkDefinition::operator > ( const NetworkDefinition& rhs )const{

    if( name() == rhs.name() ){
        if( address_start() == rhs.address_start() ){
            return (address_end() > rhs.address_end());
        }
        return (address_start() > rhs.address_start());
    }
    return (name() > rhs.name());
}


} /// End of NETWORK Namespace 
} /// End of LLNMS Namespace

