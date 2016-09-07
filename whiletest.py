#!/usr/bin/python
# Date: 9/7/2016
#
# Script will prompt user for a number.
# Using the value provided by the user - the script loops through printing 10 lines. 

iUser=int(input("Insert number here: ")) # User Input statement

# Define variables
x=(iUser)
y=int(x+10)
loop=1

while (x<=y):
	if x==y-5:
		str_x=str(x)
		str_y=str(y)
		str_loop=str(loop)
		#print("Line Count: ", loop ,' X Value: ',x,' Y Value',y,'Only 4 more lines')
		print("Line Count: "+ str_loop +" [X Value: " + str_x + " Y Value: " + str_y + "] ONLY 4 MORE LINES")
		x+=1
		loop+=1
	elif x!=y:
		str_x=str(x)
		str_y=str(y)
		str_loop=str(loop)
		#print('Line Count: '+ str_loop + ' X Value: ',x,' Y Value',y)
		print("Line Count: "+ str_loop +" [X Value: " + str_x + " Y Value: " + str_y + "]")
		x+=1
		loop+=1
	else:
		print('That\'s all folks')
		exit(0)


