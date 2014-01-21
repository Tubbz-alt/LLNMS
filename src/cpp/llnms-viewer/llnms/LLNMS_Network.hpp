/**
 * @file    LLNMS_Network.hpp
 * @author  Marvin Smith
 * @date    1/17/2014
 */
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMSNETWORK_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMSNETWORK_HPP__

#include <string>

/**
 * @class LLNMS_Network
 */
class LLNMS_Network{

    public:

        /**
         * Type of address
         */
        enum {
            SINGLE = 0,
            RANGE  = 1
         }; 
        
        /**
         * Default Network
         */
        LLNMS_Network();
    
        /**
         * Get the network name
         */
        std::string network_name()const;

        /**
         * Set the network name
         */
        std::string& network_name();
        
        /**
         * Get the network type
         */
        int network_type()const;

        /**
         * Set the network type
         */
        int& network_type();

        /**
         * Set the address 
         */
        std::string address()const;

        /**
         * Get the address
         */
        std::string& address();

        /**
         * Get the starting address
         */
        std::string address_start()const;

        /**
         * Set the starting address
         */
        std::string& address_start();

        /**
         * Get the ending address
         */
        std::string address_end()const;

        /**
         * Set the ending address
         */
        std::string& address_end();
    
    private:
        
        /// Network Name
        std::string m_network_name;
        
        /// Network Type
        int  m_network_type;

        /// Network Ranges/address
        std::string m_address_start;
        std::string m_address_end;

}; /// End of LLNMS_Network

#endif
