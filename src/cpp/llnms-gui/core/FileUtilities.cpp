/**
 * @file    FileUtilities.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "FileUtilities.hpp"

#include <boost/filesystem.hpp>

/**
 * Check if path exists
 */
bool path_exists( const std::string& pathname ){
    return boost::filesystem::exists( boost::filesystem::path( pathname ));
}

/**
 * Get a list of files in a directory
 */
std::vector<std::string> path_ls( const std::string& pathname ){
    
    // create an output container
    std::vector<std::string> output;
    
    // make sure if the path does not exist, then return
    if( boost::filesystem::exists( pathname ) == false ){
        return output;
    }

    // if the path is not a directory, then return
    if( boost::filesystem::is_directory( pathname ) == false ){
        return output;
    }

    // iterate over the directory
    boost::filesystem::path dirpath( pathname );
    boost::filesystem::directory_iterator beg_iter( dirpath );
    boost::filesystem::directory_iterator end_iter;

    for( beg_iter; beg_iter != end_iter; beg_iter++ ){
        
        if( boost::filesystem::is_regular_file( beg_iter->status())){
            output.push_back( beg_iter->path().string() );
        }

    }
    
    return output;
}

