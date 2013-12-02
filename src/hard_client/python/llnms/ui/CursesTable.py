#!/usr/bin/env python

import curses, math

class CursesTable:

	def __init__(self, cols, rows):

		# initialize the table
		self.data = [[ '' for x in xrange(cols)] for x in xrange(rows)];
		
		self.columnRatios = [ 0 for x in xrange(cols)]
		
		self.columnRanges = [ [0,0] for x in xrange(cols)]

	#---------------------------------#
	#-     Set the header label      -#
	#---------------------------------#
	def setColumnHeaderItem( self, col, text, ratio ):		
		self.data[0][col] = text
		self.columnRatios[col] = ratio

	
	#----------------------------------------------------#
	#-      Return the number of rows in the table      -#
	#----------------------------------------------------#
	def getRowCount(self):
		return len(self.data)

	#-------------------------------------------------------------#
	#-      Return the item located at the requested position    -#
	#-------------------------------------------------------------#
	def getItem( self, col, row ):
		return str(self.data[row][col])

	#----------------------------------------------------------#
	#-      Set the item located at the requested position    -#
	#----------------------------------------------------------#
	def setItem( self, col, row, text ):

		# make sure there are enough rows
		if row >= len(self.data):
			while len(self.data) <= row:	
				self.data.append( [ '' for x in xrange(len(self.data[0]))] )

		self.data[row][col] = text
	
	#-------------------------------------------#
	#-     Lay out the table for printing      -#
	#-------------------------------------------#
	def formatTable( self, tableWidth ):
		
		#  set table width
		self.tableWidth = tableWidth

		# compute the max and min ranges for the columns
		for x in xrange( 0, len(self.columnRanges)):
			
			# create a temp range container
			tempRange = [0, 0]
			if x == 0:
				tempRange[0] = 0
				tempRange[1] = int(math.ceil(tableWidth*self.columnRatios[x]))
			else:
				tempRange[0] = int(math.ceil(self.columnRanges[x-1][1]+1))
				tempRange[1] = int(math.ceil(self.columnRanges[x-1][1]+1 + tableWidth*self.columnRatios[x]))

			
			# set the range of the column
			self.columnRanges[x] = tempRange 

		self.columnRanges[-1][1] -= 1

	#---------------------------------------------------------#
	#-    Return the row as a formatted table-worth string   -#
	#---------------------------------------------------------#
	def getRow( self, row ):
			
		# print the base line
		data = '|'
		
		# iterate through each column creating the spaces
		for x in xrange( 0, len(self.data[0])):
			
			# compute the start and stop for the actual data
			midpnt = (self.columnRanges[x][1]-self.columnRanges[x][0])/2 + self.columnRanges[x][0]
			xBeg = max( midpnt - len(self.data[row][x])/2, self.columnRanges[x][0]+1)
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
			



