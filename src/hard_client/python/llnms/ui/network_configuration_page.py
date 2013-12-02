#!/bin/bash
import curses


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
#-     Compute the Column Widths in the Table    -#
#-------------------------------------------------#
def computeTableColumnWidths( llnms_state ):	
	
	#  First compute the max name width
	maxName = 0
	for net in llnms_state.networks:
		if maxName < len(net.getName()):
			maxName = len(net.getName());
	
	#  Create the column for the name in the header
	return maxName


#-------------------------------------------------#
#-     Print the network configuration row       -#
#-------------------------------------------------#
def print_header_row( stdscr, minrow, maxName ):

	maxX = curses.COLS-1

	# compute line to print
	x0_start = 0
	x0_end   = max( curses.COLS/3, maxName )
	x1_start = x0_end + 1
	x1_end   = x1_start + min(curses.COLS/4, 10)
	x2_start = x1_end + 1
	x2_end   = maxX
	
	# print name
	title = "Name"
	x0_line_start = max( x0_start+1, ((x0_end - x0_start)/2)+x0_start-(len(title)/2))
	x0_line_end   = min( x0_end    , ((x0_end - x0_start)/2)+x0_start+(len(title)/2))
	x0_title_len  = min( len(title), x0_line_end - x0_line_start)

	data = "|"
	for x in xrange( x0_start+1, x0_line_start):
		data += " ";
	data += title[0:x0_title_len]
	for x in xrange( x0_line_end, x0_end ):
		data += ' ';
	data += "|"

	# print type
	title = "Type"
	x1_line_start = max( x1_start+1, ((x1_end - x1_start)/2)+x1_start-(len(title)/2))
	x1_line_end   = min( x1_end    , ((x1_end - x1_start)/2)+x1_start+(len(title)/2))
	x1_title_len  = min( len(title), x1_line_end - x1_line_start)

	for x in xrange( x1_start+1, x1_line_start):
		data += " ";
	data += title[0:x1_title_len]
	for x in xrange( x1_line_end, x1_end ):
		data += ' ';
	data += "|"

	# print addresses
	title = "Address Range"
	x2_line_start = max( x2_start+1, ((x2_end - x2_start)/2)+x2_start-(len(title)/2))
	x2_line_end   = min( x2_end    , ((x2_end - x2_start)/2)+x2_start+(len(title)/2))
	x2_title_len  = min( len(title), x2_line_end - x2_line_start + 1)

	for x in xrange( x2_start+1, x2_line_start):
		data += " ";
	data += title[0:x2_title_len]
	for x in xrange( x2_line_end, x2_end ):
		data += ' ';
	data += "|"
	
	#  create blank line
	line = ''
	for x in range(curses.COLS-1):
		line += '-'


	#  print line
	stdscr.addstr( minrow, 0, data )
	stdscr.addstr( minrow+1, 0, line )
	
	return [(x0_start, x0_end), (x1_start, x1_end), (x2_start, x2_end)];


#------------------------------------#
#-        Print the actual row      -#
#------------------------------------#
def print_row( stdscr, row, ranges, name ):
	
	#  create our line to print
	data = '|'

	# Print the name
	x0_start      = ranges[0][0]+1
	x0_line_start = ((ranges[0][1]-ranges[0][0])/2)+x0_start-(len(name)/2)-1;
	x0_end        = ranges[0][1]

	nameCnt = 0
	for x in xrange( x0_start, x0_end ):

		#  if we havent hit the name yet, then just ignore
		if x < x0_line_start:
			data += ' '
		#  if we have hit the name, then add chars
		elif x < (x0_line_start + len(name)):
			data += name[nameCnt]
			nameCnt += 1
		else:
			data += ' '
	data += '|'

	# print the string
	stdscr.addstr( row, 0, data );

#-------------------------------------------------#
#-     Print the network configuration table     -#
#-------------------------------------------------#
def print_network_configuration_table( stdscr, llnms_state, rmin, rmax, networkIdxStart ):

	# Compute the sizes of the various columns
	maxName = computeTableColumnWidths( llnms_state )
	
	# Compute the network index ranges
	netIdxMin = networkIdxStart
	netIdxMax = len(llnms_state.networks)-netIdxMin;

	# Print the header row
	ranges = print_header_row( stdscr, rmin, maxName )

	# start printing actual networks
	rowCnt = 0
	for x in xrange( netIdxMin, netIdxMax ):

		#  Find the number of network definitions
		maxRowSize = max( 1, len(llnms_state.networks[x].getNetworkDefinitions()))
		
		#  print the top row
		print_row( stdscr, rmin+2+rowCnt, ranges, llnms_state.networks[x].getName() )
		
		# increment the row
		rowCnt = rowCnt + 1
		
		# print subsequent rows
		for y in xrange( 0, maxRowSize-1):
			print_row( stdscr, rmin+2+rowCnt, ranges, ' ');
			rowCnt+=1

	

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
		


