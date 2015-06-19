#!/usr/bin/env python
#
#    File:    llnms-create-network
#    Author:  Marvin Smith
#    Date:    6/14/2015
#
#    Purpose:  Create an LLNMS Network
#
__author__ = 'Marvin Smith'

#  Python Libraries
import argparse
import os
import sys
import datetime

#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms


# ------------------------------------ #
# -      Parse the Command Line      - #
# ------------------------------------ #
def Parse_Command_Line():

    #  Create parser
    parser = argparse.ArgumentParser(description="Create an LLNMS Network.")

    #  Version Info
    parser.add_argument('-v', '--version',
                        action='version',
                        version='%(prog)s ' + llnms.info.Get_Version_String(),
                        help='Print the version information.')

    #  Verbose Mode
    parser.add_argument('--verbose',
                        dest='verbose_flag',
                        required=False,
                        default=False,
                        action='store_true',
                        help='Print with verbose output.')

    #  Quiet Mode
    parser.add_argument('--quiet',
                        required=False,
                        default=False,
                        action='store_true',
                        help='Do not print output.')

    #  Interactive
    parser.add_argument('-i', '--interactive',
                        required=False,
                        default=False,
                        dest='interactive_mode',
                        action='store_true',
                        help='Run in interactive mode.',)

    #  Network Name
    parser.add_argument('-n', '--name',
                        required=False,
                        dest='network_name',
                        help='Name of the network to scan.')

    #  Address Start
    parser.add_argument('-as','--address-start',
                        required=False,
                        dest='network_address_start',
                        help='Starting Address.')

    #  Address End
    parser.add_argument('-ae','--address-end',
                        required=False,
                        dest='network_address_end',
                        help='Ending address.')

    #  Description
    parser.add_argument('-d','--description',
                        required=False,
                        dest='network_description',
                        help='Description of network.')

    #  Output Pathname
    parser.add_argument('-o','--output-path',
                        required=False,
                        dest='network_output_path',
                        help='Output pathname.  If not provided on will be generated.')

    #  Return Parser
    return parser.parse_args()

# ------------------------------ #
# -       Process Inputs       - #
# ------------------------------ #
def Process_Inputs( options, network_list, llnms_home ):

    #  Get the name
    network_name = options.network_name
    if options.interactive_mode is True and network_name is None:
        network_name = raw_input('Please enter network name: ')


    #  Compare the network list to see if the name is set
    for network in network_list:
        if network.name == network_name:
            raise Exception('Network with name (' + network_name + ') already exists.')

    #  Get the address start
    valid_flag = False
    network_address_start = options.network_address_start
    if options.interactive_mode is True and network_address_start is None:
        while valid_flag is False:
            network_address_start = raw_input('Please enter address start: ')
            valid_flag = llnms.utility.Network_Utilities.Is_Valid_IP4_Address(network_address_start)
            if valid_flag is False:
                print('error: Invalid input.')

    #  Get the address end
    valid_flag=False
    network_address_end = options.network_address_end
    if options.interactive_mode is True and network_address_end is None:
        while valid_flag is False:
            network_address_end = raw_input('Please enter address end: ')
            valid_flag = llnms.utility.Network_Utilities.Is_Valid_IP4_Address(network_address_end)
            if valid_flag is False:
                print('error: Invalid input.')

    #  Get the description
    network_description = options.network_description
    if options.interactive_mode is True and network_description is None:
        network_description = raw_input('Please enter description of network: ')

    #  Get the network path
    network_output_path = options.network_output_path
    if network_output_path is None:
        network_output_path = llnms_home + '/networks/' + datetime.datetime.now().strftime('%Y%M%d_%H%m%s') + '.llnms-network.xml'

    #  Return new network
    return llnms.Network.Network(name          = network_name,
                                 address_start = network_address_start,
                                 address_end   = network_address_end,
                                 description   = network_description,
                                 filename      = network_output_path)

# -------------------------------- #
# -       Validate Options       - #
# -------------------------------- #
def Validate_Options( options ):

    #  Make sure either interactive set or else the variables set
    if  options.interactive_mode is True:
        return

    #  Make sure the name, and other items set
    if options.network_name is None:
        raise Exception('No network name provided.')
    if options.network_address_start is None:
        raise Exception('No address start provided.')
    if options.network_address_end is None:
        raise Exception('No address end provided.')


# ----------------------------- #
# -       Main Function       - #
# ----------------------------- #
def Main():

    #  Look for LLNMS_HOME
    LLNMS_HOME = os.environ['LLNMS_HOME']

    #  Parse the command-line
    options = Parse_Command_Line()

    #  Check for errors
    Validate_Options( options )

    #  Check if name provided or interactive mode enabled
    network_list = llnms.Network.llnms_load_networks(llnms_home=LLNMS_HOME)

    #  Check the input arguments
    new_network = Process_Inputs( options,
                                  network_list,
                                  LLNMS_HOME )

    #  Create the network
    if new_network.Is_Valid():
        new_network.Write_Network_File()
    else:
        raise Exception('Network has an invalid structure.')

if __name__ == '__main__':
    Main()
