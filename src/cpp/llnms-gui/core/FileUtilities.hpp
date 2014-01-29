/**
 * @file    FileUtilities.hpp
 * @author  Marvin Smith
 * @date    1/28/2014
 */
#ifndef __SRC_CPP_LLNMSGUI_CORE_FILEUTILITIES_HPP__
#define __SRC_CPP_LLNMSGUI_CORE_FILEUTILITIES_HPP__

#include <string>

/**
 * Return true if the file exists
 *
 * @param[in] filename File to check
 *
 * @return True if the file exists
 */
bool file_exists( const std::string& filename );


#endif
