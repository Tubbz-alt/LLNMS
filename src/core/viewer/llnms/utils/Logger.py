#!/usr/bin/env python

#  Python Libraries
import logging

# ---------------------------------------------- #
# -       Initialize the Logging Module        - #
# ---------------------------------------------- #
def Initialize_Logging( log_file, log_level = logging.INFO ):

    #  Create the logger
    FORMAT = '%(asctime)-15s %(message)s'

    #  Configure the logger
    logging.basicConfig(format=FORMAT,
                        filename=log_file,
                        filemode='w',
                        level=logging.DEBUG)

    logging.info('logging initialized.')
