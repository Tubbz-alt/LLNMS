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

	def getAddressStr(self):
		
		aRange = self.getAddress()
		output = ""
		
		if len(aRange) > 0:
			output += aRange[0]
		if len(aRange) > 1:
			output += ' - ' +  aRange[1]
		return output

class Network:
	
	def __init__(self, filename):
		
		# set the filename
		self.filename = filename
	
		# load the xml parser
		tree = ET.parse(filename);
		
		# get root
		root = tree.getroot()
		networks = root.find('networks')

		# get name
		self.setName( root.find('name').text );

		# get each sub network
		self.network_definitions = []
		for network in networks.findall('network'):
			
			# get type
			tp = network.find('type').text
			
			if tp == "SINGLE":
				address = network.find('address').text
				self.addNetworkDefinition( tp, address, '' )
			else:
				address_start = network.find('address-start').text
				address_end   = network.find('address-end').text
				self.addNetworkDefinition( tp, address_start, address_end)




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




