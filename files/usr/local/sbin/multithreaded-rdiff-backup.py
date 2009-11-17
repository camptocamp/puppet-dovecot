#!/usr/bin/env python
# vim: tabstop=2 expandtab shiftwidth=4 softtabstop=4

import os
import re
import time
import sys
import glob
from optparse import OptionParser
import email
import smtplib
import ConfigParser
from os.path import join
from threading import Thread
from socket import gethostname
from commands import getstatusoutput

_REGEX = re.compile(r""".*ElapsedTime .*? \((?P<time>.*?)\).*Errors\s(?P<errors>\d+)""", re.DOTALL)
_RB_PATH = "/opt/rdiff-backup/rdiff-backup-%s/bin/rdiff-backup"
_PYTHONPATH = "PYTHONPATH=/opt/rdiff-backup/rdiff-backup-%s/lib/python2.5/site-packages "

class Email:
  def __init__ (self, subject, msg, mailFrom, mailTo, smtpSrv = 'localhost'):
    self.subject = subject
    self.msg = msg
    self.mailFrom = mailFrom
    self.mailTo = mailTo
    self.smtpSrv = smtpSrv
  def send(self):
    msg = email.MIMEText.MIMEText(self.msg.encode('utf-8'), _subtype="plain", _charset='utf-8')
    msg['Subject'] = email.Header.Header(self.subject.encode("utf-8"), 'utf-8')
    server = smtplib.SMTP(self.smtpSrv)
    server.sendmail(self.mailFrom, self.mailTo, msg.as_string())
    server.quit()

class Backup(Thread):
  def __init__ (self, hostPrefs, today):
    Thread.__init__(self)
    self.host = hostPrefs['host']
    self.version = hostPrefs['version']
    self.enable = hostPrefs['enable']
    self.source = hostPrefs['source']
    self.destination = hostPrefs['destination']
    self.args = hostPrefs['args']
    self.retention = hostPrefs['retention']
    self.today = today
  
  def run(self):
    if self.enable.lower == "false":
      return

    logFile = "/var/log/rdiff-backup/%s-%s.log" %(self.host, self.today)

    # starts rdiff-backup
    pythonPath= _PYTHONPATH % self.version
    rdiffBackupPath = _RB_PATH % self.version
    cmd = "%s %s %s %s %s" % (pythonPath, rdiffBackupPath, self.args, self.source, self.destination)
    self.status, self.output = getstatusoutput(cmd)
    
    # remove older files only if backup finished
    if not self.status:
        cmd = "%s %s --remove-older-than %s --force %s" % (pythonPath, rdiffBackupPath, self.retention, self.destination)
        self.status, out = getstatusoutput(cmd)
        self.output += "\n %s" %out

    # writes a logfile with rdiff-backup stdin and stderr
    flog = open(logFile, 'w')
    flog.write(self.output+"\n")
    flog.close()

  def getStatus(self):
    return self.status

  def getOutput(self):
    return self.output

def nbBackupRunning(backupDict):
  nb = 0
  for host, status in backupDict.items():
    if status and status.isAlive():
      nb += 1
  return nb

def moreBackupToRun(backupDict):
  for host, status in backupDict.items():
    if not status: return True
  return False

def getNextBackupToRun(backupDict):
  for host, status in backupDict.items():
    if not status:
      return host
  return ""

def getBackupDict():
  backupDict = {}
  backupList = glob.glob('/etc/rdiff-backup.d/*.conf')
  for backup in backupList:
    backupDict[backup] = None
  return backupDict

def day():
  return time.strftime("%d", time.localtime())

def today():
  return time.strftime("%d-%m-%Y", time.localtime())

def date():
  return time.strftime("%d %B %Y", time.localtime())

def readMainConfig():
  mainConfig = "/etc/multithreaded-rdiff-backup.conf"

  if not os.path.exists(mainConfig):
    print "Main configuration %s not found !" % mainConfig
    sys.exit(1)
  config = ConfigParser.ConfigParser()

  config.read("/etc/multithreaded-rdiff-backup.conf")
  return dict(config.items('mainconfig'))

def formatResult(backupDict):
  result = {"msg" : "", "success" : 0}
  nbBackup = len(backupDict)
  # wait until the thread terminates
  for host, thread in backupDict.items():
    config = ConfigParser.ConfigParser()
    config.read(host)
    dispHost = "[%s]" % config.get('hostconfig', 'host')
    thread.join() 
    if thread.getStatus():
      if config.get('hostconfig', 'enable').lower() == "false":
        result['msg'] = "%s disable\n" %dispHost + result['msg']
      else:
        result['msg'] = "%s Failed !\n" %dispHost + result['msg']
    else :
      stats = _REGEX.search(thread.getOutput())
      dispTime = "Time: %s" %stats.group('time')
      dispError = "Error(s): %s" %stats.group('errors')
      result['msg'] += "%s %s %s\n" %(dispHost, dispTime, dispError)
      result['success'] += 1

  return (result, nbBackup)

def chooseHost(hostDic):
  hosts = map(os.path.basename, hostDic)
  hosts = map(lambda x: x[:-5], hosts)
  hosts.sort()
  for index, host in enumerate(hosts):
    print '  %s\t%s' % (index, host)
  h = -1
  while h not in xrange(len(hosts)):
    try:
      h = input("  Host: ")
    except NameError:
      continue
  return hosts[h]

def chk_host(hostDic, host):
  hosts = map(os.path.basename, hostDic)
  hosts = map(lambda x: x[:-5], hosts)
  if host in hosts:
    return host
  return False 

if __name__=="__main__":
  # check if root
  if os.getuid():
    print "not root!"
    sys.exit(1)

  mainConf = readMainConfig()
  backupDict = getBackupDict()

  if not backupDict:
    print "No backup configuration in '/etc/rdiff-backup.d' !"
    sys.exit(1)

  options = OptionParser(version="1.0")
  options.add_option("-l", "--list", action="store_true", help="displays configured hosts, letting choose a host to backup", default=False)
  options.add_option("-H", "--host", dest="host", help="launch backup for <host> only")

  (opt, args) = options.parse_args()

  if opt.host and opt.list:
    print 'Options -l and -H are mutually exclusive.'
    sys.exit(1)

  # list ?
  if opt.list:
    host = chooseHost(backupDict)
  # host ?
  if opt.host:
    host = chk_host(backupDict, opt.host)

  if host:
    backupDict = {'/etc/rdiff-backup.d/%s.conf' % host: None}

  # start threads together
  while moreBackupToRun(backupDict): 
    if nbBackupRunning(backupDict) < mainConf['max_threads']:
      host = getNextBackupToRun(backupDict)
      if host:
        config = ConfigParser.ConfigParser()
        config.read(host)
        backupDict[host] = Backup(dict(config.items('hostconfig')), today())
        backupDict[host].start()

  # wait thread and display results
  result, nb = formatResult(backupDict)

  # send an email resume
  title = "rdiff-backup result (%s/%s) - %s" %(result['success'], nb, date())
  Email(title, result['msg'], mainConf['mail_from'], mainConf['mail_to'], mainConf['smtp_server']).send()

