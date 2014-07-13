#!/usr/bin/python

import urllib2
from urlparse import urlparse
from os.path import splitext, basename, isfile
from sys import stdout, stderr, exit, argv
import time

def get_file(FILE):
    urls = open(FILE,'r')
    #print urls.read()
    #print urls.readlines()
    for url in urls:
        # the url does not contain even the http:// :)
        if len(url) < 8:
            continue
        # hit url
        stdout.write("touching ")
        url = url.strip()
        path = (urlparse(url)).path
        filename = basename(path)
        stdout.write(filename)
        stdout.flush()
        start_req = time.time()
        resp = get_header(url)        
        # print " result - 200/301/404"
        req_time = (time.time() - start_req)
        stdout.write(" - " + str(resp) + " - " + str("%2.5r" % req_time) + '\n')
        stdout.flush()
    # timing on cache feeding maybe? :)
    #if req_time > 1:
    #   stderr.write('Refreshing ' + filename + '\n')
    #   stderr.flush()
    #   #time.sleep(3)

def get_header(url):
    req = urllib2.Request(url)
    #try:
    res = urllib2.urlopen(req)
    res.close()
    return res.code
    #except:
        #sys.exit(1)

def invalidUsage():
    """Prints usage instructions and exits
    """
    return 'Usage: '+argv[0]+' <URLs_file>'

def main():
    # delay the cronjob so that the cache expires.
    # (cache is +24h, cron job is scheduled to run daily at the same time)
    #time.sleep(3)
    get_file(argv[1])
    #get_header('http://manage.hdx.rwlabs.org/hdx/api/exporter/indicator/readme/PVX080/source/emdat/language/EN/PVX080_Readme.txt')
    return True


if __name__ == '__main__':
    if len(argv) != 2:
        exit(invalidUsage())
    if not isfile(argv[1]):
        print "File not found"
        exit(invalidUsage())
    main()
