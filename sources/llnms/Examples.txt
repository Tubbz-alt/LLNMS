.. _llnms_examples:
    

LLNMS Examples
==============


Setting up a Home Network
--------------------------

This first part will show you the basic steps to getting a basic LLNMS setup 
for a home network. 

Define Authorized Systems
^^^^^^^^^^^^^^^^^^^^^^^^^

Given a typical home network with the network range of say ``192.168.1.1`` to ``192.168.1.254``, 
first define the network and its key assets.::

    #  Create the network
    llnms-create-network -n "Home Network" -as 192.168.1.1 -ae 192.168.1.254

    #  Create an asset for the router
    llnms-create-asset -host my-router -ip4 192.168.1.1 -d 'Home router'
    
    #  Create an asset for ourselves
    llnms-create-asset -host me  -ip4 192.168.1.8 -d 'My laptop'


Register Scanners with LLNMS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Now that there is a network with a few registered systems, now scanners should be created
and attached to LLNMS networks and assets.

