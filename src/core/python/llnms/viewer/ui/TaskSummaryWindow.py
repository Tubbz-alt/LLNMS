#    File:    TaskSummaryWindow.py
#    Author:  Marvin Smith
#    Date:    6/21/2015
#
#    Purpose: Show existing task scripts
#
__author__ = 'Marvin Smith'


#  Python Libraries
import logging, curses

#  LLNMS Libraries
from UI_Window_Base import *
import CursesTable


# --------------------------------------- #
# -      Task Summary Window Class      - #
# --------------------------------------- #
class TaskSummaryWindow(Base_Window_Type):

    #  Exit Window Flag
    exit_window = False

    # --------------------------- #
    # -      Constructor        - #
    # --------------------------- #
    def __init__(self, title=None, screen = None):

        #  Build parent
        Base_Window_Type.__init__(self,title = "Task Summary Window", screen = screen)

        logging.info('End of ' + str(self.__class__.__name__) + " constructor")

    # -------------------------------- #
    # -      Process the Window      - #
    # -------------------------------- #
    def Process(self, llnms_state ):

        #  Set the run flag
        self.exit_window = False

        #  Run until exit
        while self.exit_window is not True:

            #  Clear the screen
            self.screen.clear()

            #  Print the header
            self.Render_Header()

            #  Render the Main Content
            self.Render_Main_Content(llnms_state)

            #  Render the Footer
            self.Render_Footer()

            #  Refresh the screen
            self.screen.addstr( curses.LINES-1, 0, 'option:')
            self.screen.refresh()

            #  Process Input
            c = self.screen.getch()

            #  Check if quit was requested
            if c == ord('q'):
                self.exit_window = True

            #

        #  Return the state
        return llnms_state


    # ----------------------------- #
    # -     Render the Footer     - #
    # ----------------------------- #
    def Render_Footer(self):

        #  Define the max row
        max_row = curses.LINES - 1

        #  Print the footer
        self.screen.addstr(max_row-2, 0, '-' * (curses.COLS-1))
        self.screen.addstr(max_row-1, 0, 'q) Back to main menu.')


    # ----------------------------------- #
    # -     Render the Main Content     - #
    # ----------------------------------- #
    def Render_Main_Content(self, llnms_state):

        #  Get the scanner list
        tasks = llnms_state.registered_task_list

        #  Create the table
        table = CursesTable.CursesTable(cols=3, rows=1)

        #  Set the header items
        table.Set_Column_Header_Item(0, 'ID', 0.1)
        table.Set_Column_Header_Item(1, 'Name', 0.15)
        table.Set_Column_Header_Item(2, 'Description', 0.4)

        #  Set the alignments
        table.Set_Column_Alignment(0, CursesTable.StringAlignment.ALIGN_LEFT)
        table.Set_Column_Alignment(1, CursesTable.StringAlignment.ALIGN_LEFT)
        table.Set_Column_Alignment(2, CursesTable.StringAlignment.ALIGN_LEFT)

        #  Set the data
        counter=1
        for x in xrange(0, len(tasks)):

            # Set the id
            table.Set_Item( 0, counter, tasks[x].id)

            #  Set the name
            table.Set_Item( 1, counter, tasks[x].name)

            #  Set the description
            table.Set_Item( 2, counter, tasks[x].description)

            #  Increment the counter
            counter += 1

        #  Print the Table
        min_col = 2
        max_col = curses.COLS-1 - min_col
        min_print_row = 5

        table.Render_Table( self.screen,
                            min_col,
                            max_col,
                            min_print_row,
                            curses.LINES-5,
                            self.current_field+1)

    # -------------------------------------------------- #
    # -    Command for externally closing the window   - #
    # -------------------------------------------------- #
    def Close_Window(self):
        self.exit_window = True