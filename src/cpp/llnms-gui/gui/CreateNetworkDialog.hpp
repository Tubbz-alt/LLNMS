/**
 * @file    CreateNetworkDialog.hpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_CREATENETWORKDIALOG_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_CREATENETWORKDIALOG_HPP__

#include <QDialog>
#include <QLabel>
#include <QVBoxLayout>
#include <QWidget>

/**
 * @class CreateNetworkDialog
 */
class CreateNetworkDialog : public QDialog {

    Q_OBJECT

    public:
        
        /**
         * Constructor
         */
        CreateNetworkDialog( QWidget* parent = NULL );

    
    private:

        //------------------------------------//
        //-        Private Variables         -//
        //------------------------------------//
        /// Main layout
        QVBoxLayout*  mainLayout;

        /// Main Label
        QLabel*       mainLabel;


}; /// End of CreateNetworkDialog class


#endif
