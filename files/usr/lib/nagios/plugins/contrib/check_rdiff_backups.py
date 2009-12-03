#!/usr/bin/env python
# Nagios plusgin to check errors and missing backups

logsDir = "/var/log/rdiff-backup/"
thld_hour = 4 # Hour of day after which todays backup should be present


import os, sys
import re
import datetime
import getopt
import traceback

verbosity = 0

try:
  opts, args = getopt.getopt(sys.argv[1:], "v:")
except getopt.GetoptError, err:
  print err
  sys.exit(1)
  
for opt, val in opts:
  if opt == "-v":
    verbosity = int(val)

try:
  log_name_re = re.compile("(.*)-(\d{2})-(\d{2})-(\d{4})\.log")
  
  hosts = {}
  logs = {}
  for log_file in os.listdir(logsDir):
    host, day, month, year = log_name_re.match(log_file).groups()
    date = "%s-%s-%s" %(year, month, day)
  
    if host not in hosts or date > hosts[host]:
      hosts[host] = date
      logs[host] = log_file
  
  hosts_ok = []
  now = datetime.datetime.now()
  for host, date in hosts.items():
    if date == now.strftime("%Y-%m-%d") or now.hour < thld_hour and date == (now - timedelta(days=1)).strftime("%Y-%m-%d"):
      for line in open(os.path.join(logsDir, logs[host])):
        if line.strip() == "RDIFF-BACKUP-EXIT-STATUS=0":
          hosts_ok.append(host)
          break
  
  nb_failed = len(hosts) - len(hosts_ok)
  
  if nb_failed != 0:
    print "CRITICAL - %s/%s hosts backed-up successfully (%s failed)" %(len(hosts_ok), len(hosts), nb_failed)
    if verbosity > 0:
      for host in set(hosts.keys()) - set(hosts_ok):
	print "backup for %s failed or missing." %(host)
    sys.exit(2)
  
  else:
    print "OK - %s/%s hosts backed-up successfully" %(len(hosts_ok), len(hosts))

except StandardError:
  print "WARNING - plugin error"
  if verbosity > 0:
    type,val,tb = sys.exc_info()
    print ''.join(traceback.format_exception(type,val,tb))

