.. LLNMS documentation master file, created by
   sphinx-quickstart on Sun Jun  7 19:33:50 2015.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

LLNMS - Low-Level Network Management System
===========================================

LLNMS (Low-Level Network Management System) is a systems monitoring and analysis tool designed
to work with minimal infrastructure.  It is essentially a series of shell commands which when 
run together, allow for more comprehensive monitoring capabilities.  It seeks to build on the 
strengths of the Unix pipes and allow for simple (not necessarily easy) scripting.

Installation
============

Since LLNMS is meant to be low-level, it does not have a heavy-duty installation process.  The only current
requirement is xmlstarlet.  Hopefully, it will be removed with a pure Python XML utility.

To install, the ``llnms-installer.sh`` script is provided.  This will build, then install any software. 
See the :ref:`llnms_installer` page for more details.


Overview
========

LLNMS uses these as the core elements.

 - Assets
 - Networks
 - Scans
 - Tasks


Assets
______

Assets represent endpoints on a network.  Assets have characteristics such
as a hostname, ip address, and description.  You bind scans to assets 
as well as run tasks on them.  For more information on creating and
manipulating assets, see the :ref:`llnms_asset_main` page.

Assets are currently provided the following attributes

===========   =====================================
Attribute     Description
===========   =====================================
hostname      Name of the system.
ip4-address   Where on the network.
description   Description of the system or purpose.
===========   =====================================

In addition, assets can have scans and tasks registered to them.
This will be described later in further detail.  


Networks
--------

Networks represent a range of network addresses or locations.  Assets
may reside in a network and a network may detect many potential assets, 
some of which are not registered with LLNMS.  Networks currently have the following
characteristics.

============== ===================================
Attribute      Description
============== ===================================
name            Name of network for identification
address-start   Starting address for network
address-end     Ending address for network
============== ===================================


Scanners
---------

Scanners are technically a subset of llnms tasks, however they differ
in that they are not meant to modify the state of the system they are 
operating on.  Like tasks, scanners are essentially commands that are run
with a required and optional set of parameters. Due to the nature of operating
on the shell-scripting layer, scanners can have configurations
for different operating system, primarily Linux and Windows.



Tasks
------

Tasks are jobs that can be run both on the scanning system and potentially on assets.



Contents:


.. toctree::
   :maxdepth: 2
    
   llnms/Assets
   llnms/Commands


Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`

