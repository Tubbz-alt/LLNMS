/**
 * @file    NavigationBar.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_GUI_NAVIGATIONBAR_HPP__
#define __SRC_CPP_LLNMSGUI_GUI_NAVIGATIONBAR_HPP__

#include <QWidget>


/**
 * @class NavigationBar
 */
class NavigationBar : public QWidget{

    Q_OBJECT

    public:
        
        /**
         * Constructor
         */
        NavigationBar( QWidget* parent = NULL );


}; /// End of NavigationBar class


#endif

