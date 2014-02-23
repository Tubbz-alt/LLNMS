/**
 * @file    LLNMS_Network_Host.hpp
 * @author  Marvin Smith
 * @date    1/20/2014
 */
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMS_LLNMSNETWORKHOST_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMS_LLNMSNETWORKHOST_HPP__

#include <string>
#include <vector>

#include "LLNMS_Network_Host_Update.hpp"

/**
 * @class LLNMS_Network_Host
 */
class LLNMS_Network_Host{

    public:
        
        /**
         * Default Constructor
         */
        LLNMS_Network_Host();

        /**
         * Parameterized Constructor
         *
         * @param[in] ip4_address IP4 Address of host
         * @param[in] hostname Hostname of asset
         * @param[in] description Description of asset
         */
        LLNMS_Network_Host( std::string const& ip4_address,
                            std::string const& hostname,
                            std::string const& description
                          );


        /**
         * Get IP4 Address
         */
        std::string ip4_address()const;

        /**
         * Set ip4 address
         */
        std::string& ip4_address();

        /**
         * Get hostname
         */
        std::string hostname()const;

        /**
         * Set hostname
         */
        std::string& hostname();

        /**
         * Get description
         */
        std::string description()const;

        /**
         * Set description
         */
        std::string& description();


    
    private:
        
        /// IP4 Address
        std::string m_ip4_address;

        /// Hostname
        std::string m_hostname;

        /// description
        std::string m_description;

        /// update list
        std::vector<LLNMS_Network_Host_Update> m_update_list;


}; ///  End of LLNMS_Network_Host class


#endif
