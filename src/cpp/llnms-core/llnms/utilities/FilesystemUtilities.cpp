/**
 * @file    FilesystemUtilities.cpp
 * @author  Marvin Smith
 * @date    2/15/2014
 */
#include "FilesystemUtilities.hpp"

#include <boost/filesystem.hpp>

namespace bf=boost::filesystem;

namespace LLNMS{
namespace UTILITIES{

bool is_directory( const std::string& pathname ){
    if( bf::exists( bf::path( pathname ) ) == false ){
        return false;
    }
    return bf::is_directory( bf::path( pathname ));
}

bool exists( const std::string& pathname ){
    return bf::exists( bf::path( pathname ));
}

} /// End of UTILITIES Namespace
} /// End of LLNMS Namespace

