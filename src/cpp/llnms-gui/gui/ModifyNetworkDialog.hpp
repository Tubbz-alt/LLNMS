/**
 * @file    ModifyNetworkDialog.hpp
 * @author  Marvin Smith
 * @date    4/25/2014
*/
#ifndef __SRC_CPP_LLNMSGUI_GUI_MODIFYNETWORKDIALOG_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_MODIFYNETWORKDIALOG_HPP__

///  Qt Libraries
#include <QDialog>
#include <QHBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QToolButton>
#include <QVBoxLayout>
#include <QWidget>

/// LLNMS Core Library
#include <LLNMS.hpp>

/// C++ Libraries 
#include <vector>

/// LLNMS Gui Libraries
#include "../core/MessagingService.hpp"

/// LLNMS State Object
extern LLNMS::LLNMS_State llnms;

/// Messaging Services
extern MessagingService message_service;


/**
 * @class ModifyNetworkDialog
 */
class ModifyNetworkDialog : public QDialog {

    Q_OBJECT

    public:
        
        /**
         * Default Constructor
        */
        ModifyNetworkDialog( QWidget* parent = NULL );

    private:
        
        /*******************************/
        /*      Private Functions      */
        /*******************************/
        
        /**
         * Initialize the name widget
        */
        void initNameWidget();
        
        /**
         * Initialize the start address widget
        */
        void initStartAddressWidget();

        /**
         * Initialize the ending address widget
        */
        void initEndAddressWidget();
        
        /**
         * Initialize the toolbar
        */
        void initToolbar();

        /*******************************/
        /*      Private Variables      */
        /*******************************/
        /// Main Layout
        QVBoxLayout* mainLayout;

        ///  Name Widget
        QWidget*  nameWidget;

        /// Name Layout
        QHBoxLayout* nameLayout;

        /// Name Label
        QLabel*  nameLabel;

        /// Name Edit
        QLineEdit* nameEdit;

        /// Name Button
        QToolButton* nameLockButton;
    
        /// Start address widget
        QWidget* startAddressWidget;
        
        /// Start address layout
        QHBoxLayout* startAddressLayout;

        /// Start address label
        QLabel*  startAddressLabel;

        /// Start address edit
        QLineEdit* startAddressEdit;

        /// Start address lock button
        QToolButton* startAddressLockButton;

        /// End address widget
        QWidget* endAddressWidget;

        /// End address layout
        QHBoxLayout* endAddressLayout;

        /// End address label
        QLabel* endAddressLabel;

        /// End address line edit
        QLineEdit* endAddressEdit;

        /// End address lock button
        QToolButton* endAddressLockButton;
        
        /// Main Toolbar widget
        QWidget* toolbarWidget;

        /// Toolbar Layout
        QHBoxLayout* toolbarLayout;

        /// Toolbar Save Button
        QToolButton* modifyButton;

        /// Toolbar Cancel button
        QToolButton* cancelButton;


}; /// End of ModifyNetworkDialog Class


#endif

