/**
 * @file    FilesystemUtilities.cpp
 * @author  Marvin Smith
 * @date    2/15/2014
 */
#include "FilesystemUtilities.hpp"

#include <boost/filesystem.hpp>
#include <boost/regex.hpp>

#include <vector>


namespace bf=boost::filesystem;


namespace LLNMS{
namespace UTILITIES{

/**
 * Run a standard system command and grab the output
*/
bool run_command( const std::string& command, std::string& message ){

    /// create output message
    message="";
    
    // run the command on the file descriptor
    FILE* pipe = popen(command.c_str(), "r");
    if( !pipe ){
        message = "command failed to run.";
        return false;
    }
    else{
        
        // create our output
        char buffer[128];
        
        // iterate over the stream output
        while(!feof(pipe)) {
            if(fgets(buffer, 128, pipe) != NULL)
                message += buffer;
        }
        pclose(pipe);
    
    }
    

    return true;
}



/**
 * Check if a path is a directory
*/
bool is_directory( const std::string& pathname ){
    if( bf::exists( bf::path( pathname ) ) == false ){
        return false;
    }
    return bf::is_directory( bf::path( pathname ));
}

/**
 * Check if a path exists
*/
bool exists( const std::string& pathname ){
    return bf::exists( bf::path( pathname ));
}


/**
 * Get a list of files in a directory
 */
std::vector<std::string> list_contents( const std::string& pathname, const std::string& pattern ){
    
    // create an output container
    std::vector<std::string> output;
    
    // build a regex from the pattern input
    boost::regex expression(pattern);
    
    // make sure if the path does not exist, then return
    if( boost::filesystem::exists( pathname ) == false ){
        return output;
    }

    // if the path is not a directory, then return nothing
    if( boost::filesystem::is_directory( pathname ) == false ){
        return output;
    }

    // iterate over the directory
    boost::filesystem::path dirpath( pathname );
    boost::filesystem::directory_iterator beg_iter( dirpath );
    boost::filesystem::directory_iterator end_iter;

    for( ; beg_iter != end_iter; beg_iter++ ){
        
        if( boost::filesystem::is_regular_file( beg_iter->status())){

            // compare with the pattern
            if( boost::regex_match( beg_iter->path().string(), expression ) == true ){
                output.push_back( beg_iter->path().string() );
            }
        }

    }
    
    return output;
}
} /// End of UTILITIES Namespace
} /// End of LLNMS Namespace

