/**
 * @file    AssetPane.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_ASSETPANE_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_ASSETPANE_HPP__

#include <QLabel>
#include <QVBoxLayout>
#include <QWidget>

/**
 * @class AssetPane
 */
class AssetPane : public QWidget{

    Q_OBJECT

    public:

        /**
         * Constructor for the AssetPane class
         */
        AssetPane( QWidget* parent = NULL );


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



}; /// End of AssetPane Class


#endif

