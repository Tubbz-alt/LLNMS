#!/bin/bash

#  Python Libraries
import curses

#  LLNMS Libraries
import CursesTable 

# ---------------------------------------- #
# -     Network Configuration Window     - #
# ---------------------------------------- #
class NetworkConfigurationWindow(object):

    #  Default screen
    screen = None

    #  LLNMS State
    llnms_state = None

    #  Exit Network Configuration Flag
    exit_network_configuration_page = False

    # -------------------------- #
    # -      Constructor       - #
    # -------------------------- #
    def __init__(self, screen ):

        #  Set the screen
        self.screen = screen

    # ------------------------------------ #
    # -      Print Network Summary       - #
    # ------------------------------------ #
    def Process(self, llnms_state):

        #  Set the flag
        self.exit_network_configuration_page = False
        while self.exit_network_configuration_page == True :

            #  Clear the screen
            self.screen.clear()

            #  Print the header
            self.Render_Header()

            #  Print the table
            self.Render_Network_Configuration_Table( llnms_state, 2, -3, 0 );

            #  Print the footer
            self.Render_Footer();

            #  grab the input
            self.screen.addstr( curses.LINES-1, 0, 'option:')
            self.screen.refresh();

             # get input
            c = self.screen.getch()

            if c == ord('q'):
                exit_network_configuration_page = True


        #  Return the update llnms state
        return llnms_state


    # ---------------------------------------- #
    # -    Print network summary header      - #
    # ---------------------------------------- #
    def Render_Header(self):

        #  Add the header
        self.screen.addstr( 0, 0, 'LLNMS Network Configuration')

        #  create bar
        bar = [ ' ' for x in curses.COLS-1]
        self.addstr( 1, 0, bar)


    # --------------------------------------- #
    # -     Print Network Summary Footer    - #
    # --------------------------------------- #
    def Render_Footer(self):

        #  create header
        bar = [ ' ' for x in range(curses.COLS-1)]
        self.screen.addstr( curses.LINES-3, 0, bar);

        #  Add text
        self.screen.addstr( curses.LINES-2, 0, 'q) Return to main menu')


    # ------------------------------------------------- #
    # -     Print the network configuration table     - #
    # ------------------------------------------------- #
    def Render_Network_Configuration_Table( self, llnms_state, min_row, max_row, networkIdxStart ):

        #  create the full 2d table of values
        table = CursesTable.CursesTable( 3, 1 )

        # set the table data
        table.setColumnHeaderItem( 0, 'Name', 0.3)
        table.setColumnHeaderItem( 1, 'Type', 0.1)
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

            #  Add the horizontal bar
            table.setHorizontalBar( currentRow + len(llnms_state.networks[x].getNetworkDefinitions()))

            currentRow += len(llnms_state.networks[x].getNetworkDefinitions()) + 1

        # Format the table
        table.formatTable( curses.COLS-1 )

        # print header row
        self.screen.addstr( min_row, 0, table.getRow(0));

        #  print bar
        bar = [ ' ' for x in range(curses.COLS - 1)]
        self.screen.addstr( min_row+1, 0, bar)

        # Print table rows
        for x in xrange(1, table.getRowCount()):
            self.screen.addstr( min_row+1+x, 0, table.getRow(x))
        self.screen.addstr( min_row+1+table.getRowCount(), 0,  table.getBlankRow())
