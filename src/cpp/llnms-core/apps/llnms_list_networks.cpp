/**
 * @file    llnms_list_networks.cpp
 * @author  Marvin Smith
 * @date    2/14/2014
 * 
 * @brief   LLNMS-List-Network Command-Line Application
 *
 * Provides the user with a command-line utility to list
 * registered LLNMS Networks.
*/

#include <deque>
#include <iostream>
#include <string>

#include <LLNMS.hpp>

using namespace std;

/**
 * @class Options
*/
class Options{

    public:
        
        /**
         * Default constructor for option class
        */
        Options(){
            
            /// Set default LLNMS_Home
            LLNMS_HOME="/var/tmp/llnms";

        }

        /// Base directory of LLNMS
        std::string LLNMS_HOME;

}; /// End of Options class

/**
 * Print version information
*/
void version( ){
    
    cout << "llnms-list-networks" << endl;
    cout << endl;
    cout << "Version   : " << LLNMS_VERSION_MAJOR << "." << LLNMS_VERSION_MINOR << endl;
    cout << "Build Date: " << LLNMS_VERSION_DATE << endl;
    cout << endl;

}

/**
 * Usage instructions
*/
void usage( const std::string& program_name ){

    cout << "usage: " << program_name << " [options]" << endl;
    cout << endl;
    cout << "    options: " << endl;
    cout << "    -h, --help            : Print usage instructions." << endl;
    cout << "    -v, --version         : Print version information." << endl;
    cout << "    --LLNMS_HOME <string> : Define the desired LLNMS_HOME variable." << endl;

    cout << endl;

}

/**
 * Parse Command-Line Options
*/
Options parse_command_line_options( int argc, char* argv[] ){

    /// Create option container
    Options options;

    // Look for LLNMS Home
    // first, check if the environment variable exists, otherwise use expected
    const char* llnms_home_env = getenv("LLNMS_HOME"); 
    if( llnms_home_env != NULL && LLNMS::UTILITIES::exists( llnms_home_env ) == true ){
        if( LLNMS::UTILITIES::is_directory( llnms_home_env ) == true ){
            options.LLNMS_HOME = llnms_home_env;
        }   
    }

    // push all args onto a deque
    deque<string> args;
    for( int i=1; i<argc; i++ )
        args.push_back(argv[i]);

    // iterate through all arguments
    while( args.size() > 0 ){

        // grab the top argument
        string arg = args.front();
        args.pop_front();

        /// Check for Help Command
        if( arg == "-h" || arg == "--help" ){
            usage( argv[0] );
            exit(0);
        }

        /// Check for Version Command
        else if( arg == "-v" || arg == "--version" ){
            version();
            exit(0);
        }

        /// Check for LLNMS HOME Variable
        else if( arg == "--LLNMS_HOME" ){
            
            // make sure there is an argument
            if( args.size() <= 0 ){
                throw string("No path was specified for LLNMS_HOME flag");
            }
            // grab the value
            string new_llnms_home = args.front();
            args.pop_front();
        
            // make sure the home path exists
            if( LLNMS::UTILITIES::is_directory( new_llnms_home ) == false ){
                usage(argv[1]);
                throw string("LLNMS_HOME specified is not a valid directory.");
            }
            options.LLNMS_HOME = new_llnms_home;
        }
    }

    return options;
}

int main( int argc, char* argv[] ){
    
    try{
        
        /// parse command-line options
        Options options = parse_command_line_options( argc, argv );
        
        /// Load a LLNMS Network Module
        LLNMS::NETWORK::NetworkModule network_module( options.LLNMS_HOME );
        network_module.update();

        /// Get a list of all current networks
        deque<LLNMS::NETWORK::NetworkDefinition> network_list = network_module.network_definitions();
        
        /// iterate through each network and print its information
        for( size_t i=0; i<network_list.size(); i++ ){
            cout << (i+1) << ": " << network_list[i].name() << ", " << network_list[i].address_start() << ", " << network_list[i].address_end() << endl;
        }

    } catch ( string e ){
        cout << e << endl;
        return 1;
    } catch (exception e){
        cout << e.what() << endl;
        return 1;
    }

    return 0;
}

