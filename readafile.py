import re
import os

# GLOBAL CONSTANTS used for search strings
SEARCH_HOST = '.*System\sName:\s'
SEARCH_TYPE = '.*System\sType:\s'
SEARCH_DATE = '.*Start\sDate:\s'
SEARCH_TIME = '.*Start\sTime:\s'
SEARCH_USER = '.*User\sName:\s'
SEARCH_PID = '.*Process\sID:\s\d'
SEARCH_NOFILE = '.*Nofile\sLimit:\s'
SEARCH_CHOME = '.*ITM\sHome:\s'
SEARCH_KBBRAS1 = '.*KBB_RAS1:\s'
SEARCH_IPADDR = '\d:\ssource=.*'
SEARCH_PORT = '.*KDEBP_AssignPort.*'
SEARCH_MSINDEX = '.*add_listener\"\)\s+listening:.*'

# BSS1_GetEnv Variables
SEARCH_DYNAMIC = 'BSS1_GetEnv.*KBBRA_ChangeLogging'
SEARCH_PROTOCOL = 'BSS1_GetEnv.*KDC_FAMILIES='
SEARCH_CMS = 'BSS1_GetEnv.*CMSLIST=".*'

# GLOBAL CONTSTANT used for printing header & footer
HEADER_FOOTER_CHAR = '='


def main():
    myfile = open('input_file.txt', 'r')
    display_header(myfile)

    get_host(myfile)
    myfile.seek(0)

    get_ostype(myfile)
    myfile.seek(0)

    get_date(myfile)
    myfile.seek(0)

    get_time(myfile)
    myfile.seek(0)

    get_user(myfile)
    myfile.seek(0)

    get_pid(myfile)
    myfile.seek(0)

    get_nofile(myfile)
    myfile.seek(0)

    get_chome(myfile)
    myfile.seek(0)

    get_kbbras1(myfile)
    myfile.seek(0)

    get_ipaddr(myfile)
    myfile.seek(0)

    get_assignport(myfile)
    myfile.seek(0)

    get_msindex(myfile)
    myfile.seek(0)


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

def get_msindex(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_MSINDEX, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("Monitoring Agent registration with Monitoring Service Index NOT FOUND\n")
    else:
        print("Monitoring Service Index Ports:")
        for itmout in itmemptylist:
            itmout = re.sub('\n', '', itmout)
            itmout = re.sub('\(.*\)\slistening:\s', '', itmout)
            print(itmout) 


def get_assignport(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_PORT, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("AssignPort: NOT FOUND")
    else:
            itmout = itmemptylist.pop(0)
            itmout = re.sub('^.*AssignPort\"\)\s', '', itmout)
            print("LISTENING PORT:", itmout) 


def get_ipaddr(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_IPADDR, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("\nNetwork Interfaces NOT FOUND")
    else:
        print("\nNetwork Information:")
        nic = 1
        for itmout in itmemptylist:
            itmout = re.sub('\n', '', itmout)
            itmout = re.sub('^.*\d+\s+', '', itmout)
            itmout = re.sub('\,.*.$', '', itmout )
            print("Network Interface Card["+ str(nic)+ "]:", itmout) 
            nic += 1
        print()


def get_kbbras1(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_KBBRAS1, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("KBBRAS1: NOT FOUND")
    else:
        itmout = itmemptylist.pop(0)
        itmout = re.sub('\n', '', itmout)
        itmout = re.sub('^.*KBB_RAS1:', '', itmout)
        print("Trace Setting:\t {:}".format(itmout))


def get_chome(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_CHOME, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("CANDLEHOME: NOT FOUND")
    else:
        itmout = itmemptylist.pop(0)
        itmout = re.sub('\n', '', itmout)
        itmout = re.sub('^.*Home:', '', itmout)
        print("CANDLEHOME:\t {:}".format(itmout))


def get_nofile(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_NOFILE, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("NOFILE: NOT FOUND")
    else:
        itmout = itmemptylist.pop(0)
        itmout = re.sub('\n', '', itmout)
        itmout = re.sub('^.*Limit:', '', itmout)
        print("NOFILE Setting:\t {:}".format(itmout))


def get_pid(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_PID, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("PID: NOT FOUND")
    else:
        itmout = itmemptylist.pop(0)
        itmout = re.sub('\n', '', itmout)
        itmout = re.sub('^.*ID:', '', itmout)
        print("PID Number:\t {:}".format(itmout))


def get_user(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_USER, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("USERID: NOT FOUND")
    else:
        itmout = itmemptylist.pop(0)
        itmout = re.sub('\n', '', itmout)
        itmout = re.sub('^.*Name: ', '', itmout)
        print("User Name:\t  {:}".format(itmout))


def get_time(myfile):
    itmemptylist = []
    for my_line in myfile:
        if re.search(SEARCH_TIME, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    a = len(itmemptylist)
    if a <= 0:
        print("Start TIME: NOT FOUND")
    else:
        itmout = itmemptylist.pop(0)
        itmout = re.sub('\n', '', itmout)
        itmout = re.sub('^.*Time:', '', itmout)
        print("Start Time:\t {:}".format(itmout))


def get_date(myfile) :
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
        itmout = re.sub('Start\sTime.*$', '', itmout)
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