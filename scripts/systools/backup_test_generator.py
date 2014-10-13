#!/usr/bin/python
"""
Generates NUMDAYS of valid dates in the past (starting from now)
Generates NUMHOURS of valid hours in the past (starting from now)
"""
import datetime
import os
import sys

BASE = datetime.datetime.today()
DIRNAME = 'test-backup'
FAKE_BACKUP_PREFIX = 'backup.test.'
NUMDAYS = 1024
NUMHOURS = 720

def genDaysList():
    """
    Generates the list for daily backups
    """
    days = []
    date_list = [BASE - datetime.timedelta(days=x) for x in range(0, NUMDAYS)]
    for date in date_list:
        days.append(date.strftime('%Y%m%d-030000'))
    return days

def genHoursList(numhours = 900):
    """
    Generates the list for hourly backups
    """
    hours = []
    hour_list = [BASE - datetime.timedelta(hours=x) for x in range(0, NUMHOURS)]
    for hour in hour_list:
        hours.append(hour.strftime('%Y%m%d-%H0000'))
    return hours

def createBackupFiles(list):
    """
    Create backup files, looping through the lists
    """
    for item in list:
        dirname = os.path.abspath(DIRNAME)
        filename = FAKE_BACKUP_PREFIX + item + ".tar.gz"
        absfilename = os.path.join(dirname,filename)
        if not os.path.exists(absfilename):
            open(absfilename, 'a').close()

def main():
    if not os.path.exists(DIRNAME):
        try:
            os.makedirs(DIRNAME)
        except:
            print('Creation of', DIRNAME, 'failed for some reason.')
            print('Exiting ...')
            sys.exit()
    else:
        print('Folder ' + DIRNAME + ' already exists.')
    print('Creating daily fake backups...'),
    createBackupFiles(genDaysList())
    print('done.')
    print('Creating hourly fake backups...'),
    createBackupFiles(genHoursList())
    print('done.')

if __name__ == '__main__':
    main()

