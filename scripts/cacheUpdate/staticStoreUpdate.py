#!/usr/bin/python

import urllib2
from urlparse import urlparse
from os.path import splitext, basename, isfile, isdir, abspath, join
from os import makedirs, remove
from sys import stdout, stderr, exit, argv
import time

def get_file(FILE,BASEDIR,FORCE):
    urls = open(FILE,'r')
    for url in urls:
        # the url does not contain even the http:// :)
        if len(url) < 8:
            continue
        # hit url
        url = url.strip()
        path = (urlparse(url)).path
        filename = basename(path)
        path_only = path.replace('/hdx/api/exporter/', '').replace(filename, '')
        full_path = join(BASEDIR,path_only)
        full_path_file = join(full_path, filename)

        if not isdir(full_path):
            stdout.write('folder not found. creating ' + full_path)
            makedirs(full_path)
        stdout.write(filename)
        stdout.flush()

        # force removal of the static file
        if isfile(full_path_file) and FORCE:
            remove(full_path_file)
        start_req = time.time()
        code, content = get_header(url)

        req_time = (time.time() - start_req)
        stdout.write(" - " + str(code) + " - " + str("%2.5r" % req_time) + '\n')
        stdout.flush()
        if code == 200:
            # save file
            response_file = open(full_path_file,'wb')
            response_file.write(content)
            response_file.close()


def get_header(url):
    req = urllib2.Request(url)
    res = urllib2.urlopen(req)
    code = res.code
    content = res.read()
    res.close()
    return code, content


def invalidUsage():
    """Prints usage instructions and exits
    """
    return 'Usage: '+argv[0]+' <URLs_file> <base_folder> [force]'


def main(filename,basedir,force):
    get_file(filename,basedir,force)
    return True


if __name__ == '__main__':
    if len(argv) < 3:
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
    if len(argv) == 4 and argv[3] == 'force':
        FORCE = True
    else:
        FORCE = False
    main(FILE,BASEDIR,FORCE)
