/**
 * @file    ConfigPane.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_CONFIGPANE_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_CONFIGPANE_HPP__

#include <QLabel>
#include <QVBoxLayout>
#include <QWidget>

/**
 * @class ConfigPane
 */
class ConfigPane : public QWidget{

    Q_OBJECT

    public:

        /**
         * Constructor
         */
        ConfigPane( QWidget* parent = NULL );


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




}; /// End of ConfigPane clas


#endif

