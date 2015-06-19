#    File:    Network.py
#    Author:  Marvin Smith
#    Date:    6/13/2015
#
#    Purpose:  Manage LLNMS Networks.
#
__author__ = 'Marvin Smith'

#  Python Libraries
import os
import xml.etree.ElementTree as ET
import logging
import subprocess
import glob
import itertools


#  LLNMS Libraries
from llnms.utility import XML_Utilities, Network_Utilities

# ----------------------------------- #
# -      LLNMS Network Object       - #
# ----------------------------------- #
class Network(object):

    #  Network Name
    name = ''

    #  Starting address
    address_start = ''

    #  End address
    address_end = ''

    #  Description
    description = None

    #  Registered Scanner List
    registered_scanners = []

    #  Output Filename
    filename = None

    # --------------------------- #
    # -       Constructor       - #
    # --------------------------- #
    def __init__( self, filename = None,
                        name = None,
                        address_start = None,
                        address_end = None,
                        description = None,
                        registered_scanners = [] ):

        #  Set the internal parameters
        self.name                = name
        self.address_start       = address_start
        self.address_end         = address_end
        self.description         = description
        self.registered_scanners = registered_scanners

        # set the filename if provided
        if filename != None:
            self.filename = filename
            self.Read_Network_File()

    # --------------------------------------------- #
    # -        Read an LLNMS Network File         - #
    # --------------------------------------------- #
    def Read_Network_File(self):

        #  Make sure the path exists
        if os.path.exists(self.filename) != True:
            return

        # load the xml parser
        tree = ET.parse(self.filename)

        # get root
        root = tree.getroot()

        # get name
        self.name = root.find('name').text

        #  Get min and max address
        self.address_start = root.find('address-start').text
        self.address_end   = root.find('address-end').text

        #  Get the scanner id list
        scanners_node = root.find('scanners')
        if scanners_node is None:
            self.registered_scanners = []
            return

        #  Iterate over scanner nodes
        for scanner_node in scanners_node.findall('scanner'):

            #  Get the id
            id = scanner_node.find('id').text
            if id is None:
                continue

            #  Create node
            temp_arg = [id, []]

            #  Get all arguments
            args = scanner_node.findall('argument')
            for arg in args:

                #  Get the name and value
                argname = arg.get('name')
                argval  = arg.get('value')

                #  Make sure they exist
                if argname is not None:
                    temp_arg[1].append([argname, argval])

            #  Add to list
            self.registered_scanners.append(temp_arg)

    # ---------------------------------------- #
    # -        Write the Network File        - #
    # ---------------------------------------- #
    def Write_Network_File(self, filename = None):

        #  Check the filename
        if filename is not None:
            self.filename = filename

        # load the xml parser
        if os.path.exists(self.filename):
            tree = ET.parse(self.filename)
            root = tree.getroot()
        else:
            root = ET.Element('llnms-network')
            tree = ET.ElementTree(root)


        # set name
        name_node = root.find('name')
        if name_node is None:
            name_node = ET.SubElement(root, "name")
        name_node.text = self.name


        #  Get min and max address
        start_node = root.find('address-start')
        if start_node is None:
            start_node = ET.SubElement(root, 'address-start')
        start_node.text = self.address_start


        end_node = root.find('address-end')
        if end_node is None:
            end_node = ET.SubElement(root, 'address-end')
        end_node.text = self.address_end


        #  Get description node
        des_node = root.find('description')
        if des_node is None:
            des_node = ET.SubElement(root, 'description')
        des_node.text = self.description

        #  Get the scanner id list
        #scanners_node = root.find('scanners')
        #if scanners_node is None:
        #    self.registered_scanners = []
        #    return

        #  Iterate over scanner nodes
        #for scanner_node in scanners_node.findall('scanner'):

            #  Get the id
            #id = scanner_node.find('id').text
            #if id is None:
            #    continue

            #  Create node
            #temp_arg = [id, []]

            #  Get all arguments
            #args = scanner_node.findall('argument')
            #for arg in args:

                #  Get the name and value
                #argname = arg.get('name')
                #argval  = arg.get('value')

                #  Make sure they exist
                #if argname is not None:
                #    temp_arg[1].append([argname, argval])

            #  Add to list
            #self.registered_scanners.append(temp_arg)

        #  Indent the file
        XML_Utilities.XML_Indent(root)

        #  Write the file
        tree.write(self.filename)

    # --------------------------------------------------------------------------- #
    # -        Check if the network has a particular scanner registered         - #
    # --------------------------------------------------------------------------- #
    def Has_Scanner(self, scanner_id ):

        #  Iterate over scanners
        for scanner in self.registered_scanners:

            if scanner[0] == scanner_id:
                return True

        return False

    # ----------------------------------------------------------------- #
    # -        Retrieve the arguments for a particular scanner        - #
    # ----------------------------------------------------------------- #
    def Get_Scanner_Args(self, scanner_id ):

        #  Iterate over scanners
        for scanner in self.registered_scanners:

            if scanner[0] == scanner_id:
                return scanner[1]

        return []

    # ---------------------------------------------------------------------------- #
    # -       Return a list of networks specified within the network range       - #
    # ---------------------------------------------------------------------------- #
    def Get_Network_Range(self):

        #  Break up the network
        net_start_comps = [ int(x) for x in str(self.address_start).split('.')]
        net_end_comps   = [ int(x) for x in str(self.address_end).split('.')]

        #  Create output list
        output = []
        for item in itertools.product(range(net_start_comps[0], net_end_comps[0]+1),
                                      range(net_start_comps[1], net_end_comps[1]+1),
                                      range(net_start_comps[2], net_end_comps[2]+1),
                                      range(net_start_comps[3], net_end_comps[3]+1)):
            output.append(str(item[0]) + "." + str(item[1]) + "." + str(item[2]) + "." + str(item[3]))

        return output

    # ---------------------------------------------------------------------- #
    # -        Test if the network ip address is inside the network        - #
    # ---------------------------------------------------------------------- #
    def testNetworkHost( self, host_address ):

        #Break down the network
        net_beg_0 = int(str(self.address_start).split('.')[0])
        net_end_0 = int(str(self.address_end  ).split('.')[0])
        net_beg_1 = int(str(self.address_start).split('.')[1])
        net_end_1 = int(str(self.address_end  ).split('.')[1])
        net_beg_2 = int(str(self.address_start).split('.')[2])
        net_end_2 = int(str(self.address_end  ).split('.')[2])
        net_beg_3 = int(str(self.address_start).split('.')[3])
        net_end_3 = int(str(self.address_end  ).split('.')[3])

        host_0 = int(str(host_address).split('.')[0])
        host_1 = int(str(host_address).split('.')[1])
        host_2 = int(str(host_address).split('.')[2])
        host_3 = int(str(host_address).split('.')[3])

        if host_0 >= net_beg_0 and host_0 <= net_end_0:
            if host_1 >= net_beg_1 and host_1 <= net_end_1:
                if host_2 >= net_beg_2 and host_2 <= net_end_2:
                    if host_3 >= net_beg_3 and host_3 <= net_end_3:
                        return True
        return False

    # ---------------------------------------------- #
    # -       Check if the network is valid        - #
    # ---------------------------------------------- #
    def Is_Valid(self, print_error_msg=False):

        #  Make sure addresses are valid
        if Network_Utilities.Is_Valid_IP4_Address(self.address_start) is False:
            if print_error_msg is True:
                return False, 'Invalid Starting Address.'
            else:
                return False

        if Network_Utilities.Is_Valid_IP4_Address(self.address_end) is False:
            if print_error_msg is True:
                return False, 'Invalid Ending Address.'
            else:
                return False

        #  Check the range
        beg_comps = self.address_start.split('.')
        end_comps = self.address_end.split('.')

        #  Iterate over range
        if len(beg_comps) != 4 or len(end_comps) != 4:
            if print_error_msg is True:
                return False, 'The networks are not long enough.'
            else:    
                return False

        for x in xrange(0, len(beg_comps)):
            if end_comps[x] < beg_comps[x]:
                if print_error_msg is True:
                    return False, 'Starting network cannot be larger than the ending network.'
                else:
                    return False

        #  Otherwise, return valid
        if print_error_msg is True:
            return True, 'No errors.'
        else:
            return True

    # --------------------------------------- #
    # -       Print to a Debug String       - #
    # --------------------------------------- #
    def To_Debug_String(self):

        #  Print the output
        output  =  str(self.__class__) + '\n'
        output += '             Name : ' + self.name + '\n'
        output += '    Start Address : ' + self.address_start + '\n'
        output += '      End Address : ' + self.address_end + '\n'
        output += '\n'
        output += '     Registered Scanners : \n'
        for scanner in self.registered_scanners:
            output += '        ' + str(scanner) + '\n'

        return output

# ---------------------------------------------- #
# -     Load all Network Configuration Files   - #
# ---------------------------------------------- #
def llnms_load_networks( llnms_home ):

    #  make sure the directory exists
    network_files = glob.glob(llnms_home + "/networks/*.llnms-network.xml")
    logging.debug('Found ' + str(len(network_files)) + ' network files.')

    #  create our output
    outputNetworks = []

    # iterate through the files, loading each
    for network_file in network_files:
        outputNetworks += [Network(network_file)]

    #  Return list of networks
    return outputNetworks


# ------------------------------------------- #
# -      Query the network list for all     - #
# -      networks given an ip address       - #
# ------------------------------------------- #
def llnms_query_name_from_networks( network_list, ip_address ):

    for network in network_list:
        if network.testNetworkHost( ip_address ) == True:
            return network.getName()
    return "n/a"


# ------------------------------------------------ #
# -      Query the hostname from the hostname    - #
# -      list.                                   - #
# ------------------------------------------------ #
def find_network( network_name, llnms_home ):

    #  Get the list of networks
    network_list = llnms_load_networks(llnms_home)

    #  Iterate over networks
    for network_item in network_list:

        #  See if the network names match
        if network_item.name == network_name:
            return network_item

    #  Otherwise, return none
    return None


# --------------------------------------------------- #
# -       Add a network to the LLNMS system         - #
# --------------------------------------------------- #
def llnms_create_network( network, llnms_home ):

    #  Make the system call
    command = llnms_home + '/bin/' + 'llnms-create-network '
    command += ' -n ' + network.name
    command += ' -as ' + network.address_start
    command += ' -ae ' + network.address_end

    #   Call
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = p.communicate()
    logging.info("Command Executed: " + command + '\n  STDOUT: ' + out + '\n  STDERR: ' + err)


# --------------------------------------------------- #
# -      Remove a network to the LLNMS system       - #
# --------------------------------------------------- #
def llnms_remove_network( network, llnms_home ):

    #  Make the system call
    command = llnms_home + '/bin/' + 'llnms-remove-network '
    command += ' -n ' + network.name

    #   Call
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out, err = p.communicate()
    logging.info("Command Executed: " + command + '\n  STDOUT: ' + out + '\n  STDERR: ' + err)
