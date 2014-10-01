#!/usr/bin/python

import sys
import os
import datetime
import re
import time
import tarfile
from os.path import join, getsize

YEARLY=3
MONTHLY=8
WEEKLY=4
DAILY=7
HOURLY=16
TODAY=datetime.datetime.now().strftime("%Y%m%d")


def getTimestampPrefix():
    """Gets the timestamp prefix to be used in creation a new archive
    """
#   return datetime.datetime.now().strftime("%Y%m%d-%H%M%S-")
#   return datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S-")
    return datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-")


# mailbox_dir = '/home/vmail/westaco.com'
# backup_dir = '/opt/backup_mails/backup'
# backup_dir_full = join(backup_dir,'FULL/')
# backup_dir_diff = join(backup_dir,'DIFF/')

# #sharedir="/opt/backup_mails/sambashare"
# #finaldir="/opt/backup_mails/sambashare/mail_backup"

# def getMailboxList(topdir):
#     """Get the list of users' mailbox folders
#     """
#     mbox_list = []
#     for d in os.listdir(topdir):
#         if os.path.isdir(join(topdir,d)):
#             mbox_list.append(d)
#     return sorted(mbox_list)
# #   return ['silviu.leonte']

# def getLastFullBackup(mailbox):
#     """Get the last backup for a user mailbox folder
#     """
#     files = sorted(os.listdir(backup_dir_full), reverse=True)
#     test = re.compile(mailbox, re.IGNORECASE)
#     result = filter(test.search, files)
#     if len(result) > 0:
#         file = result[0]
#     else:
#         file = 0
#     return file

# def getLastFullBackupMtime(mailbox):
#     """Gets the creation time of this mailbox last full backup - MODIFY
#     NOW IT JUST TAKES LAST BACKUP
#     """
#     last_full_backup = getLastFullBackup(mailbox)
#     return os.stat(join(backup_dir_full, last_full_backup)).st_mtime

# def getTimestampPrefix():
#     """Gets the timestamp prefix to be used in creation a new archive
#     """
# #   return datetime.datetime.now().strftime("%Y%m%d-%H%M%S-")
# #   return datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S-")
#     return datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-")

# def performFullBackup(mailbox):
#     """Perform a full backup for each user mailbox
#     """
#     sys.stdout.write('Full backup for '+mailbox+' ... ')
#     sys.stdout.flush()
#     full_backup_archive = backup_dir_full+getTimestampPrefix()+mailbox+'.tgz'
#     archive_name = join(mailbox_dir,mailbox)
#     # !!! beware the changing content of the mailbox!
#     # now the script just bails out
#     tar = tarfile.open(full_backup_archive, 'w:gz')
#     try:
#         tar.add(archive_name, arcname=mailbox)
#     except IOError:
#         sys.stdout.write('Mailbox for '+mailbox+' changed while i was reading it... Please perform a manual full backup of this mailbox.')
#         sys.stdout.flush()
#     tar.close()
#     sys.stdout.write('done!\n')

# def performDiffBackup(mailbox):
#     """Perform a diff backup (from the last backup) for each user mailbox 
#     """
#     last_full_backup = getLastFullBackup(mailbox)
#     if last_full_backup == 0:
#         sys.stdout.write('!!! Skipping diff backup for '+mailbox+' (no full backup found) !!!\n')
#         return 
#     #change it in timestampprefix and translate into mtime
#     last_full_backup_mtime = getLastFullBackupMtime(mailbox)
#     diff_backup_archive = backup_dir_diff+getTimestampPrefix()+mailbox+'.tgz'
#     empty_diff = 1
    
#     tar = tarfile.open(diff_backup_archive, 'w:gz')
#     sys.stdout.write('Diff backup for '+mailbox+' (last full backup '+last_full_backup+') ')
#     sys.stdout.flush()

#     for root, dirs, files in os.walk(join(mailbox_dir,mailbox)):

#         for name in files:
#             full_file_path = join(root,name)
#             rel_file_path = full_file_path.replace(mailbox_dir, '')
#             file_mtime = os.stat(full_file_path).st_mtime

#             if (file_mtime > last_full_backup_mtime):
#                 sys.stdout.write('.')
#                 sys.stdout.flush()
#                 tar.add(full_file_path,arcname=rel_file_path)
#                 empty_diff = 0
#     tar.close()
#     if (empty_diff == 0):
#         sys.stdout.write(' done.\n')
#         sys.stdout.flush()
#     else:
#         sys.stdout.write('no changes since last full. Skipping...\n')
#         sys.stdout.flush()
#         os.remove(diff_backup_archive)

# def invalidUsage():
#     """Prints usage instructions and exits
#     """
#     return 'Usage: '+sys.argv[0]+' [full|diff]'

# if len(sys.argv) != 2:
#      sys.exit(invalidUsage())

# if sys.argv[1] == 'full':
#     print "Performing full backup"
#     for mailbox in getMailboxList(mailbox_dir):
#         performFullBackup(mailbox)
#     sys.stdout.write('Backup job done!\n')
#     sys.stdout.flush()

# elif sys.argv[1] == 'diff':
#     print "Performing diff backup"
#     for mailbox in getMailboxList(mailbox_dir):
#         performDiffBackup(mailbox)
#     sys.stdout.write('Backup job done!\n')
#     sys.stdout.flush()
# else:
#     sys.exit(invalidUsage())

