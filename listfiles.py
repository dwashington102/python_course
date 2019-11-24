import os
from os import path

'''
Program will gather a list of the files and subdirectories in the current directory
prints out the filename and "True"  --> if the item is a file 
prints out the directory name and "is a directory"  --> if the item is a directory
'''

# Create an empty list and then add the files/subdirectories in the current directory into the list
mydirlist = []
mydirlist = os.listdir()

def main():
    myloop()

# Look  throught the list (mydirlist).  Print only the "files", ignore the subdirectories
# output:
#1: striphttp.py 	 True
#2: future_value.py 	 True
#3: csv_2_list.py 	 True
#4: csv_panda_test.py 	 True

def myloop():
    loopcount = 1
    for myfile in mydirlist:
        myfile = myfile.rstrip()
        ftype = str(path.isfile(myfile))
        if ftype == 'True':
            loop = str(loopcount)
            print(loop+ ':', myfile, '\t', ftype)
            loopcount += 1
        else:
            pass

if __name__ == '__main__':
    main()
