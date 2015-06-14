.. _llnms_network_main:

LLNMS Networks
==============

Networks represent a range of endpoints on a network.  The endpoints 
may or may not be registered assets.

.. _llnms_create_network_def:

llnms-create-network
--------------------

    Create an LLNMS Network.

.. topic:: -h --help

    Print usage options and exit.

.. topic:: -v --version

    Print LLNMS version information.

.. topic:: -i --interactive

    Run create network in interactive mode.

.. topic:: -o [output path]

    Save the LLNMS network to the specified output path. Otherwise,
    a default path will be generated.

.. topic:: -n --name [new-name]

    Set the name of the new network.

.. topic:: -as --address-start [address]

    Set the starting address of the network.

.. topic:: -ae --address-end [address]

    Set the ending address of the network.


.. _llnms-list-networks-def:

llnms-list-networks
-------------------

List the registered LLNMS networks.

.. _llnms-print-network-info-def:

llnms-print-network-info
------------------------

Print info about LLNMS networks.


llnms-register-network-scanner
------------------------------

Bind a scanner which has been registered with LLNMS with the network.  It will
enable the scanner to be run via ``llnms-scan-network``.

.. topic:: -h --help

    Print help / usage information.

.. topic:: -v --version

    Print version information.

.. topic:: -n --network [network-name]

    Select the network to scan.

.. topic:: -s --scanner [scanner-id]

    Select the scanner by its id.

.. topic:: -p --parameter [key] [value]

    Override an argument for the scanner.

.. _llnms-remove-network-def:

llnms-remove-network
---------------------

Remove an LLNMS network.


.. _llnms-scan-network-def:

llnms-scan-network
------------------

Scan the LLNMS network.

