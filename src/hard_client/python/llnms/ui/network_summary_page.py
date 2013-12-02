#!/usr/bin/env python
import curses

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
	
	stdscr.addstr( curses.LINES-2, 0, 'q) Return to main menu')


#-----------------------------------------#
#-    Print the Network Summary Table    -#
#-----------------------------------------#
def print_network_summary_table( stdscr, llnms_state, rmin ):
	
	for x in xrange( 0, len(llnms_state.network_status.network_assets)):
		stdscr.addstr( rmin + x, 0, llnms_state.network_status.network_assets[x])


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
		
		if c == ord('q'):
			exit_network_summary_page = True
		


