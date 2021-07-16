# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

from tkinter import *
root=Tk()
theLabel = Label(root, text="Hello World!")
one=Label(root, text="One", bg="red", fg="white")
two=Label(root, text="One", bg="green", fg="white")
three=Label(root, text="One", bg="blue", fg="white")

# Cause tkinter to place window anywhere 
"""
The .pack places the object on screen
By default .pack stocks like blocks

For placing side-by-side use .pack(side=LEFT)
This translates to placing each block as far left as possible.
"""
theLabel.pack()
one.pack()

# fill=x means to fill widget as wide as window
two.pack(fill=X)

# fill=Y means to fill widget at height as window
three.pack(side=LEFT, fill=Y)



# Creating frames
topFrame=Frame(root)
topFrame.pack(side=TOP)

bottomFrame=Frame(root)
bottomFrame.pack(side=BOTTOM)

# Creating  Widgets
"""
Buttons
label=Button(<frame>, text="Whatever", <color: optional>)
"""
button1=Button(topFrame, text="Button 1", fg="red")
button2=Button(topFrame, text="Button 2", fg="blue")
button3=Button(topFrame, text="Button 3", fg="green")
button4=Button(bottomFrame, text="Button 4", fg="yellow")

# Displaying Widgets
button1.pack(side=LEFT)
button2.pack(side=LEFT)
button3.pack(side=LEFT)
button4.pack(side=RIGHT)

# Causes window to remain until closed
root.mainloop()