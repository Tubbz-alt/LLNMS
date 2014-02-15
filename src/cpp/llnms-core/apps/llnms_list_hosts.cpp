/**
 * @file    llnms_list_hosts.cpp
 * @author  Marvin Smith
 * @date    2/15/2014
*/
#include <LLNMS.hpp>

#include <exception>
#include <iostream>
#include <string>

using namespace std;


/**
 * Main Function
*/
int main( int argc, char* argv[] ){

    try{

        /// create a network module
        LLNMS::NETWORK::NetworkModule network_module;

        /// update the network module
        network_module.update();
        
        /// Get a list of network hosts which are registered
        vector<LLNMS::NETWORK::NetworkHost> scanned_hosts = network_module.scanned_network_hosts();
        
        /// print the information
        for( size_t i=0; i<scanned_hosts.size(); i++ ){
            cout << i << ": " << scanned_hosts[i].ip4_address() << endl;

        }

    }catch( string e ){
        cout << e << endl;
    }catch( exception e ){
        cout << e.what() << endl;
        return 1;
    }

    return 0;
}

