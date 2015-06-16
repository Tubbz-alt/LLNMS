#!/usr/bin/env python
#
#    File:     llnms-ssh-remote-connector.py
#    Author:   Marvin Smith
#    Date:     6/15/2015
#
#    Purpose:  Provide remote connection capabilities via SSH.
#
__author__ = 'Marvin Smith'

#  Python Libraries
import argparse, os, sys, subprocess

#  LLNMS Libraries
if os.environ['LLNMS_HOME'] is not None:
    sys.path.append(os.environ['LLNMS_HOME'] + '/lib')
import llnms


# -------------------------------------------- #
# -       Parse Command-Line Arguments       - #
# -------------------------------------------- #
def Parse_Command_Line():

    #  Create argument parser
    parser = argparse.ArgumentParser( description="Connect to remote system via ssh." )
    
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
                        dest='quiet_flag',
                        required=False,
                        default=False,
                        action='store_true',
                        help='Do not print stdout results.')


    #  Select Asset
    parser.add_argument('-a','--asset-hostname',
                        required=True,
                        dest='asset_hostname',
                        help='Asset name to connect to.  Must be registered in LLNMS.')

    #  Operation Mode
    parser.add_argument('-c','--command',
                        required=True,
                        dest='command_input',
                        help='Command to run on remote system.')

    #  return the parser
    return parser.parse_args()


# ------------------------------ #
# -       Validate Input       - #
# ------------------------------ #
def Validate_Input( options, asset_list ):

    #  Figure out the print mode
    print_level=1
    if options.quiet_flag is True and options.verbose_flag is True:
        raise Exception("Conflict between quiet and verbose mode flags.")
    if options.quiet_flag is True:
        print_level=0
    elif options.verbose_flag is True:
        print_level=2

    #  Get the command input
    output_cmd = options.command_input

    #  Get the asset name
    asset_hostname = options.asset_hostname

    #  Make sure the asset is inside the asset list
    asset = None
    output_address = None
    for asset_candidate in asset_list:

        # Compare the asset names
        if asset_candidate.hostname == asset_hostname:

            #  Make sure the asset has remote connections enabled
            for address in asset_candidate.address_list:
                if address.remote_access[0] is True:
                    asset = asset_candidate
                    output_address = address
                    break

    if asset is None:
        raise Exception('Unable to find a matching asset.')

    #  Return the matching asset
    return [asset, output_address, output_cmd, print_level]

# ------------------------------- #
# -        Asset Command        - #
# ------------------------------- #
def Connect_System( asset, address, cmd, print_level ):

    #  Command
    command = 'ssh '

    #  Check if the asset contains a user entry
    username = address.remote_access[1]['login-username']
    if username is not None:
        command += username + "@"

    #  Add the hostname and cmd
    command += asset.hostname + ' \'' + cmd + '\''

    proc = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    out, err = proc.communicate()

    if print_level == 1:
        print out
    elif print_level == 2:
        print(command)
        print(out)
        print(err)


# --------------------------- #
# -       Main Driver       - #
# --------------------------- #
def Main():

    #  Get LLNMS Home
    llnms_home=os.environ['LLNMS_HOME']

    #  Parse Command-Line Arguments
    options = Parse_Command_Line()

    #  Fetch the asset list
    llnms_assets = llnms.Asset.llnms_load_assets(llnms_home=llnms_home)

    #  Validate Input
    [asset, address, cmd, print_level] = Validate_Input(options, llnms_assets)

    #  Run SSH against the matching asset
    Connect_System( asset, address, cmd, print_level )

    # exit
    return

# ---------------------------- #
# -        Main Entry        - #
# ---------------------------- #
if __name__ == '__main__':
    Main()
