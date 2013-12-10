import Network

#--------------------------------#
#-      Network Host Class      -#
#--------------------------------#
class NetworkHost:
	
	def __init__(self, ip_address, hostname, network_name, status, date_scanned ):
		
		# set the ip address
		self.ip_address = ip_address

		# set the hostname
		self.hostname = hostname

		# set if responding to ping
		self.respond_ping = status

		# set the network name
		self.network_name = network_name

		# set the date scanned
		self.date_scanned = date_scanned


#-----------------------------------------#
#-        Network Status Class           -#
#-----------------------------------------#
class NetworkStatus:

	def __init__(self, status_path, networks):
		
		#  set the base directory of the status path
		self.status_path = status_path

		#  set the filenames we are looking for
		self.status_file = status_path + '/llnms-network-status.txt'
		self.load_network_status(networks)


	def load_network_status(self, networks):
		
		# create an empty table of items
		self.network_assets = []

		# open the status file
		status_file = open(self.status_file, 'r')

		# iterate through each line
		for line in status_file:

			# Make sure the line does not start with a pound and has data
			if line.strip()[0] != '#' and len(line.strip()) > 0:
				
				# split the line into parts
				line_parts = line.strip().split()

				if len(line_parts) >= 3:

					ip_address = line_parts[0]
					hostname   = Network.llnms_query_hostname( ip_address )
					stat = line_parts[1]
					if stat == '1':
						status = True
					else:
						status = False
					date_scanned = line_parts[2]
					network_name = Network.llnms_query_name_from_networks( networks, ip_address )
					
					self.network_assets.append( NetworkHost( ip_address, hostname, network_name, status, date_scanned ));
	
	
	def reload_network_status( self, networks):
		
		# open the status file
		status_file = open( self.status_file, 'r')

		# iterate through each line
		for line in status_file:
				
			# make sure the line is not a comment and has information
			if line.strip()[0] != '#' and len(line.strip()) > 0:
				
				line_parts = line.strip().split()

				if len(line_parts) >= 3:
					
					ip_address = line_parts[0]
					hostname   = Network.llnms_query_hostname( ip_address )
					stat = line_parts[1]
					if stat == '1':
						status = True
					else:
						status = False
					date_scanned = line_parts[2]
					network_name = Network.llnms_query_name_from_networks( networks, ip_address )
					
					tempHost = NetworkHost( ip_address, hostname, network_name, status, date_scanned);

					# Check if ip_address is already in host list
					for asset in self.network_assets:
						if asset.ip_address == tempHost.ip_address:
							asset.respond_ping = tempHost.respond_ping
							asset.date_scanned = tempHost.date_scanned
							break;


