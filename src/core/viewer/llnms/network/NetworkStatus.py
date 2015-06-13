#    File:    NetworkStatus.py
#    Date:    12/8/2013
#    Author:  Marvin Smith
#

#  LLNMS Libraries
import Network

#  Python Libraries
import os, xml.etree.ElementTree as et

bool_list = ['True', 'true','t',1]
def Bool_Value( value ):

    if value in bool_list:
        return True
    return False

# -------------------------------- #
# -      Network Host Class      - #
# -------------------------------- #
class NetworkHost:

    #  Hostname
    hostname = None

    #  IP Address
    ip_address = None

    #  Network Name
    network_name = None

    #  Status List
    status_list = []

    # ------------------------- #
    # -      Constructor      - #
    # ------------------------- #
    def __init__( self,
                  ip_address = None,
                  hostname   = None,
                  network_name = None,
                  status_list = None):

        # set the ip address
        if ip_address is not None:
            self.ip_address = ip_address

        # set the hostname
        if hostname is not None:
            self.hostname = hostname

        # set if responding to ping
        if status_list is not None:
            self.status_list = status_list

        # set the network name
        if network_name is not None:
            self.network_name = network_name



# ----------------------------------------- #
# -        Network Status Class           - #
# ----------------------------------------- #
class NetworkStatus:

    #  Network Assets
    network_assets = []


    # ---------------------------- #
    # -        Constructor       - #
    # ---------------------------- #
    def __init__(self, status_path, networks):

        #  set the base directory of the status path
        self.status_path = status_path

        #  set the filenames we are looking for
        self.status_file = status_path + '/run/llnms-network-status.xml'
        self.load_network_status(networks)

    # ---------------------------------------- #
    # -     Load the Network Status File     - #
    # ---------------------------------------- #
    def load_network_status(self, networks):

        # create an empty table of items
        self.network_assets = []

        #  Make sure the status file exists
        if os.path.exists(self.status_file) != True:
            return

         # load the xml parser
        tree = et.parse(self.status_file)

        # get root
        root = tree.getroot()

        # get all host nodes
        for host_node in root.findall('host'):

            #  Create the new node
            temp_host = NetworkHost()

            #  Get the host address
            address = host_node.get('ip4-address')
            if address is not None:
                temp_host.ip_address = address

            #  Get the status list
            status_list_node = host_node.find('status-log')

            #  Iterate over the status nodes
            for status_node in status_list_node.findall('status'):

                #  Get the responsiveness
                responsive = Bool_Value(status_node.get('responsive'))

                #  Get the timestamp
                timestamp = status_node.get('timestamp')

                if responsive is not None and timestamp is not None:
                    temp_host.status_list.append((timestamp, responsive))

            #  Add the node
            self.network_assets.append(temp_host)
