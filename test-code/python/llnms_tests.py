#!/usr/bin/env python
import time, llnms, curses


print('LLNMS Test Functions')

llnms_state = llnms.LLNMS()


ADDRESSES=["192.168.0.10","192.168.0.30","192.168.0.31"]

for ADDRESS in ADDRESSES:
	print("      ADDRESS: " + ADDRESS )
	print("-------------------------------");

	for network in llnms_state.networks:

		if network.testNetworkHost(ADDRESS) == True:
			print("Network (" + network.getName() + ") contains " + ADDRESS)
		else:	
			print("Network (" + network.getName() + ") does not contain " + ADDRESS)

