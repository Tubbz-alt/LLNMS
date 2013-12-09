

class NetworkHost:
	
	def __init__(self, ip_address, hostname, status, date_scanned ):
		
		# set the ip address
		self.ip_address = ip_address

		# set the hostname
		self.hostname = hostname

		# set if responding to ping
		self.respond_ping = status

		# set the date scanned
		self.date_scanned = date_scanned


class NetworkStatus:

	def __init__(self, status_path):
		
		#  set the base directory of the status path
		self.status_path = status_path

		#  set the filenames we are looking for
		self.status_file = status_path + '/llnms-network-status.txt'
		self.load_network_status()

	def load_network_status(self):
		
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
					hostname   = ''
					stat = line_parts[1]
					if stat == '1':
						status = True
					else:
						status = False
					date_scanned = line_parts[2]
					
					self.network_assets.append( NetworkHost( ip_address, hostname, status, date_scanned ));

