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
	tinyxml2::XMLElement* hostnameElement = doc.FirstChildElement( "llnms-asset" )->FirstChildElement( "hostname" );
    hostname = hostnameElement->GetText();
    
    ip4_address="8.8.8.8";
    description="Some long description";
}
