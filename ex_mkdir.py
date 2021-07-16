from os import path


# Define GLOBAL CONSTANTS
TEMPDIR = '/tmp/data_'

def main():
    do_work()


def do_work():
    loopcount=1
    for myrange in range(0,10):
        mycount = str(loopcount)
        datadir = path.join(TEMPDIR + mycount)
        print(datadir)
        a_mkdir = path.os.mkdir(datadir, mode=550)
        loopcount += 1


if __name__ == '__main__':
    main()
