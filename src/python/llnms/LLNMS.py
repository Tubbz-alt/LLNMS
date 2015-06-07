#!/usr/bin/env python
import network
from utils import Logger
import logging

# ------------------------------------------------------------------------------ #
# -   Global class which contains most if not all relevant LLNMS information   - #
# ------------------------------------------------------------------------------ #
class LLNMS:
    """
    LLNMS Global Manager
    """

    #  Default LLNMS Home
    LLNMS_HOME="/var/tmp/llnms"

    # List of networks
    networks = []

    # List of assets
    assets = []

    # -------------------------------- #
    # -          Constructor         - #
    # -------------------------------- #
    def __init__(self):

        #  Initialize Logging
        Logger.Initialize_Logging( self.LLNMS_HOME + '/log/llnms-viewer.log',
                                   logging.DEBUG)

        # load the network list
        network_path = self.LLNMS_HOME + "/networks"
        self.networks = network.llnms_load_networks( network_path)
        logging.info('Networks loaded from ' + network_path )

        # load the scanning list
        status_path = self.LLNMS_HOME + "/run"
        self.network_status = network.NetworkStatus(status_path, self.networks )
        logging.info('Network Status Loaded')

    # ----------------------------------------- #
    # -       Refresh the network list        - #
    # ----------------------------------------- #
    def Reload_Networks(self):

        network_path = self.LLNMS_HOME + "/networks"
        self.networks = network.llnms_load_networks( network_path)
        logging.info('Networks loaded from ' + network_path )

    # -------------------------- #
    # -       Add network      - #
    # -------------------------- #
    def Add_Network(self, new_network):

        #  Add the network file
        network.llnms_create_network(new_network, self.LLNMS_HOME)
        logging.info('Reloading networks.')

        #  Reload the network
        self.Reload_Networks()

    # ----------------------------- #
    # -      Remove Network       - #
    # ----------------------------- #
    def Remove_Network(self, rm_network ):

        logging.info('Removing network.')
        network.llnms_remove_network(rm_network, self.LLNMS_HOME)
        self.Reload_Networks()
