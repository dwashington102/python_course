""" 
Program will gather a list to text files, loop through the text files, and
strip the lines that include the text "http".  Using the http lines a
pull request will be initiated to pull the files to the local workstation. 

Steps required:
1) Copy and paste chat text into a text file located in ~/Temp/static
    cd ~/Temp/static &&  touch afile_`date +%Y%m%d-%H%M`.txt
2) Generate the output files using these commands: 
    cat /dev/null > /tmp/outputfile && cat /dev/null > /tmp/outputfiles_html
    ls -1 *txt > /tmp/outputfile
3) Call script:  
    python3 striphttp.py
4) Downloaded images are stored in ~/Temp/images
"""

import os
import re
import subprocess
import wget
import colorama

from datetime import datetime
from os import path
from pathlib import Path
from time import sleep

# Custom modules/python file that sits in the same directory as the striphttp.py script

# Define GLOBAL CONSTANTS
TSTAMP=datetime.now()
DISPLAY_SPACER = "="
HOMEDIR = str(Path.home())
TFILESPATH = HOMEDIR + '/Temp/static'
HTMLFILESPATH = HOMEDIR + '/Temp/images/'
IFOUND ='Image Files Found:'


def main():
    sleep(3)
    display_header()
    get_httpEntries()
    create_outputhtml()
    parse_htmlfiles()


def display_header():
    print(DISPLAY_SPACER * 50)
    print("GET FILES")
    print(DISPLAY_SPACER * 50)


def create_outputhtml():
    os.system(HOMEDIR + '/GIT_REPO/python_course/create_outputhtml.sh')
    sleep(3)
    #os.system('/home/devdavid/GIT_REPO/python_course/create_outputhtml.sh')


def parse_htmlfiles():
    print()
    #Set/Get the text file that contains a list of html files.
    try:
        output_file = open(r'/tmp/outputfiles_html', 'r')
        print('/tmp/outputfiles_html FOUND')
        #sleep(3)
    except FileNotFoundError:
        print('\nFile NOT FOUND: /tmp/outputfiles_html\n')
        exit(2)

    # For each line of the outputfile, read the html file name, 
    # and set the filename to the variable search_file
    for rline in output_file.readlines():
        rline = rline.strip('\n')
        ftype = str(path.isfile(rline))
        if ftype == 'True':
            # Following line is for DEBUG only
            #print('wget action against --->', rline, ftype)
            search_file = open(rline, 'r')
            print('DEBUG >>> search_file', search_file)
            try:
                for searchline in search_file.readlines():
                    if re.search('og:image"\scontent=', searchline):
                        wgeturl = re.sub(r".*http", "http", searchline)
                        wgeturl = wgeturl.rstrip('\n')
                        wgeturl = re.sub(r'".*', '', wgeturl)
                        output_directory = HOMEDIR + '/Temp/images'
                        print('\nhtml_file -> Begin wget for: ', wgeturl, '\n')
                        try:
                            filename = wget.download(wgeturl, out=output_directory)
                        except:
                            print('\nError encountered for wget: ', wgeturl, '\n')
                    else:
                        pass
            except Exception:
                print('\nError encounterd attempting to search file --->', search_file)
                sleep(2)

            # Closing file prior to deleting file 
            search_file.close()
            try:
                os.remove(rline)
                print('\nDeleted file ', rline)
            except:
                print()
                print('\nUNABLE TO DELETE --->>', rline, '\n')

        else:
            #If file type != True - close file and return statement showing wget not attempted
            search_file.close()
            print('\nNo WGET Action against --->', rline, ftype)
           #pass

def get_httpEntries():
    # Convert the current time to use format yearmondayhourminute
    a_timenow = (TSTAMP.strftime("%Y%m%d%H%M"))
    format_inputfile = "/home/devdavid/Temp/images-"+ a_timenow+ ".txt"
    images_captured = open(format_inputfile, 'w')
    try:
        output_file = open(r'/tmp/outputfile', 'r')
        print('/tmp/outputfile FOUND')
    except FileNotFoundError:
        print('\nFile NOT FOUND: /tmp/outputfile\n')
        exit(1)

   # Parse each line of the output_file, extracting the text "http" from the noise in the file.
   # The "http"  lines are then passed to the images_captured() to a file 
    for rline in output_file.readlines():
        if re.search("txt", rline):
            searchfile = rline.rstrip('\n')
            searchfile = TFILESPATH + '/' + searchfile
            with open(searchfile, 'r') as httpsearch:
                for hline in httpsearch.readlines():
                    if re.search("http", hline):
                        finalout = re.sub(r".*http", "http", hline)
                        # Next 4 lines are for debug purpose only
                        #print('DEBUG finalout >>>', finalout)
                        #print(hline) only for debug purpose
                        #print(hline)
                        #print(finalout)
                        images_captured.write(finalout)
                    else:
                        pass
        else:
            print("Valid Entries:  NOT FOUND\n")
    # Closing files used for output and input
    output_file.close()
    images_captured.close()

    # Open input files for reading in order to use contents for wget statements
    images_captured = open(format_inputfile, 'r')

    #os.chdir('/home/devdavid/Temp')    
    for urline in images_captured.readlines():
        urline = urline.rstrip('\n')
        output_directory = HOMEDIR + '/Temp/images'
        try:
            if re.search("http", urline):
                print()
            try:
                #Use python wget to download file(urline) and save to output_directory and save to output_directory
                filename = wget.download(urline, out=output_directory)
            except:
                print('\nError encountered for wget: ', urline, '\n')
            else:
                pass
        except:
            print()
            print('URL not found\n')
    images_captured.close()


if __name__ == '__main__':
    main()
    print()
    print('end of program')
