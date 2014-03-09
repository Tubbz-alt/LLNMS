/**
 * @file    CreateNetworkDefinitionUI.hpp
 * @author  Marvin Smith
 * @date    2/27/2014
 */
#ifndef __SRC_CPP_LLNMSCLI_UI_CREATENETWORKDEFINITIONUI_HPP__
#define __SRC_CPP_LLNMSCLI_UI_CREATENETWORKDEFINITIONUI_HPP__

/// LLNMS Core Library
#include <LLNMS.hpp>

/// LLNMS CLI Libraries
#include <core/Logger.hpp>
#include <core/Options.hpp>

extern Logger logger;
extern Options options;
extern LLNMS::LLNMS_State state;



/**
 * Create Network Definition User Interface
 *
 * @returns{ 0 if no changes were made
 *           1 if we should update the tables
 *         }
 */
int create_network_definition_ui();

#endif
