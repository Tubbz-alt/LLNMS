/**
 * @file    LLNMS_Host.hpp
 * @author  Marvin Smith
 * @date    2/12/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_LLNMS_LLNMSHOST_HPP__
#define __SRC_CPP_LLNMSGUI_LLNMS_LLNMSHOST_HPP__

#include "LLNMS_Host_Status.hpp"

#include <string>
#include <vector>


/**
 * @class LLNMS_Host
 */
class LLNMS_Host{

    public:
        
        /**
         * Default Constructor
         */
        LLNMS_Host();

    private:

        /// address string
        std::string ip4_address;

        /// status list
        std::vector<LLNMS_Host_Status> status_messages;

}; /// End of LLNMS_Host class

#endif
