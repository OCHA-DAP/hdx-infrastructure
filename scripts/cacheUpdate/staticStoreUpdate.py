#!/usr/bin/python

import urllib2
from urlparse import urlparse
from os.path import splitext, basename, isfile, isdir, abspath, join
from os import makedirs
from sys import stdout, stderr, exit, argv
import time

def get_file(FILE,BASEDIR):
    urls = open(FILE,'r')
    #print urls.read()
    #print urls.readlines()
    for url in urls:
        # the url does not contain even the http:// :)
        if len(url) < 8:
            continue
        # hit url
        #stdout.write("touching ")
        url = url.strip()
        path = (urlparse(url)).path
        filename = basename(path)
        path_only = path.replace('/hdx/api/exporter/', '').replace(filename, '')
        full_path = join(BASEDIR,path_only)
        # stdout.write(url)
        # stdout.write(' +++ ')
        # stdout.write(path)
        # stdout.write(' +++ ')
        # stdout.write(filename)
        # stdout.write(' +++ ')
        # stdout.write(path_only)
        stdout.write(full_path+'\n')
        stdout.flush()
        if not isdir(full_path):
            stdout.write('folder not found. creating ' + full_path)
            makedirs(full_path)
        start_req = time.time()
        code, content = get_header(url)
        #print content       
        # print " result - 200/301/404"
        req_time = (time.time() - start_req)
        stdout.write(" - " + str(code) + " - " + str("%2.5r" % req_time) + '\n')
        stdout.flush()
        if code == 200:
            # save file
            response_file = open(join(full_path, filename),'wb')
            response_file.write(content)
            response_file.close()

    # timing on cache feeding maybe? :)
    #if req_time > 1:
    #   stderr.write('Refreshing ' + filename + '\n')
    #   stderr.flush()
    #   #time.sleep(3)

def get_header(url):
    req = urllib2.Request(url)
    #try:
    res = urllib2.urlopen(req)
    code = res.code
    content = res.read()
    res.close()
    return code, content
    #except:
        #sys.exit(1)

#def make_paths(BASEPATH,path) {
    
#}

def invalidUsage():
    """Prints usage instructions and exits
    """
    return 'Usage: '+argv[0]+' <URLs_file> <base_folder>'

def main(filename,basedir):
    # delay the cronjob so that the cache expires.
    # (cache is +24h, cron job is scheduled to run daily at the same time)
    #time.sleep(3)
    get_file(filename,basedir)
    #get_header('http://manage.hdx.rwlabs.org/hdx/api/exporter/indicator/readme/PVX080/source/emdat/language/EN/PVX080_Readme.txt')
    return True


if __name__ == '__main__':
    #if ( len(argv) < 2 ) or (len(argv) > 3):
    if len(argv) != 3:
        exit(invalidUsage())
    FILE=argv[1]
    if not isfile(FILE):
        print "File not found"
        exit(invalidUsage())
    BASEDIR=abspath(argv[2])
    if not isdir(BASEDIR):
        print "Base folder not found"
        exit(invalidUsage())
    print BASEDIR
    main(FILE,BASEDIR)
