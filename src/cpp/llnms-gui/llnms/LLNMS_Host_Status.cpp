/**
 * @file    LLNMS_Host_Status.cpp
 * @author  Marvin Smith
 * @date    2/12/2014
 */
#include "LLNMS_Host_Status.hpp"

/**
 * Default Constructor
 */
LLNMS_Host_Status::LLNMS_Host_Status(){

    m_message   = "";
    m_timestamp = "";

}

/**
 * Parameterized Constructor
 */
LLNMS_Host_Status::LLNMS_Host_Status( const std::string& message,
                                      const std::string& timestamp
                                    ){

    m_message   = message;
    m_timestamp = timestamp;

}

/**
 * Get message
 */
std::string LLNMS_Host_Status::message()const{
    return m_message;
}

/**
 * Set message
 */
std::string& LLNMS_Host_Status::message(){
    return m_message;
}

/**
 * Get timestamp
*/
std::string LLNMS_Host_Status::timestamp()const{
    return m_timestamp;
}

/*
 * Set timestamp
 */
std::string& LLNMS_Host_Status::timestamp(){
    return m_timestamp;
}


