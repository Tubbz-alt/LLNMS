#!/usr/bin/env python
import xml.etree.ElementTree as ET, glob
from xml.etree.ElementTree import Element, SubElement

netfiles = glob.glob("/var/tmp/llnms/networks/*.llnms-network.xml")

cnt = 0
for netfile in netfiles:

	print('File '+str(cnt))
	cnt += 1

	# load the xml parser
	tree = ET.parse(netfile);

	# get root
	root = tree.getroot()

	# get name
	print( 'Name=' + root.find('name').text )

	# get the network
	networks = root.find('networks')

	# get each sub network
	for network in networks.findall('network'):
	
		print('Type=' + network.find('type').text)

