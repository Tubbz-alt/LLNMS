#!/usr/bin/env python

#  XML Parsing Libraries
import xml.etree.ElementTree as ET, glob
from xml.etree.ElementTree import Element, SubElement

#  System Libraries
import logging, os, subprocess


class Network:

    #  Network Name
    name = ''

    #  Starting address
    address_start = ''

    #  End address
    address_end = ''

    # --------------------------- #
    # -       Constructor       - #
    # --------------------------- #
    def __init__(self, filename = None ):

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
# -     Load all Network Configuration Files   - #
# ---------------------------------------------- #
def llnms_load_networks( path ):

    #  make sure the directory exists
    network_files = glob.glob(path + "/*.llnms-network.xml")
    logging.debug('Found ' + str(len(network_files)) + ' network files.')

    #  create our output
    outputNetworks = []

    # iterate through the files, loading each
    for network_file in network_files:

        #  Create temporary network
        temp_network = Network(network_file)

        outputNetworks.append(temp_network)

        #  Log
        logging.debug('Loaded network file: ' + network_file)

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
def llnms_query_hostname( ip_address ):

    # Open the hostname resolution list
    return ''


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
