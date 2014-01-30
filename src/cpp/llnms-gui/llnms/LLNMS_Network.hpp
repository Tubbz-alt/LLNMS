/**
 * @file    LLNMS_Network.hpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_LLNMS_LLNMSNETWORK_HPP__
#define __SRC_CPP_LLNMSGUI_LLNMS_LLNMSNETWORK_HPP__

#include <string>

/**
 * @class LLNMS_Network
 */
class LLNMS_Network{


    public:
        
        /// network type
        enum {
            SINGLE = 0,
            RANGE  = 1
        };

        /**
         * Default Constructor for LLNMS_Network Class
         */
        LLNMS_Network();

    
    private:
        
        /// Name of the network
        std::string  m_name;
        
        /// Type of network
        int m_type;

        /// Address start
        std::string m_address_start;

        /// Address end
        std::string m_address_end;


}; /// End of LLNMS_Network class

#endif

