/**
 * @file    Logger.cpp
 * @author  Marvin Smith
 * @date    1/11/2014
*/
#include "Logger.hpp"

#include <fstream>
#include <iostream>

#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/date_time/local_time_adjustor.hpp>


/**
 * Convert the priority to a string format
*/
std::string priority2string( const int& priority ){
    
    switch(priority){
    
        case Logger::LOG_NOTE:    return "INFO";
        case Logger::LOG_WARNING: return "WARNING";
        case Logger::LOG_MINOR:   return "MINOR";
        case Logger::LOG_MAJOR:   return "MAJOR";

    }
    return "UNKNOWN";
}

/**
 * Message Constructor
*/
Message::Message(){
    
}


/**
 * Parameterized Message Constructor
*/
Message::Message( std::string const& text, const int& priority  ){
    
    // get current time
    boost::posix_time::ptime now = boost::posix_time::second_clock::local_time();
    
    // fill in fields
    m_text=text;
    m_priority=priority;
    m_time = to_simple_string(now);
}


/**
 * Parameterized Message Constructor
*/
Message::Message( std::string const& text, const int& priority, const std::string& time ){
    m_text=text;
    m_priority=priority;
    m_time=time;
}

/**
 * Set priority
*/
int& Message::priority(){
    return m_priority;
}

/** 
 * Get priority
*/
int Message::priority()const{
    return m_priority;
}

/**
 * Set text
*/
std::string& Message::text(){
    return m_text;
}

/** 
 * Get text
*/
std::string Message::text()const{
    return m_text;
}

/** 
 * Get time
*/
std::string& Message::time(){
    return m_time;
}

/**
 * Set time
*/
std::string Message::time()const{
    return m_time;
}

/**
 * To string
*/
std::string Message::toString()const{
    return std::string( time() + std::string(" ") + priority2string(priority()) + std::string("  ") + text());
}


/**
 * Logger Default Constructor
*/
Logger::Logger(){
    m_priority = LOG_MINOR;
}

/**
 * Logger Parameterized Constructor
*/
Logger::Logger( const std::string& filename, const int& priority ){
    m_filename = filename;
    m_priority = priority;
}

/**
 * Clear the log
*/
void Logger::clear_log(){
   std::ofstream fout;
   fout.open(m_filename);
   fout.close();
}

/**
 * Set log filename
*/
std::string& Logger::filename( ){
    return m_filename;
}

/**
 * Get log filename
*/
std::string Logger::filename()const{
    return m_filename;
}

/**
 * Set Priority
*/
int& Logger::priority(){
    return m_priority;
}


/**
 * Get Priority
*/
int Logger::priority()const{
    return m_priority;
}

/**
 * Add message
*/
void Logger::add_message( const Message& message ){
    
    // skip if priority is too low
    if( message.priority() < m_priority ){ return; }

    /**
     * open the file and pipe to it
    */
    std::fstream fs;
    fs.open ( m_filename.c_str(), std::fstream::in | std::fstream::out | std::fstream::app);
    fs << message.toString() << std::endl;
    fs.close();

}

