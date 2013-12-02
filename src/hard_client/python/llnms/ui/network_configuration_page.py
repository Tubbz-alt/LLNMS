#!/bin/bash
import curses
import CursesTable 

#----------------------------------------#
#-    Print network summary header      -#
#----------------------------------------#
def print_network_configuration_header( stdscr ):
	stdscr.addstr( 0, 0, 'LLNMS Network Configuration')

	#  create bar
	bar = ""
	for x in range(curses.COLS-1):
		bar += '-';
	stdscr.addstr( 1, 0, bar);


#---------------------------------------#
#-     Print Network Summary Footer    -#
#---------------------------------------#
def print_network_configuration_footer( stdscr ):
	
	#  create bar
	bar = ""
	for x in range(curses.COLS-1):
		bar += "-";
	stdscr.addstr( curses.LINES-3, 0, bar);
	
	stdscr.addstr( curses.LINES-2, 0, 'q) Return to main menu')


#-------------------------------------------------#
#-     Print the network configuration table     -#
#-------------------------------------------------#
def print_network_configuration_table( stdscr, llnms_state, rmin, rmax, networkIdxStart ):
	
	#  create the full 2d table of values
	table = CursesTable.CursesTable( 3, 1 )

	# set the table data
	table.setColumnHeaderItem( 0, 'Name', 0.3)
	table.setColumnHeaderItem( 1, 'Type', 0.2)
	table.setColumnHeaderItem( 2, 'Address Range', 0.5)

	# add each network
	currentRow = 1
	for x in xrange( 0, len(llnms_state.networks)):
		
		# add the table name
		table.setItem( 0, currentRow, llnms_state.networks[x].getName())

		# add each type and range
		for y in xrange( 0, len(llnms_state.networks[x].getNetworkDefinitions())):
			table.setItem( 1, currentRow + y, llnms_state.networks[x].getNetworkDefinitions()[y].getType())
			table.setItem( 2, currentRow + y, llnms_state.networks[x].getNetworkDefinitions()[y].getAddressStr())
		currentRow += len(llnms_state.networks[x].getNetworkDefinitions()) + 1


		

	# Format the table
	table.formatTable( curses.COLS-1 )

	# print header row
	stdscr.addstr( rmin, 0, table.getRow(0));

	#  print bar
	bar = ""
	for x in range(curses.COLS-1):
		bar += "-";
	stdscr.addstr( rmin+1, 0, bar)

	# Print table rows
	for x in xrange(1, table.getRowCount()):
		stdscr.addstr( rmin+1+x, 0, table.getRow(x))

	

#------------------------------------------#
#-    Print the network summary window    -#
#------------------------------------------#
def view_network_configuration( stdscr, llnms_state ):
	
	#  start the loop
	exit_network_configuration_page = False
	while exit_network_configuration_page == False:

		#  clear the screen
		stdscr.clear();

		#  Print the header
		print_network_configuration_header(stdscr);

		#  Print the table
		print_network_configuration_table( stdscr, llnms_state, 2, -3, 0 );

		#  Print the footer
		print_network_configuration_footer(stdscr);

		#  grab the input
		stdscr.addstr( curses.LINES-1, 0, 'option:')
		stdscr.refresh();

		# get input
		c = stdscr.getch()
		
		if c == ord('q'):
			exit_network_configuration_page = True
		


