#    File:    Asset.py
#    Author:  Marvin Smith
#    Date:    6/15/2015
#
#    Purpose: LLNMS Asset Utilities.
#
__author__ = 'Marvin Smith'


#  System Libraries
import glob, logging, os, re
import xml.etree.ElementTree as ET

#  Python Libraries
import Scanner, Globals, utility.XML_Utilities


# ----------------------------- #
# -       Asset Address       - #
# ----------------------------- #
class AssetAddress(object):

    #  IP Type
    ip_type = None

    #  IP Value
    ip_value = None

    #  Remote Access
    remote_access = None

    # --------------------------- #
    # -       Constructor       - #
    # --------------------------- #
    def __init__(self, ip_type=None,
                       ip_value=None,
                       remote_access = [False, {}]):

        #  Set the type
        self.ip_type = ip_type

        #  Set the value
        self.ip_value = ip_value

        #  Set the remote access
        self.remote_access = remote_access


    # ------------------------------------------------- #
    # -       Check if the AddressType is Valid       - #
    # ------------------------------------------------- #
    def Is_Valid(self):

        #  Check the ip type
        if IP_Address_Type.Is_Valid(self.ip_type):
            return False

        #  Otherwise true
        return True

    # ------------------------------------- #
    # -       Print to list format        - #
    # ------------------------------------- #
    def To_List_String(self):

        #  Output
        output = utility.Network_Utilities.IP_Address_Type().To_String(self.ip_type) + ' ' + self.ip_value

        return output

    # -------------------------------------- #
    # -       Print to Pretty Format       - #
    # -------------------------------------- #
    def To_Pretty_String(self, index = None):

        #  Output
        index_str = ''
        if index is not None:
            index_str = 'Index ' + str(index)
        output  = '     Address : ' + index_str + '\n'
        output += '        IP Address Type: ' + utility.Network_Utilities.IP_Address_Type().To_String(self.ip_type) + '\n'
        output += '        Address Value  : ' + self.ip_value + '\n'
        output += '        Remote Access\n'
        output += '                 Enabled : ' + str(self.remote_access[0]) + '\n'
        output += '               Driver-ID : ' + str(self.remote_access[1]['remote-driver']) + '\n'
        output += '                username : ' + str(self.remote_access[1]['login-username']) + '\n'
        output += '\n'

        return output

# ---------------------------- #
# -       Asset Class        - #
# ---------------------------- #
class Asset(object):

    #  Hostname
    hostname = None

    #  Address
    address_list = []

    #  Description
    description = None

    #  Registered scanners
    registered_scanners = []

    #  Filename
    filename = None

    #  Hostname Regex
    hostname_regex = re.compile(Globals.LLNMS_HOSTNAME_REGEX_PATTERN)

    # --------------------------- #
    # -       Constructor       - #
    # --------------------------- #
    def __init__( self,
                  hostname = None,
                  address_list = [],
                  description = None,
                  scanners = [],
                  filename = None ):

        #  Hostname
        self.hostname = hostname

        #  Hostname Regex
        hostname_regex = re.compile(Globals.LLNMS_HOSTNAME_REGEX_PATTERN)

        #  Address List
        self.address_list = address_list

        #  Description
        self.description = description

        #  Scanners
        self.registered_scanners = scanners

        #  Filename
        self.filename = filename

        #  Filename
        if self.filename is not None:
            self.Load_From_File(self.filename)


    # ---------------------------------------------------- #
    # -      Load the Asset Information From A File      - #
    # ---------------------------------------------------- #
    def Load_From_File(self, filename ):

        #  Set the filename
        self.filename = filename

        #  Make sure the file exists
        if os.path.exists(self.filename) is not True:
            return

        #  Open the XML File
        root = ET.parse(self.filename)

        #  Get the hostname
        hnode = root.find('hostname')
        if hnode is not None:
            self.hostname = hnode.text

        #  Get the description
        dnode = root.find('description')
        if dnode is not None:
            self.description = dnode.text

        #  Get the addresses node
        addresses_node = root.find('addresses')
        if addresses_node is not None:
            for address_node in addresses_node:

                #  Get the type
                ip_type_str = address_node.get('ip-type')
                ip_type = utility.Network_Utilities.IP_Address_Type().From_String(ip_type_str)

                #  Get the value
                ip_value = address_node.get('value')

                #  Get the remote access child
                remote_node = address_node.find('remote-access')

                remote_access = [False, {}]
                if remote_node is not None:

                    #  Check if configured
                    if bool(remote_node.get('configured')) is True:
                        remote_access[0] = True

                    #  Check the remote-driver
                    if remote_node.get('remote-driver') is not None:
                        remote_access[1]['remote-driver'] = remote_node.get('remote-driver')

                        #  Look for the remote driver node
                        remote_driver_node = remote_node.find('remote-driver')
                        if remote_driver_node is not None:

                            #  Get the login
                            login_node = remote_driver_node.find('login')

                            remote_access[1]['login-username'] = login_node.get('username')

                #  If both are valid, then create the address node
                if ip_type is not None and ip_value is not None:

                    #  Add the node
                    temp_address = AssetAddress(ip_type=ip_type,
                                                ip_value=ip_value,
                                                remote_access=remote_access)

                    #  Add to the list
                    self.address_list.append(temp_address)

        #  Get the scanner node
        scanners_node = root.find('scanners')
        if scanners_node is not None:
            for scanner_node in scanners_node:

                #  Get the id
                id_node = scanner_node.find('id')
                if id_node is None:
                    continue
                scanner_id = id_node.text

                #  Create the scanner entry
                scanner_entry = [scanner_id,[]]

                #  Get the argument list
                args_node = scanner_node.findall('argument')
                if args_node is not None:
                   for arg_node in args_node:

                        # Get the name
                        arg_name = arg_node.get('name')
                        arg_val  = arg_node.get('value')

                        #  Add to list
                        if arg_name is not None and arg_val is not None:

                            scanner_entry[1].append([arg_name,arg_val])

                #add scanner
                self.registered_scanners.append(scanner_entry)


    # ----------------------------------- #
    # -       Write Asset to File       - #
    # ----------------------------------- #
    def Write_Asset_File(self, filename = None):

        #  #  Check the filename
        if filename is not None:
            self.filename = filename

        # load the xml parser
        if os.path.exists(self.filename):
            tree = ET.parse(self.filename)
            root = tree.getroot()
        else:
            root = ET.Element('llnms-asset')
            tree = ET.ElementTree(root)


        # set name
        hostname_node = root.find('hostname')
        if hostname_node is None:
            hostname_node = ET.SubElement(root, "hostname")
        hostname_node.text = self.hostname

        #  Get description node
        des_node = root.find('description')
        if des_node is None:
            des_node = ET.SubElement(root, 'description')
        des_node.text = self.description

        #  Get address node
        addr_node = root.find('addresses')
        if addr_node is None:
            addr_node = ET.SubElement(root, 'addresses')

        #  Iterate over each address you already have
        for address in self.address_list:

            #  Check if the address is already there
            res = addr_node.findall('./address[@ip-value=\'' + address.ip_value + ']' )

            if res is not None:
                pass

        #  Indent the file
        utility.XML_Utilities.XML_Indent(root)

        #  Write the file
        print('Writing asset to ' + self.filename)
        tree.write(self.filename)
    

    # ------------------------------------------------ #
    # -      Check if the entire asset is valid      - #
    # ------------------------------------------------ #
    def Is_Valid(self,  print_error_msg=False):

        #  Make sure the hostname is valid
        if self.Is_Valid_Hostname(self.hostname) is False:
            if print_error_msg is True:
                return False, 'Invalid hostname format.'
            else:
                return False


        #  Otherwise, return valid
        if print_error_msg is True:
            return True, 'No errors.'
        else:
            return True


    # ----------------------------------------- #
    # -      Check if Hostname is Valid       - #
    # ----------------------------------------- #
    def Is_Valid_Hostname(self, hostname):

        #  Compare the hostname against the REGEX
        if self.hostname_regex.match(hostname) is None:
            return False

        #  Otherwise false
        return True

    # ----------------------------------- #
    # -      Print to List String       - #
    # ----------------------------------- #
    def To_List_String(self):

        #  Create output
        output = self.hostname + ' ' + self.filename

        #  Return
        return output

    # ------------------------------------- #
    # -      Print to Pretty String       - #
    # ------------------------------------- #
    def To_Pretty_String(self):

        #  Create output
        output =  '    Hostname    : ' + self.hostname + '\n'
        output += '    Pathname    : ' + self.filename + '\n'
        output += '    Description : ' + str(self.description) + '\n'
        output += '    Address List:\n'

        #  Build the address list
        for addr in self.address_list:
            output += addr.To_Pretty_String()
        output += '\n'

        #  Build the scanner list
        output += '    Scanners:\n'
        for scanner in self.registered_scanners:
            output += '      Scanner:\n'
            output += '          ID: ' + self.registered_scanners[0][0] + '\n'
            for arg in self.registered_scanners[0][1]:
                output += '          Arg Key: ' + arg[0] + ',  Arg Value: ' + arg[1] +  '\n'

        return output


# -------------------------------- #
# -       Load all Assets        - #
# -------------------------------- #
def llnms_load_assets( llnms_home ):

    #  make sure the directory exists
    asset_files = glob.glob(llnms_home + "/assets/*.llnms-asset.xml")
    logging.debug('Found ' + str(len(asset_files)) + ' asset files.')

    #  create our output
    output = []

    # iterate through the files, loading each
    for asset_file in asset_files:

        #  Create temporary network
        temp_asset = Asset(filename=asset_file)

        output.append(temp_asset)

        #  Log
        logging.debug('Loaded asset file: ' + asset_file)

    #  Return list
    return output

