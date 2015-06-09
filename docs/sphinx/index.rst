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

