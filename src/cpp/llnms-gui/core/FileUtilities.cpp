/**
 * @file    FileUtilities.cpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#include "FileUtilities.hpp"

#include <boost/filesystem.hpp>

/**
 * Check if file exists
 */
bool file_exists( const std::string& filename ){
    return boost::filesystem::exists( boost::filesystem::path( filename ));
}

