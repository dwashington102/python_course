#!/usr/bin/python
# Date: 9/7/2016
# Author: David D. Washington

#################################################
# Description: Figure stock price alerts
#################################################

#################################################
# Python Modules
import sys
# End Python Modules
#################################################

#################################################
# Define variables
# Increase variables (3%, 5%, 10%)
i3=float(.03)
i5=float(.05)
i10=float(.10)

# End Define variables
#################################################


#################################################
# Functions
#################################################
iUser=float(input("Insert Purchase Price: "))
iDollar=float("%.2f" % iUser)
profit3=(float(iDollar+(iDollar*i3)))
iProfit3=float("%.2f" % profit3)
strProfit3=str(iProfit3)
print("Price at 3% increase: " + strProfit3)

profit5=(float(iDollar+(iDollar*i5)))
iProfit5=float("%.2f" % profit5)
strProfit5=str(iProfit5)
print("Price at 5% increase: " + strProfit5)

profit10=(float(iDollar+(iDollar*i10)))
print("Debug 110:",profit10)
iProfit10=float("%.2f" % profit10)
print("Debug 10:",iProfit10)
strProfit10=str(iProfit10)
print("Price at 10% increase: " + strProfit10)


