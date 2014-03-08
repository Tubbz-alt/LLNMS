/**
 * @file    MessagingService.hpp
 * @author  Marvin Smith
 * @date    1/27/2014
*/
#ifndef __SRC_CPP_LLNMSGUI_CORE_MESSAGING_SERVICE_HPP__
#define __SRC_CPP_LLNMSGUI_CORE_MESSAGING_SERVICE_HPP__

#include <QtGui>
#include <QWidget>

#include <deque>
#include <string>

/**
 * @class MessagingService
 */
class MessagingService : public QObject{

    Q_OBJECT

    public:
        
        /// List of status messages
        std::deque<std::string> status_messages;
        
    
    signals:

        /**
         * Tell the program to quit
         */
        void quit_program_signal();
        
        /**
         * Tell LLNMS to update itself
         */
        void update_llnms();

};

#endif
