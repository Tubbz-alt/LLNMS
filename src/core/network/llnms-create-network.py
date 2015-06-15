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
import argparse, os, sys

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
                        dest='network_destination',
                        help='Description of network.')

    #  Return Parser
    return parser.parse_args()


# ----------------------------- #
# -       Main Function       - #
# ----------------------------- #
def Main():

    #  Parse the command-line
    options = Parse_Command_Line()

if __name__ == '__main__':
    Main()