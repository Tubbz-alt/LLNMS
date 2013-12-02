#!/usr/bin/env python
import time

INFO=0
MINOR=1
MAJOR=2

#-------------------------------------#
#-        LLNMS Log Message          -#
#-------------------------------------#
class Message:

	#-     Constructor       -#
	def __init__(self, message, priority, ltime ):
		
		# set message
		self.message = message

		# set priority
		self.priority = priority

		# set time
		self.ltime = ltime
	
	
	#---------------------------------------#
	#-     Print the Message to String     -#
	#---------------------------------------#
	def __str__(self):
		
		return self.ltime + "  " + self.message



#-------------------------------------#
#-        LLNMS Logging Tool         -#
#-------------------------------------#
class Logger:
	
	#---------------------#
	#-     Constructor   -#
    #---------------------#
	def __init__(self, LOG_PATH):

		#  set the log path
		self.LOG_PATH = LOG_PATH;

		#  set the log data priority
		self.MIN_PRIORITY = 0;

		#  set the data
		self.messages = []
	
	
	#---------------------------------#
	#-     Add Message to Logger     -#
	#---------------------------------#
	def addMessage(self, message, priority ):
		
		# add the message
		self.messages.append(Message( message, priority, time.strftime("%Y-%m-%d %H:%M:%S") ));


	#------------------------------------#
	#-         Write Log File           -#
	#------------------------------------#
	def writeLogFile(self):
		
		#  open the file
		f = open( self.LOG_PATH, 'w')
		
		for message in self.messages:
			f.write(str(message)+"\n")

		#  close the file
		f.close()


