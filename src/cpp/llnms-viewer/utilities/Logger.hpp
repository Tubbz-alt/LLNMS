/**
 * @file    Logger.hpp
 * @author  Marvin Smith
 * @date    1/11/2014
*/
#ifndef __SRC_CPP_LLNMSVIEWER_UTILITIES_LOGGER_HPP__
#define __SRC_CPP_LLNMSVIEWER_UTILITIES_LOGGER_HPP__

#include <deque>
#include <string>

/**
 * @class Message
*/
class Message{
    
    public:
        
        /**
         * Default Constructor
        */
        Message();

        /**
         * Parameterized Constructor
         *
         * @param[in] text      Message text
         * @param[in] priority  Priority
        */
        Message( const std::string& text, const int& priority );
        
        /**
         * Parameterized Constructor
         *
         * @param[in] text      Message text
         * @param[in] priority  Priority
         * @param[in] time      Date/Time String
        */
        Message( const std::string& text, const int& priority, const std::string& time );

        /**
         * Set priority
        */
        int& priority();

        /**
         * Get Priority
        */
        int  priority()const;

        /**
         * Set text
        */
        std::string& text();

        /**
         * Get text
        */
        std::string text()const;

        /**
         * Set time
        */
        std::string& time();

        /**
         * Get time
        */
        std::string time()const;

        /**
         * Convert to string
        */
        std::string toString()const;

    private:
        
        /// Message text
        std::string m_text;

        /// Message Priority
        int m_priority;
        
        /// Message Time
        std::string m_time;

};


/**
 * @class Logger
*/
class Logger{

    public:

        enum { 
            LOG_NOTE    = 1,
            LOG_WARNING = 2, 
            LOG_MINOR   = 3, 
            LOG_MAJOR   = 4 
        };
        
        /**
         * Default Constructor
        */
        Logger();
    
        /**
         * Parameterized Constructor
         * 
         * @param[in] filename  File to append log to
        */
        Logger( std::string const& filename, const int& priority );

        /**
         * Add message to log
         *
         * @param[in] message Message to add to logger
        */
        void add_message( Message const& message );
        
        /**
         * Set priority
        */
        int& priority();
        
        /**
         * Get priority
        */
        int priority()const;
        
        /**
         * Set filename
        */
        std::string& filename();

        /**
         * Get Filename
        */
        std::string filename()const;

        /**
         * Clear log
        */
        void clear_log();

    private:
        
        /// Logfile name
        std::string m_filename;
        
        /// Priority
        int m_priority;

};

#endif
