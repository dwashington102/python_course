import re
import os

# GLOBAL CONSTANTS used for search strings
SEARCH_HOST = '.*System\sName:\s'
SEARCH_TYPE = '.*System\sType:\s'
SEARCH_DATE = '.*Start\sDate:\s'

# GLOBAL CONTSTANT used for printing header & footer
HEADER_FOOTER_CHAR = '='


def main():
    myfile = open('input_file.txt')
    display_header(myfile)

    myfile = open('input_file.txt')
    get_host(myfile)
    myfile = open('input_file.txt')
    get_ostype(myfile)
    myfile = open('input_file.txt')
    get_date(myfile)

    myfile.close()
    display_footer()

def display_header(myfile):
    print(HEADER_FOOTER_CHAR * 70)
    dirty_filename_a = str(myfile)
    dirty_filename_b = re.sub('^.*name=\'', '', dirty_filename_a)
    clean_filename = re.sub('\'.*$', '', dirty_filename_b)
    print('Filename:\t', clean_filename)
    print(HEADER_FOOTER_CHAR * 70)
    
def display_footer():
    print(HEADER_FOOTER_CHAR * 70)


def get_date(myfile) :
    count_loop = 1
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_DATE, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("Start Date: NOT FOUND")
    else:
        itmout = itmemptylist.pop(0)
        itmout = re.sub('\n', '', itmout)
        itmout = re.sub('^.*Date:', '', itmout)
        #itmout = re.sub(r'St.*\n', '', itmout)
        print("Start Date:\t {:}".format(itmout))

def get_ostype(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_TYPE, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("System Type: NOT FOUND")
    else:
            itmout = itmemptylist.pop(0)
            itmout = re.sub('^.*Type:', '', itmout)
            itmout = re.sub('\n', '', itmout)
            print("System Type:\t {:}".format(itmout))

def get_host(myfile):
    itmemptylist = []
    for my_line in myfile:    
        if re.search(SEARCH_HOST, my_line):
            itmemptylist.append(my_line)
            my_line = myfile.readline()
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("Hostname NOT FOUND")
    else:
        itmout = itmemptylist.pop(0)
        itmout = re.sub('^.*Name:', '', itmout)
        itmout = re.sub('Process\sID.*$\n', '', itmout)
        print("Hostname, System Type, Start Date/Time Process Info:")
        #print("Hostname, System Type, Start Date/Time Process Info:\t", "Hostname: ", itmout)
        print("Hostname:\t {:}".format(itmout))


main()
print("End of program")    