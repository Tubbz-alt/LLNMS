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

    logger.add_message( Message( std::string("Loading asset at file: ")+filename, Logger::LOG_NOTE));

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
    if( descriptionElement->GetText() != NULL ){
        description = descriptionElement->GetText();
    }

    logger.add_message( Message( std::string("Asset file <")+filename+std::string("> loaded."), Logger::LOG_NOTE));
}
