/**
 * @file    DeleteNetworkDefinitionUI.hpp
 * @author  Marvin Smith
 * @date    3/9/2014
 */
#ifndef __SRC_CPP_LLNMSCLI_UI_DELETENETWORKDEFINITIONUI_HPP__
#define __SRC_CPP_LLNMSCLI_UI_DELETENETWORKDEFINITIONUI_HPP__

/// LLNMS Core
#include <LLNMS.hpp>

/// LLNMS CLI Libraries
#include <core/Logger.hpp>
#include <core/Options.hpp>

extern Logger logger;
extern Options options;
extern LLNMS::LLNMS_State state;

/**
 * Delete the network definition table
 */
void delete_network_definition_ui( const int& networkDefinitionIndex );

#endif
