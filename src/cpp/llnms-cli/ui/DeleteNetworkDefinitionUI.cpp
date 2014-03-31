/**
 * @file    DeleteNetworkDefinitionUI.cpp
 * @author  Marvin Smith
 * @date    3/9/2014
 */
#include "DeleteNetworkDefinitionUI.hpp"

#include <ncurses.h>

#include <string>

#include <utilities/CursesUtilities.hpp>

using namespace std;

/**
 * Delete the network definition
 */
void delete_network_definition_ui( const int& networkDefinitionIndex ){

    // start the main loop
    bool EXIT_LOOP = false;
    while( EXIT_LOOP == false ){

        // clear the console
        clear();
        
        // print network information
        print_form_line( "Network Name:",     state.m_network_module.network_definitions()[networkDefinitionIndex].name().c_str(),          5, 1, options.maxX-1, "LEFT", false, -1);
        print_form_line( "Starting Address:", state.m_network_module.network_definitions()[networkDefinitionIndex].address_start().c_str(), 7, 1, options.maxX-1, "LEFT", false, -1);
        print_form_line( "Ending Address:",   state.m_network_module.network_definitions()[networkDefinitionIndex].address_end().c_str(),   9, 1, options.maxX-1, "LEFT", false, -1);

        
        // get user input
        int ch = getch();

        // compare against options
        switch(ch){

            // cancel
            case 27:
                EXIT_LOOP = true;
                break;

            // default do nothing
            default:
                break;
        }



    }


}

