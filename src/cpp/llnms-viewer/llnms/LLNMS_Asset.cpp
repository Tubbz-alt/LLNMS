/**
 * @file LLNMS_Asset.cpp
 * @author  Marvin Smith
 * @date    1/3/2014
*/
#include "LLNMS_Asset.hpp"

#include "tinyxml2.h"

#include <string>
#include <cstdlib>
using namespace std;

LLNMS_Asset::LLNMS_Asset(){

}

LLNMS_Asset::LLNMS_Asset( const std::string& filename ){

    // set the filename
    this->filename = filename;

    // open the xml file
    tinyxml2::XMLDocument doc;
    doc.LoadFile( filename.c_str());

    // grab the hostname
	tinyxml2::XMLElement* hostnameElement = doc.FirstChildElement("llnms-asset")->FirstChildElement("hostname");
    hostname = hostnameElement->GetText();
    
    // grab the ip4 address
    tinyxml2::XMLElement* addressElement = doc.FirstChildElement("llnms-asset")->FirstChildElement("ip4-address");
    ip4_address = addressElement->GetText();

    // grab the description
    tinyxml2::XMLElement* descriptionElement = doc.FirstChildElement("llnms-asset")->FirstChildElement("description");
    description = descriptionElement->GetText();

}
