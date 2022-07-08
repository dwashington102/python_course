#!/usr/bin/env python3

import os
import argparse
from pathlib import Path
import subprocess
import sys

def main():
    do_work()

def do_work():
    parser = argparse.ArgumentParser(description='Script takes 2 arguments {pkg-name} and {branch ID}. Using these arguments the script attempts a git clone for the package and branch, saving the repo to defined git directory')
    parser.add_argument('-p', dest='pkgName', type=str, help='Package Name', required=True)
    parser.add_argument('-b', dest='branch', type=str, help='Branch Name', required=True)
    args = parser.parse_args()

#   Test if the git repo directory exists
    homeDir = os.environ.pop('HOME')
    gitDirBase = homeDir + "/ibm_git_dir/git/"
    gitDirBasePath = Path(gitDirBase)

    gitDir = gitDirBase + args.branch + "/" + args.pkgName
    gitDirPath = Path(gitDir)

    if gitDirBasePath.is_dir():
        if gitDirPath.is_dir():
            print("The directory {} exists.\nNo git-clone will be attempted.\n".format(gitDir))
            sys.exit(2)
        else:
            print("Git Repo Directory Found...starting to clone repo {}".format(args.pkgName))
    else:
        print("Git Repo Directory NOT FOUND")
        sys.exit(1)
    
    try:
        gitOpenClient = "git@github.ibm.com:openclient/" + args.pkgName
        subprocess.run(["git", "clone", "-v", gitOpenClient, "-b", args.branch, gitDir])
        print("Package cloned to the directory: {}\n".format(gitDir))
    except:
        print("Unable to cd to gitDirBase:  {}\n".format(gitDirBase))

if __name__ == '__main__':
    main()

