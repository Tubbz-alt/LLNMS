#!/usr/bin/env python
import curses
import CursesTable

#----------------------------------------#
#-    Print network summary header      -#
#----------------------------------------#
def print_network_summary_header( stdscr ):
	stdscr.addstr( 0, 0, 'LLNMS Network Summary')

	#  create bar
	bar = ""
	for x in range(curses.COLS-1):
		bar += '-';
	stdscr.addstr( 1, 0, bar);


#---------------------------------------#
#-     Print Network Summary Footer    -#
#---------------------------------------#
def print_network_summary_footer( stdscr ):
	
	#  create bar
	bar = ""
	for x in range(curses.COLS-1):
		bar += "-";
	stdscr.addstr( curses.LINES-3, 0, bar);
	
	stdscr.addstr( curses.LINES-2, 0, 'q) Return to main menu, r) Refresh')


#-----------------------------------------#
#-    Print the Network Summary Table    -#
#-----------------------------------------#
def print_network_summary_table( stdscr, llnms_state, rmin ):
	
	#  Create the table
	table = CursesTable.CursesTable( 5, 1 )
	
	#  Set the column headers
	table.setColumnHeaderItem( 0, 'IP-Address', 0.13)
	table.setColumnHeaderItem( 1, 'Hostname', 0.13)
	table.setColumnHeaderItem( 2, 'Network', 0.2)
	table.setColumnHeaderItem( 3, 'Responsive', 0.09 )
	table.setColumnHeaderItem( 4, 'Last Modified', 0.2)
	
	table.setColumnAlignment( 0, CursesTable.ALIGN_LEFT );
	table.setColumnAlignment( 1, CursesTable.ALIGN_LEFT );
	table.setColumnAlignment( 2, CursesTable.ALIGN_LEFT );
	table.setColumnAlignment( 3, CursesTable.ALIGN_MIDDLE );
	table.setColumnAlignment( 4, CursesTable.ALIGN_LEFT );

	#  Load the table
	for x in xrange( 0, len(llnms_state.network_status.network_assets)):
		
		#  Set the IP Address
		table.setItem( 0, x+1, llnms_state.network_status.network_assets[x].ip_address ); 
		
		#  Set the Hostname
		table.setItem( 1, x+1, llnms_state.network_status.network_assets[x].hostname );

		#  Set the group
		table.setItem( 2, x+1, llnms_state.network_status.network_assets[x].network_name );

		#  Set the Responsive Flag
		table.setItem( 3, x+1, str(llnms_state.network_status.network_assets[x].respond_ping) )

		#  Set the modified date
		table.setItem( 4, x+1, str(llnms_state.network_status.network_assets[x].date_scanned) )

	# Format the table
	table.formatTable( curses.COLS-1 )
	

	# print header row
	stdscr.addstr( rmin-1, 0, table.getRow(0));
	
	#  print bar
	bar = ""
	for x in range(curses.COLS-1):
		bar += "-";
	stdscr.addstr( rmin, 0, bar)

	# Print table rows
	for x in xrange(1, table.getRowCount()):
		stdscr.addstr( rmin+x, 0, table.getRow(x))



#------------------------------------------#
#-    Print the network summary window    -#
#------------------------------------------#
def view_network_summary( stdscr, llnms_state ):
	
	#  start the loop
	exit_network_summary_page = False
	while exit_network_summary_page == False:

		#  clear the screen
		stdscr.clear();

		#  Print the header
		print_network_summary_header(stdscr);

		#  Print the table
		print_network_summary_table(stdscr, llnms_state, 3 )

		#  Print the footer
		print_network_summary_footer(stdscr);

		#  grab the input
		stdscr.addstr( curses.LINES-1, 0, 'option:')
		stdscr.refresh();

		# get input
		c = stdscr.getch()
		
		#  If user wants to quit
		if c == ord('q'):
			exit_network_summary_page = True
		elif c == ord('r'):
			llnms_state.refresh_networks()


