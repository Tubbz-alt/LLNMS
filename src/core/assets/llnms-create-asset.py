#!/usr/bin/env python
#
#    File:    llnms-create-asset
#    Author:  Marvin Smith
#    Date:    6/15/2015
#
#    Purpose:  Create an LLNMS Asset
#
__author__ = 'Marvin Smith'

#  Python Libraries
import argparse, os, sys, datetime

#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms


# ------------------------------------ #
# -      Parse the Command Line      - #
# ------------------------------------ #
def Parse_Command_Line():

    #  Create parser
    parser = argparse.ArgumentParser(description="Create an LLNMS Asset.")

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
                        help='Run in interactive mode.')

    #  Network Name
    parser.add_argument('-host', '--hostname',
                        required=False,
                        dest='asset_hostname',
                        help='Name of the network to scan.')

    #  Description
    parser.add_argument('-d','--description',
                        required=False,
                        dest='asset_description',
                        help='Asset description.')
	
    #  Address
    parser.add_argument('-a','--address',
						required=False,
						dest='asset_addresses',
						action='append',
						help='Address for the particular network.')

    #  Output Pathname
    parser.add_argument('-o','--output-path',
                        required=False,
                        dest='asset_output_path',
                        help='Output pathname.  If not provided on will be generated.')

    #  Return Parser
    return parser.parse_args()

# ------------------------------ #
# -       Process Inputs       - #
# ------------------------------ #
def Process_Inputs( options, asset_list, llnms_home ):

    #  Get the hostname
    asset_hostname = options.asset_hostname
    if options.interactive_mode is True and asset_hostname is None:
        asset_hostname = raw_input('Please enter the desired asset hostname: ')
    if llnms.Asset.Asset().Is_Valid_Hostname(asset_hostname) == False:
        raise Exception('Invalid hostname.')

    #  Compare the asset list to see if the name is set
    for asset in asset_list:
        if asset.hostname == asset_hostname:
            raise Exception('Asset with hostname (' + asset_hostname + ') already exists.')


    #  Get the description
    asset_description = options.asset_description
    if options.interactive_mode is True and asset_description is None:
        asset_description = raw_input('Please enter description of network: ')


    #  Get the asset path
    asset_output_path = options.asset_output_path
    if asset_output_path is None:
        asset_output_path = llnms_home + '/assets/' + datetime.datetime.now().strftime('%Y%M%d_%H%m%s') + '.llnms-asset.xml'

    #  Get the Addresses
    asset_address_list = []
    if options.interactive_mode is True:

        # Ask user to enter IP address type
        temp_ip_type = raw_input('Please enter address type\n  1.  ipv4\n  2.  ipv6\n  $> : ')
        if temp_ip_type == 'ipv4' or temp_ip_type == 'ip4' or temp_ip_type == '1':
            temp_ip_type = llnms.utility.Network_Utilities.IP_Address_Type.IPV4
        elif temp_ip_type == 'ipv6' or temp_ip_type == 'ip6' or temp_ip_type == '2':
            temp_ip_type = llnms.utility.Network_Utilities.IP_Address_Type.IPV6
        else:
            raise Exception('error: Unknown IP Address Type.')

        #  Get the address
        temp_ip_value = raw_input('Please enter address value: ')

        #  Add to network
        asset.address_list.append(llnms.Asset.AssetAddress(ip_type=temp_ip_type,
                                                           ip_value=temp_ip_value))

    #  Return new asset
    return llnms.Asset.Asset( hostname    = asset_hostname,
                              description = asset_description,
                              filename    = asset_output_path)


# ----------------------------- #
# -       Main Function       - #
# ----------------------------- #
def Main():

    #  Look for LLNMS_HOME
    llnms_home = os.environ['LLNMS_HOME']

    #  Parse the command-line
    options = Parse_Command_Line()

    #  Check if name provided or interactive mode enabled
    asset_list = llnms.Asset.llnms_load_assets(llnms_home=llnms_home)

    #  Check the input arguments
    new_asset = Process_Inputs( options,
                                asset_list,
                                llnms_home )

    #  Create the network
    new_asset.Write_Asset_File()

if __name__ == '__main__':
    Main()
