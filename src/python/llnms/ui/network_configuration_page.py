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
        while self.exit_network_configuration_page == False :

            #  Clear the screen
            self.screen.clear()

            #  Print the header
            self.Render_Header()

            #  Print the network status window
            self.Render_Status_Window( llnms_state )

            #  Print the footer
            self.Render_Footer()

            #  grab the input
            self.screen.addstr( curses.LINES-1, 0, 'option:')
            self.screen.refresh()

             # get input
            c = self.screen.getch()

            if c == ord('q'):
                self.exit_network_configuration_page = True

        #  Return the update llnms state
        return llnms_state

    # ---------------------------------------- #
    # -    Print network summary header      - #
    # ---------------------------------------- #
    def Render_Header(self):

        #  Add the header
        self.screen.addstr( 0, 0, 'LLNMS Network Status')

        #  create bar
        bar = '-' * (curses.COLS-1)
        self.screen.addstr( 1, 0, bar)

    # --------------------------------------- #
    # -     Print Network Summary Footer    - #
    # --------------------------------------- #
    def Render_Footer(self):

        #  create header
        bar = '-' * (curses.COLS-1)
        self.screen.addstr( curses.LINES-3, 0, bar);

        #  Add text
        self.screen.addstr( curses.LINES-2, 0, 'q) Return to main menu')

    # ---------------------------------------- #
    # -      Render the Status Window        - #
    # ---------------------------------------- #
    def Render_Status_Window(self, llnms_state ):

        #  Create the table
        table = CursesTable.CursesTable( 5, 1 )

        #  Set the column headers
        table.Set_Column_Header_Item( 0, 'IP Address', 0.20)
        table.Set_Column_Header_Item( 1, 'Hostname',   0.20)
        table.Set_Column_Header_Item( 2, 'Network',    0.20)
        table.Set_Column_Header_Item( 3, 'Last Scan',  0.20)
        table.Set_Column_Header_Item( 4, 'Status',     0.20)

        table.Set_Column_Alignment( 0, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 1, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 2, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 3, CursesTable.StringAlignment.ALIGN_LEFT )
        table.Set_Column_Alignment( 4, CursesTable.StringAlignment.ALIGN_LEFT )



        #  Load the table
        for x in xrange( 0, len(llnms_state.network_status.network_assets)):

            #  Set the Name
            table.Set_Item( 0, x+1, llnms_state.network_status.network_assets[x].hostname )

            #  Set the start address
            table.Set_Item( 1, x+1, llnms_state.network_status.network_assets[x].ip_address )

            #  Set the end address
            table.Set_Item( 2, x+1, llnms_state.network_status.network_assets[x].network_name )


        #  Print the Table
        min_col = 2
        max_col = curses.COLS-1 - min_col

        table.Render_Table( self.screen,
                            min_col,
                            max_col,
                            5,
                            curses.LINES-4, -1)
