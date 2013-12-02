#!/usr/bin/env python
import xml.etree.ElementTree as ET, glob
from xml.etree.ElementTree import Element, SubElement


class NetworkDefinition:
	
	def __init__(self, networkType, addressStart, addressEnd ):
		
		self.networkType = networkType

		if networkType == "SINGLE":
			self.address = addressStart
		else:
			self.address_start = addressStart
			self.address_end   = addressEnd
	

	def getType(self):
		return self.networkType
	
	def getAddress(self):
		
		if self.networkType == "SINGLE":
			return [self.address];
		else:
			return [self.address_start, self.address_end];


class Network:
	
	def __init__(self, filename):
		
		# set the filename
		self.filename = filename
	
		# load the xml parser
		tree = ET.parse(filename);
		
		# get root
		root = tree.getroot()
		
		# get name
		self.setName( root.find('name').text );

		# get each sub network
		self.network_definitions = []
		for network in root.findall('network'):
			
			# get type
			tp = network.find('type').text
			
			self.addNetworkDefinition( tp, '127.0.0.1', '')




	#----------------------------------#
	#-      Get the Network Name      -#
	#----------------------------------#
	def getName(self):
		return self.name

	#----------------------------------#
	#-      Set the Network Name      -#
	#----------------------------------#
	def setName( self, name ):
		self.name = name;


	#------------------------------------------------#
	#-     Get the list of network definitions      -#
	#------------------------------------------------#
	def getNetworkDefinitions( self ):
		return self.network_definitions


	#----------------------------------------------#
	#-    Add a network definition to the list    -#
	#----------------------------------------------#
	def addNetworkDefinition( self, netType, addressStart, addressEnd):
		
		self.network_definitions.append(NetworkDefinition(netType, addressStart, addressEnd ));

		


#----------------------------------------------#
#-     Load all Network Configuration Files   -#
#----------------------------------------------#
def llnms_load_networks( path, logger ):

	#  make sure the directory exists
	network_files = glob.glob(path + "/*.llnms-network.xml")

	#  create our output
	outputNetworks = []

	# iterate through the files, loading each
	for network_file in network_files:
		
		#  Create temporary network
		temp_network = Network(network_file)


		outputNetworks.append(temp_network)


	return outputNetworks




