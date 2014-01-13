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


/**
 * LLNMS_Asset_Scanner Default Constructor
 */
LLNMS_Asset_Scanner::LLNMS_Asset_Scanner(){

}

/**
 * Parameterized constructor
 */
LLNMS_Asset_Scanner::LLNMS_Asset_Scanner( const std::string& scannerid, const std::vector<std::pair<std::string,std::string> >& argumentlist ){

    scanner_id() = scannerid;
    argument_list() = argumentlist;

}

/**
 * Get the argument list
 */
std::vector<std::pair<std::string,std::string> > LLNMS_Asset_Scanner::argument_list()const{
    return m_argument_list;
}

/**
 * Set the argument list
 */
std::vector<std::pair<std::string,std::string> >& LLNMS_Asset_Scanner::argument_list(){
    return m_argument_list;
}


/**
 * Get the scanner id
 */
std::string  LLNMS_Asset_Scanner::scanner_id()const{
    return m_scanner_id;
}

/**
 * Set the scanner id
 */
std::string& LLNMS_Asset_Scanner::scanner_id(){
    return m_scanner_id;
}

/**
 * Output a curses table
 */
Table  LLNMS_Asset_Scanner::toTable()const{
    
    // create output table
    Table output;

    output.setHeaderName(0, "Key");
    output.setHeaderName(1, "Value");
    
    // add the scanner id parameter
    output.setData( 0, 0, "scanner-id" );
    output.setData( 1, 0, m_scanner_id );
    
    for( size_t i=0; i<m_argument_list.size(); i++ ){
        
        output.setData( 0, 2*i+1, std::string("argument ")+num2str(i+1)+ std::string(" name "));
        output.setData( 1, 2*i+1, m_argument_list[i].first );
        output.setData( 0, 2*i+2, std::string("argument ")+num2str(i+1)+ std::string(" value "));
        output.setData( 1, 2*i+2, m_argument_list[i].second );

    }

    // return the output
    return output;
}


/**
 * Default Constructor
 */
LLNMS_Asset::LLNMS_Asset(){

}


/**
 * Parameterized Constructor.  Load the asset from the given filename.
 */
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
    logger.add_message( Message(std::string("Asset at file <")+filename+std::string("> has hostname (")+hostname+std::string(")."), Logger::LOG_NOTE ));
    
    // grab the ip4 address
    tinyxml2::XMLElement* addressElement = doc.FirstChildElement("llnms-asset")->FirstChildElement("ip4-address");
    ip4_address = addressElement->GetText();
    logger.add_message( Message(std::string("Asset ")+hostname+std::string(" has ip4-address (")+ip4_address+std::string(")."), Logger::LOG_NOTE ));

    // grab the description
    tinyxml2::XMLElement* descriptionElement = doc.FirstChildElement("llnms-asset")->FirstChildElement("description");
    if( descriptionElement->GetText() != NULL ){
        description = descriptionElement->GetText();
    }
    
    // check for the scanner list
    tinyxml2::XMLElement* scannersElement = doc.FirstChildElement("llnms-asset")->FirstChildElement("scanners");
    if( scannersElement != NULL ){
        
        // if the scanners element exist, try to pull the scanner info
        tinyxml2::XMLElement* scannerElement = scannersElement->FirstChildElement("scanner");
        if( scannerElement != NULL ){
            
            // create temp asset scanner
            LLNMS_Asset_Scanner temp_scanner;
            bool no_id_parameter_found=false;
            bool no_arguments_found = false;
            bool contains_improper_arguments = false;
            bool contains_argument_with_no_name_attribute=false;
            bool contains_argument_with_no_value_attribute=false;

            // make sure that the id field exists
            if( scannerElement->FirstChildElement("id") != NULL &&
                scannerElement->FirstChildElement("id")->GetText() != NULL ){
                temp_scanner.scanner_id() = scannerElement->FirstChildElement("id")->GetText();
            } else {
                no_id_parameter_found = true;
            }


            // make sure that the argument parameter exists
            tinyxml2::XMLElement* argumentElement = scannerElement->FirstChildElement("argument");
            if( argumentElement == NULL ){
                no_arguments_found=true;
            }else{

                // if the argument exists, pull its information
                std::pair<std::string,std::string> temp_argument;
                if( argumentElement->Attribute("name") == NULL ){
                    contains_argument_with_no_name_attribute=true;
                } else {
                    temp_argument.first = argumentElement->Attribute("name");
                }
                if( argumentElement->Attribute("value") == NULL ){
                    contains_argument_with_no_value_attribute=true;
                } else {
                    temp_argument.second = argumentElement->Attribute("value");
                }

                // add the argument to the scanner or throw error flag
                if( contains_argument_with_no_name_attribute == true ){
                    contains_improper_arguments = true;
                }
                else if( contains_argument_with_no_value_attribute == true ){
                    contains_improper_arguments = true;
                }
                else {
                    temp_scanner.argument_list().push_back(temp_argument);
                }

            }
            
            if( no_id_parameter_found == true ){
                logger.add_message( Message(std::string("Asset ")+hostname+std::string(" has scanner with no \"id\" element."), Logger::LOG_WARNING ));
            } else if( no_arguments_found == true ){ 
                logger.add_message( Message(std::string("Asset ")+hostname+std::string(" has scanner (")+temp_scanner.scanner_id()+std::string(") with no known arguments."), Logger::LOG_WARNING ));
            } else if( contains_improper_arguments ){
                logger.add_message( Message(std::string("Asset ")+hostname+std::string(" has bad registered scanner ")+temp_scanner.scanner_id()+std::string(" due to improper arguments.  Skipping scanner."), Logger::LOG_WARNING ));
            } else {
                logger.add_message( Message(std::string("Adding scanner id=(")+temp_scanner.scanner_id()+std::string(")  to Asset (")+hostname+std::string(")"), Logger::LOG_NOTE ));
                logger.add_message( Message(std::string("       scanner id=(")+temp_scanner.scanner_id()+std::string(") has ") + num2str(temp_scanner.argument_list().size()) + std::string(" arguments" ), Logger::LOG_NOTE ));
                m_scanner_list.push_back( temp_scanner );
            }
        }
    }

    logger.add_message( Message( std::string("Asset file <")+filename+std::string("> loaded."), Logger::LOG_NOTE));
}

/**
 * Get the scanner list
 */
std::vector<LLNMS_Asset_Scanner> LLNMS_Asset::scanner_list()const{
    return m_scanner_list;
}

