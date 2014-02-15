/**
 * @file    LLNMS_Host_Status.hpp
 * @author  Marvin Smith
 * @date    2/12/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_LLNMS_LLNMSHOSTSTATUS_HPP__
#define __SRC_CPP_LLNMSGUI_LLNMS_LLNMSHOSTSTATUS_HPP__

#include <string>

/**
 * @class LLNMS_Host_Status
 */
class LLNMS_Host_Status{

    public:

        /**
         * Default Constructor
         */
        LLNMS_Host_Status( );
    
        /**
         * Parameterized Constructor
         */
        LLNMS_Host_Status( const std::string& message,
                           const std::string& timestamp
                         );

        /**
         * Get message
         */
        std::string message()const;

        /**
         * Set message
         */
        std::string& message();

        /**
         * Get timestamp
         */
        std::string timestamp()const;

        /**
         * Set timestamp
         */
        std::string& timestamp();


    private:

        /// Message
        std::string m_message;

        /// Date
        std::string m_timestamp;

}; /// End of LLNMS_Host_Status class


#endif

