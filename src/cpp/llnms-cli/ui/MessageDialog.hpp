/**
 * @file    MessageDialog.hpp
 * @author  Marvin Smith
 * @date    3/2/2014
 */
#ifndef __SRC_CPP_LLNMSCLI_UI_MESSAGEDIALOG_HPP__
#define __SRC_CPP_LLNMSCLI_UI_MESSAGEDIALOG_HPP__

/// LLNMS CLI Libraries
#include <core/Options.hpp>

/// C++ Standard Library
#include <string>


extern Options options;

const int BUTTON_CANCEL = 0;
const int BUTTON_SAVE = 1;

/**
 * Show Message Dialog
 */
int message_dialog( const std::string& message, const int& BUTTON_FLAGS );


#endif
