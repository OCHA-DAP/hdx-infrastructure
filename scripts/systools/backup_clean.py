#!/usr/bin/python
"""
Attempt to clean up old backups in a folder (nonrecursive)
Expected backup format:
aaa[.bbb[.ccc[.ddd[.eee[.fff.[....]]]]].YYYYmmDD-HHMMSS.(sql|psql|tar).gz
"""
import sys
import os
import datetime

BACKUP_FOLDER='/opt/backup/'    # location of the backup files
PREFIX=''                       # optional prefix to filter the backups to be removed (e.g prod.ckan.files)
YEARLY=10                       # how many yearly backups we keep?
MONTHLY=13                      # how many monthly backups we keep?
WEEKLY=5                        # how many weekly backups we keep?
DAILY=8                         # how many daily backups we keep?
HOURLY=25                       # how many hourly backups we keep?
DAILY_HOUR=3                    # what is the time (hour) of the daily backup?
WEEKLY_WEEKDAY=5                # what is the day of the week of the weekly backup? (0 Monday .... 6 Sunday)
NOW=datetime.datetime.now()     # date time reference - the execution time

def main():
    for root, dirs, files in os.walk(BACKUP_FOLDER):
        for file in sorted(files):
            file = os.path.join(root,file)
            if PREFIX not in file:
                print 'wtf'
                continue
            if file[-3:] != '.gz':
                print file, ' is not a regular backup file. skipping it...'
                continue
            # print file, 
            o = datetimeFromFilename(file)
            if checkHourly(o):
                print file,'HOURLY'
                continue
            elif checkYearly(o):
                if getValidStatus(o, YEARLY, 'y'):
                    print file,'YEARLY'
                    continue
                print file,'older YEARLY - I will delete it!'
            elif checkMonthly(o):
                if getValidStatus(o, MONTHLY, 'm'):
                    print file,'MONTHLY'
                    continue
                print file,'older MONTHLY - I will delete it!'
            elif checkWeekly(o):
                if getValidStatus(o, WEEKLY, 'w'):
                    print file,'WEEKLY'
                    continue
                print file,'older WEEKLY - I will delete it!'
            elif checkDaily(o):
                if getValidStatus(o, DAILY, 'd'):
                    print file,'DAILY'
                    continue
                print file,'older DAILY - I will delete it!'
            else:
                print file,'UNKNOWN / ODLER HOURLY - GOOD FOR DELETION - I will delete it!'
            # really removes the file!
            os.remove(file)

def datetimeFromFilename(filename):
    '''
    Relies on the fact that the timestamp in the filename is exactly last-last group separated by dot
    Like: prod.fff.ggg.20140506-132245.psql.gz or prod.fff.ggg.20140506-132245.tar.gz
    '''
    strdatetime = filename.split('.')[-3]
    return datetime.datetime.strptime(strdatetime, '%Y%m%d-%H%M%S')

def checkHourly(o):
    if checkYearly(o) or checkMonthly(o) or checkWeekly(o) or checkDaily(o):
        return False
    else:
        if NOW - o < datetime.timedelta(hours=HOURLY):
            return True
    return False

def checkDaily(o):
    if o.hour == 3:
        return True
    return False

def checkWeekly(o):
    if checkDaily(o) and o.weekday() == WEEKLY_WEEKDAY:
        return True
    return False

def checkMonthly(o):
    if checkDaily(o) and o.day == 1:
        return True
    return False

def checkYearly(o):
    if checkDaily(o) and checkMonthly(o) and o.month == 1:
        return True
    return False

def getValidStatus(o, max, unit):
    '''
    True if file need to be kept according to backup policy, False otherwise
    '''
    if unit == 'y':
        diff = datetime.timedelta(days = 365 * max)
    elif unit == 'm':
        diff = datetime.timedelta(days = 31 * max)
    elif unit == 'w':
        diff = datetime.timedelta(days = 7 * max)
    elif unit == 'd':
        diff = datetime.timedelta(days = max)
    elif unit == 'h':
        diff = datetime.timedelta(hours = max)
    else:
        print 'Invalid unit passed... Exiting'
        sys.exit()
    if o - NOW > datetime.timedelta(minutes=1):
        print 'backup date is in the future... Exiting'
        sys.exit()
    if NOW - o < diff:
        return True
    else:
        return False

if __name__ == '__main__':
    main()
