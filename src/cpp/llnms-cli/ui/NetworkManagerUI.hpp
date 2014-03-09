/**
 *  @file    NetworkManagerUI.hpp
 *  @author  Marvin Smith
 *  @date    1/14/2014
 */
#ifndef __SRC_CPP_LLNMSCLI_NETWORKMANAGERUI_HPP__
#define __SRC_CPP_LLNMSCLI_NETWORKMANAGERUI_HPP__

/// LLNMS Core Library
#include <LLNMS.hpp>

/// LLNMS CLI Libraries
#include <core/Logger.hpp>
#include <core/Options.hpp>

extern Logger logger;
extern Options options;
extern LLNMS::LLNMS_State state;

/**
 * Network Manager UI
 */
void network_manager_ui();

#endif

