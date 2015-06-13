#!/usr/bin/env python
#
#    File:     llnms-scan-network.py
#    Author:   Marvin Smith
#    Date:     6/13/2015
#
#    Purpose:  Scan LLNMS networks
#
__author__ = 'Marvin Smith'

# Python Libraries
import argparse, os, sys

#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms

# --------------------------------------------- #
# -       Parse Command-Line Arguments        - #
# --------------------------------------------- #
def Parse_Command_Line():

    #  Create parser
    parser = argparse.ArgumentParser( description='Scan an LLNMS network.' )


    #  Version
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

    #  Network Name
    parser.add_argument('-n', '--network',
                        required=True,
                        dest='network_input',
                        help='ID of the network to scan.')

    #  Scanner Name
    parser.add_argument('-s', '--scanner',
                        required=True,
                        dest='scanner_input',
                        help='ID of the scanner to use.')

    #  Print only passes
    parser.add_argument('-om', '--output-mode',
                        required=False,
                        dest='output_mode',
                        default=None,
                        help='Output mode. Supported options are xml and stdout. If xml provided, then user must provide filename.')

    #  Return the parser
    return parser.parse_args()

# ---------------------------- #
# -      Main Function       - #
# ---------------------------- #
def Main():

    #  Grab LLNMS HOME
    llnms_home=None
    if os.environ['LLNMS_HOME'] is not None:
        llnms_home=os.environ['LLNMS_HOME']

    #  Parse Command-Line Arguments
    options = Parse_Command_Line()

    #  Load the network definition
    network = llnms.Network.find_network( network_name=options.network_input,
                                          llnms_home=llnms_home)

    # Make sure we found a network
    if network is None:
        raise Exception('No network found matching name ' + options.network_input)

    #  Print the Network if Verbose
    if options.verbose_flag is True:
        print(network.To_Debug_String())

    #  Load the scanner definition
    scanner = llnms.Scanner.find_scanner( scanner_id=options.scanner_input,
                                          llnms_home=llnms_home )

    #  Make sure we found a scanner
    if scanner is None:
        raise Exception('No scanner found matching name ' + options.scanner_input)

    #  Print scanner if verbose
    if options.verbose_flag is True:
        print(scanner.To_Debug_String())

    #  Validate the scanner is registered within the network
    if network.Has_Scanner( scanner_id=scanner.id ) is False:
        raise Exception("Network does not have a scanner registered with id=" + scanner.id )

    #  Run scan on network
    results = scanner.Run_Scan_Range(endpoint_list=network.Get_Network_Range(),
                                     arg_list=network.Get_Scanner_Args(scanner.id),
                                     num_threads=4)

    # print results
    addresses = network.Get_Network_Range()
    for x in xrange(0, len(results)):
        print(addresses[x] + ' - ' + str(results[x]))

    raw_input('pause')

# ----------------------------- #
# -     Run Main Script       - #
# ----------------------------- #
if __name__ == '__main__':
    Main()
