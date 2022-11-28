#!/usr/bin/env python3
"""
Script scrapes websites and pulls mp4 files from the links included.

URL:
https://www.route.com/video-123459/foobar

Equivalent: Shell Command
grep ${viewsrc} index+searchString.html  | awk -v http=$viewsrc -F'http' '{print $2}' | grep ${url} | awk -F'"' '{print "http"$1}'

Variables:
viewsrc="view-source:https"
url="x.com\/video-"


Sites: x_nx + searchString
"""

import os
import re
import subprocess
import urllib3
from datetime import datetime


def main():
    func_get_urls()


def get_urls():
    # Function pulls URLS from index.html file and writes to 
    # a file "rawUrls" in current directory
    sindex = "index.html"
    urlfile = "rawUrls"
    viewsrc = "view-source:https"
    url = "x.com\/video-"
    with open(sindex, 'r') as sindex:
        urlList = []
        for line in sindex:
            if re.search(viewsrc, line):
                if re.search(url, line):
                    urlList.append(line)

    if urlList:
        rawurls = []
        print('DEBUG FOUND URLS')
        for url in urlList:
            url = re.sub('.*view-source:', '', url)
            url = re.sub('".*', '', url)
            url = re.sub('\n', '', url)
            rawurls.append(url)
        with open(urlfile, 'a') as ofile:
            for rawurl in rawurls:
                ofile.write(rawurl + '\n')


def gen_rawfiles():
    rawurlfile = "rawUrls"
    count = 1
    with open(rawurlfile, 'r') as urlfile, open(output_file, 'w') as ofile:
        for line in urlfile:
            
        
        


if __name__ == '__main__':
    main()
