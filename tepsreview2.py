import datetime as DT
import os
import re

# Import custom mods
#import itm6common

# search_teps module contains search strings defined as GC
import search_teps as searcht

# Define Global Constants
#SEARCH_HOST = '.*System\sName:\s'
#SEARCH_ONLINE  = '.*Waiting\sfor\srequest.*'
#SEARCH_KFWDSN = '.*\sKFW_DSN='
#SEARCH_EWAS = '.*KFW_AUTHORIZATION_USE_EWAS=.*'
#SEARCH_EMBED = '.*KFW_USE_EMBEDDED=.*'
#SEARCH_JVM = '.*KFW_STARTJVM=.*'
#SEARCH_FIPS = '.*KFW_FIPS_ENFORCED=.*'
#SEARCH_TDW = '.*fetchWarehouse"\)'

def main():
    get_raslog = input("Filename: ")                            # Get filename from user input
    print()
    display_menu(get_raslog)                                    # Call display_menu() passing log file name

    #Open RAS log for processing
    with open(get_raslog, 'r') as raslog:                       #Open the log for process
        get_tepsinfo(raslog)                                    
        raslog.seek(0)


# Simply display menu that includes the name of the file being reviewed
def display_menu(raslog):
    display_sep = "#"
    print(display_sep * 50)
    print("Log file reviewed:\n", raslog)


# get_tepsinfo() function includes the search functions and displays information back to the console
def get_tepsinfo(raslog):
    print("\n#######################################################")
    print("TEPS Configuration Information: ")
    tepsonline(raslog)
    get_ewas(raslog)
    print("#######################################################\n")


#####  Being Search Functions Section #########
# tepsonline() - Confirms if the TEPS is online by searching for the text "Waiting for Request"
def tepsonline(raslog):                                         
    #print('DEBUG >> tepsonline()')
    myline = raslog.readline() 
    itmemptylist = []
    #DEBUG_LOOP = 1 
    for my_line in raslog:
        if re.search(searcht.SEARCH_ONLINE, my_line):
            itmemptylist.append(my_line)
        else:
            pass
    #    DEBUG_LOOP += 1
    a = len(itmemptylist)
    raslog.seek(0)
    if a <= 0:
        print('TEPS "Waiting for requests" message NOT FOUND')
    else:
        print("\n^^^^^BELOW IS CRITICAL^^^^^^^")
        itmout = itmemptylist.pop(0)
        itmout = re.sub('\n', '', itmout)
        hexts = itmout.split(":")
        hexts0 = hexts[0]
        hexts0 = re.sub('\(', '', hexts0)
        hexts0 = re.sub('\.', '', hexts0)
        hexts0 = re.sub('-.*', '', hexts0)
        converted_hex = DT.datetime.utcfromtimestamp(float(int(hexts0, 16))/16**4)
        print("TEPS startup completed at (UTC): ", converted_hex)
        itmout = re.sub('^.*"\)\s', '', itmout)
        print(itmout)
        print("^^^^^ABOVE IS CRITICAL^^^^^^^\n")


def get_ewas(raslog):
    my_line = raslog.readline()
    itmemptylist = []
    for my_line in raslog:
        if re.search(searcht.SEARCH_EWAS, my_line):
            itmemptylist.append(my_line)
        else: 
            pass
    a = len(itmemptylist)
    raslog.seek(0)
    if a <= 0:
        print('KFW_AUTHORIZATION_USE_EWAS: NOT FOUND')
    else:
        print("KFW_AUTHORIZATION_USE_EWAS='Y'")

if __name__ == '__main__':
    main()
print('End of program')
