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
	
	
	#----------------------------------------------------------------------#
	#-        Test if the network ip address is inside the network        -#
	#----------------------------------------------------------------------#
	def testNetworkHost( self, host_address ):
		
		# iterate through network definitions
		for network_def in self.network_definitions:
			
			if network_def.getType() == "SINGLE":
				if network_def.address == host_address:
					return True;

			elif network_def.getType() == "RANGE":
				
				#Break down the network 
				net_beg_0 = int(str(network_def.address_start).split('.')[0])
				net_end_0 = int(str(network_def.address_end  ).split('.')[0])
				net_beg_1 = int(str(network_def.address_start).split('.')[1])
				net_end_1 = int(str(network_def.address_end  ).split('.')[1])
				net_beg_2 = int(str(network_def.address_start).split('.')[2])
				net_end_2 = int(str(network_def.address_end  ).split('.')[2])
				net_beg_3 = int(str(network_def.address_start).split('.')[3])
				net_end_3 = int(str(network_def.address_end  ).split('.')[3])

				host_0 = int(str(host_address).split('.')[0])
				host_1 = int(str(host_address).split('.')[1])
				host_2 = int(str(host_address).split('.')[2])
				host_3 = int(str(host_address).split('.')[3])

				if host_0 >= net_beg_0 and host_0 <= net_end_0:
					if host_1 >= net_beg_1 and host_1 <= net_end_1:
						if host_2 >= net_beg_2 and host_2 <= net_end_2:
							if host_3 >= net_beg_3 and host_3 <= net_end_3:
								return True;

		return False;

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


#-------------------------------------------#
#-      Query the network list for all     -#
#-      networks given an ip address       -#  
#-------------------------------------------#
def llnms_query_name_from_networks( network_list, ip_address ):
	
	for network in network_list:
		if network.testNetworkHost( ip_address ) == True:
			return network.getName()
	return "n/a"


#------------------------------------------------#
#-      Query the hostname from the hostname    -#
#-      list.                                   -#
#------------------------------------------------#
def llnms_query_hostname( ip_address ):
	
	# Open the hostname resolution list
	return ''



