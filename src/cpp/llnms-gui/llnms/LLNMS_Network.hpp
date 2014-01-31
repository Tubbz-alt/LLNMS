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
        
        /**
         * Default Constructor for LLNMS_Network Class
         */
        LLNMS_Network();
    
        /**
         * Constructor given a llnms network file
         */
        LLNMS_Network( std::string const& filename );
        
        /**
         * Get the name
         */
        std::string name()const;

        /**
         * Set the name
         */
        std::string& name();
        
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

        /**
         * Equivalent operator
         */
        bool operator == ( const LLNMS_Network& other );

    private:
        
        /// Name of the network
        std::string  m_name;
        
        /// Address start
        std::string m_address_start;

        /// Address end
        std::string m_address_end;

        /// Network Filename
        std::string m_network_filename;




}; /// End of LLNMS_Network class

#endif

