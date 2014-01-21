/**
 * @file    LLNMS_Network_Host_Update.cpp
 * @author  Marvin Smith
 * @date    1/20/2014
 */
#include "LLNMS_Network_Host_Update.hpp"


/**
 * default constructor
 */
LLNMS_Network_Host_Update::LLNMS_Network_Host_Update(){

}

/**
 * Parameterized constructor
 */
LLNMS_Network_Host_Update::LLNMS_Network_Host_Update( const std::string& datetime,
                                                      const std::string& status  
                                                    ){
    m_datetime = datetime;
    m_status   = status;


}

