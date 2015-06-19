#    File:    ErrorWindow.py
#    Author:  Marvin Smith
#    Date:    6/18/2015
#
#    Purpose: Show the user an error.
#

__author__ = 'Marvin Smith'

#  LLNMS Libraries
import UI_Window_Base

#  Python Libraries
import curses

# ------------------------------ #
# -         Error Window       - #
# ------------------------------ #
class ErrorWindow(UI_Window_Base.Base_Window_Type):


    # ------------------------- #
    # -      Constructor      - #
    # ------------------------- #
    def __init__(self):

        #  Parent
        UI_Window_Base.Base_Window_Type.__init__(self)


    # --------------------- #
    # -      Process      - #
    # --------------------- #
    def Process( self, screen, error_message, details_message = '' ):

        #  Screen
        screen.clear()

        #  Create the error box
        self.Print_Error_Box(screen)

        #  Print window
        msg_x = max(curses.COLS/2 - (len(error_message)/2), 0)
        msg_y = max(curses.LINES/3, 0)
        screen.addstr( msg_y, msg_x, error_message, curses.color_pair(3) )

        #  Print Details
        msg_x = max(curses.COLS/2 - (len(details_message)/2), 0)
        msg_y = max(curses.LINES * 2 / 3, 0)
        screen.addstr( msg_y, msg_x, details_message, curses.color_pair(3))

        #  Refresh
        screen.refresh()

        #  Get the input
        c = screen.getch()

        if c == ord('y') or c == ord('Y'):
            return True
        else:
            return False


    # ------------------------------- #
    # -     Print the Error Box     - #
    # ------------------------------- #
    def Print_Error_Box(self, screen):

        #  Iterate over boundaries
        for x in xrange(0,4):
            screen.addstr( 4+x, 4, ' ' * (curses.COLS-8), curses.color_pair(2))
            screen.addstr( curses.LINES-8+x, 4, ' ' * (curses.COLS-8), curses.color_pair(2))

