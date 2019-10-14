# Program will gather a list to text files, loop through the text files, and
# strip the lines that include the text "http".  Using the http lines a
# pull request will be initiated to pull the files to the local workstation. 

from datetime import datetime
import os
import pathlib
import re
import subprocess
import wget


# Define GLOBAL CONSTANTS
TSTAMP=datetime.now()
DISPLAY_SPACER = "="


def main():
    display_header()
    get_httpEntries()


def display_header():
    print(DISPLAY_SPACER * 50)
    print("GET FILES")
    print(DISPLAY_SPACER * 50)


#def run_wget(images_captured):
#    with open(images_captured, 'r') as images_captured:
#        for wgetline in images_captured.readlines():
#            print('DEBUG wgetline: ', wgetline)


def get_httpEntries():
    a_timenow = (TSTAMP.strftime("%Y%m%d%H%M"))
    format_inputfile = "/home/daviddev/Temp/images-"+ a_timenow+ ".txt"
    images_captured = open(format_inputfile, 'w')
    output_file = open(r'/tmp/outputfile', 'r')
    
    for rline in output_file.readlines():
        if re.search("txt", rline):
            searchfile = rline.rstrip('\n')
            with open(searchfile, 'r') as httpsearch:
                for hline in httpsearch.readlines():
                    if re.search("http", hline):
                        finalout = re.sub(r".*http", "http", hline)
                        #print(hline) only for debug purpose
                        #print(hline)
                        #print(finalout)
                        images_captured.write(finalout)
                    else:
                        pass
                #print(httpsearch.read())
        else:
            print("Valid Entries:  NOT FOUND\n")
    # Closing files used for output and input
    output_file.close()
    images_captured.close()

    # Open input files for reading in order to use contents for wget statements
    images_captured = open(format_inputfile, 'r')

    #os.chdir('/home/daviddev/Temp')    
    for urline in images_captured.readlines():
        urline = urline.rstrip('\n')
        output_directory = '/home/daviddev/Temp'
        if re.search("http", urline):
            print('Begin wget for:', urline)
            try:
                filename = wget.download(urline, out=output_directory)
            except:
                print('Error encountered for wget: ', urline)
        else:
            pass
    images_captured.close()

main()
#images_captured.close()

print('end of program')

