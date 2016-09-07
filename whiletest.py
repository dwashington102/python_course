#!/usr/bin/python

iUser=int(input("Insert number here: "))
x=(iUser)
y=int(x+10)

while (x<=y):
	loop=x+1
	if x==y-5:
		print('Only 4 more to go:  LoopCount: ',loop,' X Value: ',x,' Y Value',y)
		x+=1
	elif x!=y:
		print('LoopCount: ',loop,' X Value: ',x,' Y Value',y)
		x+=1
	else:
		print('Thats all folks')
		exit(0)


