# Program will gather a list to text files, loop through the text files, and
# strip the lines that include the text "http".  Using the http lines a
# pull request will be initiated to pull the files to the local workstation. 


'''
Steps required:
1) Copy and paste chat text into a text file located in ~/Temp/chats
2) Generate the output_file using the command: cd ~/Temp/chats &&  ls -1 *txt > /tmp/outputfile
3) Call script:  python3 striphttp.py
4) Downloaded images are stored in ~/Temp/images
5) Must clear /tmp/outputfile before running again
'''


'''
To do
Gather a list of file types=HTML
extract text og:image | awk -F'[""]'
ex: grep og:image <filename> | awk -F'[""]' '{print $4}'
wget extracted URL
'''

from datetime import datetime
import os
from pathlib import Path
import re
import subprocess
import wget


# Define GLOBAL CONSTANTS
TSTAMP=datetime.now()
DISPLAY_SPACER = "="
HOMEDIR = str(Path.home())
TFILESPATH = HOMEDIR + '/Temp/chats'
HTMLFILESPATH = HOMEDIR + '/Temp/images/'
IFOUND ='Image Files Found:'


def main():
    display_header()
    get_httpEntries()
    parse_htmlfiles()


def display_header():
    print(DISPLAY_SPACER * 50)
    print("GET FILES")
    print(DISPLAY_SPACER * 50)


#def run_wget(images_captured):
#    with open(images_captured, 'r') as images_captured:
#        for wgetline in images_captured.readlines():
#            print('DEBUG wgetline: ', wgetline)

def parse_htmlfiles():
    print()
    #Set/Get the text file that contains a list of html files.
    output_file = open(r'/tmp/outputfiles_html', 'r')

    # For each line of the outputfile, read the html file name, 
    # and set the filename to the variable search_file
    for rline in output_file.readlines():
        rline = rline.rstrip('\n')
        search_file = HTMLFILESPATH + rline

        # Open search_file in order to locate the string "og:image content="
        try:
            html_file = open(search_file, 'r')
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
        #closing files before leaving the function
            html_file.close()
        except FileNotFoundError:
            print('\nFile NOT FOUND: ', searchline)
    output_file.close()

def get_httpEntries():
    # Convert the current time to use format yearmondayhourminute
    a_timenow = (TSTAMP.strftime("%Y%m%d%H%M"))
    format_inputfile = "/home/devdavid/Temp/images-"+ a_timenow+ ".txt"
    images_captured = open(format_inputfile, 'w')
    output_file = open(r'/tmp/outputfile', 'r')
    
    for rline in output_file.readlines():
        if re.search("txt", rline):
            searchfile = rline.rstrip('\n')
            searchfile = TFILESPATH + '/' + searchfile
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

    #os.chdir('/home/devdavid/Temp')    
    for urline in images_captured.readlines():
        urline = urline.rstrip('\n')
        output_directory = '/home/devdavid/Temp/images'
        if re.search("http", urline):
            print()
            print('Begin wget for:', urline)
            try:
                filename = wget.download(urline, out=output_directory)
            except:
                print('\nError encountered for wget: ', urline, '\n')
        else:
            pass
    images_captured.close()


if __name__ == '__main__':
     main()
#images_captured.close()

print()
print('end of program')

