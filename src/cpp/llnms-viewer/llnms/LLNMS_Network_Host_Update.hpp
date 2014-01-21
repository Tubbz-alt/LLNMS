/**
 * @file    LLNMS_Network_Host_Update.hpp
 * @author  Marvin Smith
 * @date    1/20/2014
 */
#ifndef __SRC_CPP_LLNMSVIEWER_LLNMS_LLNMSNETWORKHOSTUPDATE_HPP__
#define __SRC_CPP_LLNMSVIEWER_LLNMS_LLNMSNETWORKHOSTUPDATE_HPP__

#include <string>

/**
 * @class  LLNMS_Network_Host_Update
 */
class LLNMS_Network_Host_Update{

    public:

        /**
         * Default Constructor
         */
        LLNMS_Network_Host_Update();

        /**
         * Parameterized Constructor
         */
        LLNMS_Network_Host_Update( 
                                    std::string const& datetime,
                                    std::string const& status
                                 );


    private:

        /// Datetime string
        std::string  m_datetime;

        /// Status string
        std::string m_status;


}; /// End of LLNMS_Network_Host_Update string



#endif

