#!/usr/bin/env python
import time, llnms, curses


#----------------------------------------------------------------#
#-    Print a response message acknowledging, then returning    -#
#----------------------------------------------------------------#
def print_response_message( stdscr, message ):

	#  Print a basic message telling the user you got their response
	stdscr.clear()
	stdscr.addstr(curses.LINES/2, curses.COLS/2-(len(message)/2), message);
	stdscr.refresh();
	time.sleep(1)


#-------------------------#
#-      Main Function    -#
#-------------------------#
def main(stdscr):
	
	#  grab the current context
	llnms_state = llnms.LLNMS()
	
	# start the main loop
	exit_main_loop = False
	while exit_main_loop == False:
		
		#  clear the screen
		stdscr.clear()

		#  Print the main menu
		stdscr.addstr(0, 0, 'LLNMS-Viewer Main Menu')
		stdscr.addstr(1, 0, '----------------------')
		stdscr.addstr(2, 0, '1.  Network Summary')
		stdscr.addstr(3, 0, '2.  Network Configuration')
		stdscr.addstr(4, 0, 'q.  Quit LLNMS-Viewer')
		stdscr.addstr(5, 0, 'option:')
		stdscr.refresh();

		# get input
		c = stdscr.getch()
		
		#  Check if user wants to quit
		if c == ord('q'):
			print_response_message( stdscr, 'Quitting LLNMS');
			exit_main_loop = True
		
		# check if user wants to view the network summary
		elif c == ord('1'):
			
			#  Print a basic message telling the user you got their response
			print_response_message( stdscr, 'Loading Network Summary Page');

			#  open network summary page
			llnms.ui.view_network_summary( stdscr, llnms_state )
		
		# check if user wants to view the network configuration page
		elif c == ord('2'):
			
			#  Print a basic message telling the user you got their response
			print_response_message( stdscr, 'Loading Network Configuration Page');

			#  open network summary page
			llnms.ui.view_network_configuration( stdscr, llnms_state )

	#  close the logger
	llnms_state.logger.writeLogFile();

#---------------------------------------------------------------#
#-   If the script is called from the cmdline, execute this    -#
#---------------------------------------------------------------#
if __name__ == "__main__":
	
	#  Call the curses wrapper
	curses.wrapper(main)
	
