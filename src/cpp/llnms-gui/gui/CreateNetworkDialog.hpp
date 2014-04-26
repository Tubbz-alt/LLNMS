/**
 * @file    CreateNetworkDialog.hpp
 * @author  Marvin Smith
 * @date    1/30/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_CREATENETWORKDIALOG_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_CREATENETWORKDIALOG_HPP__

#include <QDialog>
#include <QHBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QToolButton>
#include <QVBoxLayout>
#include <QWidget>

/// Data Container
#include "../core/DataContainer.hpp"
#include "../core/MessagingService.hpp"

/// LLNMS Core Library
#include <LLNMS.hpp>

/// LLNMS State Object
extern LLNMS::LLNMS_State llnms;

/// Global Settings
extern DataContainer settings;

/// Message Service
extern MessagingService message_service;

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

    
    public slots:
        
        void saveAndClose();

    private:

        //------------------------------------//
        //-        Private Variables         -//
        //------------------------------------//
        void build_name_widget();

        void build_start_widget();

        void build_end_widget();

        void build_toolbar_widget();


        //------------------------------------//
        //-        Private Variables         -//
        //------------------------------------//
        /// Main layout
        QVBoxLayout*  mainLayout;

        /// Main Label
        QLabel*       mainLabel;
        
        /// Network Name Widget
        QWidget*      networkNameWidget;
        QHBoxLayout*  networkNameLayout;
        QLabel*       networkNameLabel;
        QLineEdit*    networkNameEdit;

        /// Network Start Address Widget
        QWidget*      networkStartWidget;
        QHBoxLayout*  networkStartLayout;
        QLabel*       networkStartLabel;
        QLineEdit*    networkStartEdit;

        /// Network End Address Widget
        QWidget*      networkEndWidget;
        QHBoxLayout*  networkEndLayout;
        QLabel*       networkEndLabel;
        QLineEdit*    networkEndEdit;

        /// Toolbar
        QWidget*      toolbarWidget;
        QHBoxLayout*  toolbarLayout;
        QToolButton*  toolbarSaveButton;
        QToolButton*  toolbarCancelButton;


}; /// End of CreateNetworkDialog class


#endif
