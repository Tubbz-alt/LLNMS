

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
				
				self.network_assets.append(line)

	

