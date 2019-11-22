# Program will gather a list to text files, loop through the text files, and
# strip the lines that include the text "http".  Using the http lines a
# pull request will be initiated to pull the files to the local workstation. 


'''
Steps required:
1) Copy and paste chat text into a text file located in ~/Temp/static
    cd ~/Temp/static &&  touch afile_`date +%Y%m%d-%H%M`.txt
2) Generate the output files using these commands: 
    cat /dev/null > /tmp/outputfile && cat /dev/null > /tmp/outputfiles_html
    ls -1 *txt > /tmp/outputfile
3) Call script:  
    python3 striphttp.py
4) Downloaded images are stored in ~/Temp/images
'''

from datetime import datetime
import os
from pathlib import Path
import re
import subprocess
from time import sleep
import wget

# Custom modules/python file that sits in the same directory as the striphttp.py script
from movehtml import list_files


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
    user_choice()

def display_header():
    print(DISPLAY_SPACER * 50)
    print("GET FILES")
    print(DISPLAY_SPACER * 50)


def user_choice():
    print()
    choice = input('\nDo you want to move html files (y/n): ')
    choice = choice.lower()
    if choice == "y":
        list_files(HTMLFILESPATH)
    elif choice == "n":
        print('Completed run and saved html files')
    else:
        print('Invalid Entry...exiting')


def create_outputhtml():
    os.system(HOMEDIR + '/GIT_REPO/python_course/create_outputhtml.sh')
    sleep(3)
    #os.system('/home/devdavid/GIT_REPO/python_course/create_outputhtml.sh')


def parse_htmlfiles():
    print('DEBUG >>> Entered parse_htmlfiles')
    sleep(5)
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
        rline = rline.rstrip('\n')
        search_file = rline
        #search_file = HTMLFILESPATH + rline

        # Open search_file in order to locate the string "og:image content="
        try:
            html_file = open(search_file, 'r')
            html_file = str(html_file)
            if os.path.isfile(html_file):
                for searchline in html_file.readlines():
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
            else:
                print('Encountered a directory at --->', html_file)
            html_file.close()

        except FileNotFoundError:
            print('\nFile NOT FOUND: ', search_file)
    output_file.close()

def get_httpEntries():
    # Convert the current time to use format yearmondayhourminute
    a_timenow = (TSTAMP.strftime("%Y%m%d%H%M"))
    format_inputfile = "/home/devdavid/Temp/images-"+ a_timenow+ ".txt"
    images_captured = open(format_inputfile, 'w')
    try:
        output_file = open(r'/tmp/outputfile', 'r')
        print('/tmp/outputfile FOUND')
        sleep(3)
    except FileNotFoundError:
        print('\nFile NOT FOUND: /tmp/outputfile\n')
        exit(1)
    
    for rline in output_file.readlines():
        if re.search("txt", rline):
            searchfile = rline.rstrip('\n')
            searchfile = TFILESPATH + '/' + searchfile
            with open(searchfile, 'r') as httpsearch:
                for hline in httpsearch.readlines():
                    if re.search("http", hline):
                        finalout = re.sub(r".*http", "http", hline)
                        print('DEBUG finalout >>>', finalout)
                        sleep(1)
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

    #os.chdir('/home/devdavid/Temp')    
    for urline in images_captured.readlines():
        urline = urline.rstrip('\n')
        output_directory = HOMEDIR + '/Temp/images'
        try:
            if re.search("http", urline):
                print()
                print('Begin wget for:', urline)
            try:
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


