#!/usr/bin/env python

#  Python Libraries
import curses, math

#  Curses Utility Enums
class StringAlignment:
    ALIGN_LEFT   = 0
    ALIGN_MIDDLE = 1

# --------------------------- #
# -     Format a String     - #
# --------------------------- #
def Format_String( data, max_length, alignment = StringAlignment.ALIGN_LEFT, padding_char = ' '):

    #  Build substr
    outdata = data[0:min(len(data),max_length)]

    #  Compute Padding Amount
    pad_width = max_length - (min(len(data),max_length))

    #  If left alignment
    if alignment == StringAlignment.ALIGN_LEFT:
        return outdata + (padding_char * pad_width)

    #  If right alignment
    elif alignment == StringAlignment.ALIGN_MIDDLE:
        return (padding_char * int(math.floor(pad_width/2.0))) + outdata + (padding_char * int(math.ceil(pad_width/2.0)))

    return data

# ----------------------------------- #
# -     Curses Printing Table       - #
# ----------------------------------- #
class CursesTable:

    # ---------------------------- #
    # -       Constructor        - #
    # ---------------------------- #
    def __init__(self, cols, rows):

        # initialize the table
        self.data = [[ '' for x in xrange(cols)] for x in xrange(rows)]

        #  Set the column ratios
        self.columnRatios = [ 0 for x in xrange(cols)]

        #  Set the default alignments
        self.alignments=[ StringAlignment.ALIGN_MIDDLE for x in range(cols)]

        #  Set the default column ranges
        self.columnRanges = [ [0,0] for x in xrange(cols)]

        #  Define the set of horizontal bars
        self.horizontalBars = []

    # --------------------------------- #
    # -     Set the header label      - #
    # --------------------------------- #
    def Set_Column_Header_Item( self, col, text, ratio ):
        self.data[0][col] = text
        self.columnRatios[col] = ratio

    # --------------------------------------- #
    # -       Set the Column Alignment      - #
    # --------------------------------------- #
    def Set_Column_Alignment( self, col, alignment ):
        self.alignments[col] = alignment

    # ---------------------------------------------------- #
    # -        Set a bar to be a horizontal bar          - #
    # ---------------------------------------------------- #
    def Set_Horizontal_Bar( self, row ):
        self.horizontalBars.append(row)

    # ---------------------------------------------------- #
    # -      Return the number of rows in the table      - #
    # ---------------------------------------------------- #
    def Get_Row_Count(self):
        return len(self.data)

    # ------------------------------------------------------------- #
    # -      Return the item located at the requested position    - #
    # ------------------------------------------------------------- #
    def Get_Item( self, col, row ):
        return str(self.data[row][col])

    # ---------------------------------------------------------- #
    # -      Set the item located at the requested position    - #
    # ---------------------------------------------------------- #
    def Set_Item( self, col, row, text ):

        # make sure there are enough rows
        if row >= len(self.data):
            while len(self.data) <= row:
                self.data.append( [ '' for x in xrange(len(self.data[0]))] )

        val = text
        if text is None:
            val = ''

        self.data[row][col] = val

    # ------------------------------------------- #
    # -     Lay out the table for printing      - #
    # ------------------------------------------- #
    def Format_Table( self, tableWidth ):

        #  set table width
        self.tableWidth = tableWidth

        # compute the max and min ranges for the columns
        for x in xrange( 0, len(self.columnRanges)):

            # create a temp range container
            tempRange = [0, 0]
            if x == 0:
                tempRange[0] = 1
                tempRange[1] = int(math.ceil(tableWidth*self.columnRatios[x]))
            else:
                tempRange[0] = int(math.ceil(self.columnRanges[x-1][1]+2))
                tempRange[1] = int(math.ceil(self.columnRanges[x-1][1]+1 + tableWidth*self.columnRatios[x]))

            # set the range of the column
            self.columnRanges[x] = tempRange

        self.columnRanges[-1][1] -= 1

    # ------------------------------------ #
    # -         Get a Blank Row          - #
    # ------------------------------------ #
    def Get_Blank_Row( self ):

        # print the base line
        data = '|'

        #  Iterate over the columns
        for col in xrange(0, len(self.columnRanges)):

            #  Append the blank data
            data += ' ' * (self.columnRanges[col][1] - self.columnRanges[col][0] - 1) + '|'

        return data

    # --------------------------------------------------------- #
    # -    Return the row as a formatted table-worth string   - #
    # --------------------------------------------------------- #
    def Format_Row( self, row ):

        #  If we are past the max row, then return a blank line
        if row >= self.Get_Row_Count():
            return self.Get_Blank_Row()

        # print the base line
        data = '|'

        # if the row is meant to be a horizontal bar, then return that
        if row in self.horizontalBars:
            data += '-' * (self.columnRanges[0][1]+1 -  self.columnRanges[-1][1]-2)
            data += '|'
            return data

        xBeg=0
        xEnd=0

        # iterate through each column creating the spaces
        for x in xrange( 0, len(self.data[0])):

            # compute the start and stop for the actual data
            midpnt = (self.columnRanges[x][1]-self.columnRanges[x][0])/2 + self.columnRanges[x][0]

            if self.alignments[x] == StringAlignment.ALIGN_MIDDLE:
                xBeg = max( midpnt - len(self.data[row][x])/2, self.columnRanges[x][0]+1)
                xEnd = min( midpnt + len(self.data[row][x])/2, self.columnRanges[x][1] )

            elif self.alignments[x] == StringAlignment.ALIGN_LEFT:
                xBeg = self.columnRanges[x][0] + 2
                xEnd = min( midpnt + len(self.data[row][x])/2, self.columnRanges[x][1] )

            for y in xrange( self.columnRanges[x][0]+1, self.columnRanges[x][1]):
                if y < xBeg:
                    data += ' '
                elif (y-xBeg) < len(self.data[row][x]):
                    data += self.data[row][x][y-xBeg]
                else:
                    data += ' '
            data += '|'

        return data

    # ------------------------------- #
    # -     Print Table Header      - #
    # ------------------------------- #
    def Print_Header(self, screen, min_col, min_row ):

        #  Create the data lines
        header_line = '+'
        header_data = '|'
        for x in xrange(0,len(self.columnRanges)):
            line_width = self.columnRanges[x][1] - self.columnRanges[x][0] - 1
            header_line += '-' * line_width + '+'
            header_data += Format_String(self.Get_Item(x,0), line_width, self.alignments[x]) + '|'

        #  Print the header bar
        screen.addstr(min_row,   min_col, header_line)
        screen.addstr(min_row+1, min_col, header_data)
        screen.addstr(min_row+2, min_col, header_line)

        return header_line

    # ----------------------------- #
    # -     Render the Table      - #
    # ----------------------------- #
    def Render_Table(self, screen, min_col, max_col, min_row, max_row, cursor_idx ):

        # Format the table
        self.Format_Table( max_col - min_col )

        # print header row
        header_line = self.Print_Header( screen, min_col, min_row - 3)

        cpair = 0

        # Print table rows
        current_table_row = 1
        for row in xrange(min_row, max_row):
            if current_table_row == cursor_idx:
                cpair = curses.color_pair(1)
            else:
                cpair = curses.color_pair(0)
            screen.addstr( row, min_col, self.Format_Row(current_table_row), cpair)
            current_table_row += 1

        #  Print header row again
        screen.addstr( max_row, min_col, header_line)