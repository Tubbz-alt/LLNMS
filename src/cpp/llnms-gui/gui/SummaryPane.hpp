/**
 * @file    SummaryPane.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_SUMMARYPANE_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_SUMMARYPANE_HPP__


#include <QLabel>
#include <QVBoxLayout>
#include <QWidget>

/**
 * @class SummaryPane
 */
class SummaryPane : public QWidget {

    Q_OBJECT

    public:

        /**
         * Default Constructor
         */
        SummaryPane( QWidget* widget = NULL );
    

    private:
        
        /*************************************/
        /*         Private Functions         */
        /*************************************/
        
        
        /*************************************/
        /*         Private Variables         */
        /*************************************/

        // main layout
        QVBoxLayout*   mainLayout;

        // main label
        QLabel*        mainLabel;


    
}; /// End of SummaryPane class


#endif

