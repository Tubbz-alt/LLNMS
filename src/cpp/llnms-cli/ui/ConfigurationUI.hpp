/**
 * @file    ConfigurationUI.hpp
 * @author  Marvin Smith
 * @date    3/2/2014
 */
#ifndef __SRC_CPP_LLNMSCLI_UI_CONFIGURATIONUI_HPP__
#define __SRC_CPP_LLNMSCLI_UI_CONFIGURATIONUI_HPP__

/// LLNMS Core Library
#include <LLNMS.hpp>

/// LLNMS CLI Libraries
#include <core/Options.hpp>

extern Options options;

extern LLNMS::LLNMS_State state;

/**
 * Print the ConfigurationUI
 */
void configuration_ui();

#endif
